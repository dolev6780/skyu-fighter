One-line: Small uppercase status pill (EQUIPPED, READY, MAX LIVES) or a glowing notification dot.

```jsx
<Badge color="var(--af-success)">Equipped</Badge>
<Badge variant="outline" color="var(--af-cyan)">Ready</Badge>
<Badge dot color="var(--af-amber)" />
```

`solid` fills with the color and uses near-black text; `outline` is bordered. `dot` ignores children and renders the tiny glowing circle seen on Home action pills.
