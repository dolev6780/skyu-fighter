import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart' hide Image;
import 'main.dart';

enum PowerUpType {
  weaponUp,    // Orange (Frame 0)
  rapidFire,   // Yellow (Frame 1)
  missiles,    // Red (Frame 2)
  repair,      // Green (Frame 3)
  extraLife,   // White (Frame 4)
  armor,       // Blue (Frame 5)
  nuke,        // Purple (Frame 6)
  scoreStar,   // Gold (Frame 7)
}

class PowerUp extends PositionComponent with HasGameReference<AeroFighterGame> {
  final PowerUpType type;
  final double speed = 85.0;
  double _time = 0;
  late final Sprite _sprite;

  PowerUp({required Vector2 position, required this.type})
      : super(position: position, size: Vector2(32, 32), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    final spriteSheet = SpriteSheet(
      image: game.images.fromCache('powerups_strip_128.png'),
      srcSize: Vector2.all(128),
    );
    _sprite = spriteSheet.getSprite(0, type.index);
  }

  @override
  void update(double dt) {
    super.update(dt);
    _time += dt;

    if (game.isHorizontalLevel) {
      position.x -= speed * dt;
      position.y += sin(_time * 4) * 0.6;
      if (position.x < -40) {
        removeFromParent();
      }
    } else {
      position.y += speed * dt;
      position.x += sin(_time * 4) * 0.6;
      if (position.y > kGameHeight + 40) {
        removeFromParent();
      }
    }
  }

  @override
  void render(Canvas canvas) {
    final pulse = 1.0 + sin(_time * 6) * 0.08;

    Color themeColor;
    switch (type) {
      case PowerUpType.weaponUp:
        themeColor = const Color(0xFFFF8800); // Orange
        break;
      case PowerUpType.rapidFire:
        themeColor = const Color(0xFFFFFF33); // Neon Yellow
        break;
      case PowerUpType.missiles:
        themeColor = const Color(0xFFFF3333); // Red
        break;
      case PowerUpType.repair:
        themeColor = const Color(0xFF33FF33); // Green
        break;
      case PowerUpType.extraLife:
        themeColor = const Color(0xFFFFFFFF); // White
        break;
      case PowerUpType.armor:
        themeColor = const Color(0xFF3388FF); // Blue
        break;
      case PowerUpType.nuke:
        themeColor = const Color(0xFFCC33FF); // Purple
        break;
      case PowerUpType.scoreStar:
        themeColor = const Color(0xFFFFD700); // Gold
        break;
    }

    // Draw glowing back circle
    canvas.drawCircle(
      Offset.zero,
      (size.x / 2) * pulse,
      Paint()
        ..color = themeColor.withValues(alpha: 0.25)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
    );

    // Render the sprite
    _sprite.render(
      canvas,
      position: Vector2.zero(),
      size: size * pulse,
      anchor: Anchor.center,
    );
  }
}

class FloatingText extends PositionComponent {
  final String text;
  final Color color;
  double _time = 0;

  FloatingText({required Vector2 position, required this.text, required this.color})
      : super(position: position, size: Vector2(100, 24), anchor: Anchor.center);

  @override
  void update(double dt) {
    super.update(dt);
    _time += dt;
    // Floating text should drift opposite to gravity/direction
    // If horizontal mode (moving right), text drifts left (upwards visually)
    // Actually in horizontal mode, standard "up" would be towards the top of screen.
    // If camera doesn't rotate and everything just moves along X, text drifting "up" is still -Y.
    position.y -= 45 * dt; 
    if (_time >= 1.2) {
      removeFromParent();
    }
  }

  @override
  void render(Canvas canvas) {
    final opacity = (1.2 - _time).clamp(0.0, 1.0);
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: color.withValues(alpha: opacity),
          fontSize: 13,
          fontWeight: FontWeight.bold,
          shadows: [
            Shadow(color: Colors.black.withValues(alpha: opacity), blurRadius: 4),
          ],
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    textPainter.paint(canvas, Offset(-textPainter.width / 2, -textPainter.height / 2));
  }
}
