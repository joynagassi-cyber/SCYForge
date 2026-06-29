/**
 * SCY Forge — Design Tokens (TypeScript)
 * Source de vérité : mindoc/s00_design/scy_design_system.md
 */

export const colors = {
  bg: {
    main: '#05050A',
    card: '#0D0D15',
    hover: '#1A1A25',
    active: '#25253A',
  },
  accent: {
    ai: '#7C3AED',
    success: '#10B981',
    info: '#06B6D4',
    alert: '#D97706',
    error: '#EF4444',
  },
  text: {
    primary: '#F3F4F6',
    secondary: '#9CA3AF',
    muted: '#6B7280',
    inverse: '#05050A',
  },
  border: {
    default: '#374151',
    hover: '#4B5563',
    focus: '#7C3AED',
  },
} as const;

export const typography = {
  fontSans: "'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif",
  fontMono: "'JetBrains Mono', 'Fira Code', 'Consolas', monospace",
  textXs: '0.75rem',
  textSm: '0.875rem',
  textBase: '1rem',
  textLg: '1.125rem',
  textXl: '1.25rem',
  text2Xl: '1.5rem',
  text3Xl: '1.875rem',
  text4Xl: '2.25rem',
  weights: {
    normal: 400,
    medium: 500,
    semibold: 600,
    bold: 700,
  },
} as const;

export const spacing = {
  space0: '0',
  space1: '0.25rem',
  space2: '0.5rem',
  space3: '0.75rem',
  space4: '1rem',
  space5: '1.25rem',
  space6: '1.5rem',
  space8: '2rem',
  space10: '2.5rem',
  space12: '3rem',
  space16: '4rem',
} as const;

export const rounded = {
  sm: '0.125rem',
  default: '0.25rem',
  md: '0.375rem',
  lg: '0.5rem',
  xl: '0.75rem',
  '2xl': '1rem',
  full: '9999px',
} as const;

export const shadows = {
  sm: '0 1px 2px 0 rgb(0 0 0 / 0.05)',
  default: '0 1px 3px 0 rgb(0 0 0 / 0.1), 0 1px 2px -1px rgb(0 0 0 / 0.1)',
  md: '0 4px 6px -1px rgb(0 0 0 / 0.1), 0 2px 4px -2px rgb(0 0 0 / 0.1)',
  lg: '0 10px 15px -3px rgb(0 0 0 / 0.1), 0 4px 6px -4px rgb(0 0 0 / 0.1)',
  xl: '0 20px 25px -5px rgb(0 0 0 / 0.1), 0 8px 10px -6px rgb(0 0 0 / 0.1)',
  glowViolet: '0 0 20px rgba(124, 58, 237, 0.3)',
  glowEmerald: '0 0 20px rgba(16, 185, 129, 0.3)',
} as const;

export const zIndex = {
  base: 0,
  dropdown: 1000,
  sticky: 1020,
  modalBackdrop: 1030,
  modal: 1040,
  popover: 1050,
  toast: 1060,
  tooltip: 1070,
} as const;
