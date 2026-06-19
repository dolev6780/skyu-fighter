import React from 'react';

export interface SegmentOption {
  label: string;
  /** Per-option active color (e.g. green for EASY, red for HARD). */
  color?: string;
}

export interface SegmentedControlProps {
  /** Strings or {label,color} objects. */
  options: (string | SegmentOption)[];
  /** Selected index. @default 0 */
  value?: number;
  onChange?: (index: number) => void;
  /** Default active color when an option has none. @default 'var(--af-blue)' */
  activeColor?: string;
  style?: React.CSSProperties;
}

/** Difficulty-scale style segmented selector. */
export function SegmentedControl(props: SegmentedControlProps): JSX.Element;
