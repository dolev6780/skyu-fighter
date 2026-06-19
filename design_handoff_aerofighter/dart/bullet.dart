import 'dart:math';
import 'dart:ui';
import 'package:flame/components.dart';
import 'main.dart';
import 'enemy.dart';

abstract class Bullet extends PositionComponent with HasGameReference<AeroFighterGame> {
  Bullet({required Vector2 position, required Vector2 size})
      : super(position: position, size: size, anchor: Anchor.center);
}

class PlayerBullet extends Bullet {
  static const double _speed = 650;
  final Vector2 direction;
  late final Sprite _sprite;

  PlayerBullet({required Vector2 position, Vector2? direction})
      : direction = direction ?? Vector2(0, -1),
        super(position: position, size: Vector2(14, 30)); // glow margin baked in

  @override
  Future<void> onLoad() async {
    _sprite = Sprite(game.images.fromCache('bullet_player_64.png'));
  }

  @override
  void update(double dt) {
    position += direction * (_speed * dt);
  }

  @override
  void render(Canvas canvas) {
    canvas.save();
    // Rotate bullet to align with its trajectory (sprite art points up).
    canvas.rotate(atan2(direction.x, -direction.y));
    _sprite.render(canvas, position: Vector2.zero(), size: size, anchor: Anchor.center);
    canvas.restore();
  }
}

class EnemyBullet extends Bullet {
  final Vector2 direction;
  final double speed;
  late final Sprite _sprite;

  EnemyBullet({
    required Vector2 position,
    required this.direction,
    this.speed = 220,
  }) : super(position: position, size: Vector2(22, 22)); // glow margin baked in

  @override
  Future<void> onLoad() async {
    _sprite = Sprite(game.images.fromCache('bullet_enemy_64.png'));
  }

  @override
  void update(double dt) {
    position += direction * (speed * game.speedMultiplier * dt);
  }

  @override
  void render(Canvas canvas) {
    _sprite.render(canvas, position: Vector2.zero(), size: size, anchor: Anchor.center);
  }
}

class PlayerMissile extends Bullet {
  static const double _speed = 400;
  PositionComponent? _target;
  double _time = 0;
  double _angle = 0;
  late final Sprite _sprite;

  PlayerMissile({required Vector2 position})
      : super(position: position, size: Vector2(20, 32)); // flame/fins margin baked in

  @override
  Future<void> onLoad() async {
    _sprite = Sprite(game.images.fromCache('missile_player_128.png'));
  }

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
    canvas.rotate(_angle); // sprite art points up
    _sprite.render(canvas, position: Vector2.zero(), size: size, anchor: Anchor.center);
    canvas.restore();
  }
}
