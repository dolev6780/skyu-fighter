---
name: aerofighter-design
description: Use this skill to generate well-branded interfaces and assets for AeroFighter (a tactical arcade jet-combat shooter), either for production or throwaway prototypes/mocks/etc. Contains essential design guidelines, colors, type, fonts, assets, and UI kit components for prototyping.
user-invocable: true
---

Read the README.md file within this skill, and explore the other available files.
If creating visual artifacts (slides, mocks, throwaway prototypes, etc), copy assets out and create static HTML files for the user to view. If working on production code, you can copy assets and read the rules here to become an expert in designing with this brand.
If the user invokes this skill without any other guidance, ask them what they want to build or design, ask some questions, and act as an expert designer who outputs HTML artifacts _or_ production code, depending on the need.

## Quick map
- `readme.md` — full design guide: product context, content fundamentals (voice/casing), visual foundations (color, type, glow, glass, motion), iconography, substitution flags, and a file index. **Start here.**
- `styles.css` — global entry; `@import`s all token files. Link this one file.
- `tokens/` — `colors.css`, `typography.css`, `spacing.css`, `effects.css`, `fonts.css`.
- `components/core/` — React primitives (Button, IconButton, Panel, GlassModal, StatBar, ProgressBar, Badge, JetChip, NavBar, SegmentedControl, Toggle, Avatar, PowerUpBadge). Each has a `.prompt.md` with usage.
- `ui_kits/aerofighter-app/` — full interactive recreation of the mobile app.
- `guidelines/` — foundation specimen cards.
- `assets/` — real game art: `sprites/` (jets, power-up strip, fx), `backgrounds/` (4 skies).

## Essence
Tactical cockpit HUD: deep-navy surfaces, electric-cyan chrome, orange/red action accents. UPPERCASE, widely-tracked type (Chakra Petch) + mono telemetry (Share Tech Mono). Depth via colored glow, not gray elevation. Frosted-glass modals. No emoji. Military-radio voice (SCRAMBLE, ABORT TO MENU, SYSTEMS NOMINAL).
