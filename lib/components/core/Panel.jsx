import React from 'react';

/**
 * Translucent navy cockpit panel — the base surface for status readouts,
 * cards, and config sections. Thin cyan-tinted border, optional glow.
 */
export function Panel({
  children,
  accent = null,        // optional accent color string for border + glow
  glow = false,
  padding = 'var(--af-space-7)',
  radius = 'var(--af-radius-md)',
  style = {},
  ...rest
}) {
  const borderColor = accent || 'var(--af-border)';
  return (
    <div
      style={{
        background: 'rgba(5,16,32,0.85)',
        border: `var(--af-stroke) solid ${borderColor}`,
        borderRadius: radius,
        padding,
        boxShadow: glow && accent ? `0 0 16px ${hexA(accent, 0.4)}` : 'var(--af-shadow-panel)',
        color: 'var(--af-text)',
        ...style,
      }}
      {...rest}
    >
      {children}
    </div>
  );
}

function hexA(c, a) {
  // Accept rgba/var passthrough; only convert #rrggbb
  if (typeof c !== 'string' || !c.startsWith('#') || c.length !== 7) return c;
  const r = parseInt(c.slice(1, 3), 16);
  const g = parseInt(c.slice(3, 5), 16);
  const b = parseInt(c.slice(5, 7), 16);
  return `rgba(${r},${g},${b},${a})`;
}
