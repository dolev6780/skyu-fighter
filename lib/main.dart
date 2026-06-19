import 'dart:math';
import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:flutter/scheduler.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'player.dart';
import 'enemy.dart';
import 'bullet.dart';
import 'explosion.dart';
import 'power_up.dart';
import 'start_menu.dart';
import 'game_overlays.dart';
import 'theme/af_tokens.dart';
import 'theme/af_text_styles.dart';

double kGameWidth = 400;
double kGameHeight = 700;

enum GameDifficulty { easy, medium, hard }

class JetSkin {
  final String name;
  final Color color;
  final String description;
  final double speedStat;
  final double armorStat;
  final double firepowerStat;

  const JetSkin({
    required this.name,
    required this.color,
    required this.description,
    required this.speedStat,
    required this.armorStat,
    required this.firepowerStat,
  });
}

const List<JetSkin> jetSkins = [
  JetSkin(
    name: 'COBALT ALPHA',
    color: Colors.transparent, // Default (no filter)
    description:
        'Standard multi-role tactical interceptor. Perfectly balanced design.',
    speedStat: 0.6,
    armorStat: 0.6,
    firepowerStat: 0.6,
  ),
  JetSkin(
    name: 'CRIMSON PHOENIX',
    color: Color(0xFFFF2244),
    description:
        'High-speed interceptor. Advanced engine allows rapid response.',
    speedStat: 0.9,
    armorStat: 0.4,
    firepowerStat: 0.7,
  ),
  JetSkin(
    name: 'SOLAR EAGLE',
    color: Color(0xFFFFBB00),
    description:
        'Heavy tactical fighter. Superior armor plating to absorb impacts.',
    speedStat: 0.4,
    armorStat: 0.9,
    firepowerStat: 0.7,
  ),
  JetSkin(
    name: 'EMERALD VIPER',
    color: Color(0xFF00EE55),
    description: 'Experimental design. Upgraded cooling for high fire rates.',
    speedStat: 0.7,
    armorStat: 0.5,
    firepowerStat: 0.9,
  ),
];

// ─── Level Data ───────────────────────────────────────────────────────────────

class LevelData {
  final int world;
  final int level;

  const LevelData(this.world, this.level);

  String get id => '$world-$level';

  String get background {
    const bgs = [
      'bg_morning_720x1280.png',
      'bg_midday_720x1280.png',
      'bg_afternoon_720x1280.png',
      'bg_night_720x1280.png',
    ];
    return bgs[level - 1];
  }

  bool get isHorizontal => level == 3;

  int get killTarget {
    const base = [30, 40, 35, 50];
    return base[level - 1] + (world - 1) * 10;
  }

  Color get worldColor {
    const colors = [
      Color(0xFFFFAA00), // W1 morning
      Color(0xFF00AAFF), // W2 midday
      Color(0xFFFF5500), // W3 afternoon
      Color(0xFF9933FF), // W4 night
    ];
    return colors[world - 1];
  }

  String get worldName {
    const names = ['DAWN SECTOR', 'MIDDAY FRONT', 'DUSK ZONE', 'NIGHT OPS'];
    return names[world - 1];
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint('Firebase init error: $e');
  }
  final physicalSize = PlatformDispatcher.instance.views.first.physicalSize;
  kGameHeight = kGameWidth * (physicalSize.height / physicalSize.width);
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.fullScreen();
  await Flame.device.setPortrait();
  runApp(const AeroFighterApp());
}

class AeroFighterApp extends StatelessWidget {
  const AeroFighterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.black,
        body: GameWidget<AeroFighterGame>(
          game: AeroFighterGame(),
          overlayBuilderMap: {
            'StartMenu': (context, game) => StartMenuOverlay(game: game),
            'Controls': (context, game) => ControlsOverlay(game: game),
            'GameOver': (context, game) => GameOverOverlay(game: game),
            'LevelComplete': (context, game) =>
                LevelCompleteOverlay(game: game),
            'PauseMenu': (context, game) => PauseMenuOverlay(game: game),
            'HUD': (context, game) => _HUDOverlay(game: game),
          },
          initialActiveOverlays: const ['StartMenu'],
        ),
      ),
    );
  }
}

// ─── Game ─────────────────────────────────────────────────────────────────────

class AeroFighterGame extends FlameGame {
  AeroFighterGame()
    : super(
        camera: CameraComponent.withFixedResolution(
          width: kGameWidth,
          height: kGameHeight,
        ),
        world: World(),
      );

  late Player player;
  int score = 0;
  int lives = 3;
  int health = 3;
  int maxHealth = 3;
  bool gameOver = false;
  bool gameStarted = false;

  int highScore = 0;
  GameDifficulty difficulty = GameDifficulty.medium;
  int selectedSkinIndex = 0;

  // Level progression
  int currentWorld = 1;
  int currentLevel = 1;
  int _levelKillCount = 0;
  int _itemsDroppedThisLevel = 0;
  bool levelComplete = false;
  final Set<String> unlockedLevels = {'1-1'};
  final Set<String> completedLevels = {};

  LevelData get currentLevelData => LevelData(currentWorld, currentLevel);
  bool get isHorizontalLevel => currentLevel == 3;
  int get levelKillCount => _levelKillCount;
  String get selectedBgImage =>
      gameStarted ? currentLevelData.background : 'bg_morning_720x1280.png';

  double get speedMultiplier {
    final base = switch (difficulty) {
      GameDifficulty.easy => 0.85,
      GameDifficulty.medium => 1.0,
      GameDifficulty.hard => 1.25,
    };
    return base * (1.0 + (currentWorld - 1) * 0.15 + (currentLevel - 1) * 0.03);
  }

  double get spawnIntervalMultiplier {
    final base = switch (difficulty) {
      GameDifficulty.easy => 1.25,
      GameDifficulty.medium => 1.0,
      GameDifficulty.hard => 0.75,
    };
    return base * (1.0 - (currentWorld - 1) * 0.08).clamp(0.5, 1.25);
  }

  ColorFilter? get selectedSkinFilter {
    if (selectedSkinIndex == 0) return null;
    return ColorFilter.mode(
      jetSkins[selectedSkinIndex].color.withOpacity(0.4),
      BlendMode.srcATop,
    );
  }

  final _rng = Random();
  double _spawnTimer = 0;
  double _spawnInterval = 1.8;
  double _totalTime = 0;
  int _killCount = 0;
  int _comboCount = 0;
  double _comboTimer = 0;
  double _shakeTimer = 0;

  static const double _comboWindow = 2.5;
  static const double _shakeDuration = 0.25;
  int get comboMultiplier => _comboCount < 3 ? 1 : (_comboCount < 6 ? 2 : 3);

  @override
  Color backgroundColor() => const Color(0xFF001133);

  @override
  Future<void> onLoad() async {
    // Preload sprite images
    await images.loadAll([
      'fighter_jet_sheet_256.png',
      'fighter_jet_thrust_loop_256.png',
      'fighter_jet_explosion_256.png',
      'jet_0_hard_left.png',
      'jet_1_bank_left.png',
      'jet_2_level.png',
      'jet_3_bank_right.png',
      'jet_4_hard_right.png',
      'bg_morning_720x1280.png',
      'bg_midday_720x1280.png',
      'bg_afternoon_720x1280.png',
      'bg_night_720x1280.png',
      'powerups_strip_128.png',
      'enemy_fighter_256.png',
      'enemy_bomber_256.png',
      'bullet_player_64.png',
      'bullet_enemy_64.png',
      'missile_player_128.png',
      'enemy_fighter_side_512.png',
      'enemy_bomber_side_512.png',
      'jet_hero_side_512.png',
    ]);

    // Show world from (0,0) to (kGameWidth, kGameHeight) in screen space
    camera.viewfinder.anchor = Anchor.topLeft;

    world.add(OceanBackground());

    // Initialize player but don't add to the world yet
    player = Player(position: Vector2(kGameWidth / 2, kGameHeight - 110));

    // HUD now handled by _HUDOverlay widget
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (_shakeTimer > 0) {
      _shakeTimer -= dt;
      final amp = max(0.0, 5.0 * (_shakeTimer / _shakeDuration));
      camera.viewfinder.position = _shakeTimer > 0
          ? Vector2(
              _rng.nextDouble() * amp * 2 - amp,
              _rng.nextDouble() * amp * 2 - amp,
            )
          : Vector2.zero();
    }
    if (!gameStarted || gameOver) return;

    _totalTime += dt;
    _spawnTimer += dt;
    if (_comboTimer > 0) {
      _comboTimer -= dt;
      if (_comboTimer <= 0) _comboCount = 0;
    }
    final baseInterval = difficulty == GameDifficulty.easy
        ? 2.2
        : (difficulty == GameDifficulty.hard ? 1.3 : 1.8);
    _spawnInterval =
        ((baseInterval - _totalTime * 0.008) * spawnIntervalMultiplier).clamp(
          0.35,
          2.5,
        );

    if (_spawnTimer >= _spawnInterval) {
      _spawnTimer = 0;
      _spawnWave();
    }

    _checkCollisions();
    _cleanupOffscreen();

    if (!levelComplete && _levelKillCount >= currentLevelData.killTarget) {
      _completeLevel();
    }
  }

  void _completeLevel() {
    levelComplete = true;
    completedLevels.add(currentLevelData.id);
    final w = currentWorld;
    final l = currentLevel;
    if (l < 4) {
      unlockedLevels.add('$w-${l + 1}');
    } else if (w < 4) {
      unlockedLevels.add('${w + 1}-1');
    }
    if (score > highScore) highScore = score;
    overlays.remove('Controls');
    overlays.remove('PauseButton');
    overlays.remove('HUD');
    overlays.add('LevelComplete');
    paused = true;
  }

  void _spawnWave() {
    if (isHorizontalLevel) {
      // Enemies spawn from right edge at random Y positions
      final y = _rng.nextDouble() * (kGameHeight - 80) + 40;
      final useBomber = _killCount >= 8 && _rng.nextDouble() < 0.22;
      if (useBomber) {
        world.add(
          BomberEnemy(
            position: Vector2(kGameWidth + 60, y.clamp(60, kGameHeight - 60)),
          ),
        );
      } else if (_rng.nextDouble() < 0.35 && _killCount >= 5) {
        final y2 = (y + (_rng.nextBool() ? 70.0 : -70.0)).clamp(
          40.0,
          kGameHeight - 40.0,
        );
        world.add(SmallFighter(position: Vector2(kGameWidth + 40, y)));
        world.add(SmallFighter(position: Vector2(kGameWidth + 40, y2)));
      } else {
        world.add(SmallFighter(position: Vector2(kGameWidth + 40, y)));
      }
    } else {
      final x = _rng.nextDouble() * (kGameWidth - 80) + 40;
      final useBomber = _killCount >= 8 && _rng.nextDouble() < 0.28;
      if (useBomber) {
        world.add(
          BomberEnemy(position: Vector2(x.clamp(60, kGameWidth - 60), -60)),
        );
      } else if (_rng.nextDouble() < 0.35 && _killCount >= 5) {
        final x2 = (x + (_rng.nextBool() ? 80.0 : -80.0)).clamp(
          40.0,
          kGameWidth - 40.0,
        );
        world.add(SmallFighter(position: Vector2(x, -40)));
        world.add(SmallFighter(position: Vector2(x2, -40)));
      } else {
        world.add(SmallFighter(position: Vector2(x, -40)));
      }
    }
  }

  void _checkCollisions() {
    final playerBullets = world.children.whereType<PlayerBullet>().toList();
    final playerMissiles = world.children.whereType<PlayerMissile>().toList();
    final playerProjectiles = [...playerBullets, ...playerMissiles];
    final enemies = world.children.whereType<Enemy>().toList();
    final enemyBullets = world.children.whereType<EnemyBullet>().toList();

    for (final bullet in playerProjectiles) {
      for (final enemy in enemies) {
        if (_overlaps(bullet, enemy)) {
          bullet.removeFromParent();
          enemy.takeDamage(34);
          if (enemy.isDead) {
            _comboCount++;
            _comboTimer = _comboWindow;
            final mult = comboMultiplier;
            score += enemy.scoreValue * mult;
            _killCount++;
            _levelKillCount++;
            spawnExplosion(enemy.position, enemy.size.x);
            enemy.removeFromParent();
            if (mult > 1 && (_comboCount == 3 || _comboCount == 6)) {
              world.add(
                FloatingText(
                  position: enemy.position.clone(),
                  text: 'x$mult COMBO!',
                  color: const Color(0xFFFFDD00),
                ),
              );
            }

            // Spawn power-up drop
            final isBomber = enemy is BomberEnemy;
            final dropRate = isBomber ? 1.0 : 0.12;
            if (_rng.nextDouble() < dropRate && _itemsDroppedThisLevel < 5) {
              _itemsDroppedThisLevel++;
              final roll = _rng.nextDouble();
              PowerUpType type;
              if (roll < 0.15) {
                type = PowerUpType.weaponUp;
              } else if (roll < 0.30) {
                type = PowerUpType.rapidFire;
              } else if (roll < 0.45) {
                type = PowerUpType.missiles;
              } else if (roll < 0.57) {
                type = PowerUpType.repair;
              } else if (roll < 0.65) {
                type = PowerUpType.extraLife;
              } else if (roll < 0.77) {
                type = PowerUpType.armor;
              } else if (roll < 0.85) {
                type = PowerUpType.nuke;
              } else {
                type = PowerUpType.scoreStar;
              }
              world.add(PowerUp(position: enemy.position.clone(), type: type));
            }
          }
          break;
        }
      }
    }

    if (!player.isInvincible && player.isMounted) {
      for (final bullet in enemyBullets) {
        if (_overlaps(bullet, player)) {
          bullet.removeFromParent();
          _hitPlayer();
          return;
        }
      }
      for (final enemy in enemies) {
        if (_overlaps(enemy, player)) {
          spawnExplosion(enemy.position, enemy.size.x);
          enemy.removeFromParent();
          _hitPlayer();
          return;
        }
      }
    }

    // Handle collecting power-ups
    if (player.isMounted && !gameOver) {
      final powerUps = world.children.whereType<PowerUp>().toList();
      for (final powerUp in powerUps) {
        if (_overlaps(powerUp, player, s: 0.0)) {
          powerUp.removeFromParent();
          _collectPowerUp(powerUp.type);
        }
      }
    }
  }

  void _collectPowerUp(PowerUpType type) {
    String text;
    Color color;
    switch (type) {
      case PowerUpType.weaponUp:
        player.weaponLevel = (player.weaponLevel + 1).clamp(1, 3);
        text = 'WEAPON UP';
        color = const Color(0xFFFF8800);
        break;
      case PowerUpType.rapidFire:
        player.rapidFireTimer = 1.0;
        text = 'RAPID FIRE';
        color = const Color(0xFFFFFF33);
        break;
      case PowerUpType.missiles:
        player.missileTimer = 30.0;
        text = 'MISSILES ACTIVE';
        color = const Color(0xFFFF3333);
        break;
      case PowerUpType.repair:
        if (health < maxHealth) {
          health = maxHealth;
          text = 'HP RESTORED';
        } else {
          if (lives < 5) {
            lives++;
            text = 'SYSTEM REPAIRED';
          } else {
            text = 'SYSTEMS NOMINAL';
          }
        }
        color = const Color(0xFF33FF33);
        break;
      case PowerUpType.extraLife:
        if (lives < 5) {
          lives++;
          text = 'EXTRA LIFE';
        } else {
          text = 'MAX LIVES';
        }
        color = const Color(0xFFFFFFFF);
        break;
      case PowerUpType.armor:
        player.shieldTimer = 1.0;
        text = 'ARMOR CHARGED';
        color = const Color(0xFF3388FF);
        break;
      case PowerUpType.nuke:
        text = 'TACTICAL NUKE';
        color = const Color(0xFFCC33FF);
        _triggerNuke();
        break;
      case PowerUpType.scoreStar:
        score += 1000;
        text = '+1000 SCORE';
        color = const Color(0xFFFFD700);
        break;
    }
    world.add(
      FloatingText(position: player.position.clone(), text: text, color: color),
    );
  }

  void _triggerNuke() {
    final enemies = world.children.whereType<Enemy>().toList();
    for (final enemy in enemies) {
      score += enemy.scoreValue;
      _killCount++;
      spawnExplosion(enemy.position, enemy.size.x);
      enemy.removeFromParent();
    }
    final bullets = world.children.whereType<EnemyBullet>().toList();
    for (final bullet in bullets) {
      bullet.removeFromParent();
    }
  }

  bool _overlaps(PositionComponent a, PositionComponent b, {double s = 0.1}) {
    // s is the shrink factor — smaller hitbox feels fairer. For powerups, use a negative s.
    final ax = a.position.x - a.size.x * (0.5 - s);
    final ay = a.position.y - a.size.y * (0.5 - s);
    final aw = a.size.x * (1 - s * 2);
    final ah = a.size.y * (1 - s * 2);
    final bx = b.position.x - b.size.x * (0.5 - s);
    final by = b.position.y - b.size.y * (0.5 - s);
    final bw = b.size.x * (1 - s * 2);
    final bh = b.size.y * (1 - s * 2);
    return ax < bx + bw && ax + aw > bx && ay < by + bh && ay + ah > by;
  }

  void _hitPlayer() {
    _shakeTimer = _shakeDuration;
    if (player.hasShield) {
      player.shieldTimer = 0.0;
      player.triggerHitFlash();
      world.add(
        FloatingText(
          position: player.position.clone(),
          text: 'SHIELD DEPLETED',
          color: const Color(0xFF00FFFF),
        ),
      );
      return;
    }

    health--;
    if (health > 0) {
      player.triggerHitFlash();
      spawnExplosion(player.position, 40);
      return;
    }

    // Explode when taking a hit
    health = maxHealth;
    spawnExplosion(player.position, 80);
    player.triggerInvincibility();
    lives--;

    if (lives <= 0) {
      lives = 0;
      gameOver = true;
      if (score > highScore) {
        highScore = score;
      }
      player.removeFromParent();
      overlays.remove('Controls');
      overlays.remove('PauseButton');

      // Delay showing the start again modal so the player can see the explosion finish
      Future.delayed(const Duration(milliseconds: 1200), () {
        if (gameOver) {
          overlays.add('GameOver');
        }
      });
    } else {
      // Respawn position after explosion
      player.position = isHorizontalLevel
          ? Vector2(80, kGameHeight / 2)
          : Vector2(kGameWidth / 2, kGameHeight - 110);

      // Reset power-ups on explosion
      player.weaponLevel = 1;
      player.rapidFireTimer = 0;
      player.missileTimer = 0;
      player.shieldTimer = 0;
    }
  }

  void _cleanupOffscreen() {
    const buf = 80.0;
    for (final e in world.children.whereType<Enemy>().toList()) {
      if (isHorizontalLevel) {
        if (e.position.x < -buf) e.removeFromParent();
      } else {
        if (e.position.y > kGameHeight + buf) e.removeFromParent();
      }
    }
    for (final b in world.children.whereType<Bullet>().toList()) {
      if (b.position.y < -buf ||
          b.position.y > kGameHeight + buf ||
          b.position.x < -buf ||
          b.position.x > kGameWidth + buf) {
        b.removeFromParent();
      }
    }
  }

  void spawnExplosion(Vector2 pos, double size) {
    world.add(Explosion(position: pos.clone(), explosionSize: size));
  }

  int get _startingLives => difficulty == GameDifficulty.easy
      ? 4
      : (difficulty == GameDifficulty.hard ? 2 : 3);

  /// Start a level fresh (resets score and lives) or advance into it (keeps them).
  void startLevel(int worldNum, int levelNum, {bool freshStart = true}) {
    currentWorld = worldNum;
    currentLevel = levelNum;
    gameStarted = true;
    gameOver = false;
    levelComplete = false;
    paused = false;
    _spawnTimer = 0;
    _totalTime = 0;
    _killCount = 0;
    _levelKillCount = 0;
    _itemsDroppedThisLevel = 0;
    _comboCount = 0;
    _comboTimer = 0;
    _shakeTimer = 0;
    camera.viewfinder.position = Vector2.zero();
    _spawnInterval = 1.8;

    if (freshStart) {
      score = 0;
      lives = _startingLives;
    }
    maxHealth = 3;
    health = maxHealth;

    _clearWorldEntities();

    int oldWeaponLevel = 1;
    double oldRapidFire = 0.0;
    double oldMissile = 0.0;
    double oldShield = 0.0;

    if (!freshStart && player.isMounted) {
      oldWeaponLevel = player.weaponLevel;
      oldRapidFire = player.rapidFireTimer;
      oldMissile = player.missileTimer;
      oldShield = player.shieldTimer;
    }

    if (player.isMounted) player.removeFromParent();
    player = Player(
      position: isHorizontalLevel
          ? Vector2(80, kGameHeight / 2)
          : Vector2(kGameWidth / 2, kGameHeight - 110),
    );

    if (!freshStart) {
      player.weaponLevel = oldWeaponLevel;
      player.rapidFireTimer = oldRapidFire;
      player.missileTimer = oldMissile;
      player.shieldTimer = oldShield;
    }

    world.add(player);

    overlays.remove('StartMenu');
    overlays.remove('GameOver');
    overlays.remove('LevelComplete');
    overlays.remove('PauseMenu');
    overlays.add('Controls');
    overlays.add('HUD');
  }

  void restart() {
    startLevel(currentWorld, currentLevel, freshStart: true);
    overlays.remove('GameOver');
  }

  void _clearWorldEntities() {
    for (final e in world.children.whereType<Enemy>().toList()) {
      e.removeFromParent();
    }
    for (final b in world.children.whereType<Bullet>().toList()) {
      b.removeFromParent();
    }
    for (final e in world.children.whereType<Explosion>().toList()) {
      e.removeFromParent();
    }
    for (final p in world.children.whereType<PowerUp>().toList()) {
      p.removeFromParent();
    }
    for (final t in world.children.whereType<FloatingText>().toList()) {
      t.removeFromParent();
    }
  }

  void exitToMainMenu() {
    gameStarted = false;
    gameOver = false;
    paused = false;
    camera.viewfinder.position = Vector2.zero();
    _shakeTimer = 0;
    _comboCount = 0;
    _comboTimer = 0;

    for (final e in world.children.whereType<Enemy>().toList()) {
      e.removeFromParent();
    }
    for (final b in world.children.whereType<Bullet>().toList()) {
      b.removeFromParent();
    }
    for (final e in world.children.whereType<Explosion>().toList()) {
      e.removeFromParent();
    }
    for (final p in world.children.whereType<PowerUp>().toList()) {
      p.removeFromParent();
    }
    for (final t in world.children.whereType<FloatingText>().toList()) {
      t.removeFromParent();
    }

    if (player.isMounted) player.removeFromParent();

    overlays.remove('Controls');
    overlays.remove('HUD');
    overlays.remove('GameOver');
    overlays.remove('LevelComplete');
    overlays.remove('PauseMenu');
    overlays.add('StartMenu');
  }
}

// ─── Background ───────────────────────────────────────────────────────────────

class OceanBackground extends PositionComponent
    with HasGameReference<AeroFighterGame> {
  double _scroll = 0;

  OceanBackground() : super(priority: -10);

  @override
  void update(double dt) {
    _scroll += 55 * game.speedMultiplier * dt;
  }

  @override
  void render(Canvas canvas) {
    if (game.isHorizontalLevel) {
      _renderLandscape(canvas);
    } else {
      final image = game.images.fromCache(game.selectedBgImage);
      final iw = image.width.toDouble();
      final ih = image.height.toDouble();
      final scaledH = kGameWidth * (ih / iw);
      final scroll = _scroll % scaledH;

      double y = scroll - scaledH;
      while (y < kGameHeight) {
        canvas.drawImageRect(
          image,
          Rect.fromLTWH(0, 0, iw, ih),
          Rect.fromLTWH(0, y, kGameWidth, scaledH),
          Paint(),
        );
        y += scaledH;
      }
      _drawClouds(
        canvas,
        _scroll * 1.5,
        kGameWidth,
        kGameHeight,
        isHorizontal: false,
      );
    }
  }

  void _renderLandscape(Canvas canvas) {
    final scroll = _scroll;
    final groundY = kGameHeight - 52.0;

    // Sky gradient
    final skyRect = Rect.fromLTWH(0, 0, kGameWidth, kGameHeight);
    canvas.drawRect(
      skyRect,
      Paint()
        ..shader = const LinearGradient(
          colors: [Color(0xFFB8CDD8), Color(0xFFCDD8C0)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ).createShader(skyRect),
    );

    // Distant mountains (slow parallax)
    _drawMountains(canvas, scroll * 0.2);

    // Fog band above treeline
    final fogRect = Rect.fromLTWH(0, groundY - 60, kGameWidth, 80);
    canvas.drawRect(
      fogRect,
      Paint()
        ..shader = const LinearGradient(
          colors: [Color(0x00C8D8C0), Color(0xBBC8D8C0)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ).createShader(fogRect),
    );

    // Mid-distance trees (slower parallax)
    _drawTreeLayer(
      canvas,
      scroll * 0.55,
      groundY - 10,
      45,
      90,
      20,
      const Color(0xFF3A4A2A),
    );

    // Near trees (full speed)
    _drawTreeLayer(
      canvas,
      scroll,
      groundY + 4,
      32,
      65,
      14,
      const Color(0xFF1F2818),
    );

    // Ground strip
    canvas.drawRect(
      Rect.fromLTWH(0, groundY + 4, kGameWidth, kGameHeight - groundY),
      Paint()..color = const Color(0xFF1A1F10),
    );

    _drawClouds(
      canvas,
      _scroll * 1.5,
      kGameWidth,
      kGameHeight,
      isHorizontal: true,
    );
  }

  void _drawClouds(
    Canvas canvas,
    double scroll,
    double w,
    double h, {
    required bool isHorizontal,
  }) {
    final paint = Paint()
      ..color = const Color(0x33FFFFFF)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20);

    const spacing = 150.0;
    final firstIdx = (scroll / spacing).floor() - 1;
    final lastIdx = ((scroll + (isHorizontal ? w : h)) / spacing).ceil() + 1;

    for (int i = firstIdx; i <= lastIdx; i++) {
      final rnd1 = (i.abs() * 17 + 5) % 100 / 100.0;
      final rnd2 = (i.abs() * 23 + 11) % 100 / 100.0;
      final offset = ((i.abs() * 31 + 7) % 60 - 30).toDouble();

      final cw = 80.0 + rnd1 * 80.0;
      final ch = 40.0 + rnd2 * 40.0;

      if (isHorizontal) {
        final cx = i * spacing + offset - scroll;
        final cy = 40.0 + rnd1 * 100.0;
        canvas.drawOval(
          Rect.fromCenter(center: Offset(cx, cy), width: cw, height: ch),
          paint,
        );
        canvas.drawOval(
          Rect.fromCenter(
            center: Offset(cx + cw * 0.3, cy - ch * 0.2),
            width: cw * 0.7,
            height: ch * 0.8,
          ),
          paint,
        );
      } else {
        final cy = i * spacing + offset - scroll;
        final cx = 40.0 + rnd1 * (w - 80);
        canvas.drawOval(
          Rect.fromCenter(center: Offset(cx, cy), width: cw, height: ch),
          paint,
        );
        canvas.drawOval(
          Rect.fromCenter(
            center: Offset(cx + cw * 0.3, cy - ch * 0.2),
            width: cw * 0.7,
            height: ch * 0.8,
          ),
          paint,
        );
      }
    }
  }

  void _drawMountains(Canvas canvas, double scroll) {
    final paint = Paint()..color = const Color(0x887888A0);
    final path = Path();
    final baseY = kGameHeight * 0.68;
    path.moveTo(-10, baseY + 10);
    for (double x = -10; x <= kGameWidth + 10; x += 5) {
      final wx = x + scroll;
      final y =
          baseY -
          sin(wx * 0.007) * 55 -
          sin(wx * 0.013) * 32 -
          sin(wx * 0.021) * 18;
      path.lineTo(x, y);
    }
    path.lineTo(kGameWidth + 10, baseY + 10);
    path.close();
    canvas.drawPath(path, paint);
  }

  void _drawTreeLayer(
    Canvas canvas,
    double scroll,
    double groundY,
    double minH,
    double maxH,
    double minW,
    Color color,
  ) {
    final paint = Paint()..color = color;
    const spacing = 42.0;
    final firstIdx = (scroll / spacing).floor() - 1;
    final lastIdx = ((scroll + kGameWidth) / spacing).ceil() + 1;

    for (int i = firstIdx; i <= lastIdx; i++) {
      final h1 = (i.abs() * 17 + 5) % 100 / 100.0;
      final h2 = (i.abs() * 23 + 11) % 100 / 100.0;
      final offsetX = ((i.abs() * 31 + 7) % 28 - 14).toDouble();
      final treeH = minH + h1 * (maxH - minH);
      final treeW = minW + h2 * (minW * 0.7);
      final sx = i * spacing + offsetX - scroll;

      // Wide base layer
      canvas.drawPath(
        Path()
          ..moveTo(sx - treeW * 0.3, groundY)
          ..lineTo(sx + treeW / 2, groundY - treeH * 0.58)
          ..lineTo(sx + treeW + treeW * 0.3, groundY)
          ..close(),
        paint,
      );
      // Tall inner spike
      canvas.drawPath(
        Path()
          ..moveTo(sx, groundY)
          ..lineTo(sx + treeW / 2, groundY - treeH)
          ..lineTo(sx + treeW, groundY)
          ..close(),
        paint,
      );
    }
  }
}

// ─── HUD ──────────────────────────────────────────────────────────────────────

class _HUDOverlay extends StatefulWidget {
  final AeroFighterGame game;
  const _HUDOverlay({required this.game});

  @override
  _HUDOverlayState createState() => _HUDOverlayState();
}

class _HUDOverlayState extends State<_HUDOverlay>
    with SingleTickerProviderStateMixin {
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
    if (!widget.game.gameStarted || !widget.game.player.isMounted)
      return const SizedBox.shrink();

    final ld = widget.game.currentLevelData;
    final kills = widget.game.levelKillCount;
    final target = ld.killTarget;
    final progress = (kills / target).clamp(0.0, 1.0);
    final accent = ld.worldColor;

    return SafeArea(
      child: Stack(
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
                boxShadow: afGlow(accent, blur: 12),
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
                  'SCORE: ${afPadScore(widget.game.score)}',
                  style: AFType.score.copyWith(shadows: [afTextShadowHud]),
                ),
                const SizedBox(height: 6),
                Row(
                  children: List.generate(
                    widget.game.lives,
                    (index) => const Padding(
                      padding: EdgeInsets.only(right: 4.0),
                      child: Icon(
                        Icons.favorite,
                        color: AF.danger,
                        size: 18,
                        shadows: [afTextShadowHud],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Text(
                      'HP ',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        shadows: [afTextShadowHud],
                      ),
                    ),
                    SizedBox(
                      width: 60,
                      height: 6,
                      child: LinearProgressIndicator(
                        value: widget.game.health / widget.game.maxHealth,
                        backgroundColor: Colors.white24,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Color(0xFF00FF00),
                        ),
                      ),
                    ),
                  ],
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
                  behavior: HitTestBehavior.opaque,
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
                      color: AF.surface.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(AF.rSm),
                      border: Border.all(
                        color: AF.cyan.withValues(alpha: 0.5),
                        width: AF.stroke,
                      ),
                    ),
                    child: const Icon(Icons.pause, color: AF.cyan, size: 24),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'LVL ${ld.id}',
                  style: AFType.levelId.copyWith(
                    color: accent,
                    shadows: [afTextShadowHud],
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
                  style: AFType.display.copyWith(
                    color: AF.orange,
                    shadows: afGlow(AF.orangeDeep, blur: 10),
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
                  _buildPowerUpIcon('RAPID FIRE', AF.warning),
                if (widget.game.player.shieldTimer > 0)
                  _buildPowerUpIcon('SHIELD', AF.shield),
                if (widget.game.player.missileTimer > 0)
                  _buildPowerUpIcon(
                    'MISSILES (${widget.game.player.missileTimer.ceil()}s)',
                    AF.dangerHot,
                  ),
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
                      style: TextStyle(
                        fontSize: 9,
                        color: Colors.white54,
                        letterSpacing: 1,
                        shadows: [Shadow(color: Colors.black, blurRadius: 2)],
                      ),
                    ),
                    Text(
                      '${kills.toInt()} / ${target.toInt()}',
                      style: const TextStyle(
                        fontFamily: 'Share Tech Mono',
                        fontSize: 9,
                        color: Colors.white54,
                        shadows: [Shadow(color: Colors.black, blurRadius: 2)],
                      ),
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
      ),
    );
  }

  Widget _buildPowerUpIcon(String label, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              boxShadow: [BoxShadow(color: color, blurRadius: 4)],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: color,
              fontWeight: FontWeight.bold,
              shadows: const [Shadow(color: Colors.black, blurRadius: 2)],
            ),
          ),
        ],
      ),
    );
  }
}
