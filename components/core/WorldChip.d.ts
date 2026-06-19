import React from 'react';

export interface WorldMeta { id: number; name: string; accent: string; }
export const WORLDS: WorldMeta[];

export interface WorldChipProps {
  /** Sector number, shown as W{id}. @default 1 */
  id?: number;
  /** Sector name, e.g. "DAWN SECTOR". */
  name?: string;
  /** Accent token/color for the dot, border, and glow. @default 'var(--af-world-dawn)' */
  accent?: string;
  /** Selected — accent border + tint + glow. @default false */
  selected?: boolean;
  /** Locked — dims and shows a lock glyph. @default false */
  locked?: boolean;
  onClick?: () => void;
  style?: React.CSSProperties;
}

/** Campaign sector selector chip (W1 DAWN SECTOR … W4 NIGHT OPS). */
export function WorldChip(props: WorldChipProps): JSX.Element;
