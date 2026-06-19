import sys

with open('c:\\repos\\skyu-fighter\\lib\\start_menu.dart', 'r', encoding='utf-8') as f:
    content = f.read()

def replace_between(content, start_marker, end_marker, new_text):
    start_idx = content.find(start_marker)
    if start_idx == -1: return content
    end_idx = content.find(end_marker, start_idx)
    if end_idx == -1: end_idx = len(content)
    return content[:start_idx] + new_text + content[end_idx:]

new_top_bar = """  Widget _buildTopBar() {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color: const Color(0xFF001133).withValues(alpha: 0.8),
        border: const Border(bottom: BorderSide(color: Color(0xFF102540), width: 1.5)),
      ),
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFF001133),
                          border: Border.all(color: const Color(0xFF00AAFF), width: 1.5),
                          boxShadow: [
                            BoxShadow(color: const Color(0xFF00AAFF).withValues(alpha: 0.5), blurRadius: 10),
                          ],
                        ),
                        child: ClipOval(
                          child: Image.asset('assets/images/jet_2_level.png', fit: BoxFit.contain),
                        ),
                      ),
                      Positioned(
                        bottom: -2,
                        right: -4,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFF00EEFF),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text('12', style: TextStyle(color: Colors.black, fontSize: 9, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('CALLSIGN', style: TextStyle(color: Color(0xFF00AAFF), fontSize: 10, letterSpacing: 1)),
                      Text('MAVERICK', style: TextStyle(color: Color(0xFF00EEFF), fontSize: 15, fontWeight: FontWeight.bold, letterSpacing: 2, shadows: [Shadow(color: Color(0xFF00EEFF), blurRadius: 8)])),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: const Color(0xFF102540)),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.local_atm, color: Color(0xFFFFD700), size: 16),
                    SizedBox(width: 6),
                    Text('25,400', style: TextStyle(color: Color(0xFFFFD700), fontSize: 13, letterSpacing: 1, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
"""
content = replace_between(content, '  Widget _buildTopBar() {', '  Widget _buildActiveContent() {', new_top_bar + '\n')


new_shop = """  Widget _buildShopPlaceholder() {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
          child: Container(
            width: 260,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.75),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0xFF00AAFF).withValues(alpha: 0.35), width: 1.5),
            ),
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.storefront, color: Color(0xFF00EEFF), size: 48),
                SizedBox(height: 16),
                Text(
                  'MARKETPLACE OFFLINE',
                  style: TextStyle(
                    color: Color(0xFF00EEFF),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
"""
content = replace_between(content, '  Widget _buildShopPlaceholder() {', '  Widget _buildSettingsWrapper() {', new_shop + '\n')

new_settings_and_hangar = """  Widget _buildSettingsWrapper() {
    return Center(
      child: SizedBox(
        width: 340,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.75),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: const Color(0xFF00AAFF).withValues(alpha: 0.35),
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
        width: 340,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.75),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: const Color(0xFF00AAFF).withValues(alpha: 0.35),
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
    final nameColor = _selectedHangarIndex == 0 ? const Color(0xFF00EEFF) : skin.color;

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
        const SizedBox(height: 14),
        SizedBox(
          height: 64,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: jetSkins.length,
            itemBuilder: (context, idx) {
              final targetSkin = jetSkins[idx];
              final isHighlighted = _selectedHangarIndex == idx;
              final isSkinEquipped = widget.game.selectedSkinIndex == idx;
              final skinColor = idx == 0 ? const Color(0xFF0088FF) : targetSkin.color;

              return GestureDetector(
                onTap: () => setState(() => _selectedHangarIndex = idx),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 60,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    color: isHighlighted
                        ? const Color(0xFF00AAFF).withValues(alpha: 0.16)
                        : Colors.black26,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isHighlighted
                          ? const Color(0xFF00EEFF)
                          : const Color(0xFF102540),
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
                            color: skinColor,
                            boxShadow: [
                              BoxShadow(
                                color: skinColor.withValues(alpha: 0.6),
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
                              color: Color(0xFF00EE55),
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
            color: nameColor,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          skin.description,
          style: const TextStyle(
            color: Colors.white54,
            fontSize: 11,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 16),
        _buildStatBar('Engine Speed', skin.speedStat, const Color(0xFF00EEFF)),
        const SizedBox(height: 8),
        _buildStatBar('Hull Integrity', skin.armorStat, const Color(0xFFFFD700)),
        const SizedBox(height: 8),
        _buildStatBar('Firepower', skin.firepowerStat, const Color(0xFFFF4444)),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: isEquipped
                  ? const Color(0xFF003366)
                  : const Color(0xFF0088FF),
              foregroundColor: isEquipped ? Colors.white54 : Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              shadowColor: isEquipped ? Colors.transparent : const Color(0xFF0088FF).withValues(alpha: 0.5),
              elevation: isEquipped ? 0 : 8,
            ),
            onPressed: isEquipped
                ? null
                : () {
                    setState(() {
                      widget.game.selectedSkinIndex = _selectedHangarIndex;
                    });
                  },
            child: Text(
              isEquipped ? 'Equipped' : 'Equip Fighter Jet',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
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
        Container(
          height: 36,
          decoration: BoxDecoration(
            color: Colors.black38,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFF102540)),
          ),
          child: Row(
            children: GameDifficulty.values.map((d) {
              final isSelected = widget.game.difficulty == d;
              Color activeCol = const Color(0xFF0088FF);
              if (d == GameDifficulty.easy) activeCol = const Color(0xFF00EE55);
              if (d == GameDifficulty.hard) activeCol = const Color(0xFFFF3333);

              return Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => widget.game.difficulty = d),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected ? activeCol : Colors.transparent,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Center(
                      child: Text(
                        d.name[0].toUpperCase() + d.name.substring(1),
                        style: TextStyle(
                          color: isSelected ? Colors.black : Colors.white54,
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
        ),
        const SizedBox(height: 10),
        Text(
          diffDesc,
          style: const TextStyle(
            color: Colors.white54,
            fontSize: 10,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 18),
        const Divider(color: Color(0xFF102540)),
        const SizedBox(height: 10),
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
"""

content = replace_between(content, '  Widget _buildSettingsWrapper() {', 'class _ReticlePainter extends CustomPainter {', new_settings_and_hangar + '\n')

with open('c:\\repos\\skyu-fighter\\lib\\start_menu.dart', 'w', encoding='utf-8') as f:
    f.write(content)
