One-line: AeroFighter's primary CTA — the uppercase, tracked action button, headlined by the orange-gradient "SCRAMBLE" launcher.

```jsx
<Button variant="primary" size="lg" icon="rocket_launch">Scramble</Button>
<Button variant="secondary" icon="flight">Hangar</Button>
<Button variant="danger">Abort to Menu</Button>
<Button disabled>Equipped</Button>
```

Variants: `primary` (orange gradient + glow; italic at `lg`), `secondary` (cyan outline), `ghost` (soft cyan fill), `danger` (red outline), `success` (green outline). Sizes `sm | md | lg`. Pass `icon` (a Material Symbols Rounded name) and `block` for full width. Disabled drops to a muted navy fill with faint text, matching the game's EQUIPPED state.
