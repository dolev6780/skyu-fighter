One-line: The floating bottom tab bar (HOME / HANGAR / SHOP / PILOT); active tab is the orange glow tile.

```jsx
<NavBar
  value={tab}
  onChange={setTab}
  items={[
    { icon: 'home', label: 'HOME' },
    { icon: 'flight', label: 'HANGAR' },
    { icon: 'shopping_cart', label: 'SHOP' },
    { icon: 'person', label: 'PILOT' },
  ]}
/>
```

Selected item fills orange with black glyph+label; the rest are cyan. Margin it off the bottom edge (16px) so it floats over content.
