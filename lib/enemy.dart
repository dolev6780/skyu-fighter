import 'dart:math';
import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flutter/painting.dart';
import 'bullet.dart';
import 'main.dart';

abstract class Enemy extends PositionComponent with HasGameReference<AeroFighterGame> {
  int health;
  final int scoreValue;
  final double shootInterval;
  double _shootTimer;

  bool get isDead => health <= 0;

  Enemy({
    required Vector2 position,
    required Vector2 size,
    required this.health,
    required this.scoreValue,
    required this.shootInterval,
    double initialShootDelay = 0,
  })  : _shootTimer = initialShootDelay,
        super(position: position, size: size, anchor: Anchor.center);

  void takeDamage(int damage) {
    health -= damage;
  }

  void fireWeapon();

  @override
  void update(double dt) {
    super.update(dt);
    _shootTimer += dt;
    if (_shootTimer >= shootInterval) {
      _shootTimer = 0;
      fireWeapon();
    }
  }
}

// ─── Small Fighter ────────────────────────────────────────────────────────────

class SmallFighter extends Enemy {
  final int movementPattern; // 0=straight, 1=left diagonal, 2=right diagonal, 3=zigzag
  final double _baseX;
  final double _baseY;
  final double _moveSpeed;
  double _time = 0;
  late final Sprite _sprite;

  SmallFighter({required Vector2 position, int? pattern})
      : movementPattern = pattern ?? Random().nextInt(4),
        _baseX = position.x,
        _baseY = position.y,
        _moveSpeed = 130 + Random().nextDouble() * 70,
        super(
          position: position,
          size: Vector2(36, 38),
          health: 1,
          scoreValue: 100,
          shootInterval: 2.0 + Random().nextDouble() * 2.0,
          initialShootDelay: Random().nextDouble() * 2.0,
        );

  @override
  Future<void> onLoad() async {
    _sprite = Sprite(game.images.fromCache('jet_2_level.png'));
  }

  @override
  void fireWeapon() {
    if (!game.player.isMounted) return;
    final dir = (game.player.position - position).normalized();
    game.world.add(EnemyBullet(position: position.clone(), direction: dir));
  }

  @override
  void update(double dt) {
    _time += dt;
    super.update(dt);
    final currentSpeed = _moveSpeed * game.speedMultiplier;
    if (game.isHorizontalLevel) {
      switch (movementPattern) {
        case 0:
          position.x -= currentSpeed * dt;
        case 1:
          position.x -= currentSpeed * dt;
          position.y -= currentSpeed * 0.3 * dt;
        case 2:
          position.x -= currentSpeed * dt;
          position.y += currentSpeed * 0.3 * dt;
        case 3:
          position.x -= currentSpeed * dt;
          position.y = _baseY + sin(_time * 2.5) * 70;
      }
    } else {
      switch (movementPattern) {
        case 0:
          position.y += currentSpeed * dt;
        case 1:
          position.y += currentSpeed * dt;
          position.x -= currentSpeed * 0.3 * dt;
        case 2:
          position.y += currentSpeed * dt;
          position.x += currentSpeed * 0.3 * dt;
        case 3:
          position.y += currentSpeed * dt;
          position.x = _baseX + sin(_time * 2.5) * 70;
      }
    }
  }

  @override
  void render(Canvas canvas) {
    canvas.save();
    // Face down in normal mode, face left in horizontal mode
    canvas.rotate(game.isHorizontalLevel ? -pi / 2 : pi);

    // Draw drop shadow
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(0, -size.y / 2 + 8),
        width: size.x * 0.75,
        height: 10,
      ),
      Paint()
        ..color = const Color(0x33000000)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
    );

    // Tint red using modulate filter to preserve shading
    final paint = Paint()
      ..colorFilter = const ColorFilter.mode(Color(0xFFFF4444), BlendMode.modulate);

    _sprite.render(
      canvas,
      position: Vector2.zero(),
      size: size,
      anchor: Anchor.center,
      overridePaint: paint,
    );
    canvas.restore();
  }
}

// ─── Bomber ───────────────────────────────────────────────────────────────────

class BomberEnemy extends Enemy {
  static const int _maxHealth = 3;
  final double _baseX;
  final double _baseY;
  double _time = 0;
  bool _flashWhite = false;
  double _flashTimer = 0;
  late final Sprite _sprite;

  BomberEnemy({required Vector2 position})
      : _baseX = position.x,
        _baseY = position.y,
        super(
          position: position,
          size: Vector2(60, 50),
          health: _maxHealth,
          scoreValue: 350,
          shootInterval: 1.4,
          initialShootDelay: 0.7,
        );

  @override
  Future<void> onLoad() async {
    _sprite = Sprite(game.images.fromCache('jet_2_level.png'));
  }

  @override
  void takeDamage(int damage) {
    super.takeDamage(damage);
    _flashWhite = true;
    _flashTimer = 0.1;
  }

  @override
  void fireWeapon() {
    if (game.isHorizontalLevel) {
      game.world.add(EnemyBullet(position: position + Vector2(-4, -12), direction: Vector2(-1, 0), speed: 190));
      game.world.add(EnemyBullet(position: position + Vector2(-4, 12), direction: Vector2(-1, 0), speed: 190));
    } else {
      game.world.add(EnemyBullet(position: position + Vector2(-12, 4), direction: Vector2(0, 1), speed: 190));
      game.world.add(EnemyBullet(position: position + Vector2(12, 4), direction: Vector2(0, 1), speed: 190));
    }
  }

  @override
  void update(double dt) {
    _time += dt;
    super.update(dt);
    if (game.isHorizontalLevel) {
      position.x -= 75 * game.speedMultiplier * dt;
      position.y = _baseY + sin(_time * 1.1) * 100;
      position.y = position.y.clamp(size.y / 2, kGameHeight - size.y / 2);
    } else {
      position.y += 75 * game.speedMultiplier * dt;
      position.x = _baseX + sin(_time * 1.1) * 100;
      position.x = position.x.clamp(size.x / 2, kGameWidth - size.x / 2);
    }

    if (_flashWhite) {
      _flashTimer -= dt;
      if (_flashTimer <= 0) _flashWhite = false;
    }
  }

  @override
  void render(Canvas canvas) {
    canvas.save();
    canvas.rotate(game.isHorizontalLevel ? -pi / 2 : pi);

    // Draw drop shadow
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(0, -size.y / 2 + 8),
        width: size.x * 0.75,
        height: 10,
      ),
      Paint()
        ..color = const Color(0x33000000)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
    );

    final Paint paint;
    if (_flashWhite) {
      // Flash white silhouette when damaged
      paint = Paint()..colorFilter = const ColorFilter.mode(Color(0xFFFFFFFF), BlendMode.srcIn);
    } else {
      // Tint green camouflage using modulate filter to preserve shading
      paint = Paint()..colorFilter = const ColorFilter.mode(Color(0xFF66BB66), BlendMode.modulate);
    }

    _sprite.render(
      canvas,
      position: Vector2.zero(),
      size: size,
      anchor: Anchor.center,
      overridePaint: paint,
    );
    canvas.restore();

    // Upright health bar
    final barW = size.x * 0.75;
    final barX = -barW / 2;
    const barY = -32.0;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
          Rect.fromLTWH(barX, barY, barW, 5), const Radius.circular(2)),
      Paint()..color = const Color(0x88000000),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
          Rect.fromLTWH(barX, barY, barW * (health / _maxHealth), 5),
          const Radius.circular(2)),
      Paint()..color = const Color(0xFF44FF44),
    );
  }
}
