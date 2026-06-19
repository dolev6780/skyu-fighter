import React from 'react';

export interface NavItem {
  /** Material Symbols Rounded icon name. */
  icon: string;
  /** Uppercase tab label. */
  label: string;
}

export interface NavBarProps {
  items: NavItem[];
  /** Index of the active tab. @default 0 */
  value?: number;
  onChange?: (index: number) => void;
  style?: React.CSSProperties;
}

/**
 * Floating glass bottom-tab bar; active tab is the orange tile.
 * @startingPoint section="Navigation" subtitle="HOME / HANGAR / SHOP / PILOT bottom nav" viewport="700x140"
 */
export function NavBar(props: NavBarProps): JSX.Element;
