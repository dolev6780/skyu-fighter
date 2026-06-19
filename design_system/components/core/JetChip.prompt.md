One-line: The hangar's jet-skin selector tile — a glowing skin-color dot, with highlight (previewing) and equipped (green check) states.

```jsx
<div style={{ display: 'flex', gap: 12 }}>
  <JetChip color="var(--af-skin-cobalt)" highlighted equipped />
  <JetChip color="var(--af-skin-crimson)" />
  <JetChip color="var(--af-skin-solar)" />
  <JetChip color="var(--af-skin-emerald)" />
</div>
```

`highlighted` = the one currently shown in the configurator (cyan 2px border). `equipped` = the active loadout (green check, soft cyan border). Lay them in a horizontal scroll row.
