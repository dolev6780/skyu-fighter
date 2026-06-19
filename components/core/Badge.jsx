import React from 'react';

/**
 * Status / count badge. `dot` renders a tiny notification circle (the orange
 * dot on action pills); otherwise a small uppercase pill (e.g. EQUIPPED, READY).
 */
export function Badge({ children, color = 'var(--af-cyan)', variant = 'solid', dot = false, style = {} }) {
  if (dot) {
    return <span style={{ display: 'inline-block', width: 8, height: 8, borderRadius: '999px', background: color, boxShadow: `0 0 8px ${color}`, ...style }} />;
  }
  const solid = variant === 'solid';
  return (
    <span style={{
      display: 'inline-flex', alignItems: 'center', gap: 4,
      padding: '3px 9px', borderRadius: 'var(--af-radius-sm)',
      fontFamily: 'var(--af-font-ui)', fontSize: 10, fontWeight: 700,
      letterSpacing: 'var(--af-track-wide)', textTransform: 'uppercase',
      background: solid ? color : 'transparent',
      color: solid ? 'var(--af-on-action)' : color,
      border: solid ? 'none' : `1px solid ${color}`,
      ...style,
    }}>{children}</span>
  );
}
