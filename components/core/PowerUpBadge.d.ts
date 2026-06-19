import React from 'react';

export interface PowerUpMeta { key: string; label: string; color: string; }
export const POWERUPS: PowerUpMeta[];

export interface PowerUpBadgeProps {
  /** Frame index 0..7 or key ('weaponUp','rapidFire','missiles','repair','extraLife','armor','nuke','scoreStar'). @default 0 */
  type?: number | string;
  /** Path to the 8-frame powerups_strip_128.png (resolve relative to your page). */
  src?: string;
  /** Square px size. @default 56 */
  size?: number;
  /** Show the pulsing colored ring + glow. @default true */
  ring?: boolean;
  style?: React.CSSProperties;
}

/** Glowing power-up pickup badge built from the game's real sprite strip. */
export function PowerUpBadge(props: PowerUpBadgeProps): JSX.Element;
