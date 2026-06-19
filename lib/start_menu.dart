import 'dart:math' as math;
import 'package:flutter/material.dart' hide Image;
import 'theme/af_tokens.dart';
import 'theme/af_text_styles.dart';
import 'theme/af_widgets.dart';
import 'auth_service.dart';
import 'main.dart'; // AeroFighterGame, GameDifficulty, jetSkins

class StartMenuOverlay extends StatefulWidget {
  final AeroFighterGame game;
  const StartMenuOverlay({super.key, required this.game});

  @override
  State<StartMenuOverlay> createState() => _StartMenuOverlayState();
}

class _StartMenuOverlayState extends State<StartMenuOverlay> {
  int _activeTab = 0; // 0: HOME, 1: HANGAR, 2: SHOP, 3: PILOT
  int _selectedHangarIndex = 0;
  int _selectedWorldIndex = 0; 
  bool _sfxEnabled = true;
  bool _musicEnabled = true;

  static const _nav = [
    AfNavItem(Icons.home_filled, 'HOME'),
    AfNavItem(Icons.flight, 'HANGAR'),
    AfNavItem(Icons.shopping_cart_outlined, 'SHOP'),
  ];

  @override
  void initState() {
    super.initState();
    authService.addListener(_onAuthChanged);
    _selectedHangarIndex = widget.game.selectedSkinIndex;

    int highestW = 1;
    for (int w = 4; w >= 1; w--) {
      for (int l = 4; l >= 1; l--) {
        if (widget.game.unlockedLevels.contains('$w-$l')) {
          highestW = w;
          break;
        }
      }
      if (highestW != 1) break;
    }
    _selectedWorldIndex = highestW - 1;
  }

  void _onAuthChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    authService.removeListener(_onAuthChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage('assets/images/main_menu_bg.jpg'),
            fit: BoxFit.fill,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.3),
              BlendMode.darken,
            ),
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildTopBar(),
              Expanded(
                child: AnimatedSwitcher(
                  duration: AF.easeSlow,
                  child: _buildActiveContent(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(AF.s5, 0, AF.s5, AF.s5),
                child: AfNavBar(
                  items: _nav,
                  value: _activeTab,
                  onChange: (i) => setState(() => _activeTab = i),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    final bool isLogged = authService.isLoggedIn;
    final String email = authService.currentUser?.email ?? '';
    final String displayName = isLogged ? (email.split('@').first) : authService.guestId;
    final String initial = isLogged 
        ? (email.isNotEmpty ? email.substring(0, 1).toUpperCase() : 'P')
        : '';
        
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AF.s5, vertical: AF.s4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: _showAuthDialog,
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: Row(
                children: [
                  isLogged 
                    ? CircleAvatar(
                        backgroundColor: AF.cyan,
                        radius: 14,
                        child: Text(initial, style: const TextStyle(color: AF.bg, fontSize: 14, fontWeight: FontWeight.bold)),
                      )
                    : const Icon(Icons.account_circle, color: AF.cyan, size: 32),
                  const SizedBox(width: 8),
                  Text(
                    displayName,
                    style: AFType.body.copyWith(fontWeight: FontWeight.bold, color: AF.cyan),
                  ),
                ],
              ),
            ),
          ),
          IconButton(
            icon: Icon(_activeTab == 3 ? Icons.close : Icons.menu, color: AF.cyan, size: 28),
            onPressed: () {
              setState(() => _activeTab = _activeTab == 3 ? 0 : 3);
            },
          ),
        ],
      ),
    );
  }

  void _showAuthDialog() {
    showDialog(
      context: context,
      builder: (context) => const _AuthModal(),
    );
  }

  Widget _buildActiveContent() {
    switch (_activeTab) {
      case 0:
        return _buildHomeTab();
      case 1:
        return _glassCenter(const ValueKey('hangar'), _buildHangarTab());
      case 2:
        return _buildShopPlaceholder();
      case 3:
        return _glassCenter(const ValueKey('pilot'), _buildSettingsTab());
      default:
        return const SizedBox();
    }
  }

  // ── HOME ──
  Widget _buildHomeTab() {
    return Padding(
      key: const ValueKey('home'),
      padding: const EdgeInsets.fromLTRB(AF.s5, 4, AF.s5, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Spacer(),
          AfButton(
            'Battle',
            icon: Icons.rocket_launch,
            size: AfButtonSize.lg,
            block: true,
            onTap: _scramble,
          ),
          const SizedBox(height: AF.s5),
        ],
      ),
    );
  }

  void _scramble() {
    int startW = 1;
    int startL = 1;
    for (int w = 4; w >= 1; w--) {
      for (int l = 4; l >= 1; l--) {
        if (widget.game.unlockedLevels.contains('$w-$l')) {
          startW = w;
          startL = l;
          break;
        }
      }
      if (startW != 1 || startL != 1) break;
    }
    widget.game.startLevel(startW, startL);
  }


  // ── SHOP ──
  Widget _buildShopPlaceholder() {
    return Center(
      key: const ValueKey('shop'),
      child: AfGlassModal(
        width: 300,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.store, color: AF.cyan, size: 48),
            const SizedBox(height: AF.s5),
            Text('MARKETPLACE OFFLINE', style: AFType.h2),
          ],
        ),
      ),
    );
  }

  // ── HANGAR ──
  Widget _buildHangarTab() {
    final skin = jetSkins[_selectedHangarIndex];
    final isEquipped = widget.game.selectedSkinIndex == _selectedHangarIndex;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('JET CONFIGURATOR', style: AFType.h2),
        const SizedBox(height: AF.s4),
        SizedBox(
          height: 64,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: jetSkins.length,
            separatorBuilder: (_, _) => const SizedBox(width: AF.s4),
            itemBuilder: (context, idx) {
              final dotColor = idx == 0 ? AF.skinCobalt : jetSkins[idx].color;
              return AfJetChip(
                color: dotColor,
                highlighted: _selectedHangarIndex == idx,
                equipped: widget.game.selectedSkinIndex == idx,
                onTap: () => setState(() => _selectedHangarIndex = idx),
              );
            },
          ),
        ),
        const SizedBox(height: AF.s5),
        Text(
          skin.name,
          style: AFType.h2.copyWith(color: _selectedHangarIndex == 0 ? AF.cyan : skin.color),
        ),
        const SizedBox(height: AF.s2),
        Text(skin.description, style: AFType.body),
        const SizedBox(height: AF.s5),
        AfStatBar(label: 'Engine Speed', value: skin.speedStat, color: AF.cyan),
        const SizedBox(height: AF.s3),
        AfStatBar(label: 'Hull Integrity', value: skin.armorStat, color: AF.gold),
        const SizedBox(height: AF.s3),
        AfStatBar(label: 'Firepower', value: skin.firepowerStat, color: AF.danger),
        const SizedBox(height: AF.s6),
        AfButton(
          isEquipped ? 'Equipped' : 'Equip Fighter Jet',
          block: true,
          disabled: isEquipped,
          onTap: () => setState(() => widget.game.selectedSkinIndex = _selectedHangarIndex),
        ),
      ],
    );
  }

  // ── PILOT (settings) ──
  Widget _buildSettingsTab() {
    final diff = widget.game.difficulty;
    final diffDesc = switch (diff) {
      GameDifficulty.easy => 'Easy: 4 Lives. Reduced enemy speed.',
      GameDifficulty.medium => 'Normal: 3 Lives. Default arcade striker parameters.',
      GameDifficulty.hard => 'Hard: 2 Lives. Accelerated enemy speed.',
    };

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('PILOT SYSTEM PARAMETERS', style: AFType.h2),
        const SizedBox(height: AF.s5),
        Text('DIFFICULTY SCALE', style: AFType.caption),
        const SizedBox(height: AF.s3),
        AfSegmented(
          value: GameDifficulty.values.indexOf(diff),
          options: const [
            AfSegment('EASY', color: AF.success),
            AfSegment('NORMAL', color: AF.blue),
            AfSegment('HARD', color: AF.danger),
          ],
          onChange: (i) => setState(() => widget.game.difficulty = GameDifficulty.values[i]),
        ),
        const SizedBox(height: 10),
        Text(diffDesc, style: AFType.body.copyWith(fontSize: 10)),
        const SizedBox(height: AF.s7),
        const Divider(color: AF.borderQuiet),
        const SizedBox(height: AF.s5),
        _toggleRow(Icons.volume_up, 'SOUND FX (SIMULATED)', _sfxEnabled,
            (v) => setState(() => _sfxEnabled = v)),
        _toggleRow(Icons.music_note, 'MUSIC TRACK (SIMULATED)', _musicEnabled,
            (v) => setState(() => _musicEnabled = v)),
      ],
    );
  }

  Widget _toggleRow(IconData icon, String label, bool value, ValueChanged<bool> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AF.s2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: AF.textMuted),
              const SizedBox(width: AF.s3),
              Text(label, style: AFType.body.copyWith(color: AF.text, fontSize: 12)),
            ],
          ),
          AfToggle(value: value, onChanged: onChanged),
        ],
      ),
    );
  }

  // ── Shared frosted-glass wrapper for HANGAR / PILOT ──
  Widget _glassCenter(Key key, Widget child) {
    return Center(
      key: key,
      child: AfGlassModal(width: 360, child: child),
    );
  }
}

class _AuthModal extends StatefulWidget {
  const _AuthModal({super.key});

  @override
  State<_AuthModal> createState() => _AuthModalState();
}

class _AuthModalState extends State<_AuthModal> {
  String? _error;
  bool _isLoading = false;

  void _submitGoogle() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    String? error = await authService.signInWithGoogle();

    if (mounted) {
      setState(() => _isLoading = false);
      if (error != null) {
        setState(() => _error = error);
      } else {
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (authService.isLoggedIn) {
      return Center(
        child: Material(
          color: Colors.transparent,
          child: AfGlassModal(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('PILOT PROFILE', style: AFType.h2),
                const SizedBox(height: AF.s4),
                Text('Logged in as:\n${authService.currentUser?.email}', style: AFType.body, textAlign: TextAlign.center),
                const SizedBox(height: AF.s5),
                AfButton('Sign Out', variant: AfButtonVariant.danger, block: true, onTap: () async {
                  await authService.signOut();
                  await authService.signOut();
                  if (!context.mounted) return;
                  Navigator.of(context).pop();
                }),
                const SizedBox(height: AF.s3),
                AfButton('Close', variant: AfButtonVariant.ghost, block: true, onTap: () => Navigator.of(context).pop()),
              ],
            ),
          ),
        ),
      );
    }

    return Center(
      child: Material(
        color: Colors.transparent,
        child: AfGlassModal(
          child: Padding(
            padding: const EdgeInsets.all(AF.s2),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('SYSTEM LOGIN', style: AFType.h2),
                const SizedBox(height: AF.s4),
                if (_error != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: AF.s3),
                    child: Text(_error!, style: const TextStyle(color: AF.danger, fontSize: 12)),
                  ),
                AfButton(
                  _isLoading ? 'WAIT...' : 'SIGN IN WITH GOOGLE',
                  block: true,
                  variant: AfButtonVariant.secondary,
                  onTap: _isLoading ? null : _submitGoogle,
                ),
                const SizedBox(height: AF.s4),
                AfButton('Cancel', variant: AfButtonVariant.ghost, block: true, onTap: () => Navigator.of(context).pop()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

