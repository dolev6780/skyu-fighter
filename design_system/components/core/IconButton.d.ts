import React from 'react';

export interface IconButtonProps extends React.ButtonHTMLAttributes<HTMLButtonElement> {
  /** Material Symbols Rounded icon name. */
  icon: string;
  /** Accessible label. */
  label?: string;
  /** Orange selected treatment. @default false */
  active?: boolean;
  /** Square px size (also the hit target). @default 44 */
  size?: number;
  /** Glyph color when not active. @default 'var(--af-cyan)' */
  color?: string;
  /** 'circle' or 'rounded'. @default 'circle' */
  shape?: 'circle' | 'rounded';
}

/** Icon-only control (pause, wifi, top-bar) with cyan/active-orange states. */
export function IconButton(props: IconButtonProps): JSX.Element;
