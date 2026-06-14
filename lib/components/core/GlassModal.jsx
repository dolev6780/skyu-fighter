import React from 'react';

/**
 * Frosted-glass modal — dark blur fill, colored 1.5px border + glow, 24px
 * radius. The shell for GAME OVER / MISSION COMPLETE / SYSTEM PAUSED and the
 * hangar/settings sheets. Renders an optional scrim behind.
 */
export function GlassModal({ children, accent = 'var(--af-cyan-mid)', glow = false, width = 360, scrim = true, onScrimClick = null, style = {} }) {
  const panel = (
    <div style={{
      width, maxWidth: '90vw',
      background: 'var(--af-glass-fill)',
      backdropFilter: 'var(--af-blur-glass)', WebkitBackdropFilter: 'var(--af-blur-glass)',
      border: `var(--af-stroke) solid ${withAlpha(accent, 0.4)}`,
      borderRadius: 'var(--af-radius-2xl)',
      padding: 'var(--af-space-7)',
      boxShadow: glow ? `var(--af-shadow-modal), 0 0 30px ${withAlpha(accent, 0.4)}` : 'var(--af-shadow-modal)',
      color: 'var(--af-text)',
      ...style,
    }}>
      {children}
    </div>
  );
  if (!scrim) return panel;
  return (
    <div
      onClick={(e) => { if (e.target === e.currentTarget && onScrimClick) onScrimClick(); }}
      style={{ position: 'absolute', inset: 0, display: 'flex', alignItems: 'center', justifyContent: 'center', background: 'rgba(0,5,15,0.55)', padding: 20 }}
    >
      {panel}
    </div>
  );
}

function withAlpha(c, a) {
  if (typeof c !== 'string' || !c.startsWith('#') || c.length !== 7) {
    return `color-mix(in srgb, ${c} ${a * 100}%, transparent)`;
  }
  const r = parseInt(c.slice(1, 3), 16), g = parseInt(c.slice(3, 5), 16), b = parseInt(c.slice(5, 7), 16);
  return `rgba(${r},${g},${b},${a})`;
}
