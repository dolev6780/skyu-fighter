import React from 'react';

export interface GlassModalProps {
  children?: React.ReactNode;
  /** Border + glow color. @default 'var(--af-cyan-mid)' */
  accent?: string;
  /** Add a colored outer glow (e.g. red for GAME OVER). @default false */
  glow?: boolean;
  /** Panel width in px. @default 360 */
  width?: number;
  /** Render the dimming scrim behind. @default true */
  scrim?: boolean;
  /** Called when the scrim (not the panel) is clicked. */
  onScrimClick?: (() => void) | null;
  style?: React.CSSProperties;
}

/**
 * Frosted-glass modal shell (GAME OVER / MISSION COMPLETE / PAUSED / hangar).
 * @startingPoint section="Feedback" subtitle="Frosted-glass modal with accent border + glow" viewport="700x460"
 */
export function GlassModal(props: GlassModalProps): JSX.Element;
