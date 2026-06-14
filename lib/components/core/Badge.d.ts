import React from 'react';

export interface BadgeProps {
  children?: React.ReactNode;
  /** Badge color. @default 'var(--af-cyan)' */
  color?: string;
  /** 'solid' (filled) or 'outline'. @default 'solid' */
  variant?: 'solid' | 'outline';
  /** Render as a tiny notification dot instead of a pill. @default false */
  dot?: boolean;
  style?: React.CSSProperties;
}

/** Status pill (EQUIPPED, READY) or notification dot. */
export function Badge(props: BadgeProps): JSX.Element;
