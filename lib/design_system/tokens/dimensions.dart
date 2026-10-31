// dimensions.dart
//
// © 2026 Vertex Corporation
// ─────────────────────────────────────────────────────────────────────────────
// Component dimensions: touch targets, icon sizes, bars and control heights.

abstract final class AllyDimensions {
  /// Minimum accessible touch target (Material & WCAG guidance).
  static const double minTouchTarget = 48;

  // Iconography
  static const double iconXs = 16;
  static const double iconSm = 20;
  static const double iconMd = 24;
  static const double iconLg = 28;
  static const double iconXl = 32;
  static const double iconHero = 48;

  // Bars and controls
  static const double appBarHeight = 56;
  static const double bottomNavHeight = 68;
  static const double buttonHeight = 52;
  static const double buttonHeightSm = 44;
  static const double inputHeight = 52;
  static const double progressThickness = 8;

  // Icon chips inside cards (the tinted rounded square behind an icon).
  static const double iconChip = 40;
  static const double iconChipSm = 32;

  // Drag handle of bottom sheets.
  static const double sheetHandleWidth = 36;
  static const double sheetHandleHeight = 4;
}
