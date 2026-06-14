One-line: The frosted-glass overlay shell behind GAME OVER, MISSION COMPLETE, SYSTEM PAUSED, and the hangar/settings sheets.

```jsx
<GlassModal accent="var(--af-danger)" glow onScrimClick={close}>
  <h1>GAME OVER</h1>
  <Button block variant="primary">Re-launch Mission</Button>
  <Button block variant="danger">Abort to Menu</Button>
</GlassModal>
```

`blur(14px)` over `rgba(0,0,0,0.75)`, 24px radius, accent-tinted border. Set `glow` for hero alerts (red Game Over, world-accent Mission Complete). `scrim` (default) wraps it in a dimming, click-to-dismiss backdrop inside the nearest positioned ancestor — make the parent `position: relative`. Set `scrim={false}` to drop just the panel into your own layout.
