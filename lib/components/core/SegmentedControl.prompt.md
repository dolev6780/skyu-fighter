One-line: The DIFFICULTY SCALE selector — a row of segments where the active one tints + borders in its color.

```jsx
<SegmentedControl
  value={diff}
  onChange={setDiff}
  options={[
    { label: 'Easy', color: 'var(--af-success)' },
    { label: 'Normal', color: 'var(--af-blue)' },
    { label: 'Hard', color: 'var(--af-danger)' },
  ]}
/>
```

Options can be plain strings (use `activeColor`) or `{label,color}` for per-segment colors. Selected = 20%-opacity fill + solid colored border.
