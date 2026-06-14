import 'dart:math';
import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'bullet.dart';
import 'main.dart';

class Player extends PositionComponent with HasGameReference<AeroFighterGame> {
  static const double _baseFireInterval = 0.13;
  static const double _invincibleDuration = 1.8;

  double get _effectiveFireInterval {
    final fp = jetSkins[game.selectedSkinIndex].firepowerStat;
    return _baseFireInterval * (0.6 / fp).clamp(0.55, 1.15);
  }

  double _fireTimer = 0;
  double _invincibleTimer = 0;
  bool _visible = true;

  bool get isInvincible => _invincibleTimer > 0;

  int weaponLevel = 1;
  double shieldTimer = 0.0;
  bool get hasShield => shieldTimer > 0;
  double rapidFireTimer = 0.0;
  double missileTimer = 0.0;

  // Sprite components (managed and rendered manually to avoid duplicating the jet body)
  late final SpriteComponent _staticBodyComponent;
  late final SpriteAnimationComponent _animatedBodyComponent;
  final List<Sprite> _sprites = [];

  // Banking physics variables
  double _targetBank = 0.0;
  double _currentBank = 0.0;
  bool _movedThisFrame = false;

  Player({required Vector2 position})
      : super(position: position, size: Vector2(56, 56), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    // Populate banking sprites (0: hard left, 1: bank left, 2: level, 3: bank right, 4: hard right)
    _sprites.addAll([
      Sprite(game.images.fromCache('jet_0_hard_left.png')),
      Sprite(game.images.fromCache('jet_1_bank_left.png')),
      Sprite(game.images.fromCache('jet_2_level.png')),
      Sprite(game.images.fromCache('jet_3_bank_right.png')),
      Sprite(game.images.fromCache('jet_4_hard_right.png')),
    ]);

    // Create the static body component (centered at Vector2.zero since the canvas is already translated)
    _staticBodyComponent = SpriteComponent(
      sprite: _sprites[2],
      position: Vector2.zero(),
      size: size,
      anchor: Anchor.center,
    );

    // Create the animated body component for level flight (includes animated exhaust flame)
    final thrustSheet = SpriteSheet(
      image: game.images.fromCache('fighter_jet_thrust_loop_256.png'),
      srcSize: Vector2.all(256),
    );
    _animatedBodyComponent = SpriteAnimationComponent(
      animation: thrustSheet.createAnimation(row: 0, stepTime: 0.07, loop: true),
      position: Vector2.zero(),
      size: size,
      anchor: Anchor.center,
    );
  }

  void moveBy(Vector2 delta) {
    final sp = jetSkins[game.selectedSkinIndex].speedStat;
    position += delta * (sp / 0.6).clamp(0.6, 1.8);
    position.x = position.x.clamp(size.x / 2, kGameWidth - size.x / 2);
    position.y = position.y.clamp(size.y / 2, kGameHeight - size.y / 2);

    if (!game.isHorizontalLevel) {
      _movedThisFrame = true;
      if (delta.x < -1.2) {
        _targetBank = -2.0;
      } else if (delta.x < -0.1) {
        _targetBank = -1.0;
      } else if (delta.x > 1.2) {
        _targetBank = 2.0;
      } else if (delta.x > 0.1) {
        _targetBank = 1.0;
      }
    }
  }

  void triggerInvincibility() {
    final armor = jetSkins[game.selectedSkinIndex].armorStat;
    _invincibleTimer = _invincibleDuration * (armor / 0.6).clamp(0.6, 1.8);
    _visible = true;
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (shieldTimer > 0) {
      shieldTimer -= dt;
    }

    if (rapidFireTimer > 0) {
      rapidFireTimer -= dt;
    }

    if (missileTimer > 0) {
      missileTimer -= dt;
    }

    _fireTimer += dt;
    final currentFireInterval = rapidFireTimer > 0 ? _effectiveFireInterval / 2.0 : _effectiveFireInterval;
    if (_fireTimer >= currentFireInterval) {
      _fireTimer = 0;
      _shoot();
    }

    if (_invincibleTimer > 0) {
      _invincibleTimer -= dt;
      _visible = ((_invincibleTimer * 8).floor() % 2 == 0);
      if (_invincibleTimer <= 0) _visible = true;
    }

    // Horizontal mode: always level (no banking while facing right)
    if (game.isHorizontalLevel) {
      _targetBank = 0.0;
      _currentBank = 0.0;
    } else if (!_movedThisFrame) {
      _targetBank = 0.0;
    }
    _movedThisFrame = false;

    // Smoothly transition banking angle
    final lerpFactor = 12 * dt;
    _currentBank += (_targetBank - _currentBank) * lerpFactor.clamp(0.0, 1.0);

    // Map banking value to sprite index
    int spriteIndex = 2;
    if (_currentBank < -1.2) {
      spriteIndex = 0;
    } else if (_currentBank < -0.3) {
      spriteIndex = 1;
    } else if (_currentBank > 1.2) {
      spriteIndex = 4;
    } else if (_currentBank > 0.3) {
      spriteIndex = 3;
    }

    // Update active component state
    if (spriteIndex == 2) {
      _animatedBodyComponent.update(dt);
    } else {
      _staticBodyComponent.sprite = _sprites[spriteIndex];
      _staticBodyComponent.update(dt);
    }
  }

  void _shoot() {
    if (game.gameOver) return;

    if (game.isHorizontalLevel) {
      // Horizontal mode: fire rightward from the right edge of the sprite
      final bulletX = position.x + size.x / 2;
      final right = Vector2(1, 0);
      if (weaponLevel == 1) {
        game.world.add(PlayerBullet(position: Vector2(bulletX, position.y - 10), direction: right));
        game.world.add(PlayerBullet(position: Vector2(bulletX, position.y + 10), direction: right));
      } else if (weaponLevel == 2) {
        game.world.add(PlayerBullet(position: Vector2(bulletX, position.y - 11), direction: right));
        game.world.add(PlayerBullet(position: Vector2(bulletX, position.y + 11), direction: right));
        game.world.add(PlayerBullet(position: Vector2(bulletX + 6, position.y), direction: right));
      } else {
        game.world.add(PlayerBullet(position: Vector2(bulletX, position.y - 11), direction: right));
        game.world.add(PlayerBullet(position: Vector2(bulletX, position.y + 11), direction: right));
        game.world.add(PlayerBullet(position: Vector2(bulletX + 6, position.y), direction: right));
        game.world.add(PlayerBullet(position: Vector2(bulletX + 2, position.y - 16), direction: Vector2(0.97, -0.24).normalized()));
        game.world.add(PlayerBullet(position: Vector2(bulletX + 2, position.y + 16), direction: Vector2(0.97, 0.24).normalized()));
      }
      if (missileTimer > 0) {
        game.world.add(PlayerMissile(position: Vector2(position.x, position.y - 24)));
        game.world.add(PlayerMissile(position: Vector2(position.x, position.y + 24)));
      }
    } else {
      final bulletY = position.y - size.y / 2;
      if (weaponLevel == 1) {
        game.world.add(PlayerBullet(position: Vector2(position.x - 11, bulletY)));
        game.world.add(PlayerBullet(position: Vector2(position.x + 11, bulletY)));
      } else if (weaponLevel == 2) {
        game.world.add(PlayerBullet(position: Vector2(position.x - 12, bulletY)));
        game.world.add(PlayerBullet(position: Vector2(position.x + 12, bulletY)));
        game.world.add(PlayerBullet(position: Vector2(position.x, bulletY - 6)));
      } else {
        game.world.add(PlayerBullet(position: Vector2(position.x - 12, bulletY)));
        game.world.add(PlayerBullet(position: Vector2(position.x + 12, bulletY)));
        game.world.add(PlayerBullet(position: Vector2(position.x, bulletY - 6)));
        game.world.add(PlayerBullet(position: Vector2(position.x - 16, bulletY + 2), direction: Vector2(-0.24, -0.97).normalized()));
        game.world.add(PlayerBullet(position: Vector2(position.x + 16, bulletY + 2), direction: Vector2(0.24, -0.97).normalized()));
      }
      if (missileTimer > 0) {
        game.world.add(PlayerMissile(position: Vector2(position.x - 24, position.y)));
        game.world.add(PlayerMissile(position: Vector2(position.x + 24, position.y)));
      }
    }
  }

  @override
  void render(Canvas canvas) {
    if (!_visible) return;

    final isHoriz = game.isHorizontalLevel;

    // Shadow offset depends on orientation
    canvas.drawOval(
      Rect.fromCenter(
        center: isHoriz ? Offset(size.x / 2 - 8, 0) : Offset(0, size.y / 2 - 8),
        width: isHoriz ? 10 : size.x * 0.75,
        height: isHoriz ? size.y * 0.75 : 10,
      ),
      Paint()
        ..color = const Color(0x44000000)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
    );

    canvas.save();
    if (isHoriz) canvas.rotate(pi / 2); // face right

    final filter = game.selectedSkinFilter;
    if (filter != null) {
      canvas.saveLayer(null, Paint()..colorFilter = filter);
    }

    if (_currentBank.abs() < 0.3) {
      _animatedBodyComponent.render(canvas);
    } else {
      _staticBodyComponent.render(canvas);
    }

    if (filter != null) {
      canvas.restore();
    }

    canvas.restore();

    // Render glowing shield orbit
    if (hasShield) {
      final time = DateTime.now().millisecondsSinceEpoch / 1000.0;
      final pulse = 1.0 + sin(time * 6) * 0.04;
      final opacity = 0.6 + sin(time * 10) * 0.15;

      canvas.drawCircle(
        Offset.zero,
        size.x * 0.85 * pulse,
        Paint()
          ..color = const Color(0x223388FF)
          ..style = PaintingStyle.fill,
      );

      canvas.drawCircle(
        Offset.zero,
        size.x * 0.85 * pulse,
        Paint()
          ..color = const Color(0xFF3388FF).withOpacity(opacity)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.0
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2),
      );
    }
  }
}
