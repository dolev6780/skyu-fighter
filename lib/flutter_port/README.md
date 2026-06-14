# AeroFighter → Flutter/Flame port

Ready-to-paste Dart that mirrors the AeroFighter Design System for your
Flutter + Flame app. Copy these three files into your project (e.g. `lib/theme/`
and `lib/widgets/`) and reference them instead of inline `Color(0xFF…)` /
`BoxDecoration` literals.

## Files
| File | What it gives you |
|---|---|
| `af_tokens.dart` | All colors (surfaces, cyan, orange, semantic, worlds, skins), gradients, radii, spacing, durations, and glow/shadow helpers as `AF.*`. |
| `af_text_styles.dart` | The type scale as `TextStyle`s (`AFType.hero/title/label/score/…`) + `afPadScore()`. Structural text → call `.toUpperCase()`. |
| `af_widgets.dart` | Drop-in widgets: `AfButton`, `AfPanel`, `AfGlassModal`, `AfStatBar`, `AfProgressBar`, `AfWorldChip`, `AfBadge`. |

## Setup
1. **Fonts** — download Chakra Petch + Share Tech Mono `.ttf`s into
   `assets/fonts/`, then declare in `pubspec.yaml`:
   ```yaml
   flutter:
     fonts:
       - family: ChakraPetch
         fonts:
           - { asset: assets/fonts/ChakraPetch-Regular.ttf, weight: 400 }
           - { asset: assets/fonts/ChakraPetch-Bold.ttf, weight: 700 }
       - family: ShareTechMono
         fonts:
           - { asset: assets/fonts/ShareTechMono-Regular.ttf }
   ```
   (If you keep system Roboto, change `_display/_ui/_mono` in `af_text_styles.dart`.)
2. **Copy the three `.dart` files** in and fix the `import` paths to match where
   you place them.

## Usage
```dart
// SCRAMBLE launcher
AfButton('Scramble', icon: Icons.rocket_launch, size: AfButtonSize.lg,
    block: true, onTap: _startRun);

// Hangar stat
AfStatBar(label: 'Engine Speed', value: 0.9, color: AF.cyan);

// Sector strip
SingleChildScrollView(
  scrollDirection: Axis.horizontal,
  child: Row(children: [
    for (var i = 0; i < AF.worlds.length; i++)
      Padding(padding: const EdgeInsets.only(right: 10),
        child: AfWorldChip(id: i + 1, name: worldNames[i], accent: AF.worlds[i],
            selected: i == _sector, onTap: () => setState(() => _sector = i))),
  ]),
);

// Game Over (over your Flame GameWidget, via overlayBuilderMap)
Center(child: AfGlassModal(accent: AF.danger, glow: true, child: Column(
  mainAxisSize: MainAxisSize.min, children: [
    Text('GAME OVER', style: AFType.hero.copyWith(color: AF.danger)),
    Text('FINAL SCORE: ${afPadScore(score)}', style: AFType.score),
    AfButton('Re-launch Mission', icon: Icons.rocket_launch, block: true, onTap: _restart),
  ]))));
```

## Mapping notes
- **Flame layer** (scrolling sky, jets, bullets) stays as-is — feed it the same
  asset paths (`assets/images/bg_*.png`, jet sprites, `powerups_strip_128.png`)
  and `AF.*` colors. Worlds map to `AF.worlds[i]` + the matching background.
- **HUD/menu overlays** are pure Flutter widgets → use these. Wire modals through
  Flame's `overlayBuilderMap` / `game.overlays.add('gameOver')`.
- **Glow** = `boxShadow: afGlow(color)`. **Glass** = `AfGlassModal` (uses
  `BackdropFilter` blur 14, which your app already uses).
- **Scanlines / screen-shake / floating score** from the web kit are presentation
  flourishes — do scanlines as a Flame overlay/painter, shake via a Flame
  `MoveEffect` on the camera, floating text via a `TextComponent` + `MoveEffect`
  + `OpacityEffect`.

These are a faithful translation, not a drop-in replacement for your existing
`start_menu.dart` — refactor screen by screen, swapping literals for `AF.*` and
hand-rolled containers for the `Af*` widgets.
