One-line: The base translucent-navy surface — status readouts, cards, config sections all sit on a Panel.

```jsx
<Panel>
  <h3>FUEL SYSTEM</h3>
</Panel>
<Panel accent="#00eeff" glow>Active sector</Panel>
```

Defaults to an 85%-opacity `#051020` fill with a thin `#102540` border. Pass `accent` (hex) to recolor the border and, with `glow`, add a matching outer glow — used for active/alert states. Tune `padding` and `radius` per context (modals use 24px).
