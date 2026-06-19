# Handoff: AeroFighter Design System → Flutter/Flame game

> **For the developer / Claude Code reading this:** this bundle is a *paste-ready
> Dart port* of the AeroFighter Design System, plus exact instructions for wiring
> it into the `flutter_flame_game` repo. Unlike a typical design handoff, you are
> **not** recreating HTML mockups — the Dart is already written. Your job is to
> install it correctly into the existing game, patch one file surgically, set up
> fonts, and verify it compiles and looks right.

---

## Overview

`flutter_flame_game` is a Flame vertical-scrolling shoot-'em-up. The metagame
shell (start menu, hangar, shop, pilot settings) and the gameplay overlays
(game over, mission complete, paused) are plain **Flutter widgets** layered over
the Flame `GameWidget` via `overlayBuilderMap`. Today those widgets use inline
`Color(0xFF…)` literals and hand-rolled `Container`s.

This handoff replaces that ad-hoc styling with **one source of truth** — the
AeroFighter Design System — expressed as Dart tokens, text styles, and widgets
(`AF.*`, `AFType.*`, `Af*`). The look is identical to the design system's web
reference; the game logic is untouched.

## Fidelity

**High-fidelity.** Every color, radius, spacing value, font, and component in the
`dart/` files is the final, exact design-system value. Do not approximate —
install them as-is. The `reference/tokens/*.css` files are the canonical token
source these Dart files were generated from, included so you can verify any value.

---

## ⚠️ Current repo state (read before installing)

This is a **partial** integration — some pieces are already in the repo, some are
stale, some are missing:

| Path in repo | State | Action |
|---|---|---|
| `lib/flutter_port/af_*.dart` | Full port, already copied in | Ignore / delete — the canonical copies belong in `lib/theme/` (see below) |
| `lib/theme/af_tokens.dart` | **Stale 39-line stub** | **Overwrite** with `dart/theme/af_tokens.dart` |
| `lib/theme/af_text_styles.dart`, `af_widgets.dart` | Stub/partial | **Overwrite** with the `dart/theme/` versions |
| `lib/start_menu.dart` | Still inline `Color(0xFF…)` | **Replace** with `dart/start_menu.dart` |
| `lib/game_overlays.dart` | Missing | **Add** `dart/game_overlays.dart` |
| `lib/main.dart` | Overlay classes still inline; **1498 lines** | **Patch surgically — do NOT overwrite** (see step 4) |
| `pubspec.yaml` | No `fonts:` section | **Add fonts** (see step 2) |

> **Important — do not blindly copy `main.dart`.** The included
> `dart/main.reference.dart` is a *pre-patched reference* generated from an
> earlier, smaller version of the game (1026 lines vs. your current 1498). The
> live `lib/main.dart` has diverged — it likely has features the reference lacks.
> Apply the **three edits** in step 4 to the *current* file; use the reference
> only to see what the finished `overlayBuilderMap` and imports should look like.

---

## Install (5 steps)

### 1. Theme files → `lib/theme/`
Copy these three over the existing stubs:
```
dart/theme/af_tokens.dart        → lib/theme/af_tokens.dart
dart/theme/af_text_styles.dart   → lib/theme/af_text_styles.dart
dart/theme/af_widgets.dart       → lib/theme/af_widgets.dart
```
Then delete the now-redundant `lib/flutter_port/` folder (or leave it; nothing
should import from it). Make sure `start_menu.dart` / `game_overlays.dart` import
from `theme/…`, e.g. `import 'theme/af_tokens.dart';`.

### 2. Fonts → `pubspec.yaml`
`af_text_styles.dart` expects **Chakra Petch** (display/UI) and **Share Tech
Mono** (telemetry: score, currency). Download the `.ttf`s into `assets/fonts/`
and add to `pubspec.yaml` under `flutter:`:
```yaml
flutter:
  uses-material-design: true
  assets:
    - assets/images/
    - assets/fonts/
  fonts:
    - family: ChakraPetch
      fonts:
        - { asset: assets/fonts/ChakraPetch-Regular.ttf, weight: 400 }
        - { asset: assets/fonts/ChakraPetch-Bold.ttf,    weight: 700 }
    - family: ShareTechMono
      fonts:
        - { asset: assets/fonts/ShareTechMono-Regular.ttf }
```
(Both are free on Google Fonts.) **Prefer to keep system Roboto?** Skip this step
and change the `_display` / `_ui` / `_mono` constants at the top of
`af_text_styles.dart` to `'Roboto'` — everything else still works.

### 3. Screen files → `lib/`
```
dart/start_menu.dart     → lib/start_menu.dart   (replace)
dart/game_overlays.dart  → lib/game_overlays.dart (new)
```
`StartMenuOverlay`'s public API is unchanged, so `main.dart` keeps calling it the
same way. `game_overlays.dart` exposes the overlays as **public** widgets:
`ControlsOverlay`, `GameOverOverlay`, `LevelCompleteOverlay`, `PauseMenuOverlay`,
`PauseButtonOverlay`.

### 4. Patch `lib/main.dart` — three surgical edits

**a.** Add the import near the other `lib/` imports:
```dart
import 'game_overlays.dart';
```

**b.** Repoint `overlayBuilderMap` to the new public overlay widgets:
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

**c.** Delete the **old private overlay classes** now living in
`game_overlays.dart` — the `_ControlsOverlay … _PauseButtonOverlay` block
(and any `_ReticlePainter`/helpers only they used). **Keep** `HudComponent`,
`OceanBackground`, and all `AeroFighterGame` engine logic. If your current
`main.dart` has overlay variants the reference doesn't, port their styling onto
`AF.*`/`Af*` rather than dropping them.

### 5. Optional — route the in-game HUD through `AF.*`
`HudComponent` paints to the Flame canvas (not a Flutter widget), so it can't use
the `Af*` widgets, but it *can* read the tokens. Swap its literals:
`AF.text` / `afTextShadowHud` for score & lives, `AF.orange` for weapon text,
`ld.worldColor` for the kill bar, `AF.shield/warning/dangerHot` for power-up
timers, `AF.warning/orangeDeep` for combo x2/x3. Floating-pickup colors map to
`afPowerUps[i].color`. See `docs/INTEGRATION.md` → "Optional".

Then: `flutter pub get && flutter run`.

---

## What the design system gives you

### Components (`dart/theme/af_widgets.dart` — all 14)
`AfButton` (primary = orange-gradient SCRAMBLE CTA; secondary/ghost/danger/success;
`fillColor` for dynamic modal accents) · `AfIconButton` · `AfPanel` ·
`AfGlassModal` (backdrop-blur 14 frosted modal) · `AfStatBar` · `AfProgressBar` ·
`AfBadge` · `AfWorldChip` · `AfJetChip` · `AfNavBar`/`AfNavItem` ·
`AfSegmented`/`AfSegment` · `AfToggle` · `AfAvatar` · `AfPowerUpBadge` (+
`afPowerUps` metadata table, sprite-strip order).

### Where each appears
- **SCRAMBLE** → `AfButton(size: lg, variant: primary)` — orange gradient + glow.
- **Bottom nav** → `AfNavBar`; selected tile fills orange + glows.
- **Modals** → `AfGlassModal`: GAME OVER = `AF.danger`, PAUSED = `AF.cyanMid`,
  MISSION COMPLETE = per-world `AF.worlds[i]`.
- **Difficulty** → `AfSegmented` (EASY green / NORMAL blue / HARD red).
- **Hangar** → `AfStatBar` (engine/hull/firepower) + `AfJetChip` picker.
- **Telemetry** (scores, currency) → Share Tech Mono via `AFType.score` /
  `afPadScore()`.

## Design tokens (canonical values)

**Surfaces** `bg #001133` · `surface #051020` · `border #102540` · `void #000A1A`
**Cyan (signal)** `cyan #00EEFF` · `cyanMid #00AAFF` · `blue #0088FF` · `shield #4499FF`
**Action orange** `orange #FF8800` · `orangeDeep #FF5500` · `orangeHot #FF4400`
**Semantic** `danger #FF3333` · `success #00EE55` · `warning #FFCC00` · `gold #FFD700` · `nuke #CC33FF`
**Worlds** Dawn `#FFAA00` · Midday `#00AAFF` · Dusk `#FF5500` · Night `#9933FF`
**Radii** sm 8 · md 12 · lg 16 · xl 20 · modal 24 · pill 32
**Spacing** 4 · 6 · 8 · 12 · 16 · 20 · 24 · 32 · 48
**Motion** easeFast 120ms · ease 200ms · easeSlow 300ms · curve `Cubic(0.2,0.7,0.2,1)`
**Type** Chakra Petch (display/UI, UPPERCASE + wide tracking) · Share Tech Mono (telemetry)

Full source: `reference/tokens/*.css` and the header comments in
`dart/theme/af_tokens.dart`.

## Verify
- `flutter analyze` is clean (no missing imports, no leftover `_Overlay` refs).
- App launches to the start menu; HOME / HANGAR / SHOP / PILOT all render.
- SCRAMBLE starts a run; dying shows the red GAME OVER `AfGlassModal`; pause shows
  the blue PAUSED modal; clearing a level shows the per-world MISSION COMPLETE.
- Fonts render as Chakra Petch / Share Tech Mono (not fallback) — or Roboto if you
  took that path in step 2.

## Files in this bundle
```
README.md                      ← this file (start here)
dart/
  theme/af_tokens.dart         ← colors, radii, spacing, motion, glow helpers (AF.*)
  theme/af_text_styles.dart    ← type scale (AFType.*) + afPadScore()
  theme/af_widgets.dart        ← all 14 components (Af*)
  start_menu.dart              ← HOME/HANGAR/SHOP/PILOT on the DS (drop-in)
  game_overlays.dart           ← public overlay widgets (drop-in)
  main.reference.dart          ← pre-patched main.dart, REFERENCE ONLY (do not copy)
docs/
  INTEGRATION.md               ← original step-by-step + optional HUD routing
  PUSH_GUIDE.md                ← git push notes
  flutter_port_README.md       ← port overview + usage snippets
reference/
  tokens/*.css                 ← canonical design-system token source
```

> Note: the SHOP tab currently renders a "MARKETPLACE OFFLINE" placeholder by
> design — it's intentional, not a missing screen. Build it out only if asked.
