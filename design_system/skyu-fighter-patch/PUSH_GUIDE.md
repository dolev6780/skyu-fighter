# skyu-fighter — design-system patch

This `lib/` folder is your AeroFighter game **already wired** onto the AeroFighter
Design System. Every file sits at its final repo path — copy `lib/` over your
local project's `lib/`, then commit & push. **No hand-editing needed** —
`main.dart` is already patched.

## What changed
- `lib/theme/af_tokens.dart`, `af_text_styles.dart`, `af_widgets.dart` — the full
  design-system port (replaces the old stub theme files; `af_widgets.dart` ports
  all 14 DS components).
- `lib/start_menu.dart` — HOME / HANGAR / SHOP / PILOT rebuilt on `AF.*` + `Af*`.
- `lib/game_overlays.dart` — **new**: Game Over / Mission Complete / Paused /
  pause button as public widgets.
- `lib/main.dart` — import added, `overlayBuilderMap` points at the new public
  overlay widgets, old private overlay classes removed. Game engine untouched.

## Before it compiles: fonts
`af_text_styles.dart` expects **Chakra Petch** + **Share Tech Mono**. Add the
`.ttf`s to `assets/fonts/` and declare them in `pubspec.yaml` (see
`INTEGRATION.md`), or keep Roboto by editing `_display/_ui/_mono` in
`af_text_styles.dart`.

## Push
```bash
# from your local game project root, after copying this lib/ over yours
git init                       # if needed
git remote add origin https://github.com/dolev6780/skyu-fighter.git
git add .
git commit -m "Wire game onto AeroFighter Design System"
git branch -M main
git push -u origin main        # use --force only if overwriting the empty repo's history
```

> Note: I can read GitHub but can't push for you — this bundle is the drop-in so
> the push is one command on your side.
