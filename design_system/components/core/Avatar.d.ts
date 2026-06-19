import React from 'react';

export interface AvatarProps {
  /** Image URL; falls back to initials, then a person glyph. */
  src?: string | null;
  /** Initials to show when no image. */
  initials?: string | null;
  /** Square px size. @default 48 */
  size?: number;
  /** Ring color. @default 'var(--af-cyan-mid)' */
  ring?: string;
  style?: React.CSSProperties;
}

/** Cyan-ringed pilot avatar (image / initials / person glyph). */
export function Avatar(props: AvatarProps): JSX.Element;
