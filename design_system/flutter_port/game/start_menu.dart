import 'package:flutter/material.dart' hide Image;
import 'theme/af_tokens.dart';
import 'theme/af_text_styles.dart';
import 'theme/af_widgets.dart';
import 'main.dart'; // AeroFighterGame, GameDifficulty, jetSkins

/// Home-base metagame overlay (HOME / HANGAR / SHOP / PILOT), rebuilt on the
/// AeroFighter Design System: AF.* tokens + Af* widgets instead of inline
/// Color(0xFF…) literals. Game logic is unchanged from the original.
class StartMenuOverlay extends StatefulWidget {
  final AeroFighterGame game;
  const StartMenuOverlay({super.key, required this.game});

  @override
  State<StartMenuOverlay> createState() => _StartMenuOverlayState();
}

class _StartMenuOverlayState extends State<StartMenuOverlay> {
  int _activeTab = 0; // 0: HOME, 1: HANGAR, 2: SHOP, 3: PILOT
  int _selectedHangarIndex = 0;
  bool _sfxEnabled = true;
  bool _musicEnabled = true;

  static const _nav = [
    AfNavItem(Icons.home_filled, 'HOME'),
    AfNavItem(Icons.flight, 'HANGAR'),
    AfNavItem(Icons.shopping_cart_outlined, 'SHOP'),
    AfNavItem(Icons.person_outline, 'PILOT'),
  ];

  @override
  void initState() {
    super.initState();
    _selectedHangarIndex = widget.game.selectedSkinIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
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
    );
  }

  // ── Top bar: avatar · callsign · currency · link status ──
  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AF.s5, vertical: AF.s4),
      child: Row(
        children: [
          const AfAvatar(size: 48),
          const SizedBox(width: AF.s4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('CALLSIGN', style: AFType.label),
                Text('MAVERICK', style: AFType.title),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _currency(Icons.paid, '25,400', AF.text),
              const SizedBox(height: 2),
              _currency(Icons.diamond, '150', AF.orange),
            ],
          ),
          const SizedBox(width: AF.s5),
          const Icon(Icons.wifi, color: AF.cyan, size: 24),
        ],
      ),
    );
  }

  Widget _currency(IconData icon, String value, Color color) {
    return Row(
      children: [
        Icon(icon, color: color == AF.text ? AF.cyan : AF.orange, size: 14),
        const SizedBox(width: 4),
        Text(value, style: AFType.currency.copyWith(color: color, fontSize: 15)),
      ],
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
      padding: const EdgeInsets.symmetric(horizontal: AF.s6),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(child: Center(child: _reticle())),
          AfButton(
            'Scramble',
            icon: Icons.rocket_launch,
            size: AfButtonSize.lg,
            block: true,
            onTap: _scramble,
          ),
          const SizedBox(height: AF.s6),
          Row(
            children: [
              Expanded(child: _statusPanel('FUEL SYSTEM', '85% OPTIMAL', 0.85, AF.cyan)),
              const SizedBox(width: AF.s5),
              Expanded(child: _statusPanel('WEAPONS LOAD', 'READY', 1.0, AF.orange)),
            ],
          ),
          const SizedBox(height: AF.s6),
          Row(
            children: [
              Expanded(child: _actionPill(Icons.emoji_events, 'Daily\nRewards', false)),
              const SizedBox(width: AF.s4),
              Expanded(child: _actionPill(Icons.mail_outline, 'Inbox', false)),
              const SizedBox(width: AF.s4),
              Expanded(child: _actionPill(Icons.calendar_today, 'Event', true)),
            ],
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  void _scramble() {
    int startW = 1, startL = 1;
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

  Widget _reticle() {
    return SizedBox(
      width: 140,
      height: 140,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(size: const Size(140, 140), painter: _ReticlePainter()),
          Icon(Icons.star_border, color: AF.cyan, size: 80,
              shadows: [Shadow(color: AF.cyan.withValues(alpha: 0.8), blurRadius: 24)]),
          const Positioned(top: 10, child: Icon(Icons.diamond, color: AF.orange, size: 12)),
        ],
      ),
    );
  }

  Widget _statusPanel(String title, String status, double progress, Color color) {
    return AfPanel(
      padding: const EdgeInsets.symmetric(horizontal: AF.s5, vertical: AF.s4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AFType.caption.copyWith(color: AF.cyanMid)),
          const SizedBox(height: AF.s3),
          AfProgressBar(value: progress, color: color, height: AF.barThin),
          const SizedBox(height: AF.s2),
          Align(
            alignment: Alignment.centerRight,
            child: Text(status, style: AFType.body.copyWith(color: AF.text, fontSize: 11)),
          ),
        ],
      ),
    );
  }

  Widget _actionPill(IconData icon, String text, bool hasNotification) {
    return Container(
      height: 65,
      decoration: BoxDecoration(
        color: AF.surface.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(AF.rPill),
        border: Border.all(color: AF.border, width: AF.stroke),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: AF.cyan, size: 20),
              const SizedBox(width: AF.s3),
              Text(text, textAlign: TextAlign.center, style: AFType.body.copyWith(fontSize: 11)),
            ],
          ),
          if (hasNotification)
            const Positioned(
              top: 10, right: 16,
              child: CircleAvatar(backgroundColor: AF.orange, radius: 4),
            ),
        ],
      ),
    );
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
            separatorBuilder: (_, __) => const SizedBox(width: AF.s4),
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

class _ReticlePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AF.cyan
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;
    final w = size.width, h = size.height, len = w * 0.25;
    canvas.drawPath(
      Path()..moveTo(0, len)..lineTo(0, 0)..lineTo(len, 0),
      paint,
    );
    canvas.drawPath(
      Path()..moveTo(w, h - len)..lineTo(w, h)..lineTo(w - len, h),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
