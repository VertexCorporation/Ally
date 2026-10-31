// colors.dart
//
// © 2026 Vertex Corporation
// ─────────────────────────────────────────────────────────────────────────────
// Central color tokens for the Ally design language.
//
// Vertex provides the monochrome foundation ("quiet authority"); Ally keeps a
// small set of restrained semantic accents for health information. Colors are
// never decorative: semantic colors communicate health-related state and are
// always paired with an icon or label so status is not conveyed by color alone.

import 'package:flutter/material.dart';

/// Monochrome foundation tokens, light variant — matched to the
/// vertexishere.com design system.
abstract final class VertexLightColors {
  static const Color background = Color(0xFFFAFAF9);
  static const Color surface = Color(0xFFF1F1EE);
  static const Color elevatedSurface = Color(0xFFFAFAF9);
  static const Color hoverSurface = Color(0xFFEAEAE6);
  static const Color textPrimary = Color(0xFF1A1B1E);
  static const Color textSecondary = Color(0xFF6B6E76);
  static const Color textMuted = Color(0xFF9A9DA4);
  static const Color border = Color(0xFFE3E3DF);
  static const Color borderStrong = Color(0xFFD2D2CE);
}

/// Monochrome foundation tokens, dark variant — matched to the
/// vertexishere.com design system.
abstract final class VertexDarkColors {
  static const Color background = Color(0xFF0E1013);
  static const Color surface = Color(0xFF15171B);
  static const Color elevatedSurface = Color(0xFF1B1E23);
  static const Color hoverSurface = Color(0xFF1B1E23);
  static const Color textPrimary = Color(0xFFEDEEEF);
  static const Color textSecondary = Color(0xFF8A8D96);
  static const Color textMuted = Color(0xFF5F626A);
  static const Color border = Color(0xFF262932);
  static const Color borderStrong = Color(0xFF31353D);
}

/// Semantic status colors, shared by both themes and always distinguishable.
abstract final class AllySemanticColors {
  static const Color success = Color(0xFF3FB68B);
  static const Color warning = Color(0xFFD9A03F);
  static const Color error = Color(0xFFE5654E);
  static const Color info = Color(0xFF7FA8C9);
}

/// Restrained accents for health metrics.
///
/// Each metric keeps its meaningful hue but stays desaturated and controlled
/// so cards remain part of one coherent, monochrome-first interface.
abstract final class AllyHealthColors {
  /// Heart rate — restrained red.
  static const Color heartRateLight = Color(0xFFC05B50);
  static const Color heartRateDark = Color(0xFFE5654E);

  /// Sleep — restrained purple.
  static const Color sleepLight = Color(0xFF7B6CA8);
  static const Color sleepDark = Color(0xFFA094D0);

  /// Hydration — restrained blue.
  static const Color waterLight = Color(0xFF4E8CB8);
  static const Color waterDark = Color(0xFF7FA8C9);

  /// Nutrition — restrained amber.
  static const Color nutritionLight = Color(0xFFC08A3E);
  static const Color nutritionDark = Color(0xFFD9A03F);

  /// Exercise / activity — restrained green.
  static const Color activityLight = Color(0xFF3F8F6B);
  static const Color activityDark = Color(0xFF3FB68B);

  /// Steps / movement — restrained steel blue.
  static const Color stepsLight = Color(0xFF4E7FA6);
  static const Color stepsDark = Color(0xFF6E9BC0);

  /// Weight — restrained teal-green.
  static const Color weightLight = Color(0xFF4C8A6E);
  static const Color weightDark = Color(0xFF57A57F);

  /// Ally AI — the product's own voice; neutral graphite.
  static const Color aiLight = Color(0xFF59616C);
  static const Color aiDark = Color(0xFFACACAC);
}

/// Convenience resolution of health accents for a brightness.
Color healthAccent(AllyHealthAccent accent, Brightness brightness) {
  final bool isDark = brightness == Brightness.dark;
  switch (accent) {
    case AllyHealthAccent.heartRate:
      return isDark
          ? AllyHealthColors.heartRateDark
          : AllyHealthColors.heartRateLight;
    case AllyHealthAccent.sleep:
      return isDark ? AllyHealthColors.sleepDark : AllyHealthColors.sleepLight;
    case AllyHealthAccent.water:
      return isDark ? AllyHealthColors.waterDark : AllyHealthColors.waterLight;
    case AllyHealthAccent.nutrition:
      return isDark
          ? AllyHealthColors.nutritionDark
          : AllyHealthColors.nutritionLight;
    case AllyHealthAccent.activity:
      return isDark
          ? AllyHealthColors.activityDark
          : AllyHealthColors.activityLight;
    case AllyHealthAccent.steps:
      return isDark ? AllyHealthColors.stepsDark : AllyHealthColors.stepsLight;
    case AllyHealthAccent.weight:
      return isDark
          ? AllyHealthColors.weightDark
          : AllyHealthColors.weightLight;
    case AllyHealthAccent.ai:
      return isDark ? AllyHealthColors.aiDark : AllyHealthColors.aiLight;
  }
}

enum AllyHealthAccent {
  heartRate,
  sleep,
  water,
  nutrition,
  activity,
  steps,
  weight,
  ai,
}

/// Mid-tone accents usable in `const` contexts (static widget trees, legacy
/// helpers that have no theme access). They are tuned to stay legible on both
/// the light and dark Vertex surfaces.
abstract final class AllyUniversalAccents {
  static const Color exercise = Color(0xFFC05B50);
  static const Color rest = Color(0xFF5E8FB5);
  static const Color done = Color(0xFF3F8F6B);
  static const Color warn = Color(0xFFC08A3E);
  static const Color energy = Color(0xFF7B6CA8);
  static const Color info = Color(0xFF5E8FB5);
  static const Color danger = Color(0xFFE5654E);
  static const Color steps = Color(0xFF4E7FA6);
  static const Color sleep = Color(0xFF7B6CA8);
  static const Color water = Color(0xFF4E8CB8);
  static const Color nutrition = Color(0xFFC08A3E);
  static const Color weight = Color(0xFF4C8A6E);
}
