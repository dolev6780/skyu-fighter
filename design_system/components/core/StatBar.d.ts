import React from 'react';

export interface StatBarProps {
  /** Uppercase label, e.g. "ENGINE SPEED". */
  label: string;
  /** 0..1 fill fraction. @default 0.6 */
  value?: number;
  /** Fill + percentage color (CSS color or token). @default 'var(--af-cyan)' */
  color?: string;
  style?: React.CSSProperties;
}

/** Hangar-style labeled stat bar with right-aligned percentage. */
export function StatBar(props: StatBarProps): JSX.Element;
