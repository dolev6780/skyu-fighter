import React from 'react';

export interface PanelProps extends React.HTMLAttributes<HTMLDivElement> {
  /** Accent color (hex) applied to border, and to the glow when `glow` is set. */
  accent?: string | null;
  /** Render a colored outer glow (requires `accent`). @default false */
  glow?: boolean;
  /** CSS padding. @default 'var(--af-space-7)' (24px) */
  padding?: string;
  /** CSS border-radius. @default 'var(--af-radius-md)' (12px) */
  radius?: string;
  children?: React.ReactNode;
}

/** Translucent navy cockpit surface with a thin cyan-tinted border. */
export function Panel(props: PanelProps): JSX.Element;
