import React from 'react';

export interface ProgressBarProps {
  /** 0..1 fill fraction. @default 0.5 */
  value?: number;
  /** Fill color. @default 'var(--af-orange)' */
  color?: string;
  /** CSS height. @default 'var(--af-bar-thin)' (4px) */
  height?: string;
  /** Glow the fill. @default true */
  glow?: boolean;
  /** Track color. @default 'rgba(0,0,0,0.45)' */
  track?: string;
  style?: React.CSSProperties;
}

/** Thin HUD progress / timer bar (kill-progress, power-up duration). */
export function ProgressBar(props: ProgressBarProps): JSX.Element;
