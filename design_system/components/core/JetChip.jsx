import React from 'react';

/**
 * Hangar jet-selector chip — a glowing skin-color dot in a rounded tile.
 * Highlighted (being viewed) gets a 2px cyan border + tint; equipped shows a
 * green check. Mirrors the configurator's horizontal skin list.
 */
export function JetChip({ color = 'var(--af-skin-cobalt)', highlighted = false, equipped = false, onClick = () => {}, style = {} }) {
  return (
    <button onClick={onClick} style={{
      width: 60, height: 64, flex: '0 0 auto', cursor: 'pointer', position: 'relative',
      borderRadius: 'var(--af-radius-md)',
      background: highlighted ? 'rgba(0,170,255,0.10)' : 'rgba(0,0,0,0.25)',
      border: highlighted
        ? '2px solid var(--af-cyan)'
        : `1.2px solid ${equipped ? 'rgba(0,170,255,0.5)' : 'var(--af-border-inactive)'}`,
      display: 'flex', alignItems: 'center', justifyContent: 'center',
      transition: 'all var(--af-dur) var(--af-ease)',
      ...style,
    }}>
      <span style={{ width: 24, height: 24, borderRadius: '999px', background: color, boxShadow: `0 0 8px 1px ${color}` }} />
      {equipped && (
        <span className="material-symbols-rounded" style={{
          position: 'absolute', top: 2, right: 2, fontSize: 13, color: 'var(--af-success)',
        }}>check_circle</span>
      )}
    </button>
  );
}
