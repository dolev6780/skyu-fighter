import React from 'react';

/**
 * Segmented selector — the difficulty scale (EASY / NORMAL / HARD). Selected
 * option tints with the active color at low opacity + a colored border.
 */
export function SegmentedControl({ options = [], value = 0, onChange = () => {}, activeColor = 'var(--af-blue)', style = {} }) {
  return (
    <div style={{ display: 'flex', gap: 8, ...style }}>
      {options.map((opt, i) => {
        const selected = i === value;
        const col = (typeof opt === 'object' && opt.color) || activeColor;
        const label = typeof opt === 'object' ? opt.label : opt;
        return (
          <button key={label} onClick={() => onChange(i)} style={{
            flex: 1, padding: '10px 8px', cursor: 'pointer',
            borderRadius: 'var(--af-radius-sm)',
            background: selected ? colorMix(col, 0.2) : 'rgba(0,0,0,0.22)',
            border: `1.5px solid ${selected ? col : 'var(--af-border-quiet)'}`,
            color: selected ? 'var(--af-text)' : 'var(--af-text-muted)',
            fontFamily: 'var(--af-font-ui)', fontSize: 11, fontWeight: 700,
            letterSpacing: 'var(--af-track-normal)', textTransform: 'uppercase',
            transition: 'all var(--af-dur) var(--af-ease)',
          }}>{label}</button>
        );
      })}
    </div>
  );
}

function colorMix(c, a) {
  if (typeof c === 'string' && c.startsWith('#') && c.length === 7) {
    const r = parseInt(c.slice(1, 3), 16), g = parseInt(c.slice(3, 5), 16), b = parseInt(c.slice(5, 7), 16);
    return `rgba(${r},${g},${b},${a})`;
  }
  return `color-mix(in srgb, ${c} ${a * 100}%, transparent)`;
}
