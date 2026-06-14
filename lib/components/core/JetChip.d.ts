import React from 'react';

export interface JetChipProps {
  /** Skin accent color (the glowing dot). @default 'var(--af-skin-cobalt)' */
  color?: string;
  /** Currently being previewed — 2px cyan border + tint. @default false */
  highlighted?: boolean;
  /** Equipped — shows the green check. @default false */
  equipped?: boolean;
  onClick?: () => void;
  style?: React.CSSProperties;
}

/** Hangar jet-skin selector chip (glowing dot, highlight + equipped states). */
export function JetChip(props: JetChipProps): JSX.Element;
