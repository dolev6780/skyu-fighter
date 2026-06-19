# START HERE — apply the AeroFighter design to your game

Your game is currently **unchanged** — none of the design files were copied in yet.
Here are two ways to fix that. Pick ONE.

---

## Option A — let Claude Code do everything (recommended)

1. Unzip this whole `design_handoff_aerofighter/` folder into the **root of your
   game repo** (so it sits next to `lib/` and `pubspec.yaml`).
2. Open the repo in Claude Code and paste this prompt:

> Read `design_handoff_aerofighter/README.md` and apply it to this Flutter Flame
> game. Specifically: copy `design_handoff_aerofighter/dart/theme/*.dart` into
> `lib/theme/` (overwrite the stubs), copy `dart/start_menu.dart` and
> `dart/game_overlays.dart` into `lib/`, then make the 3 surgical edits to
> `lib/main.dart` (add `import 'game_overlays.dart';`, repoint `overlayBuilderMap`
> to the new public overlay widgets, and delete the old inline `_ControlsOverlay`
> … `_PauseButtonOverlay` classes). Add the fonts to `pubspec.yaml`. Then run
> `flutter analyze` and fix anything that fails to compile.

That's it. Claude Code can edit your files directly; it'll handle the `main.dart`
patch, which is the fiddly part.

---

## Option B — do it by hand

From your repo root, with this folder unzipped there:

```bash
# 1. theme files (overwrite the old stubs)
cp design_handoff_aerofighter/dart/theme/af_tokens.dart       lib/theme/af_tokens.dart
cp design_handoff_aerofighter/dart/theme/af_text_styles.dart  lib/theme/af_text_styles.dart
cp design_handoff_aerofighter/dart/theme/af_widgets.dart      lib/theme/af_widgets.dart

# 2. screen + overlays
cp design_handoff_aerofighter/dart/start_menu.dart      lib/start_menu.dart
cp design_handoff_aerofighter/dart/game_overlays.dart   lib/game_overlays.dart
```

Then **edit `lib/main.dart` by hand** (3 changes):

**a.** Add near the other `lib/` imports:
```dart
import 'game_overlays.dart';
```

**b.** Replace your `overlayBuilderMap` with:
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

**c.** Delete these old classes from the bottom of `main.dart` (they now live in
`game_overlays.dart`):
`_ControlsOverlay`, `_GameOverOverlay`, `_LevelCompleteOverlay`,
`_PauseMenuOverlay`, `_PauseButtonOverlay`.

Then add the **fonts** block to `pubspec.yaml` (see main README step 2 — or skip
fonts by setting the font constants in `af_text_styles.dart` to `'Roboto'`).

Finally:
```bash
flutter pub get
flutter analyze   # should be clean
flutter run
```

---

## If you hit a compile error
The usual culprit after a partial copy is a **mismatch**: e.g. the new
`start_menu.dart` is in but `af_tokens.dart` is still the old stub. Make sure ALL
THREE `lib/theme/` files are the new versions — they depend on each other. Paste
any red error text and it's almost always a one-line fix.
```
