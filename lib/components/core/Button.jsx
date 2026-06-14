import React from 'react';

/**
 * AeroFighter primary CTA. The signature orange-gradient "SCRAMBLE" action,
 * plus secondary (outlined cyan) and danger variants. All-caps, tracked.
 */
export function Button({
  children,
  variant = 'primary',
  size = 'md',
  icon = null,
  disabled = false,
  block = false,
  style = {},
  ...rest
}) {
  const sizes = {
    sm: { padding: '8px 16px', fontSize: 12, letterSpacing: '1px', minHeight: 36, gap: 8, iconSize: 16 },
    md: { padding: '14px 24px', fontSize: 15, letterSpacing: '1.5px', minHeight: 48, gap: 10, iconSize: 20 },
    lg: { padding: '18px 28px', fontSize: 22, letterSpacing: '2px', minHeight: 64, gap: 12, iconSize: 26 },
  };
  const s = sizes[size] || sizes.md;

  const base = {
    display: block ? 'flex' : 'inline-flex',
    width: block ? '100%' : 'auto',
    alignItems: 'center',
    justifyContent: 'center',
    gap: s.gap,
    padding: s.padding,
    minHeight: s.minHeight,
    fontFamily: 'var(--af-font-ui)',
    fontWeight: 700,
    fontSize: s.fontSize,
    letterSpacing: s.letterSpacing,
    textTransform: 'uppercase',
    borderRadius: 'var(--af-radius-md)',
    border: 'none',
    cursor: disabled ? 'not-allowed' : 'pointer',
    transition: 'transform var(--af-dur-fast) var(--af-ease), filter var(--af-dur) var(--af-ease), box-shadow var(--af-dur) var(--af-ease)',
    whiteSpace: 'nowrap',
  };

  const variants = {
    primary: {
      background: 'var(--af-grad-action)',
      color: 'var(--af-on-action)',
      boxShadow: 'var(--af-glow-orange)',
      fontStyle: size === 'lg' ? 'italic' : 'normal',
    },
    secondary: {
      background: 'transparent',
      color: 'var(--af-cyan)',
      border: 'var(--af-stroke) solid var(--af-cyan-mid)',
    },
    ghost: {
      background: 'rgba(0,170,255,0.08)',
      color: 'var(--af-cyan)',
    },
    danger: {
      background: 'transparent',
      color: 'var(--af-danger)',
      border: 'var(--af-stroke) solid var(--af-danger)',
    },
    success: {
      background: 'transparent',
      color: 'var(--af-success)',
      border: 'var(--af-stroke) solid var(--af-success)',
    },
  };

  const disabledStyle = disabled
    ? { background: 'var(--af-border-inactive)', color: 'var(--af-text-faint)', boxShadow: 'none', border: 'none', filter: 'saturate(0.4)' }
    : {};

  return (
    <button
      style={{ ...base, ...(variants[variant] || variants.primary), ...disabledStyle, ...style }}
      disabled={disabled}
      onMouseDown={(e) => { if (!disabled) e.currentTarget.style.transform = 'scale(0.97)'; }}
      onMouseUp={(e) => { e.currentTarget.style.transform = 'scale(1)'; }}
      onMouseLeave={(e) => { e.currentTarget.style.transform = 'scale(1)'; }}
      {...rest}
    >
      {icon && <span className="material-symbols-rounded" style={{ fontSize: s.iconSize, lineHeight: 1 }}>{icon}</span>}
      {children}
    </button>
  );
}
