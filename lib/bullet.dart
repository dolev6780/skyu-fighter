import 'dart:math';
import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flutter/painting.dart';
import 'main.dart';
import 'enemy.dart';

abstract class Bullet extends PositionComponent with HasGameReference<AeroFighterGame> {
  Bullet({required Vector2 position, required Vector2 size})
      : super(position: position, size: size, anchor: Anchor.center);
}

class PlayerBullet extends Bullet {
  static const double _speed = 650;
  final Vector2 direction;

  PlayerBullet({required Vector2 position, Vector2? direction})
      : direction = direction ?? Vector2(0, -1),
        super(position: position, size: Vector2(5, 18));

  @override
  void update(double dt) {
    position += direction * (_speed * dt);
  }

  @override
  void render(Canvas canvas) {
    canvas.save();
    // Rotate bullet to align with its trajectory
    final angle = atan2(direction.x, -direction.y);
    canvas.rotate(angle);

    // Glow
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset.zero, width: size.x + 4, height: size.y + 4),
        const Radius.circular(4),
      ),
      Paint()
        ..color = const Color(0x5500FFFF)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
    );
    // Core beam
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset.zero, width: size.x, height: size.y),
        const Radius.circular(2),
      ),
      Paint()
        ..shader = const LinearGradient(
          colors: [Color(0xFFFFFFFF), Color(0xFF00EEFF)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ).createShader(Rect.fromCenter(
            center: Offset.zero, width: 5, height: 18)),
    );
    canvas.restore();
  }
}

class EnemyBullet extends Bullet {
  final Vector2 direction;
  final double speed;

  EnemyBullet({
    required Vector2 position,
    required this.direction,
    this.speed = 220,
  }) : super(position: position, size: Vector2(12, 12));

  @override
  void update(double dt) {
    position += direction * (speed * game.speedMultiplier * dt);
  }

  @override
  void render(Canvas canvas) {
    // Glow
    canvas.drawCircle(
      Offset.zero,
      size.x * 0.8,
      Paint()
        ..color = const Color(0x66FF0000)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5),
    );
    // Core
    canvas.drawCircle(
      Offset.zero,
      size.x * 0.4,
      Paint()..color = const Color(0xFFFF4444),
    );
    // Highlight
    canvas.drawCircle(
      const Offset(-2, -2),
      size.x * 0.15,
      Paint()..color = const Color(0x88FFAAAA),
    );
  }
}

class PlayerMissile extends Bullet {
  static const double _speed = 400;
  PositionComponent? _target;
  double _time = 0;
  double _angle = 0;

  PlayerMissile({required Vector2 position})
      : super(position: position, size: Vector2(10, 22));

  @override
  void update(double dt) {
    super.update(dt);
    _time += dt;

    if (_target == null || !_target!.isMounted || (_target is Enemy && (_target as Enemy).isDead)) {
      final enemies = game.world.children.whereType<Enemy>().where((e) => !e.isDead).toList();
      if (enemies.isNotEmpty) {
        double minDist = double.infinity;
        for (final e in enemies) {
          final d = position.distanceTo(e.position);
          if (d < minDist) {
            minDist = d;
            _target = e;
          }
        }
      }
    }

    Vector2 steerDir;
    if (_target != null && _target!.isMounted) {
      steerDir = (_target!.position - position).normalized();
    } else {
      steerDir = Vector2(0, -1);
    }

    position += steerDir * (_speed * dt);
    _angle = atan2(steerDir.x, -steerDir.y);
  }

  @override
  void render(Canvas canvas) {
    canvas.save();
    canvas.rotate(_angle);

    // Glow
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset.zero, width: size.x + 6, height: size.y + 6),
        const Radius.circular(5),
      ),
      Paint()
        ..color = const Color(0x66FF3333)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
    );

    // Core body
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset.zero, width: size.x, height: size.y),
        const Radius.circular(2),
      ),
      Paint()..color = const Color(0xFFFF4444),
    );

    // Tip
    final path = Path()
      ..moveTo(-size.x / 2, -size.y / 2)
      ..lineTo(0, -size.y / 2 - 5)
      ..lineTo(size.x / 2, -size.y / 2)
      ..close();
    canvas.drawPath(path, Paint()..color = const Color(0xFFFFFFFF));

    // Flame trail
    final pulse = 1.0 + sin(_time * 20) * 0.25;
    canvas.drawCircle(
      Offset(0, size.y / 2 + 2),
      4 * pulse,
      Paint()
        ..color = const Color(0xFFFF9900)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2),
    );

    canvas.restore();
  }
}
