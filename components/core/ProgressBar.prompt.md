One-line: A thin glowing HUD track for kill-progress and power-up countdowns.

```jsx
<ProgressBar value={0.6} color="var(--af-orange)" />
<ProgressBar value={0.3} color="var(--af-cyan)" glow={false} />
```

Defaults thin (4px) with a glow. Use the world/power-up accent for color. For labeled jet stats use `StatBar`.
