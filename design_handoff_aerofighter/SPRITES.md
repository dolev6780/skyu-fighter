# Combat sprites — install into the game

Five new transparent PNG sprites in the AeroFighter style:

| File | Size | Replaces |
|---|---|---|
| `enemy_fighter_256.png` | 256² | the red-tinted player jet used by `SmallFighter` |
| `enemy_bomber_256.png` | 256² | the green-tinted player jet used by `BomberEnemy` |
| `bullet_player_64.png` | 64² | the canvas beam in `PlayerBullet` |
| `bullet_enemy_64.png` | 64² | the canvas circle in `EnemyBullet` |
| `missile_player_128.png` | 128² | the canvas rocket in `PlayerMissile` |

All sprites are **nose-up** (matching `jet_2_level.png`), so the existing rotations
in `enemy.dart` / `bullet.dart` keep working unchanged.

---

## ⚡ Fastest path (3 steps, no hand-editing)

1. **Art** → copy `assets/sprites/*.png` into your game's `assets/images/`.
2. **Code** → overwrite two files with the ready-patched versions in this folder:
   ```
   dart/enemy.dart   →  lib/enemy.dart
   dart/bullet.dart  →  lib/bullet.dart
   ```
   These are your exact game files with only the sprite swaps applied — homing,
   movement, health bar, damage-flash, collisions all unchanged.
3. **Preload** → in `lib/main.dart`, add these 5 lines inside the existing
   `images.loadAll([ ... ])` call in `onLoad()`:
   ```dart
   'enemy_fighter_256.png',
   'enemy_bomber_256.png',
   'bullet_player_64.png',
   'bullet_enemy_64.png',
   'missile_player_128.png',
   ```
   Then `flutter pub get && flutter run`.

> ⚠️ Step 2 assumes your `enemy.dart` / `bullet.dart` are the versions I read from
> your repo. If you've changed them since, use the manual edits below instead so
> you don't lose your changes — or let Claude Code apply them.

---

## Manual edits (if you'd rather patch by hand)

### 1. Copy the art
```
design_handoff_aerofighter/assets/sprites/*.png  →  <game>/assets/images/
```
(Your game loads images from `assets/images/` — that's where `jet_2_level.png`
lives. Confirm in `pubspec.yaml` under `flutter: assets:`.)

## 2. Preload them — `lib/main.dart`, inside `onLoad()`'s `images.loadAll([...])`
Add these five entries to the existing list:
```dart
'enemy_fighter_256.png',
'enemy_bomber_256.png',
'bullet_player_64.png',
'bullet_enemy_64.png',
'missile_player_128.png',
```

## 3. Enemies — `lib/enemy.dart`

**`SmallFighter`** — point it at its own sprite and drop the red tint:
```dart
@override
Future<void> onLoad() async {
  _sprite = Sprite(game.images.fromCache('enemy_fighter_256.png'));
}
```
In `render(...)`, render the sprite **without** the modulate paint:
```dart
_sprite.render(canvas, position: Vector2.zero(), size: size, anchor: Anchor.center);
```
(Delete the `final paint = Paint()..colorFilter = ...modulate...` line and the
`overridePaint: paint` argument.)

**`BomberEnemy`** — same swap, but keep the white damage-flash:
```dart
@override
Future<void> onLoad() async {
  _sprite = Sprite(game.images.fromCache('enemy_bomber_256.png'));
}
```
```dart
// in render(...)
if (_flashWhite) {
  final paint = Paint()
    ..colorFilter = const ColorFilter.mode(Color(0xFFFFFFFF), BlendMode.srcIn);
  _sprite.render(canvas, position: Vector2.zero(), size: size,
      anchor: Anchor.center, overridePaint: paint);
} else {
  _sprite.render(canvas, position: Vector2.zero(), size: size, anchor: Anchor.center);
}
```
(Remove the old green `modulate` branch.) Keep the drop-shadow and health-bar code.

> Tip: the bomber art reads well a bit larger — try `size: Vector2(64, 56)` if you
> want it chunkier. Optional.

## 4. Projectiles — `lib/bullet.dart`

These currently draw with `Canvas`. Swap each `render` for a sprite. Add a sprite
field to each class and load it lazily (the images are already cached from step 2).

**`PlayerBullet`** (drawn nose-up; existing trajectory `rotate` still applies):
```dart
late final Sprite _sprite = Sprite(game.images.fromCache('bullet_player_64.png'));

@override
void render(Canvas canvas) {
  canvas.save();
  canvas.rotate(atan2(direction.x, -direction.y));
  _sprite.render(canvas, position: Vector2.zero(),
      size: Vector2(14, 30), anchor: Anchor.center);   // was 5x18; sprite has glow margin
  canvas.restore();
}
```

**`EnemyBullet`**:
```dart
late final Sprite _sprite = Sprite(game.images.fromCache('bullet_enemy_64.png'));

@override
void render(Canvas canvas) {
  _sprite.render(canvas, position: Vector2.zero(),
      size: Vector2(22, 22), anchor: Anchor.center);    // was 12x12; sprite has glow margin
}
```

**`PlayerMissile`** (keep the homing/`_angle` logic; just swap the draw):
```dart
late final Sprite _sprite = Sprite(game.images.fromCache('missile_player_128.png'));

@override
void render(Canvas canvas) {
  canvas.save();
  canvas.rotate(_angle);
  _sprite.render(canvas, position: Vector2.zero(),
      size: Vector2(20, 32), anchor: Anchor.center);     // glow/flame margin baked in
  canvas.restore();
}
```
> `Bullet` mixes in `HasGameReference<AeroFighterGame>`, so `game.images` is
> available. If `late final` initialization complains, move the assignment into an
> `onLoad()` override instead.

The render sizes above are slightly larger than the old hitbox sizes because the
sprites bake in their glow/flame margin — the visible bolt still matches. Collision
uses the component `size`, so leave the constructor `size:` values as they are (or
nudge them if you want bigger hitboxes).

## 5. Run
```
flutter pub get && flutter run
```
Enemies should now be a red interceptor and an orange-striped bomber; bullets and
the missile use the new art. Preview of all five: `sprite_preview.html`.
