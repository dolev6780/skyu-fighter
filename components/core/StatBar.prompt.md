One-line: The hangar's labeled capability meter — ENGINE SPEED / HULL INTEGRITY / FIREPOWER.

```jsx
<StatBar label="Engine Speed" value={0.9} color="var(--af-cyan)" />
<StatBar label="Hull Integrity" value={0.4} color="var(--af-warning)" />
<StatBar label="Firepower" value={0.7} color="#ff4444" />
```

`value` is 0..1; the percentage prints in the bar color (mono). Color the bar by stat in the jet configurator. For generic loading/HUD progress use `ProgressBar` instead.
