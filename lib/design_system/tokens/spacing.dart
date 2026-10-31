// spacing.dart
//
// © 2026 Vertex Corporation
// ─────────────────────────────────────────────────────────────────────────────
// Spacing scale. Every vertical/horizontal gap in the app resolves to one of
// these steps — arbitrary pixel values are not allowed.

abstract final class AllySpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 24;
  static const double xxxl = 32;
  static const double huge = 40;
  static const double massive = 48;

  /// Default horizontal screen padding.
  static const double screenH = 20;

  /// Standard card padding (small cards use [lg]).
  static const double cardPadding = 16;
  static const double cardPaddingLg = 20;

  /// Gap between sections of a screen.
  static const double section = 24;
  static const double sectionLg = 32;

  /// Gap between sibling components inside a section.
  static const double item = 12;
  static const double itemLg = 16;
}
