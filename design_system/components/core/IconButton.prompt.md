One-line: Icon-only control for pause / wifi / top-bar actions, with the cyan-on-dark default and orange active state.

```jsx
<IconButton icon="pause" label="Pause" />
<IconButton icon="wifi" size={36} />
<IconButton icon="home" active />
```

Defaults to a 44px circle (minimum hit target). `active` switches to the orange gradient + glow. Use `shape="rounded"` for square-ish chrome.
