import React from 'react';

/**
 * Labeled stat bar — ENGINE SPEED / HULL INTEGRITY / FIREPOWER style.
 * Uppercase label left, percentage right (in bar color), thin filled track.
 */
export function StatBar({ label, value = 0.6, color = 'var(--af-cyan)', style = {} }) {
  const pct = Math.round(value * 100);
  return (
    <div style={{ ...style }}>
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'baseline', marginBottom: 4 }}>
        <span style={{
          color: 'var(--af-text-muted)', fontFamily: 'var(--af-font-ui)', fontSize: 10,
          letterSpacing: 'var(--af-track-normal)', textTransform: 'uppercase', fontWeight: 600,
        }}>{label}</span>
        <span style={{ color, fontFamily: 'var(--af-font-mono)', fontSize: 11, fontWeight: 700 }}>{pct}%</span>
      </div>
      <div style={{ height: 'var(--af-bar)', borderRadius: 'var(--af-radius-sm)', background: 'rgba(255,255,255,0.10)', overflow: 'hidden' }}>
        <div style={{
          width: `${pct}%`, height: '100%', background: color,
          borderRadius: 'var(--af-radius-sm)', boxShadow: `0 0 8px ${color}`,
          transition: 'width var(--af-dur) var(--af-ease)',
        }} />
      </div>
    </div>
  );
}
