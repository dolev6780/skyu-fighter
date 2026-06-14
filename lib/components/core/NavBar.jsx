import React from 'react';

/**
 * Bottom tab bar — the floating glass nav (HOME / HANGAR / SHOP / PILOT).
 * Selected item gets the orange filled tile + glow; others are cyan glyph+label.
 */
export function NavBar({ items = [], value = 0, onChange = () => {}, style = {} }) {
  return (
    <nav style={{
      display: 'flex', justifyContent: 'space-evenly', alignItems: 'center',
      height: 75, padding: '0 8px',
      background: 'rgba(5,16,32,0.95)',
      border: 'var(--af-stroke) solid var(--af-border)',
      borderRadius: 'var(--af-radius-xl)',
      boxShadow: 'var(--af-shadow-panel)',
      ...style,
    }}>
      {items.map((it, i) => {
        const selected = i === value;
        return (
          <button key={it.label} onClick={() => onChange(i)} style={{
            width: 65, height: 60, border: 'none', cursor: 'pointer',
            display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center', gap: 4,
            borderRadius: 'var(--af-radius-lg)',
            background: selected ? 'var(--af-orange)' : 'transparent',
            boxShadow: selected ? 'var(--af-glow-orange-soft)' : 'none',
            color: selected ? '#000000' : 'var(--af-cyan-mid)',
            transition: 'background var(--af-dur) var(--af-ease)',
          }}>
            <span className="material-symbols-rounded" style={{ fontSize: 24, lineHeight: 1 }}>{it.icon}</span>
            <span style={{ fontFamily: 'var(--af-font-ui)', fontSize: 9, fontWeight: 700, letterSpacing: 'var(--af-track-normal)' }}>{it.label}</span>
          </button>
        );
      })}
    </nav>
  );
}
