import React from 'react';

/** Power-up metadata — order matches the game's sprite strip (frame index). */
export const POWERUPS = [
  { key: 'weaponUp',  label: 'WEAPON UP',     color: '#FF8800' },
  { key: 'rapidFire', label: 'RAPID FIRE',    color: '#FFFF33' },
  { key: 'missiles',  label: 'MISSILES',      color: '#FF3333' },
  { key: 'repair',    label: 'SYSTEM REPAIRED', color: '#33FF33' },
  { key: 'extraLife', label: 'EXTRA LIFE',    color: '#FFFFFF' },
  { key: 'armor',     label: 'ARMOR',         color: '#3388FF' },
  { key: 'nuke',      label: 'TACTICAL NUKE', color: '#CC33FF' },
  { key: 'scoreStar', label: 'SCORE STAR',    color: '#FFD700' },
];

/**
 * Glowing power-up badge — one frame of the 8-frame sprite strip inside a
 * pulsing colored ring. Pass the strip path via `src`.
 */
export function PowerUpBadge({ type = 0, src = 'assets/sprites/powerups_strip_128.png', size = 56, ring = true, style = {} }) {
  const idx = typeof type === 'string' ? POWERUPS.findIndex((p) => p.key === type) : type;
  const meta = POWERUPS[idx] || POWERUPS[0];
  return (
    <div style={{
      width: size, height: size, borderRadius: '999px', position: 'relative',
      display: 'inline-flex', alignItems: 'center', justifyContent: 'center',
      background: ring ? `radial-gradient(circle, ${rgba(meta.color, 0.28)} 0%, ${rgba(meta.color, 0.05)} 70%, transparent 100%)` : 'transparent',
      border: ring ? `1.5px solid ${rgba(meta.color, 0.6)}` : 'none',
      boxShadow: ring ? `0 0 14px ${rgba(meta.color, 0.5)}` : 'none',
      ...style,
    }}>
      <span style={{
        width: '74%', height: '74%',
        backgroundImage: `url(${src})`,
        backgroundSize: `${800}% 100%`,
        backgroundPosition: `${(idx / 7) * 100}% 0`,
        backgroundRepeat: 'no-repeat',
        imageRendering: 'auto',
      }} />
    </div>
  );
}

function rgba(c, a) {
  if (typeof c !== 'string' || !c.startsWith('#') || c.length !== 7) return c;
  const r = parseInt(c.slice(1, 3), 16), g = parseInt(c.slice(3, 5), 16), b = parseInt(c.slice(5, 7), 16);
  return `rgba(${r},${g},${b},${a})`;
}
