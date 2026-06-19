# AeroFighter Design System

A tactical, cockpit-HUD design system for **AeroFighter** — a vertical-scrolling
arcade jet-combat shooter. This system captures the game's military-arcade
identity: deep-navy skies, electric-cyan HUD chrome, orange/red action accents,
heavily letterspaced uppercase type, and glowing frosted-glass panels.

---

## 1. Product context

**AeroFighter** is a mobile (portrait) arcade shoot-'em-up built in Flutter +
Flame. The player is a fighter pilot — callsign **MAVERICK** — who scrambles
jets through a four-world campaign, downing enemy fighters and bombers,
chaining kill combos, and collecting power-ups.

**Core loop & surfaces**
- **Start menu / metagame** — a four-tab home base: `HOME` (scramble launcher,
  fuel/weapons status, daily rewards), `HANGAR` (jet configurator with skins +
  stat bars), `SHOP` (marketplace), `PILOT` (settings: difficulty, audio).
- **Gameplay HUD** — score, lives, weapon level, kill-progress bar, combo
  multiplier, and stacking power-up timers overlaid on a scrolling sky.
- **Modals** — Game Over, Mission Complete, System Paused — all frosted-glass.

**Campaign worlds** (each its own accent color & sky):
| World | Name | Accent | Sky |
|---|---|---|---|
| W1 | DAWN SECTOR | `#FFAA00` | slate dawn |
| W2 | MIDDAY FRONT | `#00AAFF` | bright blue |
| W3 | DUSK ZONE | `#FF5500` | purple dusk (side-scroll level) |
| W4 | NIGHT OPS | `#9933FF` | deep night |

**Jet skins** (hangar loadouts): COBALT ALPHA (balanced, blue), CRIMSON PHOENIX
(speed, crimson), SOLAR EAGLE (armor, gold), EMERALD VIPER (firepower, green).

**Power-ups**: Weapon Up, Rapid Fire, Missiles, Repair, Extra Life, Armor,
Tactical Nuke, Score Star — each a glowing ringed badge.

### Source material
- **Codebase (read-only, mounted):** `flutter flame game/` — Flutter/Flame
  project. Key files: `lib/main.dart` (game, HUD, all modal overlays),
  `lib/start_menu.dart` (home/hangar/shop/settings metagame UI),
  `lib/player.dart`, `lib/enemy.dart`, `lib/power_up.dart`.
- **Art assets:** `flutter flame game/assets/images/` — jet sprites, parallax
  sky backgrounds (4 times of day), power-up strip, explosion/thrust sheets.
  Copied into this project under `assets/`.
- No external Figma or brand guide was provided; all tokens are derived
  directly from the source colors, type treatments, and layout constants.

---

## 2. Content fundamentals

The voice is **military radio chatter meets arcade bravado** — terse, tactical,
confident. Everything reads like a cockpit readout or a mission briefing.

- **Casing:** Structural UI is **ALL CAPS** with wide letterspacing
  (`SCRAMBLE`, `JET CONFIGURATOR`, `PILOT SYSTEM PARAMETERS`). Descriptive
  copy (jet bios, difficulty notes) is sentence case.
- **Person:** Second-person imperative or impersonal-system voice. The player is
  addressed as the pilot ("RETURN TO BASE", "ABORT TO MENU"); the game speaks as
  the aircraft's systems ("SYSTEM REPAIRED", "SYSTEMS NOMINAL", "SHIELD DEPLETED").
  Rarely first-person.
- **Tone:** Punchy, high-stakes, aviation/military flavored. Verbs are mission
  verbs: *scramble, launch, re-launch, abort, equip, deploy*. Status is reported
  like avionics: *85% OPTIMAL, READY, NOMINAL, OFFLINE*.
- **Numbers:** Always feel like telemetry — zero-padded scores (`000000`),
  comma-grouped currency (`25,400`), percentages on stats (`85%`), level IDs
  (`LVL 1-1`), combo multipliers (`x3 COMBO!`).
- **Emoji:** **None.** Never used. Meaning is carried by icons and color.
- **Microcopy examples:**
  - CTA: `SCRAMBLE`, `EQUIP FIGHTER JET`, `NEXT MISSION`, `RESUME MISSION`
  - Destructive/exit: `ABORT TO MENU`, `RETURN TO BASE`, `RE-LAUNCH MISSION`
  - States: `EQUIPPED`, `READY`, `MARKETPLACE OFFLINE`, `MAX LIVES`
  - Pickups: `WEAPON UP`, `RAPID FIRE`, `MISSILES ACTIVE`, `ARMOR CHARGED`,
    `TACTICAL NUKE`, `+1000 SCORE`, `SYSTEM REPAIRED`
  - Hero alerts: `GAME OVER`, `MISSION COMPLETE`, `CAMPAIGN COMPLETE`, `SYSTEM PAUSED`
  - Labels: `CALLSIGN`, `FUEL SYSTEM`, `WEAPONS LOAD`, `DIFFICULTY SCALE`,
    `ENGINE SPEED`, `HULL INTEGRITY`, `FIREPOWER`

Default callsign: **MAVERICK**. Section/screen names: HOME, HANGAR, SHOP, PILOT.

---

## 3. Visual foundations

**Overall vibe:** A glowing tactical cockpit at night. Dark, high-contrast,
neon-on-navy. Reads as both "military avionics display" and "arcade cabinet."

### Color
- **Surfaces** are deep navy → near-black: app `#001133`, panels `#051020`
  (often at 75–95% opacity over the sky), borders `#102540`, dividers `#002244`.
- **Cyan is the HUD signal color** — `#00EEFF` (brightest, icons/headings),
  `#00AAFF` (labels), `#0088FF` (interactive/buttons), `#88CCFF` (soft data).
- **Orange is the action color** — the SCRAMBLE button and selected nav use an
  `#FF8800 → #FF4400` vertical gradient with an orange outer glow. Orange =
  "do this / you are here."
- **Semantics:** danger red `#FF3333`/`#FF2244`, success green `#00EE55`, warning
  gold `#FFD700`, special purple `#CC33FF`.
- **Per-world & per-skin accents** recolor modals, progress, and badges
  contextually (see tables above).
- **Imagery color vibe:** sky backgrounds are soft, painterly, low-contrast
  (cool blues by day, warm dusk, muted night) — they sit *behind* and *beneath*
  the crisp neon UI, never competing with it. Sprites are saturated and cel-shaded.

### Type
- Two families: **Chakra Petch** (squared technical sans — all headings, labels,
  body, buttons) and **Share Tech Mono** (numeric telemetry — score, currency,
  coords). *Substitution flag below.*
- Structural text is **bold, UPPERCASE, widely tracked** (2–4px). The hero
  `SCRAMBLE` is additionally *italic* + heavy (w900) for forward motion.
- Descriptive copy is regular weight, sentence case, line-height ~1.4.

### Spacing & layout
- Mobile-touch rhythm: 12 / 16 / 20 / 24 px padding steps. Minimum hit target
  44px (pause button, nav tiles). Bottom nav and modals are centered and
  generously padded.
- Portrait-first. Content stacks vertically; the metagame uses a fixed top bar
  (avatar + callsign + currency) and a floating bottom nav.

### Corners, borders & cards
- Radii: controls 8–12px, nav tiles 16px, bottom bar 20px, **modals & glass
  panels 24px**, action pills 32px, badges/avatars fully round.
- Cards = translucent navy fill + a thin (1.5px) cyan-tinted border. Selected/
  alert states use a 2px accent border. No heavy drop shadows on flat cards;
  depth comes from **glow**, not elevation.

### Shadows, glow & glass
- The signature depth cue is **colored outer glow**, not gray elevation:
  orange glow on CTAs, cyan glow on active chrome, red glow on Game Over.
- **HUD text** carries a dark blur shadow (`0 1px 6px #000033`) so it stays
  legible over the sky.
- **Modals are frosted glass**: `backdrop-filter: blur(12–14px)` over a
  `rgba(0,0,0,0.75)` fill with a colored 1.5–2px border and a soft colored glow.
  Use blur/transparency for *overlays and modals*, never for primary content.

### Motion
- Quick, snappy, no bounce. Selection transitions ~200ms (`AnimatedContainer`),
  tab/content swaps ~300ms (`AnimatedSwitcher`). Default easing is a gentle
  ease-out (`cubic-bezier(0.2,0.7,0.2,1)`).
- In-world flourishes: pulsing power-up glows, screen shake on hit, blinking
  invincibility, floating pickup text that drifts up and fades. UI itself stays
  calm; energy lives in glows and the gameplay.
- **Hover** (web/desktop adaptation): lighten fill / intensify glow.
  **Press:** the game uses ink ripples + slight scale; emulate with a quick
  scale-down (0.97) and brighter glow. Disabled controls drop to a muted navy
  fill with `white54` text.

### Transparency & blur — when
- **Yes:** modal scrims, glass panels floating over gameplay, status-panel fills
  (navy at 85%), HUD bars (white at 20% track).
- **No:** never blur or fade the core readouts (score/lives) or primary buttons.

---

## 4. Iconography

The game uses **Flutter Material Icons** (the built-in Material Symbols font) —
filled, rounded-corner glyphs. There is no custom icon font or SVG icon set in
the source. Icons are always paired with cyan (`#00EEFF`) on dark, or black on
the orange selected state.

**Icons seen in the source** (Material names): `home_filled`, `flight` (jet,
HANGAR), `shopping_cart_outlined`, `person` / `person_outline`, `rocket_launch`
(SCRAMBLE), `star_border`, `diamond`, `money`, `wifi`, `pause`, `volume_up`,
`music_note`, `emoji_events`, `mail_outline`, `calendar_today`, `store`,
`arrow_forward`, `check_circle`.

**This system's approach:** we substitute **Material Symbols Rounded** from the
Google Fonts CDN (the closest faithful match to Flutter's built-in Material
Icons — identical glyph language). Load it via:
`<link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Rounded:opsz,wght,FILL,GRAD@24,400,1,0" rel="stylesheet">`
then `<span class="material-symbols-rounded">flight</span>`. *Substitution flag
below.* Emoji and Unicode pictographs are **never** used as icons.

**Game art assets** (sprites, not UI icons) live in `assets/` and are real PNGs
from the game — use these for the jet emblem, power-up badges, and backdrops:
- `assets/sprites/` — `jet_2_level.png` (hero jet, level flight) + bank frames,
  `powerups_strip_128.png` (8 power-up badges in one strip),
  `fighter_jet_explosion_256.png`, `fighter_jet_thrust_loop_256.png`.
- `assets/backgrounds/` — `bg_morning/midday/afternoon/night.png` (parallax
  skies, one per world).

---

## 5. Substitution flags ⚑

These were not in the source and were matched to the nearest available option —
**please confirm or supply replacements:**
1. **Display/UI font → Chakra Petch**, **Numeric font → Share Tech Mono**
   (Google Fonts). The game ships system **Roboto**; these tactical typefaces
   better express the cockpit HUD. Swap in `tokens/fonts.css` + `tokens/typography.css`.
2. **Icon set → Material Symbols Rounded** (Google Fonts CDN), standing in for
   Flutter's built-in Material Icons.
3. **Logo:** AeroFighter has no logo image in the source — it is a text
   wordmark. The brand cards present a wordmark lockup + jet emblem built from
   the real `jet_2_level.png` sprite. Supply an official logo if one exists.

---

## 6. Index / manifest

**Root**
- `styles.css` — global entry (import this); `@import` manifest only.
- `readme.md` — this guide.
- `SKILL.md` — Agent-Skills-compatible invocation wrapper.

**`tokens/`** — `fonts.css`, `colors.css`, `typography.css`, `spacing.css`,
`effects.css` (all reached from `styles.css`).

**`assets/`** — `sprites/` (jets, power-ups, fx), `backgrounds/` (4 skies).

**`guidelines/`** — foundation specimen cards (Type, Colors, Spacing, Brand) for
the Design System tab.

**`components/core/`** — 14 reusable React primitives (see the two component
cards, `controls.card.html` + `surfaces.card.html`): `Button`, `IconButton`,
`Panel`, `GlassModal`, `StatBar`, `ProgressBar`, `Badge`, `JetChip`, `WorldChip`,
`NavBar`, `SegmentedControl`, `Toggle`, `Avatar`, `PowerUpBadge`. Each ships a
`.d.ts` props contract and a `.prompt.md` usage note. Compiler namespace:
`window.AeroFighterDesignSystem_9520d9`.

**`ui_kits/aerofighter-app/`** — full interactive recreation of the mobile app:
Home (scramble), Hangar (jet configurator), Gameplay HUD, and modal flows.
