import 'dart:math';
import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flame/particles.dart';
import 'main.dart';
import 'enemy.dart';

abstract class Bullet extends PositionComponent with HasGameReference<AeroFighterGame> {
  Bullet({required Vector2 position, required Vector2 size})
      : super(position: position, size: size, anchor: Anchor.center);
}

class PlayerBullet extends Bullet {
  static const double _speed = 650;
  final Vector2 direction;
  late final Sprite _sprite = Sprite(game.images.fromCache('bullet_player_64.png'));

  PlayerBullet({required super.position, Vector2? direction})
      : direction = direction ?? Vector2(0, -1),
        super(size: Vector2(5, 18));

  @override
  void update(double dt) {
    position += direction * (_speed * dt);
  }

  @override
  void render(Canvas canvas) {
    canvas.save();
    canvas.rotate(atan2(direction.x, -direction.y));
    
    // Add blue glow
    canvas.drawOval(
      Rect.fromCenter(center: Offset.zero, width: 20, height: 36),
      Paint()
        ..color = const Color(0x8800FFFF)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
    );

    _sprite.render(canvas, position: Vector2.zero(),
        size: Vector2(14, 30), anchor: Anchor.center);
    canvas.restore();
  }
}

class EnemyBullet extends Bullet {
  final Vector2 direction;
  final double speed;
  late final Sprite _sprite = Sprite(game.images.fromCache('bullet_enemy_64.png'));

  EnemyBullet({
    required super.position,
    required this.direction,
    this.speed = 220,
  }) : super(size: Vector2(12, 12));

  @override
  void update(double dt) {
    position += direction * (speed * game.speedMultiplier * dt);
  }

  @override
  void render(Canvas canvas) {
    // Add red glow
    canvas.drawCircle(
      Offset.zero,
      14,
      Paint()
        ..color = const Color(0x99FF2222)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
    );

    _sprite.render(canvas, position: Vector2.zero(),
        size: Vector2(22, 22), anchor: Anchor.center);
  }
}

class PlayerMissile extends Bullet {
  static const double _speed = 400;
  PositionComponent? _target;
  double _angle = 0;
  late final Sprite _sprite = Sprite(game.images.fromCache('missile_player_128.png'));

  PlayerMissile({required super.position})
      : super(size: Vector2(10, 22));

  @override
  void update(double dt) {
    super.update(dt);

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

    // Add smoke trail
    if (Random().nextDouble() < 0.4) {
      game.world.add(
        ParticleSystemComponent(
          position: position.clone() - (steerDir * 10),
          particle: Particle.generate(
            count: 1,
            lifespan: 0.3 + Random().nextDouble() * 0.2,
            generator: (i) => ComputedParticle(
              renderer: (canvas, particle) {
                final opacity = (1 - particle.progress).clamp(0.0, 1.0) * 0.5;
                final size = 3.0 + (particle.progress * 4.0);
                canvas.drawCircle(
                  Offset.zero,
                  size,
                  Paint()
                    ..color = const Color(0xFFCCCCCC).withValues(alpha: opacity)
                    ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2),
                );
              },
            ),
          ),
        ),
      );
    }
  }

  @override
  void render(Canvas canvas) {
    canvas.save();
    canvas.rotate(_angle);

    // Add orange glow
    canvas.drawOval(
      Rect.fromCenter(center: Offset.zero, width: 28, height: 40),
      Paint()
        ..color = const Color(0x66FF8800)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
    );

    _sprite.render(canvas, position: Vector2.zero(),
        size: Vector2(20, 32), anchor: Anchor.center);
    canvas.restore();
  }
}
