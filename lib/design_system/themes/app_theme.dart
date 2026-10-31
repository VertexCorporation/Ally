// app_theme.dart
//
// © 2026 Vertex Corporation
// ─────────────────────────────────────────────────────────────────────────────
// Theme dispatcher for the whole application.
//
//   'light'  → Vertex light
//   'dark'   → Vertex dark
//   'system' → follows the OS brightness (kept as a persisted preference)
//   anything else → legacy custom theme (love, nature, grayscale, …). These
//   existing user themes are preserved and adapted into the new component
//   themes instead of being deleted.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../theme.dart';
import '../extensions/color_invert.dart';
import 'theme_base.dart';
import 'dark_theme.dart';
import 'light_theme.dart';

abstract final class AppTheme {
  /// Theme identifiers that map to the Vertex identity.
  static const String light = 'light';
  static const String dark = 'dark';
  static const String system = 'system';

  static const List<String> vertexThemes = <String>[light, dark, system];

  /// Resolves the effective [Brightness] for a persisted theme name.
  static Brightness resolveBrightness(
    String themeName,
    Brightness platformBrightness,
  ) {
    switch (themeName) {
      case dark:
        return Brightness.dark;
      case system:
        return platformBrightness;
      case light:
        return Brightness.light;
      default:
        // Legacy themes declare their own brightness via their background.
        return _legacyIsDark(themeName) ? Brightness.dark : Brightness.light;
    }
  }

  static bool isDark(String themeName, Brightness platformBrightness) =>
      resolveBrightness(themeName, platformBrightness) == Brightness.dark;

  /// Builds the full [ThemeData] for the app.
  static ThemeData build({
    required String themeName,
    required Brightness platformBrightness,
  }) {
    switch (themeName) {
      case dark:
        return DarkTheme.data();
      case light:
        return LightTheme.data();
      case system:
        return platformBrightness == Brightness.dark
            ? DarkTheme.data()
            : LightTheme.data();
      default:
        return _buildLegacyTheme(themeName);
    }
  }

  /// Status-bar / navigation-bar overlay style for a theme.
  static SystemUiOverlayStyle overlayStyleFor(
    String themeName,
    Brightness platformBrightness,
  ) {
    final Brightness brightness = resolveBrightness(
      themeName,
      platformBrightness,
    );
    final bool isDark = brightness == Brightness.dark;
    final Color navColor = isDark
        ? const Color(0xFF0F0F10)
        : const Color(0xFFF8F9FA);
    return SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
      statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
      systemNavigationBarColor: navColor,
      systemNavigationBarIconBrightness: isDark
          ? Brightness.light
          : Brightness.dark,
      systemNavigationBarDividerColor: Colors.transparent,
      systemStatusBarContrastEnforced: false,
      systemNavigationBarContrastEnforced: false,
    );
  }

  // ── Legacy custom themes ──────────────────────────────────────────────────

  static bool _legacyIsDark(String themeName) {
    final ThemeColors? colors = AppColors.themeDefinitions[themeName];
    if (colors == null) return false;
    return ThemeData.estimateBrightnessForColor(colors.background) ==
        Brightness.dark;
  }

  /// Adapts a legacy [ThemeColors] palette into the current component theme so
  /// existing user themes keep working without compromising the design system.
  static ThemeData _buildLegacyTheme(String themeName) {
    final ThemeColors colors = AppColors.getThemeColors(themeName);

    final Color textPrimary = colors.primaryColor.inverted;
    final Color textSecondary = colors.tertiaryColor;

    return AllyThemeBase.build(
      AllyTokenBundle(
        brightness: _legacyIsDark(themeName)
            ? Brightness.dark
            : Brightness.light,
        background: colors.background,
        surface: colors.secondaryColor,
        elevatedSurface: colors.quaternaryColor,
        hoverSurface: colors.quaternaryColor,
        textPrimary: textPrimary,
        textSecondary: textSecondary,
        textMuted: textSecondary.withValues(alpha: 0.75),
        border: colors.border,
        borderStrong: colors.border,
      ),
    );
  }
}
