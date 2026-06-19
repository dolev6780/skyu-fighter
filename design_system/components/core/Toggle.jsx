import React from 'react';

/**
 * Settings switch — cyan when on, dark track when off. Matches the Flutter
 * Switch used for SOUND FX / MUSIC TRACK.
 */
export function Toggle({ checked = false, onChange = () => {}, color = 'var(--af-cyan)', style = {} }) {
  return (
    <button
      role="switch"
      aria-checked={checked}
      onClick={() => onChange(!checked)}
      style={{
        width: 50, height: 28, borderRadius: '999px', border: 'none', cursor: 'pointer',
        padding: 3, display: 'inline-flex', alignItems: 'center',
        background: checked ? color : 'var(--af-border-inactive)',
        boxShadow: checked ? `0 0 10px ${color}` : 'none',
        transition: 'background var(--af-dur) var(--af-ease)',
        ...style,
      }}
    >
      <span style={{
        width: 22, height: 22, borderRadius: '999px', background: checked ? 'var(--af-bg)' : 'rgba(255,255,255,0.5)',
        transform: checked ? 'translateX(22px)' : 'translateX(0)',
        transition: 'transform var(--af-dur) var(--af-ease)',
      }} />
    </button>
  );
}
