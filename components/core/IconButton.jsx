import React from 'react';

/**
 * Circular/rounded icon-only control. Used for pause, wifi, top-bar actions.
 * Cyan glyph on dark; `active` flips to the orange selected treatment.
 */
export function IconButton({ icon, label, active = false, size = 44, color = 'var(--af-cyan)', shape = 'circle', style = {}, ...rest }) {
  return (
    <button
      aria-label={label}
      style={{
        width: size, height: size, flex: '0 0 auto',
        display: 'inline-flex', alignItems: 'center', justifyContent: 'center',
        borderRadius: shape === 'circle' ? '999px' : 'var(--af-radius-md)',
        background: active ? 'var(--af-grad-action)' : 'rgba(5,16,32,0.6)',
        border: active ? 'none' : `1.5px solid ${active ? 'transparent' : 'var(--af-border)'}`,
        color: active ? 'var(--af-on-action)' : color,
        boxShadow: active ? 'var(--af-glow-orange)' : 'none',
        cursor: 'pointer',
        transition: 'transform var(--af-dur-fast) var(--af-ease)',
        ...style,
      }}
      onMouseDown={(e) => { e.currentTarget.style.transform = 'scale(0.92)'; }}
      onMouseUp={(e) => { e.currentTarget.style.transform = 'scale(1)'; }}
      onMouseLeave={(e) => { e.currentTarget.style.transform = 'scale(1)'; }}
      {...rest}
    >
      <span className="material-symbols-rounded" style={{ fontSize: Math.round(size * 0.5), lineHeight: 1 }}>{icon}</span>
    </button>
  );
}
