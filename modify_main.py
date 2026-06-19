import sys
import re

with open('c:\\repos\\skyu-fighter\\lib\\main.dart', 'r', encoding='utf-8') as f:
    content = f.read()

def replace_between(content, start_marker, end_marker, new_text):
    start_idx = content.find(start_marker)
    if start_idx == -1: return content
    end_idx = content.find(end_marker, start_idx)
    if end_idx == -1: end_idx = len(content)
    return content[:start_idx] + new_text + content[end_idx:]

# 1. Update GameWidget in main.dart
game_widget_start = "overlayBuilderMap: {"
game_widget_end = "initialActiveOverlays: const ['StartMenu'],"
new_overlay_map = """overlayBuilderMap: {
            'StartMenu': (context, game) => StartMenuOverlay(game: game),
            'Controls': (context, game) => _ControlsOverlay(game: game),
            'GameOver': (context, game) => _GameOverOverlay(game: game),
            'LevelComplete': (context, game) => _LevelCompleteOverlay(game: game),
            'PauseMenu': (context, game) => _PauseMenuOverlay(game: game),
            'HUD': (context, game) => _HUDOverlay(game: game),
          },
          """
content = replace_between(content, game_widget_start, game_widget_end, new_overlay_map)

# 2. Update startLevel in main.dart
start_level_overlays_start = "overlays.remove('StartMenu');"
start_level_overlays_end = "  }"
new_start_level_overlays = """overlays.remove('StartMenu');
    overlays.remove('GameOver');
    overlays.remove('LevelComplete');
    overlays.remove('PauseMenu');
    overlays.add('Controls');
    overlays.add('HUD');
"""
content = replace_between(content, start_level_overlays_start, start_level_overlays_end, new_start_level_overlays)

# 3. Update exitToMainMenu in main.dart
exit_start = "overlays.remove('Controls');"
exit_end = "overlays.add('StartMenu');"
new_exit = """overlays.remove('Controls');
    overlays.remove('HUD');
    overlays.remove('PauseButton');
    """
content = replace_between(content, exit_start, exit_end, new_exit)

# 4. Remove camera.viewport.add(HudComponent())
content = content.replace("camera.viewport.add(HudComponent());", "// HUD now handled by _HUDOverlay widget")

# 5. Remove HudComponent entirely
hud_comp_start = "class HudComponent extends Component"
hud_comp_end = "// ─── Overlays"
content = replace_between(content, hud_comp_start, hud_comp_end, "")

# 6. Remove _PauseButtonOverlay entirely (it will be inside _HUDOverlay)
pause_button_start = "class _PauseButtonOverlay extends StatelessWidget {"
pause_button_end = "}\n\n// ─── Flame Behaviors & Extras"
# Just in case we can't find the exact end, we use a regex
content = re.sub(r'class _PauseButtonOverlay extends StatelessWidget \{.*?\n\}\n\}', '', content, flags=re.DOTALL)

# Let's be safer with the regex removal of _PauseButtonOverlay
idx = content.find("class _PauseButtonOverlay extends StatelessWidget")
if idx != -1:
    idx2 = content.find("class ", idx + 10)
    if idx2 == -1: idx2 = len(content)
    content = content[:idx] + content[idx2:]

# 7. Update Overlays
overlays_start = "class _GameOverOverlay extends StatelessWidget {"
overlays_end = "class OceanBackground "
new_overlays = """
import 'package:flutter/scheduler.dart';

class _HUDOverlay extends StatefulWidget {
  final AeroFighterGame game;
  const _HUDOverlay({required this.game});

  @override
  _HUDOverlayState createState() => _HUDOverlayState();
}

class _HUDOverlayState extends State<_HUDOverlay> with SingleTickerProviderStateMixin {
  late Ticker _ticker;
  double _lastScore = 0;
  List<Map<String, dynamic>> _floats = [];

  @override
  void initState() {
    super.initState();
    _ticker = createTicker((_) {
      if (widget.game.score != _lastScore) {
        // Just as an example, we could spawn floating text, but we'll just update UI
        _lastScore = widget.game.score.toDouble();
      }
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
                  fontFamily: 'Share Tech Mono', // fallback will be sans-serif if not found
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
                    '$kills / $target',
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
content = replace_between(content, overlays_start, overlays_end, new_overlays)

# Since we imported Scheduler, we need to add the import at the top
import_stmt = "import 'package:flutter/scheduler.dart';\n"
if "import 'package:flutter/scheduler.dart';" not in content:
    content = content.replace("import 'package:flutter/material.dart' hide Image;", "import 'package:flutter/material.dart' hide Image;\n" + import_stmt)

with open('c:\\repos\\skyu-fighter\\lib\\main.dart', 'w', encoding='utf-8') as f:
    f.write(content)

