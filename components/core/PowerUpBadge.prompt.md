One-line: A glowing power-up pickup badge — one frame of the real 8-frame sprite strip inside a colored ring.

```jsx
<PowerUpBadge type="weaponUp" src="../../assets/sprites/powerups_strip_128.png" />
<PowerUpBadge type={6} size={64} />        {/* tactical nuke */}
<PowerUpBadge type="repair" ring={false} /> {/* bare sprite */}
```

`type` is a 0..7 frame index or a key. **You must point `src` at `assets/sprites/powerups_strip_128.png` resolved from your page's location.** The exported `POWERUPS` array gives `{key,label,color}` for each (order = frame order): weaponUp, rapidFire, missiles, repair, extraLife, armor, nuke, scoreStar.
