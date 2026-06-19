import sys

with open('c:\\repos\\skyu-fighter\\lib\\main.dart', 'r', encoding='utf-8') as f:
    content = f.read()

# Add scheduler import
if "import 'package:flutter/scheduler.dart';" not in content:
    content = content.replace("import 'package:flutter/material.dart' hide Image;", "import 'package:flutter/material.dart' hide Image;\nimport 'package:flutter/scheduler.dart';")

# 1. Update GameWidget overlayBuilderMap
content = content.replace(
"""          overlayBuilderMap: {
            'StartMenu': (context, game) => StartMenuOverlay(game: game),
            'Controls': (context, game) => _ControlsOverlay(game: game),
            'GameOver': (context, game) => _GameOverOverlay(game: game),
            'LevelComplete': (context, game) =>
                _LevelCompleteOverlay(game: game),
            'PauseMenu': (context, game) => _PauseMenuOverlay(game: game),
            'PauseButton': (context, game) => _PauseButtonOverlay(game: game),
          },""",
"""          overlayBuilderMap: {
            'StartMenu': (context, game) => StartMenuOverlay(game: game),
            'Controls': (context, game) => _ControlsOverlay(game: game),
            'GameOver': (context, game) => _GameOverOverlay(game: game),
            'LevelComplete': (context, game) =>
                _LevelCompleteOverlay(game: game),
            'PauseMenu': (context, game) => _PauseMenuOverlay(game: game),
            'HUD': (context, game) => _HUDOverlay(game: game),
          },"""
)

# 2. Update startLevel
content = content.replace(
"""    overlays.remove('StartMenu');
    overlays.remove('GameOver');
    overlays.remove('LevelComplete');
    overlays.remove('PauseMenu');
    overlays.add('Controls');
    overlays.add('PauseButton');""",
"""    overlays.remove('StartMenu');
    overlays.remove('GameOver');
    overlays.remove('LevelComplete');
    overlays.remove('PauseMenu');
    overlays.add('Controls');
    overlays.add('HUD');"""
)

# 3. Update exitToMainMenu
content = content.replace(
"""    overlays.remove('Controls');
    overlays.remove('PauseButton');
    overlays.remove('GameOver');
    overlays.remove('LevelComplete');
    overlays.remove('PauseMenu');
    overlays.add('StartMenu');""",
"""    overlays.remove('Controls');
    overlays.remove('HUD');
    overlays.remove('GameOver');
    overlays.remove('LevelComplete');
    overlays.remove('PauseMenu');
    overlays.add('StartMenu');"""
)

# 4. Remove HudComponent from viewport
content = content.replace("    camera.viewport.add(HudComponent());", "    // HUD now handled by _HUDOverlay widget")

# 5. Remove HudComponent entirely
hud_comp_start = "class HudComponent extends Component"
hud_comp_end = "// ─── Overlays ─────────────────────────────────────────────────────────────────"
idx1 = content.find(hud_comp_start)
idx2 = content.find(hud_comp_end, idx1)
if idx1 != -1 and idx2 != -1:
    content = content[:idx1] + content[idx2:]

# 6. Replace Overlays section to the end of the file
overlays_str_start = "class _GameOverOverlay extends StatelessWidget {"
idx3 = content.find(overlays_str_start)

new_overlays = """
class _HUDOverlay extends StatefulWidget {
  final AeroFighterGame game;
  const _HUDOverlay({required this.game});

  @override
  _HUDOverlayState createState() => _HUDOverlayState();
}

class _HUDOverlayState extends State<_HUDOverlay> with SingleTickerProviderStateMixin {
  late Ticker _ticker;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker((_) {
      setState(() {});
    });
    _ticker.start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.game.gameStarted || !widget.game.player.isMounted) return const SizedBox.shrink();

    final ld = widget.game.currentLevelData;
    final kills = widget.game.levelKillCount;
    final target = ld.killTarget;
    final progress = (kills / target).clamp(0.0, 1.0);
    final accent = ld.worldColor;

    return Stack(
      children: [
        // Top Edge Accent Line
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 3,
            decoration: BoxDecoration(
              color: accent,
              boxShadow: [BoxShadow(color: accent, blurRadius: 12)],
            ),
          ),
        ),

        // Top Left: Score & Lives
        Positioned(
          top: 14,
          left: 16,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'SCORE: ${widget.game.score.toString().padLeft(6, '0')}',
                style: const TextStyle(
                  fontFamily: 'Share Tech Mono',
                  fontSize: 18,
                  color: Color(0xFF88CCFF),
                  letterSpacing: 1,
                  shadows: [Shadow(color: Color(0xFF001133), blurRadius: 4)],
                ),
              ),
              const SizedBox(height: 6),
              Row(
                children: List.generate(
                  widget.game.lives,
                  (index) => const Padding(
                    padding: EdgeInsets.only(right: 4.0),
                    child: Icon(Icons.favorite, color: Color(0xFFFF3333), size: 18, shadows: [Shadow(color: Color(0xFF001133), blurRadius: 4)]),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Top Right: Pause Button & Level
        Positioned(
          top: 14,
          right: 16,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () {
                  widget.game.paused = true;
                  widget.game.overlays.add('PauseMenu');
                  widget.game.overlays.remove('Controls');
                  widget.game.overlays.remove('HUD');
                },
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: const Color(0xFF00050F).withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFF00EEFF).withValues(alpha: 0.5), width: 1.5),
                  ),
                  child: const Icon(Icons.pause, color: Color(0xFF00EEFF), size: 24),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'LVL ${ld.id}',
                style: TextStyle(
                  fontFamily: 'Share Tech Mono',
                  fontSize: 12,
                  color: accent,
                  letterSpacing: 1,
                  shadows: const [Shadow(color: Color(0xFF001133), blurRadius: 4)],
                ),
              ),
            ],
          ),
        ),

        // Combo Pop
        if (widget.game.comboMultiplier >= 2)
          Positioned(
            top: 96,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'x${widget.game.comboMultiplier} COMBO',
                style: const TextStyle(
                  fontStyle: FontStyle.italic,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFF8800),
                  letterSpacing: 2,
                  shadows: [Shadow(color: Color(0xFFFF5500), blurRadius: 10)],
                ),
              ),
            ),
          ),

        // PowerUps (Bottom Left area, above progress)
        Positioned(
          bottom: 64,
          left: 16,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.game.player.rapidFireTimer > 0)
                _buildPowerUpBar('RAPID FIRE', widget.game.player.rapidFireTimer / 8.0, const Color(0xFFFFEE33)),
              if (widget.game.player.shieldTimer > 0)
                _buildPowerUpBar('SHIELD', widget.game.player.shieldTimer / 8.0, const Color(0xFF4499FF)),
              if (widget.game.player.missileTimer > 0)
                _buildPowerUpBar('MISSILES', widget.game.player.missileTimer / 8.0, const Color(0xFFFF5544)),
            ],
          ),
        ),

        // Kill Progress (Bottom)
        Positioned(
          bottom: 26,
          left: 16,
          right: 16,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'SECTOR CLEAR',
                    style: TextStyle(fontSize: 9, color: Colors.white54, letterSpacing: 1, shadows: [Shadow(color: Colors.black, blurRadius: 2)]),
                  ),
                  Text(
                    '${kills.toInt()} / ${target.toInt()}',
                    style: const TextStyle(fontFamily: 'Share Tech Mono', fontSize: 9, color: Colors.white54, shadows: [Shadow(color: Colors.black, blurRadius: 2)]),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: SizedBox(
                  height: 6,
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.white10,
                    valueColor: AlwaysStoppedAnimation<Color>(accent),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPowerUpBar(String label, double progress, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 4,
            height: 12,
            decoration: BoxDecoration(color: color, boxShadow: [BoxShadow(color: color, blurRadius: 4)]),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(fontSize: 8, color: color, fontWeight: FontWeight.bold)),
              const SizedBox(height: 2),
              SizedBox(
                width: 60,
                height: 3,
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.black54,
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class _GameOverOverlay extends StatelessWidget {
  final AeroFighterGame game;
  const _GameOverOverlay({required this.game});

  @override
  Widget build(BuildContext context) {
    final isBest = game.score >= game.highScore;
    return Center(
      child: SizedBox(
        width: 320,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.75),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: const Color(0xFFFF3333).withValues(alpha: 0.4),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFF0000).withValues(alpha: 0.2),
                    blurRadius: 32,
                    spreadRadius: 4,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'GAME OVER',
                    style: TextStyle(
                      color: Color(0xFFFF3333),
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 4,
                      shadows: [
                        Shadow(color: Color(0xFFFF0000), blurRadius: 16),
                        Shadow(color: Color(0xFFFF4444), blurRadius: 8),
                      ],
                    ),
                  ),
                  const SizedBox(height: 22),
                  const Text(
                    'FINAL SCORE:',
                    style: TextStyle(color: Colors.white54, fontSize: 12, letterSpacing: 2),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    game.score.toString().padLeft(6, '0'),
                    style: const TextStyle(
                      fontFamily: 'Share Tech Mono',
                      color: Color(0xFF88CCFF),
                      fontSize: 30,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    isBest ? 'NEW PERSONAL BEST' : 'PERSONAL BEST',
                    style: const TextStyle(color: Colors.white54, fontSize: 11, letterSpacing: 2),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    game.highScore.toString().padLeft(6, '0'),
                    style: const TextStyle(
                      fontFamily: 'Share Tech Mono',
                      color: Color(0xFFFFD700),
                      fontSize: 18,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF3333),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 48),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      elevation: 8,
                      shadowColor: const Color(0xFFFF3333),
                      textStyle: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.5),
                    ),
                    onPressed: game.restart,
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.rocket_launch, size: 18),
                        SizedBox(width: 8),
                        Text('Re-launch Mission'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFFFF3333),
                      side: const BorderSide(color: Color(0xFFFF3333)),
                      minimumSize: const Size(double.infinity, 48),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      textStyle: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.5),
                    ),
                    onPressed: game.exitToMainMenu,
                    child: const Text('Abort to Menu'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LevelCompleteOverlay extends StatelessWidget {
  final AeroFighterGame game;
  const _LevelCompleteOverlay({required this.game});

  @override
  Widget build(BuildContext context) {
    final ld = game.currentLevelData;
    final isLastLevel = ld.world == 4 && ld.level == 4;
    final nextLevelId = ld.level < 4
        ? '${ld.world}-${ld.level + 1}'
        : ld.world < 4
        ? '${ld.world + 1}-1'
        : null;

    return Center(
      child: SizedBox(
        width: 360,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 36),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.80),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: ld.worldColor.withValues(alpha: 0.5),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: ld.worldColor.withValues(alpha: 0.15),
                    blurRadius: 28,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    isLastLevel ? 'CAMPAIGN COMPLETE' : 'MISSION COMPLETE',
                    style: TextStyle(
                      color: ld.worldColor,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 3,
                      shadows: [Shadow(color: ld.worldColor, blurRadius: 16)],
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'LEVEL ${ld.id}  —  ${ld.worldName}',
                    style: const TextStyle(
                      color: Colors.white54,
                      fontSize: 12,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Divider(color: Color(0xFF002244)),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'SCORE:',
                        style: TextStyle(
                          color: Colors.white54,
                          fontSize: 13,
                          letterSpacing: 1,
                        ),
                      ),
                      Text(
                        game.score.toString().padLeft(6, '0'),
                        style: const TextStyle(
                          color: Color(0xFF88CCFF),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),
                  if (!isLastLevel && nextLevelId != null)
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ld.worldColor,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 8,
                        textStyle: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                      onPressed: () {
                        final parts = nextLevelId!.split('-');
                        game.startLevel(
                          int.parse(parts[0]),
                          int.parse(parts[1]),
                          freshStart: false,
                        );
                      },
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.arrow_forward),
                          SizedBox(width: 8),
                          Text('NEXT MISSION'),
                        ],
                      ),
                    ),
                  const SizedBox(height: 12),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white38),
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                    onPressed: game.exitToMainMenu,
                    child: const Text('RETURN TO BASE'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PauseMenuOverlay extends StatelessWidget {
  final AeroFighterGame game;
  const _PauseMenuOverlay({required this.game});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 300,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.75),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: const Color(0xFF00AAFF).withValues(alpha: 0.4),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF0088FF).withValues(alpha: 0.15),
                    blurRadius: 32,
                    spreadRadius: 4,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'SYSTEM PAUSED',
                    style: TextStyle(
                      color: Color(0xFF00EEFF),
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 3,
                      shadows: [Shadow(color: Color(0xFF0066FF), blurRadius: 16)],
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0088FF),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 48),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      elevation: 8,
                      shadowColor: const Color(0xFF0088FF),
                      textStyle: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.5),
                    ),
                    onPressed: () {
                      game.paused = false;
                      game.overlays.remove('PauseMenu');
                      game.overlays.add('Controls');
                      game.overlays.add('HUD');
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.play_arrow, size: 20),
                        SizedBox(width: 8),
                        Text('Resume Mission'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFFFF3333),
                      side: const BorderSide(color: Color(0xFFFF3333)),
                      minimumSize: const Size(double.infinity, 48),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      textStyle: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.5),
                    ),
                    onPressed: game.exitToMainMenu,
                    child: const Text('Abort to Menu'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
"""

if idx3 != -1:
    content = content[:idx3] + new_overlays

with open('c:\\repos\\skyu-fighter\\lib\\main.dart', 'w', encoding='utf-8') as f:
    f.write(content)
