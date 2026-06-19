import React from 'react';

export interface ToggleProps {
  checked?: boolean;
  onChange?: (checked: boolean) => void;
  /** On-state color. @default 'var(--af-cyan)' */
  color?: string;
  style?: React.CSSProperties;
}

/** Settings switch (SOUND FX / MUSIC TRACK) — cyan on, dark off. */
export function Toggle(props: ToggleProps): JSX.Element;
