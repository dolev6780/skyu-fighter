import 'package:flame/components.dart';
import 'package:flutter/material.dart' hide Image;
import 'theme/af_tokens.dart';
import 'theme/af_text_styles.dart';
import 'theme/af_widgets.dart';
import 'main.dart'; // AeroFighterGame, LevelData

/// In-mission overlay widgets, rebuilt on the AeroFighter Design System.
/// These were private classes inside main.dart; they now live here as public
/// widgets wired through main.dart's `overlayBuilderMap`. Game logic unchanged.

// ── Drag-to-fly capture layer ──────────────────────────────────────────────
class ControlsOverlay extends StatelessWidget {
  final AeroFighterGame game;
  const ControlsOverlay({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final sw = constraints.maxWidth;
        final sh = constraints.maxHeight;
        final gameAspect = kGameWidth / kGameHeight;
        final screenAspect = sw / sh;
        final scale = screenAspect < gameAspect ? kGameWidth / sw : kGameHeight / sh;
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onPanUpdate: (d) {
            if (!game.gameOver && !game.paused) {
              game.player.moveBy(Vector2(d.delta.dx * scale, d.delta.dy * scale));
            }
          },
          child: const ColoredBox(color: Colors.transparent, child: SizedBox.expand()),
        );
      },
    );
  }
}

// ── GAME OVER ───────────────────────────────────────────────────────────────
class GameOverOverlay extends StatelessWidget {
  final AeroFighterGame game;
  const GameOverOverlay({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AfGlassModal(
        accent: AF.danger,
        glow: true,
        width: 360,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'GAME OVER',
              style: AFType.hero.copyWith(color: AF.danger, shadows: [
                const Shadow(color: AF.dangerHot, blurRadius: 16),
                Shadow(color: AF.danger.withValues(alpha: 0.6), blurRadius: 8),
              ]),
            ),
            const SizedBox(height: AF.s5),
            const Divider(color: Color(0xFF331111)),
            const SizedBox(height: AF.s5),
            _statRow('FINAL SCORE', afPadScore(game.score), AF.blueSoft),
            const SizedBox(height: AF.s4),
            _statRow('PERSONAL BEST', afPadScore(game.highScore), AF.gold),
            const SizedBox(height: AF.s8),
            AfButton('Re-launch Mission', icon: Icons.rocket_launch,
                variant: AfButtonVariant.danger, fillColor: AF.danger, block: true,
                onTap: game.restart),
            const SizedBox(height: AF.s4),
            AfButton('Abort to Menu', variant: AfButtonVariant.secondary, block: true,
                onTap: game.exitToMainMenu),
          ],
        ),
      ),
    );
  }
}

// ── MISSION / CAMPAIGN COMPLETE ─────────────────────────────────────────────
class LevelCompleteOverlay extends StatelessWidget {
  final AeroFighterGame game;
  const LevelCompleteOverlay({super.key, required this.game});

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
      child: AfGlassModal(
        accent: ld.worldColor,
        glow: true,
        width: 360,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              isLastLevel ? 'CAMPAIGN COMPLETE' : 'MISSION COMPLETE',
              textAlign: TextAlign.center,
              style: AFType.title.copyWith(color: ld.worldColor, fontSize: 26,
                  shadows: [Shadow(color: ld.worldColor, blurRadius: 16)]),
            ),
            const SizedBox(height: AF.s2),
            Text('LEVEL ${ld.id}  —  ${ld.worldName}',
                style: AFType.caption.copyWith(letterSpacing: 2)),
            const SizedBox(height: AF.s5),
            const Divider(color: AF.borderQuiet),
            const SizedBox(height: AF.s4),
            _statRow('SCORE', afPadScore(game.score), AF.blueSoft),
            const SizedBox(height: AF.s7),
            if (!isLastLevel && nextLevelId != null) ...[
              AfButton('Next Mission', icon: Icons.arrow_forward, block: true,
                  variant: AfButtonVariant.secondary, fillColor: ld.worldColor,
                  onTap: () {
                final parts = nextLevelId.split('-');
                game.startLevel(int.parse(parts[0]), int.parse(parts[1]), freshStart: false);
              }),
              const SizedBox(height: AF.s4),
            ],
            AfButton('Return to Base', variant: AfButtonVariant.secondary, block: true,
                onTap: game.exitToMainMenu),
          ],
        ),
      ),
    );
  }
}

// ── SYSTEM PAUSED ───────────────────────────────────────────────────────────
class PauseMenuOverlay extends StatelessWidget {
  final AeroFighterGame game;
  const PauseMenuOverlay({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AfGlassModal(
        accent: AF.cyanMid,
        glow: true,
        width: 320,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('SYSTEM PAUSED',
                style: AFType.title.copyWith(color: AF.cyan, fontSize: 28,
                    shadows: const [Shadow(color: Color(0xFF0066FF), blurRadius: 16)])),
            const SizedBox(height: AF.s5),
            const Divider(color: AF.borderQuiet),
            const SizedBox(height: AF.s7),
            AfButton('Resume Mission', icon: Icons.play_arrow, block: true,
                variant: AfButtonVariant.secondary, fillColor: AF.blue, onTap: () {
              game.paused = false;
              game.overlays.remove('PauseMenu');
              game.overlays.add('Controls');
              game.overlays.add('PauseButton');
            }),
            const SizedBox(height: AF.s4),
            AfButton('Abort to Menu', variant: AfButtonVariant.danger, block: true,
                onTap: game.exitToMainMenu),
          ],
        ),
      ),
    );
  }
}

// ── Floating pause button (top-right) ───────────────────────────────────────
class PauseButtonOverlay extends StatelessWidget {
  final AeroFighterGame game;
  const PauseButtonOverlay({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: AF.s4, right: AF.s4),
          child: AfIconButton(
            Icons.pause,
            semanticLabel: 'Pause',
            color: AF.cyan,
            onTap: () {
              game.paused = true;
              game.overlays.add('PauseMenu');
              game.overlays.remove('Controls');
              game.overlays.remove('PauseButton');
            },
          ),
        ),
      ),
    );
  }
}

// ── Shared score/stat row ───────────────────────────────────────────────────
Widget _statRow(String label, String value, Color valueColor) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(label, style: AFType.body.copyWith(color: AF.textDim, fontSize: 13, letterSpacing: 1)),
      Text(value, style: AFType.score.copyWith(color: valueColor, fontSize: 20)),
    ],
  );
}
