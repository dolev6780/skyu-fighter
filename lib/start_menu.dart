import 'dart:ui';
import 'package:flutter/material.dart' hide Image;
import 'main.dart'; // To access AeroFighterGame, GameDifficulty, jetSkins

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
                duration: const Duration(milliseconds: 300),
                child: _buildActiveContent(),
              ),
            ),
            _buildBottomNav(),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFF00AAFF), width: 1.5),
              color: const Color(0xFF001133),
            ),
            child: const Icon(Icons.person, color: Color(0xFF00EEFF)),
          ),
          const SizedBox(width: 12),
          // Callsign
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'CALLSIGN',
                  style: TextStyle(
                    color: Color(0xFF00AAFF),
                    fontSize: 10,
                    letterSpacing: 2,
                  ),
                ),
                Text(
                  'MAVERICK',
                  style: TextStyle(
                    color: Color(0xFF00EEFF),
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 3,
                  ),
                ),
              ],
            ),
          ),
          // Currency
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  const Icon(Icons.money, color: Color(0xFF00EEFF), size: 14),
                  const SizedBox(width: 4),
                  const Text(
                    '25,400',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  const Icon(Icons.diamond, color: Color(0xFFFF6600), size: 14),
                  const SizedBox(width: 4),
                  const Text(
                    '150',
                    style: TextStyle(
                      color: Color(0xFFFF8800),
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(width: 16),
          const Icon(Icons.wifi, color: Color(0xFF00EEFF), size: 24),
        ],
      ),
    );
  }

  Widget _buildActiveContent() {
    switch (_activeTab) {
      case 0:
        return _buildHomeTab();
      case 1:
        return _buildHangarWrapper();
      case 2:
        return _buildShopPlaceholder();
      case 3:
        return _buildSettingsWrapper(); // Repurposing PILOT tab for Settings
      default:
        return const SizedBox();
    }
  }

  Widget _buildHomeTab() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Glowing Star/Reticle
          Expanded(
            child: Center(
              child: SizedBox(
                width: 140,
                height: 140,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CustomPaint(
                      size: const Size(140, 140),
                      painter: _ReticlePainter(),
                    ),
                    Icon(
                      Icons.star_border,
                      color: const Color(0xFF00EEFF),
                      size: 80,
                      shadows: [
                        Shadow(
                          color: const Color(0xFF00EEFF).withOpacity(0.8),
                          blurRadius: 24,
                        ),
                      ],
                    ),
                    const Positioned(
                      top: 10,
                      child: Icon(
                        Icons.diamond,
                        color: Color(0xFFFF8800),
                        size: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Scramble Button
          Container(
            width: double.infinity,
            height: 70,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: const LinearGradient(
                colors: [Color(0xFFFF8800), Color(0xFFFF4400)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFF5500).withOpacity(0.5),
                  blurRadius: 20,
                  spreadRadius: 2,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  // Find highest unlocked level
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
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.rocket_launch,
                      color: Colors.black,
                      size: 28,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'SCRAMBLE',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        fontStyle: FontStyle.italic,
                        letterSpacing: 2,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 4,
                            offset: const Offset(1, 2),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Status Panels
          Row(
            children: [
              Expanded(
                child: _buildStatusPanel(
                  'FUEL SYSTEM',
                  '85% OPTIMAL',
                  0.85,
                  const Color(0xFF00EEFF),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatusPanel(
                  'WEAPONS LOAD',
                  'READY',
                  1.0,
                  const Color(0xFFFF8800),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Action Pills
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildActionPill(Icons.emoji_events, 'Daily\nRewards', false),
              _buildActionPill(Icons.mail_outline, 'Inbox', false),
              _buildActionPill(Icons.calendar_today, 'Event', true),
            ],
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildStatusPanel(
    String title,
    String status,
    double progress,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF051020).withOpacity(0.85),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF102540), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF00AAFF),
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.black54,
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 4,
          ),
          const SizedBox(height: 6),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              status,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                letterSpacing: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionPill(IconData icon, String text, bool hasNotification) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6),
        height: 65,
        decoration: BoxDecoration(
          color: const Color(0xFF051020).withOpacity(0.85),
          borderRadius: BorderRadius.circular(32),
          border: Border.all(color: const Color(0xFF102540), width: 1.5),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: const Color(0xFF00EEFF), size: 20),
                const SizedBox(width: 8),
                Text(
                  text,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white70, fontSize: 11),
                ),
              ],
            ),
            if (hasNotification)
              const Positioned(
                top: 10,
                right: 16,
                child: CircleAvatar(
                  backgroundColor: Color(0xFFFF6600),
                  radius: 4,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      height: 75,
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      decoration: BoxDecoration(
        color: const Color(0xFF051020).withOpacity(0.95),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF102540), width: 1.5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem(0, Icons.home_filled, 'HOME'),
          _buildNavItem(1, Icons.flight, 'HANGAR'),
          _buildNavItem(2, Icons.shopping_cart_outlined, 'SHOP'),
          _buildNavItem(3, Icons.person_outline, 'PILOT'),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = _activeTab == index;
    return GestureDetector(
      onTap: () => setState(() => _activeTab = index),
      child: Container(
        width: 65,
        height: 60,
        decoration: isSelected
            ? BoxDecoration(
                color: const Color(0xFFFF8800),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFF5500).withOpacity(0.4),
                    blurRadius: 12,
                    spreadRadius: 2,
                  ),
                ],
              )
            : null,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.black : const Color(0xFF00AAFF),
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.black : const Color(0xFF00AAFF),
                fontSize: 9,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShopPlaceholder() {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.7),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0xFF00AAFF).withOpacity(0.4)),
        ),
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.store, color: Color(0xFF00EEFF), size: 48),
            SizedBox(height: 16),
            Text(
              'MARKETPLACE OFFLINE',
              style: TextStyle(
                color: Color(0xFF00EEFF),
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsWrapper() {
    return Center(
      child: SizedBox(
        width: 360,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.75),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: const Color(0xFF00AAFF).withOpacity(0.35),
                  width: 1.5,
                ),
              ),
              child: _buildSettingsTab(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHangarWrapper() {
    return Center(
      child: SizedBox(
        width: 360,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.75),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: const Color(0xFF00AAFF).withOpacity(0.35),
                  width: 1.5,
                ),
              ),
              child: _buildHangarTab(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHangarTab() {
    final skin = jetSkins[_selectedHangarIndex];
    final isEquipped = widget.game.selectedSkinIndex == _selectedHangarIndex;

    return Column(
      key: const ValueKey('hangar_tab'),
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'JET CONFIGURATOR',
          style: TextStyle(
            color: Color(0xFF00EEFF),
            fontSize: 15,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 64,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: jetSkins.length,
            itemBuilder: (context, idx) {
              final targetSkin = jetSkins[idx];
              final isHighlighted = _selectedHangarIndex == idx;
              final isSkinEquipped = widget.game.selectedSkinIndex == idx;

              return GestureDetector(
                onTap: () => setState(() => _selectedHangarIndex = idx),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 60,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    color: isHighlighted
                        ? const Color(0xFF00AAFF).withOpacity(0.1)
                        : Colors.black26,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isHighlighted
                          ? const Color(0xFF00EEFF)
                          : (isSkinEquipped
                                ? const Color(0xFF00AAFF).withOpacity(0.5)
                                : const Color(0xFF003366)),
                      width: isHighlighted ? 2 : 1.2,
                    ),
                  ),
                  child: Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: idx == 0
                                ? const Color(0xFF0088FF)
                                : targetSkin.color,
                            boxShadow: [
                              BoxShadow(
                                color:
                                    (idx == 0
                                            ? const Color(0xFF0088FF)
                                            : targetSkin.color)
                                        .withOpacity(0.6),
                                blurRadius: 8,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                        ),
                        if (isSkinEquipped)
                          const Positioned(
                            right: 2,
                            top: 2,
                            child: Icon(
                              Icons.check_circle,
                              size: 12,
                              color: Color(0xFF00FF66),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        Text(
          skin.name,
          style: TextStyle(
            color: _selectedHangarIndex == 0
                ? const Color(0xFF00EEFF)
                : skin.color,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          skin.description,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 11,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 16),
        _buildStatBar('ENGINE SPEED', skin.speedStat, Colors.cyan),
        const SizedBox(height: 8),
        _buildStatBar('HULL INTEGRITY', skin.armorStat, Colors.amber),
        const SizedBox(height: 8),
        _buildStatBar('FIREPOWER', skin.firepowerStat, const Color(0xFFFF4444)),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: isEquipped
                  ? const Color(0xFF003366)
                  : const Color(0xFFFF8800),
              foregroundColor: isEquipped ? Colors.white54 : Colors.black,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: isEquipped
                ? null
                : () {
                    setState(() {
                      widget.game.selectedSkinIndex = _selectedHangarIndex;
                    });
                  },
            child: Text(
              isEquipped ? 'EQUIPPED' : 'EQUIP FIGHTER JET',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
                color: isEquipped ? Colors.white54 : Colors.black,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatBar(String label, double value, Color barColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: Colors.white54,
                fontSize: 10,
                letterSpacing: 1,
              ),
            ),
            Text(
              '${(value * 100).toInt()}%',
              style: TextStyle(
                color: barColor,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 3),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: SizedBox(
            height: 6,
            child: LinearProgressIndicator(
              value: value,
              backgroundColor: Colors.white10,
              valueColor: AlwaysStoppedAnimation<Color>(barColor),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsTab() {
    String diffDesc = '';
    switch (widget.game.difficulty) {
      case GameDifficulty.easy:
        diffDesc = 'Easy: 4 Lives. Reduced enemy speed.';
        break;
      case GameDifficulty.medium:
        diffDesc = 'Normal: 3 Lives. Default arcade striker parameters.';
        break;
      case GameDifficulty.hard:
        diffDesc = 'Hard: 2 Lives. Accelerated enemy speed.';
        break;
    }

    return Column(
      key: const ValueKey('settings_tab'),
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'PILOT SYSTEM PARAMETERS',
          style: TextStyle(
            color: Color(0xFF00EEFF),
            fontSize: 15,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'DIFFICULTY SCALE',
          style: TextStyle(
            color: Colors.white54,
            fontSize: 10,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: GameDifficulty.values.map((d) {
            final isSelected = widget.game.difficulty == d;
            Color activeCol = const Color(0xFF0088FF);
            if (d == GameDifficulty.easy) activeCol = Colors.green;
            if (d == GameDifficulty.hard) activeCol = const Color(0xFFFF3333);

            return Expanded(
              child: GestureDetector(
                onTap: () => setState(() => widget.game.difficulty = d),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? activeCol.withOpacity(0.2)
                        : Colors.black38,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isSelected ? activeCol : const Color(0xFF002244),
                      width: 1.5,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      d.name.toUpperCase(),
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.white54,
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 10),
        Text(
          diffDesc,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 10,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 24),
        const Divider(color: Color(0xFF002244)),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Row(
              children: [
                Icon(Icons.volume_up, size: 18, color: Colors.white54),
                SizedBox(width: 8),
                Text(
                  'SOUND FX (SIMULATED)',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ],
            ),
            Switch(
              value: _sfxEnabled,
              activeColor: const Color(0xFF00EEFF),
              onChanged: (val) => setState(() => _sfxEnabled = val),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Row(
              children: [
                Icon(Icons.music_note, size: 18, color: Colors.white54),
                SizedBox(width: 8),
                Text(
                  'MUSIC TRACK (SIMULATED)',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ],
            ),
            Switch(
              value: _musicEnabled,
              activeColor: const Color(0xFF00EEFF),
              onChanged: (val) => setState(() => _musicEnabled = val),
            ),
          ],
        ),
      ],
    );
  }
}

class _ReticlePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF00EEFF)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;

    final w = size.width;
    final h = size.height;
    final len = w * 0.25;

    // Top-left
    canvas.drawPath(
      Path()
        ..moveTo(0, len)
        ..lineTo(0, 0)
        ..lineTo(len, 0),
      paint,
    );
    // Bottom-right
    canvas.drawPath(
      Path()
        ..moveTo(w, h - len)
        ..lineTo(w, h)
        ..lineTo(w - len, h),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
