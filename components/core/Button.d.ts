import React from 'react';

export type ButtonVariant = 'primary' | 'secondary' | 'ghost' | 'danger' | 'success';
export type ButtonSize = 'sm' | 'md' | 'lg';

export interface ButtonProps extends React.ButtonHTMLAttributes<HTMLButtonElement> {
  /** Visual style. `primary` is the orange SCRAMBLE gradient. @default 'primary' */
  variant?: ButtonVariant;
  /** @default 'md' — use 'lg' for the hero SCRAMBLE launcher (renders italic). */
  size?: ButtonSize;
  /** Material Symbols Rounded icon name, e.g. "rocket_launch". */
  icon?: string | null;
  disabled?: boolean;
  /** Stretch to full container width. @default false */
  block?: boolean;
  children?: React.ReactNode;
}

/**
 * AeroFighter action button — uppercase, tracked, tactical.
 * @startingPoint section="Core" subtitle="Orange-gradient CTA + secondary/danger variants" viewport="700x220"
 */
export function Button(props: ButtonProps): JSX.Element;
