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
  int movementPattern; // 0=straight, 1=left diagonal, 2=right diagonal, 3=zigzag
  final double _baseX;
  final double _baseY;
  final double _moveSpeed;
  double _time = 0;
  bool _flashWhite = false;
  double _flashTimer = 0;
  late final Sprite _sprite;

  SmallFighter({required super.position, int? pattern})
      : movementPattern = pattern ?? Random().nextInt(4),
        _baseX = position.x,
        _baseY = position.y,
        _moveSpeed = 70 + Random().nextDouble() * 40,
        super(
          size: Vector2(36, 38),
          health: 100,
          scoreValue: 100,
          shootInterval: 2.5 + Random().nextDouble() * 2.0,
          initialShootDelay: 1.0 + Random().nextDouble() * 1.5,
        );

  @override
  Future<void> onLoad() async {
    final img = game.isHorizontalLevel ? 'enemy_fighter_side_512.png' : 'enemy_fighter_256.png';
    _sprite = Sprite(game.images.fromCache(img));
  }

  @override
  void takeDamage(int damage) {
    super.takeDamage(damage);
    _flashWhite = true;
    _flashTimer = 0.1;
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
          break;
        case 1:
          position.x -= currentSpeed * dt;
          position.y -= currentSpeed * 0.3 * dt;
          if (position.y <= size.y / 2) movementPattern = 2;
          break;
        case 2:
          position.x -= currentSpeed * dt;
          position.y += currentSpeed * 0.3 * dt;
          if (position.y >= kGameHeight - size.y / 2) movementPattern = 1;
          break;
        case 3:
          position.x -= currentSpeed * dt;
          position.y = _baseY + sin(_time * 2.5) * 70;
          break;
      }
      position.y = position.y.clamp(size.y / 2 + 12.0, kGameHeight - size.y / 2 - 12.0);
    } else {
      switch (movementPattern) {
        case 0:
          position.y += currentSpeed * dt;
          break;
        case 1:
          position.y += currentSpeed * dt;
          position.x -= currentSpeed * 0.3 * dt;
          if (position.x <= size.x / 2) movementPattern = 2;
          break;
        case 2:
          position.y += currentSpeed * dt;
          position.x += currentSpeed * 0.3 * dt;
          if (position.x >= kGameWidth - size.x / 2) movementPattern = 1;
          break;
        case 3:
          position.y += currentSpeed * dt;
          position.x = _baseX + sin(_time * 2.5) * 70;
          break;
      }
      position.x = position.x.clamp(size.x / 2 + 12.0, kGameWidth - size.x / 2 - 12.0);
    }
    
    if (_flashWhite) {
      _flashTimer -= dt;
      if (_flashTimer <= 0) _flashWhite = false;
    }
  }

  @override
  void render(Canvas canvas) {
    canvas.save();
    // Face down in normal mode, face left in horizontal mode
    if (!game.isHorizontalLevel) {
      canvas.rotate(pi);
    }

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

    if (_flashWhite) {
      final paint = Paint()
        ..colorFilter = const ColorFilter.mode(Color(0xFFFFFFFF), BlendMode.srcIn);
      _sprite.render(canvas, position: Vector2.zero(), size: size,
          anchor: Anchor.center, overridePaint: paint);
    } else {
      _sprite.render(canvas, position: Vector2.zero(), size: size, anchor: Anchor.center);
    }
    canvas.restore();
  }
}

// ─── Bomber ───────────────────────────────────────────────────────────────────

class BomberEnemy extends Enemy {
  static const int _maxHealth = 300;
  final double _baseX;
  final double _baseY;
  double _time = 0;
  bool _flashWhite = false;
  double _flashTimer = 0;
  late final Sprite _sprite;

  BomberEnemy({required super.position})
      : _baseX = position.x,
        _baseY = position.y,
        super(
          size: Vector2(60, 50),
          health: _maxHealth,
          scoreValue: 350,
          shootInterval: 1.8,
          initialShootDelay: 1.0,
        );

  @override
  Future<void> onLoad() async {
    final img = game.isHorizontalLevel ? 'enemy_bomber_side_512.png' : 'enemy_bomber_256.png';
    _sprite = Sprite(game.images.fromCache(img));
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
      position.x -= 45 * game.speedMultiplier * dt;
      position.y = _baseY + sin(_time * 1.1) * 100;
      position.y = position.y.clamp(size.y / 2 + 12.0, kGameHeight - size.y / 2 - 12.0);
    } else {
      position.y += 45 * game.speedMultiplier * dt;
      position.x = _baseX + sin(_time * 1.1) * 100;
      position.x = position.x.clamp(size.x / 2 + 12.0, kGameWidth - size.x / 2 - 12.0);
    }

    if (_flashWhite) {
      _flashTimer -= dt;
      if (_flashTimer <= 0) _flashWhite = false;
    }
  }

  @override
  void render(Canvas canvas) {
    canvas.save();
    if (!game.isHorizontalLevel) {
      canvas.rotate(pi);
    }

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

    if (_flashWhite) {
      final paint = Paint()
        ..colorFilter = const ColorFilter.mode(Color(0xFFFFFFFF), BlendMode.srcIn);
      _sprite.render(canvas, position: Vector2.zero(), size: size,
          anchor: Anchor.center, overridePaint: paint);
    } else {
      _sprite.render(canvas, position: Vector2.zero(), size: size, anchor: Anchor.center);
    }
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
