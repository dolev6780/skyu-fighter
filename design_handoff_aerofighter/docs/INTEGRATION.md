# AeroFighter — game integration

Drop-in source that wires the **actual game** onto the AeroFighter Design System.
The screens here replace the inline `Color(0xFF…)` / hand-rolled `Container`
versions in your repo with `AF.*` tokens and `Af*` widgets — same layout, same
game logic, one source of truth for the look.

## What's in this folder

| File | Replaces / adds | Notes |
|---|---|---|
| `start_menu.dart` | your `lib/start_menu.dart` | HOME / HANGAR / SHOP / PILOT, rebuilt on the DS. Public API (`StartMenuOverlay`) is unchanged. |
| `game_overlays.dart` | the overlay classes inside `lib/main.dart` | `ControlsOverlay`, `GameOverOverlay`, `LevelCompleteOverlay`, `PauseMenuOverlay`, `PauseButtonOverlay` — now **public**, in their own file. |

These depend on the three theme files from `flutter_port/`:
`af_tokens.dart`, `af_text_styles.dart`, `af_widgets.dart` (the widgets file now
ports **all 14** DS components, including the `AfNavBar` / `AfAvatar` /
`AfSegmented` / `AfToggle` / `AfJetChip` / `AfIconButton` the metagame needs).

## Install

1. **Theme files** → copy `flutter_port/af_tokens.dart`,
   `af_text_styles.dart`, `af_widgets.dart` into `lib/theme/`.
   *(Your repo already has stub versions in `lib/theme/` — overwrite them; the
   stub `af_tokens.dart` is only a fragment of the full token set.)*

2. **Fonts** → download Chakra Petch + Share Tech Mono `.ttf`s into
   `assets/fonts/` and declare them in `pubspec.yaml`:
   ```yaml
   flutter:
     fonts:
       - family: ChakraPetch
         fonts:
           - { asset: assets/fonts/ChakraPetch-Regular.ttf, weight: 400 }
           - { asset: assets/fonts/ChakraPetch-Bold.ttf,    weight: 700 }
       - family: ShareTechMono
         fonts:
           - { asset: assets/fonts/ShareTechMono-Regular.ttf }
   ```
   *(Keep system Roboto instead? Change `_display/_ui/_mono` in
   `af_text_styles.dart`.)*

3. **Screens** → copy `start_menu.dart` over `lib/start_menu.dart`, and copy
   `game_overlays.dart` into `lib/`.

4. **Patch `lib/main.dart`** — three small edits (game engine untouched):

   **a. Add the import** near the top, with the others:
   ```dart
   import 'game_overlays.dart';
   ```

   **b. Point the overlay map at the new public widgets** — replace the
   `overlayBuilderMap` block with:
   ```dart
   overlayBuilderMap: {
     'StartMenu':     (context, game) => StartMenuOverlay(game: game),
     'Controls':      (context, game) => ControlsOverlay(game: game),
     'GameOver':      (context, game) => GameOverOverlay(game: game),
     'LevelComplete': (context, game) => LevelCompleteOverlay(game: game),
     'PauseMenu':     (context, game) => PauseMenuOverlay(game: game),
     'PauseButton':   (context, game) => PauseButtonOverlay(game: game),
   },
   ```

   **c. Delete the old overlay classes** — remove everything from
   `// ─── Overlays ───` down through the end of `_PauseButtonOverlay`
   (i.e. the five `_ControlsOverlay … _PauseButtonOverlay` classes). They now
   live in `game_overlays.dart`. **Keep** `HudComponent`, the `OceanBackground`,
   and all `AeroFighterGame` logic.

That's it — `flutter run`.

## Optional: route the in-game HUD through AF

`HudComponent` paints to the Flame canvas (score, lives, kill bar, combo,
power-up timers) so it isn't a Flutter widget — but it can still read the
tokens. Swap its literals for `AF.*` to keep one palette:

```dart
// score/lives shadow → afTextShadowHud
TextStyle(color: AF.text, fontSize: 18, fontWeight: FontWeight.bold,
    shadows: const [afTextShadowHud]);

// weapon-level text   → AF.orange
// kill-progress bar   → ld.worldColor   (already per-world)
// power-up timer bars → AF.shield / AF.warning / AF.dangerHot
// combo x2 / x3       → AF.warning / AF.orangeDeep
```

Floating pickup text colors map straight to `afPowerUps[i].color`.

## Why these match

Every value used here comes from the design system, so the game and the
`ui_kits/aerofighter-app/` reference render identically:

- **SCRAMBLE** → `AfButton(size: lg)` = the orange-gradient hero CTA.
- **Bottom nav** → `AfNavBar`, selected tile fills orange + glow.
- **Modals** → `AfGlassModal` (backdrop blur 14, colored 1.5px border + glow):
  GAME OVER = `AF.danger`, PAUSED = `AF.cyanMid`, MISSION COMPLETE = per-world.
- **Difficulty** → `AfSegmented` (EASY green / NORMAL blue / HARD red).
- **Hangar stats** → `AfStatBar`; jet picker → `AfJetChip`.
- **Telemetry** (scores, currency) → Share Tech Mono via `AFType.score` /
  `afPadScore()`.
