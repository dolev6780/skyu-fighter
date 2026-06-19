One-line: The campaign sector selector — a glowing accent dot + W# + name, used in a horizontal scroll strip to pick which world you scramble into.

```jsx
import { WORLDS } from './WorldChip';

<div style={{ display: 'flex', gap: 10, overflowX: 'auto' }}>
  {WORLDS.map((w, i) => (
    <WorldChip key={w.id} {...w} selected={i === sel} onClick={() => setSel(i)} />
  ))}
</div>
<WorldChip id={4} name="NIGHT OPS" accent="var(--af-world-night)" locked />
```

The exported `WORLDS` array gives `{id, name, accent}` for all four sectors (Dawn / Midday / Dusk / Night). `selected` glows in the accent; `locked` dims with a lock glyph. Pair with the matching sky background per world.
