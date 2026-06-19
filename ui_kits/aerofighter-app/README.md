# AeroFighter App — UI Kit

Interactive, click-through recreation of the **AeroFighter** mobile metagame and
gameplay HUD, composed entirely from this design system's core components.

## Run
Open `index.html`. It mounts a 393×852 portrait device.

## Flow
- **Menu** (4 tabs via the bottom `NavBar`):
  - **HOME** — a **SELECT SECTOR** strip (`WorldChip` × 4 campaign worlds; the
    reticle tints to the chosen sector's accent), the orange **SCRAMBLE**
    launcher, FUEL/WEAPONS status panels, and Daily Rewards / Inbox / Event
    action pills.
  - **HANGAR** — the glass **JET CONFIGURATOR**: pick a skin (`JetChip` row),
    read its bio + `StatBar`s, and **EQUIP FIGHTER JET** (button disables to
    EQUIPPED).
  - **SHOP** — `MARKETPLACE OFFLINE` placeholder (matches the source).
  - **PILOT** — settings: DIFFICULTY SCALE (`SegmentedControl`) + SOUND/MUSIC
    `Toggle`s.
- **SCRAMBLE → Gameplay HUD** — launches into the selected sector's sky &
  accent: score (mono), life hearts, LVL tag, pause, pulsing active power-up
  timers (`PowerUpBadge`), a kill-progress bar, and CRT scanlines. **Tap the
  field** to score (floating "+250" popups + combo pop); **SIMULATE HIT**
  damages you (screen shake) toward GAME OVER.
- Losing all lives → **GAME OVER** modal (re-launch / abort). The **pause**
  button → **SYSTEM PAUSED** modal.

## Files
- `index.html` — device shell, sky backdrop, script loader, mount.
- `App.jsx` — orchestrator (menu/playing/paused/gameover state).
- `TopBar.jsx`, `HomeScreen.jsx`, `HangarScreen.jsx`, `SettingsScreens.jsx`
  (Shop + Pilot), `GameplayHUD.jsx`, `Modals.jsx`.

## Notes
- Components come from `window.AeroFighterDesignSystem_9520d9` via the compiled
  `_ds_bundle.js`. Screens are intentionally cosmetic recreations — no real game
  loop. Jet/skin data and copy are lifted verbatim from `lib/main.dart` &
  `lib/start_menu.dart`. The Home reticle is decorative HUD chrome (a simple
  ring), standing in for the game's `CustomPainter`.
