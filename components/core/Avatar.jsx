import React from 'react';

/**
 * Pilot avatar — cyan-ringed circle with a person glyph or initials/image.
 */
export function Avatar({ src = null, initials = null, size = 48, ring = 'var(--af-cyan-mid)', style = {} }) {
  return (
    <div style={{
      width: size, height: size, borderRadius: '999px',
      border: `1.5px solid ${ring}`, background: 'var(--af-bg)',
      display: 'inline-flex', alignItems: 'center', justifyContent: 'center',
      overflow: 'hidden', flex: '0 0 auto', ...style,
    }}>
      {src
        ? <img src={src} alt="" style={{ width: '100%', height: '100%', objectFit: 'cover' }} />
        : initials
          ? <span style={{ color: 'var(--af-cyan)', fontFamily: 'var(--af-font-ui)', fontWeight: 700, fontSize: Math.round(size * 0.36), letterSpacing: '1px' }}>{initials}</span>
          : <span className="material-symbols-rounded" style={{ color: 'var(--af-cyan)', fontSize: Math.round(size * 0.55) }}>person</span>}
    </div>
  );
}
