import React from 'react';

/** Campaign sectors — id, name, and accent token. Sky/level live in the app. */
export const WORLDS = [
  { id: 1, name: 'DAWN SECTOR',  accent: 'var(--af-world-dawn)' },
  { id: 2, name: 'MIDDAY FRONT', accent: 'var(--af-world-midday)' },
  { id: 3, name: 'DUSK ZONE',    accent: 'var(--af-world-dusk)' },
  { id: 4, name: 'NIGHT OPS',    accent: 'var(--af-world-night)' },
];

/**
 * Campaign sector selector chip — a glowing accent dot, the sector code (W1)
 * and name. Selected gets the accent border + tint + glow; locked dims with a
 * lock glyph. Lay several in a horizontal scroll strip (same vocabulary as the
 * hangar jet list).
 */
export function WorldChip({ id = 1, name = 'DAWN SECTOR', accent = 'var(--af-world-dawn)', selected = false, locked = false, onClick = () => {}, style = {} }) {
  return (
    <button
      onClick={locked ? undefined : onClick}
      disabled={locked}
      style={{
        display: 'flex', alignItems: 'center', gap: 10, flex: '0 0 auto',
        padding: '8px 14px', cursor: locked ? 'not-allowed' : 'pointer', whiteSpace: 'nowrap',
        borderRadius: 'var(--af-radius-md)',
        background: selected ? withAlpha(accent, 0.16) : 'rgba(0,0,0,0.25)',
        border: selected ? `2px solid ${accent}` : '1.2px solid var(--af-border-inactive)',
        boxShadow: selected ? `0 0 14px ${withAlpha(accent, 0.5)}` : 'none',
        opacity: locked ? 0.45 : 1,
        transition: 'all var(--af-dur) var(--af-ease)',
        ...style,
      }}
    >
      {locked
        ? <span className="material-symbols-rounded" style={{ fontSize: 16, color: 'var(--af-text-muted)' }}>lock</span>
        : <span style={{ width: 12, height: 12, borderRadius: '999px', background: accent, boxShadow: `0 0 8px ${accent}`, flex: '0 0 auto' }} />}
      <div style={{ textAlign: 'left' }}>
        <div style={{ fontFamily: 'var(--af-font-mono)', fontSize: 9, letterSpacing: '1px', color: 'var(--af-text-muted)', lineHeight: 1.1 }}>W{id}</div>
        <div style={{ fontFamily: 'var(--af-font-ui)', fontSize: 11, fontWeight: 700, letterSpacing: 'var(--af-track-normal)', color: selected ? 'var(--af-text)' : 'var(--af-text-muted)', lineHeight: 1.2 }}>{name}</div>
      </div>
    </button>
  );
}

function withAlpha(c, a) {
  if (typeof c !== 'string' || !c.startsWith('#') || c.length !== 7) {
    return `color-mix(in srgb, ${c} ${a * 100}%, transparent)`;
  }
  const r = parseInt(c.slice(1, 3), 16), g = parseInt(c.slice(3, 5), 16), b = parseInt(c.slice(5, 7), 16);
  return `rgba(${r},${g},${b},${a})`;
}
