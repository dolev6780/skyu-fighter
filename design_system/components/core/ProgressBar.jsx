import React from 'react';

/**
 * Thin HUD progress / timer track. Used for kill-progress and power-up timers.
 * Optional glow on the fill.
 */
export function ProgressBar({ value = 0.5, color = 'var(--af-orange)', height = 'var(--af-bar-thin)', glow = true, track = 'rgba(0,0,0,0.45)', style = {} }) {
  const pct = Math.max(0, Math.min(1, value)) * 100;
  return (
    <div style={{ height, borderRadius: 'var(--af-radius-sm)', background: track, overflow: 'hidden', ...style }}>
      <div style={{
        width: `${pct}%`, height: '100%', background: color, borderRadius: 'var(--af-radius-sm)',
        boxShadow: glow ? `0 0 8px ${color}` : 'none', transition: 'width var(--af-dur) linear',
      }} />
    </div>
  );
}
