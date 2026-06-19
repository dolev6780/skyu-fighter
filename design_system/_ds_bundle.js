/* @ds-bundle: {"format":3,"namespace":"AeroFighterDesignSystem_9520d9","components":[{"name":"Avatar","sourcePath":"components/core/Avatar.jsx"},{"name":"Badge","sourcePath":"components/core/Badge.jsx"},{"name":"Button","sourcePath":"components/core/Button.jsx"},{"name":"GlassModal","sourcePath":"components/core/GlassModal.jsx"},{"name":"IconButton","sourcePath":"components/core/IconButton.jsx"},{"name":"JetChip","sourcePath":"components/core/JetChip.jsx"},{"name":"NavBar","sourcePath":"components/core/NavBar.jsx"},{"name":"Panel","sourcePath":"components/core/Panel.jsx"},{"name":"POWERUPS","sourcePath":"components/core/PowerUpBadge.jsx"},{"name":"PowerUpBadge","sourcePath":"components/core/PowerUpBadge.jsx"},{"name":"ProgressBar","sourcePath":"components/core/ProgressBar.jsx"},{"name":"SegmentedControl","sourcePath":"components/core/SegmentedControl.jsx"},{"name":"StatBar","sourcePath":"components/core/StatBar.jsx"},{"name":"Toggle","sourcePath":"components/core/Toggle.jsx"},{"name":"WORLDS","sourcePath":"components/core/WorldChip.jsx"},{"name":"WorldChip","sourcePath":"components/core/WorldChip.jsx"}],"sourceHashes":{"components/core/Avatar.jsx":"b037fe612543","components/core/Badge.jsx":"0051a28353eb","components/core/Button.jsx":"8d5ef9a2f5bf","components/core/GlassModal.jsx":"c402e8cd09d3","components/core/IconButton.jsx":"4db4a878ffb5","components/core/JetChip.jsx":"3a03ef1c6b28","components/core/NavBar.jsx":"ea0d1bb38914","components/core/Panel.jsx":"660d6e736840","components/core/PowerUpBadge.jsx":"2f2d58425a83","components/core/ProgressBar.jsx":"83f439114eb1","components/core/SegmentedControl.jsx":"7b2b226fac35","components/core/StatBar.jsx":"f8c9747877fb","components/core/Toggle.jsx":"dd0a29eadf3f","components/core/WorldChip.jsx":"6b5a2724f92b","ui_kits/aerofighter-app/App.jsx":"3fbbffe1770b","ui_kits/aerofighter-app/GameplayHUD.jsx":"7889d3904553","ui_kits/aerofighter-app/HangarScreen.jsx":"014fc1fc29b6","ui_kits/aerofighter-app/HomeScreen.jsx":"5f4765da5dab","ui_kits/aerofighter-app/Modals.jsx":"73a1cf643fa3","ui_kits/aerofighter-app/SettingsScreens.jsx":"772db15d8a5b","ui_kits/aerofighter-app/TopBar.jsx":"95a104f4bb85"},"inlinedExternals":[],"unexposedExports":[]} */

(() => {

const __ds_ns = (window.AeroFighterDesignSystem_9520d9 = window.AeroFighterDesignSystem_9520d9 || {});

const __ds_scope = {};

(__ds_ns.__errors = __ds_ns.__errors || []);

// components/core/Avatar.jsx
try { (() => {
/**
 * Pilot avatar â€” cyan-ringed circle with a person glyph or initials/image.
 */
function Avatar({
  src = null,
  initials = null,
  size = 48,
  ring = 'var(--af-cyan-mid)',
  style = {}
}) {
  return /*#__PURE__*/React.createElement("div", {
    style: {
      width: size,
      height: size,
      borderRadius: '999px',
      border: `1.5px solid ${ring}`,
      background: 'var(--af-bg)',
      display: 'inline-flex',
      alignItems: 'center',
      justifyContent: 'center',
      overflow: 'hidden',
      flex: '0 0 auto',
      ...style
    }
  }, src ? /*#__PURE__*/React.createElement("img", {
    src: src,
    alt: "",
    style: {
      width: '100%',
      height: '100%',
      objectFit: 'cover'
    }
  }) : initials ? /*#__PURE__*/React.createElement("span", {
    style: {
      color: 'var(--af-cyan)',
      fontFamily: 'var(--af-font-ui)',
      fontWeight: 700,
      fontSize: Math.round(size * 0.36),
      letterSpacing: '1px'
    }
  }, initials) : /*#__PURE__*/React.createElement("span", {
    className: "material-symbols-rounded",
    style: {
      color: 'var(--af-cyan)',
      fontSize: Math.round(size * 0.55)
    }
  }, "person"));
}
Object.assign(__ds_scope, { Avatar });
})(); } catch (e) { __ds_ns.__errors.push({ path: "components/core/Avatar.jsx", error: String((e && e.message) || e) }); }

// components/core/Badge.jsx
try { (() => {
/**
 * Status / count badge. `dot` renders a tiny notification circle (the orange
 * dot on action pills); otherwise a small uppercase pill (e.g. EQUIPPED, READY).
 */
function Badge({
  children,
  color = 'var(--af-cyan)',
  variant = 'solid',
  dot = false,
  style = {}
}) {
  if (dot) {
    return /*#__PURE__*/React.createElement("span", {
      style: {
        display: 'inline-block',
        width: 8,
        height: 8,
        borderRadius: '999px',
        background: color,
        boxShadow: `0 0 8px ${color}`,
        ...style
      }
    });
  }
  const solid = variant === 'solid';
  return /*#__PURE__*/React.createElement("span", {
    style: {
      display: 'inline-flex',
      alignItems: 'center',
      gap: 4,
      padding: '3px 9px',
      borderRadius: 'var(--af-radius-sm)',
      fontFamily: 'var(--af-font-ui)',
      fontSize: 10,
      fontWeight: 700,
      letterSpacing: 'var(--af-track-wide)',
      textTransform: 'uppercase',
      background: solid ? color : 'transparent',
      color: solid ? 'var(--af-on-action)' : color,
      border: solid ? 'none' : `1px solid ${color}`,
      ...style
    }
  }, children);
}
Object.assign(__ds_scope, { Badge });
})(); } catch (e) { __ds_ns.__errors.push({ path: "components/core/Badge.jsx", error: String((e && e.message) || e) }); }

// components/core/Button.jsx
try { (() => {
function _extends() { return _extends = Object.assign ? Object.assign.bind() : function (n) { for (var e = 1; e < arguments.length; e++) { var t = arguments[e]; for (var r in t) ({}).hasOwnProperty.call(t, r) && (n[r] = t[r]); } return n; }, _extends.apply(null, arguments); }
/**
 * AeroFighter primary CTA. The signature orange-gradient "SCRAMBLE" action,
 * plus secondary (outlined cyan) and danger variants. All-caps, tracked.
 */
function Button({
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
    sm: {
      padding: '8px 16px',
      fontSize: 12,
      letterSpacing: '1px',
      minHeight: 36,
      gap: 8,
      iconSize: 16
    },
    md: {
      padding: '14px 24px',
      fontSize: 15,
      letterSpacing: '1.5px',
      minHeight: 48,
      gap: 10,
      iconSize: 20
    },
    lg: {
      padding: '18px 28px',
      fontSize: 22,
      letterSpacing: '2px',
      minHeight: 64,
      gap: 12,
      iconSize: 26
    }
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
    whiteSpace: 'nowrap'
  };
  const variants = {
    primary: {
      background: 'var(--af-grad-action)',
      color: 'var(--af-on-action)',
      boxShadow: 'var(--af-glow-orange)',
      fontStyle: size === 'lg' ? 'italic' : 'normal'
    },
    secondary: {
      background: 'transparent',
      color: 'var(--af-cyan)',
      border: 'var(--af-stroke) solid var(--af-cyan-mid)'
    },
    ghost: {
      background: 'rgba(0,170,255,0.08)',
      color: 'var(--af-cyan)'
    },
    danger: {
      background: 'transparent',
      color: 'var(--af-danger)',
      border: 'var(--af-stroke) solid var(--af-danger)'
    },
    success: {
      background: 'transparent',
      color: 'var(--af-success)',
      border: 'var(--af-stroke) solid var(--af-success)'
    }
  };
  const disabledStyle = disabled ? {
    background: 'var(--af-border-inactive)',
    color: 'var(--af-text-faint)',
    boxShadow: 'none',
    border: 'none',
    filter: 'saturate(0.4)'
  } : {};
  return /*#__PURE__*/React.createElement("button", _extends({
    style: {
      ...base,
      ...(variants[variant] || variants.primary),
      ...disabledStyle,
      ...style
    },
    disabled: disabled,
    onMouseDown: e => {
      if (!disabled) e.currentTarget.style.transform = 'scale(0.97)';
    },
    onMouseUp: e => {
      e.currentTarget.style.transform = 'scale(1)';
    },
    onMouseLeave: e => {
      e.currentTarget.style.transform = 'scale(1)';
    }
  }, rest), icon && /*#__PURE__*/React.createElement("span", {
    className: "material-symbols-rounded",
    style: {
      fontSize: s.iconSize,
      lineHeight: 1
    }
  }, icon), children);
}
Object.assign(__ds_scope, { Button });
})(); } catch (e) { __ds_ns.__errors.push({ path: "components/core/Button.jsx", error: String((e && e.message) || e) }); }

// components/core/GlassModal.jsx
try { (() => {
/**
 * Frosted-glass modal â€” dark blur fill, colored 1.5px border + glow, 24px
 * radius. The shell for GAME OVER / MISSION COMPLETE / SYSTEM PAUSED and the
 * hangar/settings sheets. Renders an optional scrim behind.
 */
function GlassModal({
  children,
  accent = 'var(--af-cyan-mid)',
  glow = false,
  width = 360,
  scrim = true,
  onScrimClick = null,
  style = {}
}) {
  const panel = /*#__PURE__*/React.createElement("div", {
    style: {
      width,
      maxWidth: '90vw',
      background: 'var(--af-glass-fill)',
      backdropFilter: 'var(--af-blur-glass)',
      WebkitBackdropFilter: 'var(--af-blur-glass)',
      border: `var(--af-stroke) solid ${withAlpha(accent, 0.4)}`,
      borderRadius: 'var(--af-radius-2xl)',
      padding: 'var(--af-space-7)',
      boxShadow: glow ? `var(--af-shadow-modal), 0 0 30px ${withAlpha(accent, 0.4)}` : 'var(--af-shadow-modal)',
      color: 'var(--af-text)',
      ...style
    }
  }, children);
  if (!scrim) return panel;
  return /*#__PURE__*/React.createElement("div", {
    onClick: e => {
      if (e.target === e.currentTarget && onScrimClick) onScrimClick();
    },
    style: {
      position: 'absolute',
      inset: 0,
      display: 'flex',
      alignItems: 'center',
      justifyContent: 'center',
      background: 'rgba(0,5,15,0.55)',
      padding: 20
    }
  }, panel);
}
function withAlpha(c, a) {
  if (typeof c !== 'string' || !c.startsWith('#') || c.length !== 7) {
    return `color-mix(in srgb, ${c} ${a * 100}%, transparent)`;
  }
  const r = parseInt(c.slice(1, 3), 16),
    g = parseInt(c.slice(3, 5), 16),
    b = parseInt(c.slice(5, 7), 16);
  return `rgba(${r},${g},${b},${a})`;
}
Object.assign(__ds_scope, { GlassModal });
})(); } catch (e) { __ds_ns.__errors.push({ path: "components/core/GlassModal.jsx", error: String((e && e.message) || e) }); }

// components/core/IconButton.jsx
try { (() => {
function _extends() { return _extends = Object.assign ? Object.assign.bind() : function (n) { for (var e = 1; e < arguments.length; e++) { var t = arguments[e]; for (var r in t) ({}).hasOwnProperty.call(t, r) && (n[r] = t[r]); } return n; }, _extends.apply(null, arguments); }
/**
 * Circular/rounded icon-only control. Used for pause, wifi, top-bar actions.
 * Cyan glyph on dark; `active` flips to the orange selected treatment.
 */
function IconButton({
  icon,
  label,
  active = false,
  size = 44,
  color = 'var(--af-cyan)',
  shape = 'circle',
  style = {},
  ...rest
}) {
  return /*#__PURE__*/React.createElement("button", _extends({
    "aria-label": label,
    style: {
      width: size,
      height: size,
      flex: '0 0 auto',
      display: 'inline-flex',
      alignItems: 'center',
      justifyContent: 'center',
      borderRadius: shape === 'circle' ? '999px' : 'var(--af-radius-md)',
      background: active ? 'var(--af-grad-action)' : 'rgba(5,16,32,0.6)',
      border: active ? 'none' : `1.5px solid ${active ? 'transparent' : 'var(--af-border)'}`,
      color: active ? 'var(--af-on-action)' : color,
      boxShadow: active ? 'var(--af-glow-orange)' : 'none',
      cursor: 'pointer',
      transition: 'transform var(--af-dur-fast) var(--af-ease)',
      ...style
    },
    onMouseDown: e => {
      e.currentTarget.style.transform = 'scale(0.92)';
    },
    onMouseUp: e => {
      e.currentTarget.style.transform = 'scale(1)';
    },
    onMouseLeave: e => {
      e.currentTarget.style.transform = 'scale(1)';
    }
  }, rest), /*#__PURE__*/React.createElement("span", {
    className: "material-symbols-rounded",
    style: {
      fontSize: Math.round(size * 0.5),
      lineHeight: 1
    }
  }, icon));
}
Object.assign(__ds_scope, { IconButton });
})(); } catch (e) { __ds_ns.__errors.push({ path: "components/core/IconButton.jsx", error: String((e && e.message) || e) }); }

// components/core/JetChip.jsx
try { (() => {
/**
 * Hangar jet-selector chip â€” a glowing skin-color dot in a rounded tile.
 * Highlighted (being viewed) gets a 2px cyan border + tint; equipped shows a
 * green check. Mirrors the configurator's horizontal skin list.
 */
function JetChip({
  color = 'var(--af-skin-cobalt)',
  highlighted = false,
  equipped = false,
  onClick = () => {},
  style = {}
}) {
  return /*#__PURE__*/React.createElement("button", {
    onClick: onClick,
    style: {
      width: 60,
      height: 64,
      flex: '0 0 auto',
      cursor: 'pointer',
      position: 'relative',
      borderRadius: 'var(--af-radius-md)',
      background: highlighted ? 'rgba(0,170,255,0.10)' : 'rgba(0,0,0,0.25)',
      border: highlighted ? '2px solid var(--af-cyan)' : `1.2px solid ${equipped ? 'rgba(0,170,255,0.5)' : 'var(--af-border-inactive)'}`,
      display: 'flex',
      alignItems: 'center',
      justifyContent: 'center',
      transition: 'all var(--af-dur) var(--af-ease)',
      ...style
    }
  }, /*#__PURE__*/React.createElement("span", {
    style: {
      width: 24,
      height: 24,
      borderRadius: '999px',
      background: color,
      boxShadow: `0 0 8px 1px ${color}`
    }
  }), equipped && /*#__PURE__*/React.createElement("span", {
    className: "material-symbols-rounded",
    style: {
      position: 'absolute',
      top: 2,
      right: 2,
      fontSize: 13,
      color: 'var(--af-success)'
    }
  }, "check_circle"));
}
Object.assign(__ds_scope, { JetChip });
})(); } catch (e) { __ds_ns.__errors.push({ path: "components/core/JetChip.jsx", error: String((e && e.message) || e) }); }

// components/core/NavBar.jsx
try { (() => {
/**
 * Bottom tab bar â€” the floating glass nav (HOME / HANGAR / SHOP / PILOT).
 * Selected item gets the orange filled tile + glow; others are cyan glyph+label.
 */
function NavBar({
  items = [],
  value = 0,
  onChange = () => {},
  style = {}
}) {
  return /*#__PURE__*/React.createElement("nav", {
    style: {
      display: 'flex',
      justifyContent: 'space-evenly',
      alignItems: 'center',
      height: 75,
      padding: '0 8px',
      background: 'rgba(5,16,32,0.95)',
      border: 'var(--af-stroke) solid var(--af-border)',
      borderRadius: 'var(--af-radius-xl)',
      boxShadow: 'var(--af-shadow-panel)',
      ...style
    }
  }, items.map((it, i) => {
    const selected = i === value;
    return /*#__PURE__*/React.createElement("button", {
      key: it.label,
      onClick: () => onChange(i),
      style: {
        width: 65,
        height: 60,
        border: 'none',
        cursor: 'pointer',
        display: 'flex',
        flexDirection: 'column',
        alignItems: 'center',
        justifyContent: 'center',
        gap: 4,
        borderRadius: 'var(--af-radius-lg)',
        background: selected ? 'var(--af-orange)' : 'transparent',
        boxShadow: selected ? 'var(--af-glow-orange-soft)' : 'none',
        color: selected ? '#000000' : 'var(--af-cyan-mid)',
        transition: 'background var(--af-dur) var(--af-ease)'
      }
    }, /*#__PURE__*/React.createElement("span", {
      className: "material-symbols-rounded",
      style: {
        fontSize: 24,
        lineHeight: 1
      }
    }, it.icon), /*#__PURE__*/React.createElement("span", {
      style: {
        fontFamily: 'var(--af-font-ui)',
        fontSize: 9,
        fontWeight: 700,
        letterSpacing: 'var(--af-track-normal)'
      }
    }, it.label));
  }));
}
Object.assign(__ds_scope, { NavBar });
})(); } catch (e) { __ds_ns.__errors.push({ path: "components/core/NavBar.jsx", error: String((e && e.message) || e) }); }

// components/core/Panel.jsx
try { (() => {
function _extends() { return _extends = Object.assign ? Object.assign.bind() : function (n) { for (var e = 1; e < arguments.length; e++) { var t = arguments[e]; for (var r in t) ({}).hasOwnProperty.call(t, r) && (n[r] = t[r]); } return n; }, _extends.apply(null, arguments); }
/**
 * Translucent navy cockpit panel â€” the base surface for status readouts,
 * cards, and config sections. Thin cyan-tinted border, optional glow.
 */
function Panel({
  children,
  accent = null,
  // optional accent color string for border + glow
  glow = false,
  padding = 'var(--af-space-7)',
  radius = 'var(--af-radius-md)',
  style = {},
  ...rest
}) {
  const borderColor = accent || 'var(--af-border)';
  return /*#__PURE__*/React.createElement("div", _extends({
    style: {
      background: 'rgba(5,16,32,0.85)',
      border: `var(--af-stroke) solid ${borderColor}`,
      borderRadius: radius,
      padding,
      boxShadow: glow && accent ? `0 0 16px ${hexA(accent, 0.4)}` : 'var(--af-shadow-panel)',
      color: 'var(--af-text)',
      ...style
    }
  }, rest), children);
}
function hexA(c, a) {
  // Accept rgba/var passthrough; only convert #rrggbb
  if (typeof c !== 'string' || !c.startsWith('#') || c.length !== 7) return c;
  const r = parseInt(c.slice(1, 3), 16);
  const g = parseInt(c.slice(3, 5), 16);
  const b = parseInt(c.slice(5, 7), 16);
  return `rgba(${r},${g},${b},${a})`;
}
Object.assign(__ds_scope, { Panel });
})(); } catch (e) { __ds_ns.__errors.push({ path: "components/core/Panel.jsx", error: String((e && e.message) || e) }); }

// components/core/PowerUpBadge.jsx
try { (() => {
/** Power-up metadata â€” order matches the game's sprite strip (frame index). */
const POWERUPS = [{
  key: 'weaponUp',
  label: 'WEAPON UP',
  color: '#FF8800'
}, {
  key: 'rapidFire',
  label: 'RAPID FIRE',
  color: '#FFFF33'
}, {
  key: 'missiles',
  label: 'MISSILES',
  color: '#FF3333'
}, {
  key: 'repair',
  label: 'SYSTEM REPAIRED',
  color: '#33FF33'
}, {
  key: 'extraLife',
  label: 'EXTRA LIFE',
  color: '#FFFFFF'
}, {
  key: 'armor',
  label: 'ARMOR',
  color: '#3388FF'
}, {
  key: 'nuke',
  label: 'TACTICAL NUKE',
  color: '#CC33FF'
}, {
  key: 'scoreStar',
  label: 'SCORE STAR',
  color: '#FFD700'
}];

/**
 * Glowing power-up badge â€” one frame of the 8-frame sprite strip inside a
 * pulsing colored ring. Pass the strip path via `src`.
 */
function PowerUpBadge({
  type = 0,
  src = 'assets/sprites/powerups_strip_128.png',
  size = 56,
  ring = true,
  style = {}
}) {
  const idx = typeof type === 'string' ? POWERUPS.findIndex(p => p.key === type) : type;
  const meta = POWERUPS[idx] || POWERUPS[0];
  return /*#__PURE__*/React.createElement("div", {
    style: {
      width: size,
      height: size,
      borderRadius: '999px',
      position: 'relative',
      display: 'inline-flex',
      alignItems: 'center',
      justifyContent: 'center',
      background: ring ? `radial-gradient(circle, ${rgba(meta.color, 0.28)} 0%, ${rgba(meta.color, 0.05)} 70%, transparent 100%)` : 'transparent',
      border: ring ? `1.5px solid ${rgba(meta.color, 0.6)}` : 'none',
      boxShadow: ring ? `0 0 14px ${rgba(meta.color, 0.5)}` : 'none',
      ...style
    }
  }, /*#__PURE__*/React.createElement("span", {
    style: {
      width: '74%',
      height: '74%',
      backgroundImage: `url(${src})`,
      backgroundSize: `${800}% 100%`,
      backgroundPosition: `${idx / 7 * 100}% 0`,
      backgroundRepeat: 'no-repeat',
      imageRendering: 'auto'
    }
  }));
}
function rgba(c, a) {
  if (typeof c !== 'string' || !c.startsWith('#') || c.length !== 7) return c;
  const r = parseInt(c.slice(1, 3), 16),
    g = parseInt(c.slice(3, 5), 16),
    b = parseInt(c.slice(5, 7), 16);
  return `rgba(${r},${g},${b},${a})`;
}
Object.assign(__ds_scope, { POWERUPS, PowerUpBadge });
})(); } catch (e) { __ds_ns.__errors.push({ path: "components/core/PowerUpBadge.jsx", error: String((e && e.message) || e) }); }

// components/core/ProgressBar.jsx
try { (() => {
/**
 * Thin HUD progress / timer track. Used for kill-progress and power-up timers.
 * Optional glow on the fill.
 */
function ProgressBar({
  value = 0.5,
  color = 'var(--af-orange)',
  height = 'var(--af-bar-thin)',
  glow = true,
  track = 'rgba(0,0,0,0.45)',
  style = {}
}) {
  const pct = Math.max(0, Math.min(1, value)) * 100;
  return /*#__PURE__*/React.createElement("div", {
    style: {
      height,
      borderRadius: 'var(--af-radius-sm)',
      background: track,
      overflow: 'hidden',
      ...style
    }
  }, /*#__PURE__*/React.createElement("div", {
    style: {
      width: `${pct}%`,
      height: '100%',
      background: color,
      borderRadius: 'var(--af-radius-sm)',
      boxShadow: glow ? `0 0 8px ${color}` : 'none',
      transition: 'width var(--af-dur) linear'
    }
  }));
}
Object.assign(__ds_scope, { ProgressBar });
})(); } catch (e) { __ds_ns.__errors.push({ path: "components/core/ProgressBar.jsx", error: String((e && e.message) || e) }); }

// components/core/SegmentedControl.jsx
try { (() => {
/**
 * Segmented selector â€” the difficulty scale (EASY / NORMAL / HARD). Selected
 * option tints with the active color at low opacity + a colored border.
 */
function SegmentedControl({
  options = [],
  value = 0,
  onChange = () => {},
  activeColor = 'var(--af-blue)',
  style = {}
}) {
  return /*#__PURE__*/React.createElement("div", {
    style: {
      display: 'flex',
      gap: 8,
      ...style
    }
  }, options.map((opt, i) => {
    const selected = i === value;
    const col = typeof opt === 'object' && opt.color || activeColor;
    const label = typeof opt === 'object' ? opt.label : opt;
    return /*#__PURE__*/React.createElement("button", {
      key: label,
      onClick: () => onChange(i),
      style: {
        flex: 1,
        padding: '10px 8px',
        cursor: 'pointer',
        borderRadius: 'var(--af-radius-sm)',
        background: selected ? colorMix(col, 0.2) : 'rgba(0,0,0,0.22)',
        border: `1.5px solid ${selected ? col : 'var(--af-border-quiet)'}`,
        color: selected ? 'var(--af-text)' : 'var(--af-text-muted)',
        fontFamily: 'var(--af-font-ui)',
        fontSize: 11,
        fontWeight: 700,
        letterSpacing: 'var(--af-track-normal)',
        textTransform: 'uppercase',
        transition: 'all var(--af-dur) var(--af-ease)'
      }
    }, label);
  }));
}
function colorMix(c, a) {
  if (typeof c === 'string' && c.startsWith('#') && c.length === 7) {
    const r = parseInt(c.slice(1, 3), 16),
      g = parseInt(c.slice(3, 5), 16),
      b = parseInt(c.slice(5, 7), 16);
    return `rgba(${r},${g},${b},${a})`;
  }
  return `color-mix(in srgb, ${c} ${a * 100}%, transparent)`;
}
Object.assign(__ds_scope, { SegmentedControl });
})(); } catch (e) { __ds_ns.__errors.push({ path: "components/core/SegmentedControl.jsx", error: String((e && e.message) || e) }); }

// components/core/StatBar.jsx
try { (() => {
/**
 * Labeled stat bar â€” ENGINE SPEED / HULL INTEGRITY / FIREPOWER style.
 * Uppercase label left, percentage right (in bar color), thin filled track.
 */
function StatBar({
  label,
  value = 0.6,
  color = 'var(--af-cyan)',
  style = {}
}) {
  const pct = Math.round(value * 100);
  return /*#__PURE__*/React.createElement("div", {
    style: {
      ...style
    }
  }, /*#__PURE__*/React.createElement("div", {
    style: {
      display: 'flex',
      justifyContent: 'space-between',
      alignItems: 'baseline',
      marginBottom: 4
    }
  }, /*#__PURE__*/React.createElement("span", {
    style: {
      color: 'var(--af-text-muted)',
      fontFamily: 'var(--af-font-ui)',
      fontSize: 10,
      letterSpacing: 'var(--af-track-normal)',
      textTransform: 'uppercase',
      fontWeight: 600
    }
  }, label), /*#__PURE__*/React.createElement("span", {
    style: {
      color,
      fontFamily: 'var(--af-font-mono)',
      fontSize: 11,
      fontWeight: 700
    }
  }, pct, "%")), /*#__PURE__*/React.createElement("div", {
    style: {
      height: 'var(--af-bar)',
      borderRadius: 'var(--af-radius-sm)',
      background: 'rgba(255,255,255,0.10)',
      overflow: 'hidden'
    }
  }, /*#__PURE__*/React.createElement("div", {
    style: {
      width: `${pct}%`,
      height: '100%',
      background: color,
      borderRadius: 'var(--af-radius-sm)',
      boxShadow: `0 0 8px ${color}`,
      transition: 'width var(--af-dur) var(--af-ease)'
    }
  })));
}
Object.assign(__ds_scope, { StatBar });
})(); } catch (e) { __ds_ns.__errors.push({ path: "components/core/StatBar.jsx", error: String((e && e.message) || e) }); }

// components/core/Toggle.jsx
try { (() => {
/**
 * Settings switch â€” cyan when on, dark track when off. Matches the Flutter
 * Switch used for SOUND FX / MUSIC TRACK.
 */
function Toggle({
  checked = false,
  onChange = () => {},
  color = 'var(--af-cyan)',
  style = {}
}) {
  return /*#__PURE__*/React.createElement("button", {
    role: "switch",
    "aria-checked": checked,
    onClick: () => onChange(!checked),
    style: {
      width: 50,
      height: 28,
      borderRadius: '999px',
      border: 'none',
      cursor: 'pointer',
      padding: 3,
      display: 'inline-flex',
      alignItems: 'center',
      background: checked ? color : 'var(--af-border-inactive)',
      boxShadow: checked ? `0 0 10px ${color}` : 'none',
      transition: 'background var(--af-dur) var(--af-ease)',
      ...style
    }
  }, /*#__PURE__*/React.createElement("span", {
    style: {
      width: 22,
      height: 22,
      borderRadius: '999px',
      background: checked ? 'var(--af-bg)' : 'rgba(255,255,255,0.5)',
      transform: checked ? 'translateX(22px)' : 'translateX(0)',
      transition: 'transform var(--af-dur) var(--af-ease)'
    }
  }));
}
Object.assign(__ds_scope, { Toggle });
})(); } catch (e) { __ds_ns.__errors.push({ path: "components/core/Toggle.jsx", error: String((e && e.message) || e) }); }

// components/core/WorldChip.jsx
try { (() => {
/** Campaign sectors â€” id, name, and accent token. Sky/level live in the app. */
const WORLDS = [{
  id: 1,
  name: 'DAWN SECTOR',
  accent: 'var(--af-world-dawn)'
}, {
  id: 2,
  name: 'MIDDAY FRONT',
  accent: 'var(--af-world-midday)'
}, {
  id: 3,
  name: 'DUSK ZONE',
  accent: 'var(--af-world-dusk)'
}, {
  id: 4,
  name: 'NIGHT OPS',
  accent: 'var(--af-world-night)'
}];

/**
 * Campaign sector selector chip â€” a glowing accent dot, the sector code (W1)
 * and name. Selected gets the accent border + tint + glow; locked dims with a
 * lock glyph. Lay several in a horizontal scroll strip (same vocabulary as the
 * hangar jet list).
 */
function WorldChip({
  id = 1,
  name = 'DAWN SECTOR',
  accent = 'var(--af-world-dawn)',
  selected = false,
  locked = false,
  onClick = () => {},
  style = {}
}) {
  return /*#__PURE__*/React.createElement("button", {
    onClick: locked ? undefined : onClick,
    disabled: locked,
    style: {
      display: 'flex',
      alignItems: 'center',
      gap: 10,
      flex: '0 0 auto',
      padding: '8px 14px',
      cursor: locked ? 'not-allowed' : 'pointer',
      whiteSpace: 'nowrap',
      borderRadius: 'var(--af-radius-md)',
      background: selected ? withAlpha(accent, 0.16) : 'rgba(0,0,0,0.25)',
      border: selected ? `2px solid ${accent}` : '1.2px solid var(--af-border-inactive)',
      boxShadow: selected ? `0 0 14px ${withAlpha(accent, 0.5)}` : 'none',
      opacity: locked ? 0.45 : 1,
      transition: 'all var(--af-dur) var(--af-ease)',
      ...style
    }
  }, locked ? /*#__PURE__*/React.createElement("span", {
    className: "material-symbols-rounded",
    style: {
      fontSize: 16,
      color: 'var(--af-text-muted)'
    }
  }, "lock") : /*#__PURE__*/React.createElement("span", {
    style: {
      width: 12,
      height: 12,
      borderRadius: '999px',
      background: accent,
      boxShadow: `0 0 8px ${accent}`,
      flex: '0 0 auto'
    }
  }), /*#__PURE__*/React.createElement("div", {
    style: {
      textAlign: 'left'
    }
  }, /*#__PURE__*/React.createElement("div", {
    style: {
      fontFamily: 'var(--af-font-mono)',
      fontSize: 9,
      letterSpacing: '1px',
      color: 'var(--af-text-muted)',
      lineHeight: 1.1
    }
  }, "W", id), /*#__PURE__*/React.createElement("div", {
    style: {
      fontFamily: 'var(--af-font-ui)',
      fontSize: 11,
      fontWeight: 700,
      letterSpacing: 'var(--af-track-normal)',
      color: selected ? 'var(--af-text)' : 'var(--af-text-muted)',
      lineHeight: 1.2
    }
  }, name)));
}
function withAlpha(c, a) {
  if (typeof c !== 'string' || !c.startsWith('#') || c.length !== 7) {
    return `color-mix(in srgb, ${c} ${a * 100}%, transparent)`;
  }
  const r = parseInt(c.slice(1, 3), 16),
    g = parseInt(c.slice(3, 5), 16),
    b = parseInt(c.slice(5, 7), 16);
  return `rgba(${r},${g},${b},${a})`;
}
Object.assign(__ds_scope, { WORLDS, WorldChip });
})(); } catch (e) { __ds_ns.__errors.push({ path: "components/core/WorldChip.jsx", error: String((e && e.message) || e) }); }

// ui_kits/aerofighter-app/App.jsx
try { (() => {
// AeroFighter app â€” orchestrator. Menu (4 tabs + sector select) â†’ Scramble â†’ Gameplay â†’ Game Over.
const AF_WORLDS = (window.AeroFighterDesignSystem_9520d9 || {}).WORLDS || [{
  id: 1,
  name: 'DAWN SECTOR',
  accent: 'var(--af-world-dawn)'
}, {
  id: 2,
  name: 'MIDDAY FRONT',
  accent: 'var(--af-world-midday)'
}, {
  id: 3,
  name: 'DUSK ZONE',
  accent: 'var(--af-world-dusk)'
}, {
  id: 4,
  name: 'NIGHT OPS',
  accent: 'var(--af-world-night)'
}];
function App() {
  const {
    NavBar
  } = window.AeroFighterDesignSystem_9520d9;
  const WORLDS = AF_WORLDS;
  const WORLD_BG = ['bg_morning', 'bg_midday', 'bg_afternoon', 'bg_night'];
  const WORLD_LEVEL = ['1-1', '2-1', '3-1', '4-1'];
  const [mode, setMode] = React.useState('menu'); // menu | playing | paused | gameover
  const [tab, setTab] = React.useState(0);
  const [worldIdx, setWorldIdx] = React.useState(1);
  const [score, setScore] = React.useState(0);
  const [lives, setLives] = React.useState(3);
  const [shake, setShake] = React.useState(false);
  const world = {
    ...WORLDS[worldIdx],
    bg: WORLD_BG[worldIdx],
    level: WORLD_LEVEL[worldIdx]
  };
  const startRun = () => {
    setScore(0);
    setLives(3);
    setMode('playing');
  };
  const addScore = () => setScore(s => s + 250);
  const takeHit = () => {
    setShake(true);
    setTimeout(() => setShake(false), 360);
    setLives(l => {
      const nl = l - 1;
      if (nl <= 0) {
        setMode('gameover');
        return 0;
      }
      return nl;
    });
  };
  const tabContent = [/*#__PURE__*/React.createElement(HomeScreen, {
    onScramble: startRun,
    worldIndex: worldIdx,
    onSelectWorld: setWorldIdx
  }), /*#__PURE__*/React.createElement(HangarScreen, null), /*#__PURE__*/React.createElement(ShopScreen, null), /*#__PURE__*/React.createElement(PilotScreen, null)][tab];
  const inGame = mode === 'playing' || mode === 'paused' || mode === 'gameover';
  return /*#__PURE__*/React.createElement("div", {
    className: 'device' + (shake ? ' shaking' : '')
  }, /*#__PURE__*/React.createElement("div", {
    className: "sky",
    style: {
      backgroundImage: `url(../../assets/backgrounds/${inGame ? world.bg : 'bg_midday'}.png)`
    }
  }), /*#__PURE__*/React.createElement("div", {
    className: "sky-veil",
    style: {
      opacity: inGame ? 0 : 1
    }
  }), inGame ? /*#__PURE__*/React.createElement(React.Fragment, null, /*#__PURE__*/React.createElement(GameplayHUD, {
    world: world,
    score: score,
    lives: lives,
    onScore: mode === 'playing' ? addScore : undefined,
    onHit: mode === 'playing' ? takeHit : undefined,
    onPause: () => setMode('paused')
  }), mode === 'paused' && /*#__PURE__*/React.createElement(PausedModal, {
    onResume: () => setMode('playing'),
    onAbort: () => setMode('menu')
  }), mode === 'gameover' && /*#__PURE__*/React.createElement(GameOverModal, {
    score: score,
    best: 112400,
    onRelaunch: startRun,
    onAbort: () => setMode('menu')
  })) : /*#__PURE__*/React.createElement("div", {
    style: {
      position: 'absolute',
      inset: 0,
      display: 'flex',
      flexDirection: 'column'
    }
  }, /*#__PURE__*/React.createElement(TopBar, null), /*#__PURE__*/React.createElement("div", {
    style: {
      flex: 1,
      minHeight: 0,
      position: 'relative'
    }
  }, tabContent), /*#__PURE__*/React.createElement("div", {
    style: {
      padding: '0 16px 16px'
    }
  }, /*#__PURE__*/React.createElement(NavBar, {
    value: tab,
    onChange: setTab,
    items: [{
      icon: 'home',
      label: 'HOME'
    }, {
      icon: 'flight',
      label: 'HANGAR'
    }, {
      icon: 'shopping_cart',
      label: 'SHOP'
    }, {
      icon: 'person',
      label: 'PILOT'
    }]
  }))));
}
window.App = App;
})(); } catch (e) { __ds_ns.__errors.push({ path: "ui_kits/aerofighter-app/App.jsx", error: String((e && e.message) || e) }); }

// ui_kits/aerofighter-app/GameplayHUD.jsx
try { (() => {
// AeroFighter app â€” gameplay HUD over the scrolling sky.
// Tap the field to score (floating +pts); TAKE HIT damages you toward GAME OVER.
function GameplayHUD({
  world,
  score = 48250,
  lives = 3,
  onScore,
  onHit,
  onPause
}) {
  const {
    ProgressBar,
    PowerUpBadge
  } = window.AeroFighterDesignSystem_9520d9;
  const STRIP = '../../assets/sprites/powerups_strip_128.png';
  const pad = n => n.toString().padStart(6, '0');
  const [floats, setFloats] = React.useState([]);
  const [combo, setCombo] = React.useState(0);
  const comboTimer = React.useRef(null);
  const accent = world && world.accent || 'var(--af-world-midday)';
  const bg = world && world.bg || 'bg_midday';
  const level = world && world.level || '2-3';
  const spawnFloat = e => {
    const host = e.currentTarget.getBoundingClientRect();
    const x = (e.clientX - host.left) / host.width * 100;
    const y = (e.clientY - host.top) / host.height * 100;
    const id = Math.random().toString(36).slice(2);
    setFloats(f => [...f, {
      id,
      x,
      y,
      text: '+250'
    }]);
    setTimeout(() => setFloats(f => f.filter(it => it.id !== id)), 850);
    setCombo(c => c + 1);
    clearTimeout(comboTimer.current);
    comboTimer.current = setTimeout(() => setCombo(0), 1400);
    onScore && onScore();
  };
  return /*#__PURE__*/React.createElement("div", {
    onClick: spawnFloat,
    style: {
      position: 'absolute',
      inset: 0,
      overflow: 'hidden',
      cursor: 'crosshair',
      backgroundImage: `url(../../assets/backgrounds/${bg}.png)`,
      backgroundSize: 'cover',
      backgroundPosition: 'center'
    }
  }, /*#__PURE__*/React.createElement("div", {
    style: {
      position: 'absolute',
      inset: 0,
      background: 'var(--af-grad-hud-vignette)',
      pointerEvents: 'none'
    }
  }), /*#__PURE__*/React.createElement("div", {
    className: "hud-scanlines",
    style: {
      position: 'absolute',
      inset: 0,
      pointerEvents: 'none'
    }
  }), /*#__PURE__*/React.createElement("div", {
    style: {
      position: 'absolute',
      top: 0,
      left: 0,
      right: 0,
      height: 3,
      background: accent,
      boxShadow: `0 0 12px ${accent}`,
      opacity: 0.8,
      pointerEvents: 'none'
    }
  }), /*#__PURE__*/React.createElement("div", {
    style: {
      position: 'absolute',
      top: 14,
      left: 16,
      right: 16,
      display: 'flex',
      justifyContent: 'space-between',
      alignItems: 'flex-start',
      pointerEvents: 'none'
    }
  }, /*#__PURE__*/React.createElement("div", null, /*#__PURE__*/React.createElement("div", {
    style: {
      fontFamily: 'var(--af-font-mono)',
      fontSize: 18,
      color: 'var(--af-blue-soft)',
      letterSpacing: '1px',
      textShadow: 'var(--af-text-shadow-hud)'
    }
  }, "SCORE: ", pad(score)), /*#__PURE__*/React.createElement("div", {
    style: {
      marginTop: 6,
      display: 'flex',
      alignItems: 'center',
      gap: 4
    }
  }, Array.from({
    length: lives
  }).map((_, i) => /*#__PURE__*/React.createElement("span", {
    key: i,
    className: "material-symbols-rounded",
    style: {
      color: 'var(--af-danger)',
      fontSize: 18,
      textShadow: 'var(--af-text-shadow-hud)'
    }
  }, "favorite")))), /*#__PURE__*/React.createElement("div", {
    style: {
      textAlign: 'right'
    }
  }, /*#__PURE__*/React.createElement("button", {
    onClick: e => {
      e.stopPropagation();
      onPause && onPause();
    },
    style: {
      width: 44,
      height: 44,
      borderRadius: 'var(--af-radius-md)',
      cursor: 'pointer',
      pointerEvents: 'auto',
      background: 'rgba(0,5,15,0.5)',
      border: '1.5px solid rgba(0,238,255,0.5)',
      color: 'var(--af-cyan)',
      display: 'inline-flex',
      alignItems: 'center',
      justifyContent: 'center'
    }
  }, /*#__PURE__*/React.createElement("span", {
    className: "material-symbols-rounded",
    style: {
      fontSize: 24
    }
  }, "pause")), /*#__PURE__*/React.createElement("div", {
    style: {
      marginTop: 8,
      fontFamily: 'var(--af-font-mono)',
      fontSize: 12,
      color: accent,
      letterSpacing: '1px',
      textShadow: 'var(--af-text-shadow-hud)'
    }
  }, "LVL ", level))), combo >= 2 && /*#__PURE__*/React.createElement("div", {
    key: combo,
    style: {
      position: 'absolute',
      top: 96,
      left: 0,
      right: 0,
      textAlign: 'center',
      pointerEvents: 'none'
    }
  }, /*#__PURE__*/React.createElement("span", {
    className: "af-combo-pop",
    style: {
      display: 'inline-block',
      fontFamily: 'var(--af-font-display)',
      fontWeight: 700,
      fontStyle: 'italic',
      fontSize: 22,
      color: 'var(--af-orange)',
      letterSpacing: '2px',
      textShadow: 'var(--af-text-glow-orange)'
    }
  }, "x", combo, " COMBO")), floats.map(f => /*#__PURE__*/React.createElement("span", {
    key: f.id,
    className: "af-float",
    style: {
      position: 'absolute',
      left: `${f.x}%`,
      top: `${f.y}%`,
      transform: 'translate(-50%,-50%)',
      fontFamily: 'var(--af-font-mono)',
      fontSize: 18,
      fontWeight: 700,
      color: 'var(--af-gold)',
      textShadow: '0 0 10px rgba(255,215,0,0.8)',
      pointerEvents: 'none'
    }
  }, f.text)), /*#__PURE__*/React.createElement("img", {
    src: "../../assets/sprites/jet_2_level.png",
    alt: "",
    style: {
      position: 'absolute',
      bottom: 150,
      left: '50%',
      width: 96,
      transform: 'translateX(-50%)',
      filter: 'drop-shadow(0 0 12px rgba(0,170,255,0.6))',
      pointerEvents: 'none'
    }
  }), /*#__PURE__*/React.createElement("button", {
    onClick: e => {
      e.stopPropagation();
      onHit && onHit();
    },
    style: {
      position: 'absolute',
      bottom: 122,
      left: '50%',
      transform: 'translateX(-50%)',
      pointerEvents: 'auto',
      padding: '6px 14px',
      borderRadius: 'var(--af-radius-pill)',
      cursor: 'pointer',
      background: 'rgba(40,0,8,0.6)',
      border: '1.5px solid var(--af-danger)',
      color: 'var(--af-danger)',
      fontFamily: 'var(--af-font-ui)',
      fontSize: 9,
      fontWeight: 700,
      letterSpacing: '2px',
      textTransform: 'uppercase'
    }
  }, "Simulate Hit"), /*#__PURE__*/React.createElement("div", {
    style: {
      position: 'absolute',
      bottom: 64,
      left: 16,
      right: 16,
      display: 'flex',
      gap: 14,
      justifyContent: 'center',
      pointerEvents: 'none'
    }
  }, ['rapidFire', 'armor', 'missiles'].map((t, i) => /*#__PURE__*/React.createElement("span", {
    key: t,
    className: "af-pulse",
    style: {
      animationDelay: `${i * 0.4}s`
    }
  }, /*#__PURE__*/React.createElement(PowerUpBadge, {
    type: t,
    src: STRIP,
    size: 44
  })))), /*#__PURE__*/React.createElement("div", {
    style: {
      position: 'absolute',
      bottom: 26,
      left: 16,
      right: 16,
      pointerEvents: 'none'
    }
  }, /*#__PURE__*/React.createElement("div", {
    style: {
      display: 'flex',
      justifyContent: 'space-between',
      marginBottom: 5
    }
  }, /*#__PURE__*/React.createElement("span", {
    style: {
      fontFamily: 'var(--af-font-ui)',
      fontSize: 9,
      letterSpacing: '1px',
      color: 'var(--af-text-dim)',
      textShadow: 'var(--af-text-shadow-hud)'
    }
  }, "SECTOR CLEAR"), /*#__PURE__*/React.createElement("span", {
    style: {
      fontFamily: 'var(--af-font-mono)',
      fontSize: 9,
      color: 'var(--af-text-dim)',
      textShadow: 'var(--af-text-shadow-hud)'
    }
  }, "18 / 25")), /*#__PURE__*/React.createElement(ProgressBar, {
    value: 18 / 25,
    color: accent
  })));
}
window.GameplayHUD = GameplayHUD;
})(); } catch (e) { __ds_ns.__errors.push({ path: "ui_kits/aerofighter-app/GameplayHUD.jsx", error: String((e && e.message) || e) }); }

// ui_kits/aerofighter-app/HangarScreen.jsx
try { (() => {
// AeroFighter app â€” HANGAR tab. Jet configurator inside a glass sheet.
const JET_SKINS = [{
  name: 'COBALT ALPHA',
  color: 'var(--af-skin-cobalt)',
  nameColor: 'var(--af-cyan)',
  desc: 'Standard multi-role tactical interceptor. Perfectly balanced design.',
  speed: 0.6,
  armor: 0.6,
  power: 0.6
}, {
  name: 'CRIMSON PHOENIX',
  color: 'var(--af-skin-crimson)',
  nameColor: 'var(--af-skin-crimson)',
  desc: 'High-speed interceptor. Advanced engine allows rapid response.',
  speed: 0.9,
  armor: 0.4,
  power: 0.7
}, {
  name: 'SOLAR EAGLE',
  color: 'var(--af-skin-solar)',
  nameColor: 'var(--af-skin-solar)',
  desc: 'Heavy tactical fighter. Superior armor plating to absorb impacts.',
  speed: 0.4,
  armor: 0.9,
  power: 0.7
}, {
  name: 'EMERALD VIPER',
  color: 'var(--af-skin-emerald)',
  nameColor: 'var(--af-skin-emerald)',
  desc: 'Experimental design. Upgraded cooling for high fire rates.',
  speed: 0.7,
  armor: 0.5,
  power: 0.9
}];
function HangarScreen() {
  const {
    GlassModal,
    StatBar,
    JetChip,
    Button
  } = window.AeroFighterDesignSystem_9520d9;
  const [sel, setSel] = React.useState(1);
  const [equipped, setEquipped] = React.useState(0);
  const skin = JET_SKINS[sel];
  const isEquipped = sel === equipped;
  return /*#__PURE__*/React.createElement("div", {
    style: {
      height: '100%',
      display: 'flex',
      alignItems: 'center',
      justifyContent: 'center',
      padding: '0 16px'
    }
  }, /*#__PURE__*/React.createElement(GlassModal, {
    scrim: false,
    width: 340
  }, /*#__PURE__*/React.createElement("div", {
    style: {
      color: 'var(--af-cyan)',
      fontSize: 15,
      fontWeight: 700,
      letterSpacing: '2px',
      fontFamily: 'var(--af-font-display)'
    }
  }, "JET CONFIGURATOR"), /*#__PURE__*/React.createElement("div", {
    style: {
      height: 14
    }
  }), /*#__PURE__*/React.createElement("div", {
    style: {
      display: 'flex',
      gap: 12,
      overflowX: 'auto',
      paddingBottom: 2
    }
  }, JET_SKINS.map((s, i) => /*#__PURE__*/React.createElement(JetChip, {
    key: s.name,
    color: s.color,
    highlighted: i === sel,
    equipped: i === equipped,
    onClick: () => setSel(i)
  }))), /*#__PURE__*/React.createElement("div", {
    style: {
      height: 16
    }
  }), /*#__PURE__*/React.createElement("div", {
    style: {
      color: skin.nameColor,
      fontSize: 16,
      fontWeight: 700,
      letterSpacing: '2px',
      fontFamily: 'var(--af-font-display)'
    }
  }, skin.name), /*#__PURE__*/React.createElement("div", {
    style: {
      height: 6
    }
  }), /*#__PURE__*/React.createElement("div", {
    style: {
      color: 'var(--af-text-dim)',
      fontSize: 11,
      lineHeight: 1.4,
      fontFamily: 'var(--af-font-ui)'
    }
  }, skin.desc), /*#__PURE__*/React.createElement("div", {
    style: {
      height: 16
    }
  }), /*#__PURE__*/React.createElement(StatBar, {
    label: "Engine Speed",
    value: skin.speed,
    color: "var(--af-cyan)"
  }), /*#__PURE__*/React.createElement("div", {
    style: {
      height: 8
    }
  }), /*#__PURE__*/React.createElement(StatBar, {
    label: "Hull Integrity",
    value: skin.armor,
    color: "var(--af-warning)"
  }), /*#__PURE__*/React.createElement("div", {
    style: {
      height: 8
    }
  }), /*#__PURE__*/React.createElement(StatBar, {
    label: "Firepower",
    value: skin.power,
    color: "#ff4444"
  }), /*#__PURE__*/React.createElement("div", {
    style: {
      height: 20
    }
  }), /*#__PURE__*/React.createElement(Button, {
    block: true,
    variant: isEquipped ? 'primary' : 'primary',
    disabled: isEquipped,
    onClick: () => setEquipped(sel)
  }, isEquipped ? 'Equipped' : 'Equip Fighter Jet')));
}
window.HangarScreen = HangarScreen;
})(); } catch (e) { __ds_ns.__errors.push({ path: "ui_kits/aerofighter-app/HangarScreen.jsx", error: String((e && e.message) || e) }); }

// ui_kits/aerofighter-app/HomeScreen.jsx
try { (() => {
// AeroFighter app â€” HOME tab. Sector selector + reticle + SCRAMBLE launcher, status panels, action pills.
function HomeScreen({
  onScramble,
  worldIndex = 1,
  onSelectWorld = () => {}
}) {
  const NS = window.AeroFighterDesignSystem_9520d9;
  const {
    Button,
    Panel,
    ProgressBar,
    Badge
  } = NS;
  const WORLDS = NS.WORLDS || [{
    id: 1,
    name: 'DAWN SECTOR',
    accent: 'var(--af-world-dawn)'
  }, {
    id: 2,
    name: 'MIDDAY FRONT',
    accent: 'var(--af-world-midday)'
  }, {
    id: 3,
    name: 'DUSK ZONE',
    accent: 'var(--af-world-dusk)'
  }, {
    id: 4,
    name: 'NIGHT OPS',
    accent: 'var(--af-world-night)'
  }];
  const WorldChip = NS.WorldChip || function FallbackWorldChip({
    id,
    name,
    accent,
    selected,
    onClick
  }) {
    return /*#__PURE__*/React.createElement("button", {
      onClick: onClick,
      style: {
        display: 'flex',
        alignItems: 'center',
        gap: 10,
        flex: '0 0 auto',
        padding: '8px 14px',
        cursor: 'pointer',
        whiteSpace: 'nowrap',
        borderRadius: 'var(--af-radius-md)',
        background: selected ? 'rgba(0,170,255,0.16)' : 'rgba(0,0,0,0.25)',
        border: selected ? '2px solid ' + accent : '1.2px solid var(--af-border-inactive)'
      }
    }, /*#__PURE__*/React.createElement("span", {
      style: {
        width: 12,
        height: 12,
        borderRadius: '999px',
        background: accent,
        boxShadow: '0 0 8px ' + accent
      }
    }), /*#__PURE__*/React.createElement("div", {
      style: {
        textAlign: 'left'
      }
    }, /*#__PURE__*/React.createElement("div", {
      style: {
        fontFamily: 'var(--af-font-mono)',
        fontSize: 9,
        letterSpacing: '1px',
        color: 'var(--af-text-muted)'
      }
    }, "W", id), /*#__PURE__*/React.createElement("div", {
      style: {
        fontFamily: 'var(--af-font-ui)',
        fontSize: 11,
        fontWeight: 700,
        letterSpacing: '1px',
        color: selected ? 'var(--af-text)' : 'var(--af-text-muted)'
      }
    }, name)));
  };
  const world = WORLDS[worldIndex] || WORLDS[0];
  const StatusPanel = ({
    title,
    status,
    value,
    color
  }) => /*#__PURE__*/React.createElement(Panel, {
    padding: "14px 16px",
    style: {
      flex: 1
    }
  }, /*#__PURE__*/React.createElement("div", {
    style: {
      color: 'var(--af-cyan-mid)',
      fontSize: 10,
      fontWeight: 700,
      letterSpacing: '1px'
    }
  }, title), /*#__PURE__*/React.createElement("div", {
    style: {
      height: 8
    }
  }), /*#__PURE__*/React.createElement(ProgressBar, {
    value: value,
    color: color,
    glow: false
  }), /*#__PURE__*/React.createElement("div", {
    style: {
      height: 6
    }
  }), /*#__PURE__*/React.createElement("div", {
    style: {
      textAlign: 'right',
      color: 'var(--af-text)',
      fontFamily: 'var(--af-font-mono)',
      fontSize: 11,
      letterSpacing: '1px'
    }
  }, status));
  const ActionPill = ({
    icon,
    label,
    dot
  }) => /*#__PURE__*/React.createElement("div", {
    style: {
      flex: 1,
      height: 60,
      position: 'relative',
      display: 'flex',
      alignItems: 'center',
      justifyContent: 'center',
      gap: 8,
      background: 'rgba(5,16,32,0.85)',
      border: '1.5px solid var(--af-border)',
      borderRadius: 'var(--af-radius-pill)'
    }
  }, /*#__PURE__*/React.createElement("span", {
    className: "material-symbols-rounded",
    style: {
      color: 'var(--af-cyan)',
      fontSize: 20
    }
  }, icon), /*#__PURE__*/React.createElement("span", {
    style: {
      color: 'var(--af-text-dim)',
      fontSize: 11,
      fontFamily: 'var(--af-font-ui)',
      whiteSpace: 'pre-line',
      textAlign: 'center',
      lineHeight: 1.15
    }
  }, label), dot && /*#__PURE__*/React.createElement("span", {
    style: {
      position: 'absolute',
      top: 11,
      right: 16
    }
  }, /*#__PURE__*/React.createElement(Badge, {
    dot: true,
    color: "var(--af-amber)"
  })));
  return /*#__PURE__*/React.createElement("div", {
    style: {
      display: 'flex',
      flexDirection: 'column',
      height: '100%',
      padding: '0 20px 12px',
      boxSizing: 'border-box'
    }
  }, /*#__PURE__*/React.createElement("div", {
    style: {
      paddingTop: 4
    }
  }, /*#__PURE__*/React.createElement("div", {
    style: {
      color: 'var(--af-cyan-mid)',
      fontSize: 9,
      fontWeight: 700,
      letterSpacing: '2px',
      marginBottom: 8
    }
  }, "SELECT SECTOR"), /*#__PURE__*/React.createElement("div", {
    style: {
      display: 'flex',
      gap: 10,
      overflowX: 'auto',
      paddingBottom: 4,
      scrollbarWidth: 'none'
    }
  }, WORLDS.map((w, i) => /*#__PURE__*/React.createElement(WorldChip, {
    key: w.id,
    id: w.id,
    name: w.name,
    accent: w.accent,
    selected: i === worldIndex,
    onClick: () => onSelectWorld(i)
  })))), /*#__PURE__*/React.createElement("div", {
    style: {
      flex: 1,
      display: 'flex',
      alignItems: 'center',
      justifyContent: 'center'
    }
  }, /*#__PURE__*/React.createElement("div", {
    style: {
      position: 'relative',
      width: 150,
      height: 150,
      display: 'flex',
      alignItems: 'center',
      justifyContent: 'center'
    }
  }, /*#__PURE__*/React.createElement(Reticle, {
    accent: world.accent
  }), /*#__PURE__*/React.createElement("span", {
    className: "material-symbols-rounded",
    style: {
      position: 'absolute',
      color: world.accent,
      fontSize: 84,
      textShadow: `0 0 24px ${world.accent}`,
      transition: 'color var(--af-dur) var(--af-ease)'
    }
  }, "flight"))), /*#__PURE__*/React.createElement(Button, {
    block: true,
    variant: "primary",
    size: "lg",
    icon: "rocket_launch",
    onClick: onScramble
  }, "Scramble"), /*#__PURE__*/React.createElement("div", {
    style: {
      height: 20
    }
  }), /*#__PURE__*/React.createElement("div", {
    style: {
      display: 'flex',
      gap: 16
    }
  }, /*#__PURE__*/React.createElement(StatusPanel, {
    title: "FUEL SYSTEM",
    status: "85% OPTIMAL",
    value: 0.85,
    color: "var(--af-cyan)"
  }), /*#__PURE__*/React.createElement(StatusPanel, {
    title: "WEAPONS LOAD",
    status: "READY",
    value: 1.0,
    color: "var(--af-orange)"
  })), /*#__PURE__*/React.createElement("div", {
    style: {
      height: 18
    }
  }), /*#__PURE__*/React.createElement("div", {
    style: {
      display: 'flex',
      gap: 12
    }
  }, /*#__PURE__*/React.createElement(ActionPill, {
    icon: "emoji_events",
    label: 'Daily\nRewards'
  }), /*#__PURE__*/React.createElement(ActionPill, {
    icon: "mail",
    label: "Inbox"
  }), /*#__PURE__*/React.createElement(ActionPill, {
    icon: "event",
    label: "Event",
    dot: true
  })));
}

// Decorative HUD reticle ring (matches the game's _ReticlePainter), tinted per sector.
function Reticle({
  accent = '#00eeff'
}) {
  return /*#__PURE__*/React.createElement("svg", {
    width: "150",
    height: "150",
    viewBox: "0 0 150 150",
    style: {
      position: 'absolute',
      transition: 'stroke 0.2s'
    }
  }, /*#__PURE__*/React.createElement("g", {
    fill: "none",
    stroke: accent,
    strokeWidth: "2.5",
    opacity: "0.9"
  }, /*#__PURE__*/React.createElement("circle", {
    cx: "75",
    cy: "75",
    r: "66",
    strokeDasharray: "40 18",
    opacity: "0.5"
  }, /*#__PURE__*/React.createElement("animateTransform", {
    attributeName: "transform",
    type: "rotate",
    from: "0 75 75",
    to: "360 75 75",
    dur: "24s",
    repeatCount: "indefinite"
  })), /*#__PURE__*/React.createElement("path", {
    d: "M75 6 v16 M75 128 v16 M6 75 h16 M128 75 h16"
  }), /*#__PURE__*/React.createElement("circle", {
    cx: "75",
    cy: "75",
    r: "48",
    opacity: "0.35"
  })));
}
window.HomeScreen = HomeScreen;
})(); } catch (e) { __ds_ns.__errors.push({ path: "ui_kits/aerofighter-app/HomeScreen.jsx", error: String((e && e.message) || e) }); }

// ui_kits/aerofighter-app/Modals.jsx
try { (() => {
// AeroFighter app â€” GAME OVER and SYSTEM PAUSED modals.
function GameOverModal({
  score = 48250,
  best = 112400,
  onRelaunch,
  onAbort
}) {
  const {
    GlassModal,
    Button
  } = window.AeroFighterDesignSystem_9520d9;
  const pad = n => n.toString().padStart(6, '0');
  const isBest = score >= best;
  return /*#__PURE__*/React.createElement(GlassModal, {
    accent: "var(--af-danger)",
    glow: true,
    onScrimClick: onAbort,
    width: 320
  }, /*#__PURE__*/React.createElement("div", {
    style: {
      textAlign: 'center'
    }
  }, /*#__PURE__*/React.createElement("div", {
    style: {
      fontFamily: 'var(--af-font-display)',
      fontSize: 34,
      fontWeight: 700,
      letterSpacing: '4px',
      color: 'var(--af-danger)',
      textShadow: 'var(--af-text-glow-danger)'
    }
  }, "GAME OVER"), /*#__PURE__*/React.createElement("div", {
    style: {
      height: 22
    }
  }), /*#__PURE__*/React.createElement("div", {
    style: {
      color: 'var(--af-text-muted)',
      fontSize: 12,
      letterSpacing: '2px',
      fontFamily: 'var(--af-font-ui)'
    }
  }, "FINAL SCORE:"), /*#__PURE__*/React.createElement("div", {
    style: {
      fontFamily: 'var(--af-font-mono)',
      fontSize: 30,
      color: 'var(--af-blue-soft)',
      letterSpacing: '2px',
      margin: '4px 0 18px'
    }
  }, pad(score)), /*#__PURE__*/React.createElement("div", {
    style: {
      color: 'var(--af-text-muted)',
      fontSize: 11,
      letterSpacing: '2px',
      fontFamily: 'var(--af-font-ui)'
    }
  }, isBest ? 'NEW PERSONAL BEST' : 'PERSONAL BEST'), /*#__PURE__*/React.createElement("div", {
    style: {
      fontFamily: 'var(--af-font-mono)',
      fontSize: 18,
      color: 'var(--af-gold)',
      letterSpacing: '2px',
      margin: '2px 0 24px'
    }
  }, pad(best)), /*#__PURE__*/React.createElement(Button, {
    block: true,
    variant: "primary",
    icon: "rocket_launch",
    onClick: onRelaunch
  }, "Re-launch Mission"), /*#__PURE__*/React.createElement("div", {
    style: {
      height: 12
    }
  }), /*#__PURE__*/React.createElement(Button, {
    block: true,
    variant: "danger",
    onClick: onAbort
  }, "Abort to Menu")));
}
window.GameOverModal = GameOverModal;
function PausedModal({
  onResume,
  onAbort
}) {
  const {
    GlassModal,
    Button
  } = window.AeroFighterDesignSystem_9520d9;
  return /*#__PURE__*/React.createElement(GlassModal, {
    accent: "var(--af-cyan-mid)",
    onScrimClick: onResume,
    width: 300
  }, /*#__PURE__*/React.createElement("div", {
    style: {
      textAlign: 'center'
    }
  }, /*#__PURE__*/React.createElement("div", {
    style: {
      fontFamily: 'var(--af-font-display)',
      fontSize: 28,
      fontWeight: 700,
      letterSpacing: '3px',
      color: 'var(--af-cyan)'
    }
  }, "SYSTEM PAUSED"), /*#__PURE__*/React.createElement("div", {
    style: {
      height: 24
    }
  }), /*#__PURE__*/React.createElement(Button, {
    block: true,
    variant: "primary",
    icon: "play_arrow",
    onClick: onResume
  }, "Resume Mission"), /*#__PURE__*/React.createElement("div", {
    style: {
      height: 12
    }
  }), /*#__PURE__*/React.createElement(Button, {
    block: true,
    variant: "danger",
    onClick: onAbort
  }, "Abort to Menu")));
}
window.PausedModal = PausedModal;
})(); } catch (e) { __ds_ns.__errors.push({ path: "ui_kits/aerofighter-app/Modals.jsx", error: String((e && e.message) || e) }); }

// ui_kits/aerofighter-app/SettingsScreens.jsx
try { (() => {
// AeroFighter app â€” SHOP (placeholder) + PILOT (settings) tabs.
function ShopScreen() {
  const {
    GlassModal
  } = window.AeroFighterDesignSystem_9520d9;
  return /*#__PURE__*/React.createElement("div", {
    style: {
      height: '100%',
      display: 'flex',
      alignItems: 'center',
      justifyContent: 'center',
      padding: '0 16px'
    }
  }, /*#__PURE__*/React.createElement(GlassModal, {
    scrim: false,
    width: 260,
    style: {
      textAlign: 'center'
    }
  }, /*#__PURE__*/React.createElement("span", {
    className: "material-symbols-rounded",
    style: {
      color: 'var(--af-cyan)',
      fontSize: 48
    }
  }, "storefront"), /*#__PURE__*/React.createElement("div", {
    style: {
      height: 16
    }
  }), /*#__PURE__*/React.createElement("div", {
    style: {
      color: 'var(--af-cyan)',
      fontSize: 16,
      fontWeight: 700,
      letterSpacing: '2px',
      fontFamily: 'var(--af-font-display)'
    }
  }, "MARKETPLACE OFFLINE")));
}
window.ShopScreen = ShopScreen;
function PilotScreen() {
  const {
    GlassModal,
    SegmentedControl,
    Toggle
  } = window.AeroFighterDesignSystem_9520d9;
  const [diff, setDiff] = React.useState(1);
  const [sfx, setSfx] = React.useState(true);
  const [music, setMusic] = React.useState(true);
  const descs = ['Easy: 4 Lives. Reduced enemy speed.', 'Normal: 3 Lives. Default arcade striker parameters.', 'Hard: 2 Lives. Accelerated enemy speed.'];
  const Label = ({
    children
  }) => /*#__PURE__*/React.createElement("div", {
    style: {
      color: 'var(--af-text-muted)',
      fontSize: 10,
      letterSpacing: '1px',
      fontFamily: 'var(--af-font-ui)'
    }
  }, children);
  const SwitchRow = ({
    icon,
    label,
    on,
    set
  }) => /*#__PURE__*/React.createElement("div", {
    style: {
      display: 'flex',
      alignItems: 'center',
      justifyContent: 'space-between',
      padding: '6px 0'
    }
  }, /*#__PURE__*/React.createElement("div", {
    style: {
      display: 'flex',
      alignItems: 'center',
      gap: 8
    }
  }, /*#__PURE__*/React.createElement("span", {
    className: "material-symbols-rounded",
    style: {
      color: 'var(--af-text-muted)',
      fontSize: 18
    }
  }, icon), /*#__PURE__*/React.createElement("span", {
    style: {
      color: 'var(--af-text)',
      fontSize: 12,
      fontFamily: 'var(--af-font-ui)'
    }
  }, label)), /*#__PURE__*/React.createElement(Toggle, {
    checked: on,
    onChange: set
  }));
  return /*#__PURE__*/React.createElement("div", {
    style: {
      height: '100%',
      display: 'flex',
      alignItems: 'center',
      justifyContent: 'center',
      padding: '0 16px'
    }
  }, /*#__PURE__*/React.createElement(GlassModal, {
    scrim: false,
    width: 340
  }, /*#__PURE__*/React.createElement("div", {
    style: {
      color: 'var(--af-cyan)',
      fontSize: 15,
      fontWeight: 700,
      letterSpacing: '2px',
      fontFamily: 'var(--af-font-display)'
    }
  }, "PILOT SYSTEM PARAMETERS"), /*#__PURE__*/React.createElement("div", {
    style: {
      height: 16
    }
  }), /*#__PURE__*/React.createElement(Label, null, "DIFFICULTY SCALE"), /*#__PURE__*/React.createElement("div", {
    style: {
      height: 8
    }
  }), /*#__PURE__*/React.createElement(SegmentedControl, {
    value: diff,
    onChange: setDiff,
    options: [{
      label: 'Easy',
      color: 'var(--af-success)'
    }, {
      label: 'Normal',
      color: 'var(--af-blue)'
    }, {
      label: 'Hard',
      color: 'var(--af-danger)'
    }]
  }), /*#__PURE__*/React.createElement("div", {
    style: {
      height: 10
    }
  }), /*#__PURE__*/React.createElement("div", {
    style: {
      color: 'var(--af-text-dim)',
      fontSize: 10,
      lineHeight: 1.4,
      fontFamily: 'var(--af-font-ui)'
    }
  }, descs[diff]), /*#__PURE__*/React.createElement("div", {
    style: {
      height: 18,
      borderBottom: '1px solid var(--af-border-quiet)',
      marginBottom: 10
    }
  }), /*#__PURE__*/React.createElement(SwitchRow, {
    icon: "volume_up",
    label: "SOUND FX (SIMULATED)",
    on: sfx,
    set: setSfx
  }), /*#__PURE__*/React.createElement(SwitchRow, {
    icon: "music_note",
    label: "MUSIC TRACK (SIMULATED)",
    on: music,
    set: setMusic
  })));
}
window.PilotScreen = PilotScreen;
})(); } catch (e) { __ds_ns.__errors.push({ path: "ui_kits/aerofighter-app/SettingsScreens.jsx", error: String((e && e.message) || e) }); }

// ui_kits/aerofighter-app/TopBar.jsx
try { (() => {
// AeroFighter app â€” top bar (avatar Â· callsign Â· currency Â· wifi)
function TopBar({
  currency = '25,400',
  gems = '150'
}) {
  const {
    Avatar
  } = window.AeroFighterDesignSystem_9520d9;
  return /*#__PURE__*/React.createElement("div", {
    style: {
      display: 'flex',
      alignItems: 'center',
      gap: 12,
      padding: '12px 16px'
    }
  }, /*#__PURE__*/React.createElement(Avatar, null), /*#__PURE__*/React.createElement("div", {
    style: {
      flex: 1,
      minWidth: 0
    }
  }, /*#__PURE__*/React.createElement("div", {
    style: {
      color: 'var(--af-cyan-mid)',
      fontSize: 10,
      letterSpacing: '2px',
      fontFamily: 'var(--af-font-ui)',
      fontWeight: 600
    }
  }, "CALLSIGN"), /*#__PURE__*/React.createElement("div", {
    style: {
      color: 'var(--af-cyan)',
      fontSize: 22,
      fontWeight: 700,
      letterSpacing: '3px',
      fontFamily: 'var(--af-font-display)',
      lineHeight: 1.1
    }
  }, "MAVERICK")), /*#__PURE__*/React.createElement("div", {
    style: {
      display: 'flex',
      flexDirection: 'column',
      alignItems: 'flex-end',
      gap: 3
    }
  }, /*#__PURE__*/React.createElement("div", {
    style: {
      display: 'flex',
      alignItems: 'center',
      gap: 4
    }
  }, /*#__PURE__*/React.createElement("span", {
    className: "material-symbols-rounded",
    style: {
      color: 'var(--af-cyan)',
      fontSize: 15
    }
  }, "paid"), /*#__PURE__*/React.createElement("span", {
    style: {
      color: 'var(--af-text)',
      fontFamily: 'var(--af-font-mono)',
      fontSize: 15,
      fontWeight: 700
    }
  }, currency)), /*#__PURE__*/React.createElement("div", {
    style: {
      display: 'flex',
      alignItems: 'center',
      gap: 4
    }
  }, /*#__PURE__*/React.createElement("span", {
    className: "material-symbols-rounded",
    style: {
      color: 'var(--af-amber)',
      fontSize: 15
    }
  }, "diamond"), /*#__PURE__*/React.createElement("span", {
    style: {
      color: 'var(--af-orange)',
      fontFamily: 'var(--af-font-mono)',
      fontSize: 14,
      fontWeight: 700
    }
  }, gems))), /*#__PURE__*/React.createElement("span", {
    className: "material-symbols-rounded",
    style: {
      color: 'var(--af-cyan)',
      fontSize: 24,
      marginLeft: 4
    }
  }, "wifi"));
}
window.TopBar = TopBar;
})(); } catch (e) { __ds_ns.__errors.push({ path: "ui_kits/aerofighter-app/TopBar.jsx", error: String((e && e.message) || e) }); }

__ds_ns.Avatar = __ds_scope.Avatar;

__ds_ns.Badge = __ds_scope.Badge;

__ds_ns.Button = __ds_scope.Button;

__ds_ns.GlassModal = __ds_scope.GlassModal;

__ds_ns.IconButton = __ds_scope.IconButton;

__ds_ns.JetChip = __ds_scope.JetChip;

__ds_ns.NavBar = __ds_scope.NavBar;

__ds_ns.Panel = __ds_scope.Panel;

__ds_ns.POWERUPS = __ds_scope.POWERUPS;

__ds_ns.PowerUpBadge = __ds_scope.PowerUpBadge;

__ds_ns.ProgressBar = __ds_scope.ProgressBar;

__ds_ns.SegmentedControl = __ds_scope.SegmentedControl;

__ds_ns.StatBar = __ds_scope.StatBar;

__ds_ns.Toggle = __ds_scope.Toggle;

__ds_ns.WORLDS = __ds_scope.WORLDS;

__ds_ns.WorldChip = __ds_scope.WorldChip;

})();
