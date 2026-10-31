// typography.dart
//
// © 2026 Vertex Corporation
// ─────────────────────────────────────────────────────────────────────────────
// Central typography system.
//
//   Anton          — large, distinctive display headings only (used rarely).
//   Space Grotesk  — screen/card headings and numeric metrics.
//   Inter          — body copy, labels, buttons, navigation.
//
// All three families ship full latin-ext coverage (Turkish characters included)
// through the project's existing `google_fonts` dependency. Every text style in
// the app resolves through this file or through the active Material TextTheme —
// screens must not hardcode font sizes or families.

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'colors.dart';

abstract final class AllyTypography {
  // ── Type ramp ─────────────────────────────────────────────────────────────

  /// Anton display — reserved for hero moments (welcome, key scores).
  static TextStyle display({
    double size = 40,
    Color? color,
    double letterSpacing = 1.5,
    double height = 1.1,
  }) => GoogleFonts.anton(
    fontSize: size,
    color: color,
    letterSpacing: letterSpacing,
    height: height,
  );

  /// Space Grotesk headline for screen titles.
  static TextStyle headline({
    double size = 28,
    Color? color,
    FontWeight weight = FontWeight.w600,
  }) => GoogleFonts.spaceGrotesk(
    fontSize: size,
    fontWeight: weight,
    color: color,
    height: 1.2,
  );

  /// Space Grotesk heading for card titles.
  static TextStyle cardTitle({
    double size = 18,
    Color? color,
    FontWeight weight = FontWeight.w600,
  }) => GoogleFonts.spaceGrotesk(
    fontSize: size,
    fontWeight: weight,
    color: color,
    height: 1.25,
  );

  /// Space Grotesk numeric metric — tabular alignment for numbers.
  static TextStyle metric({
    double size = 44,
    Color? color,
    FontWeight weight = FontWeight.w600,
    double height = 1.05,
  }) => GoogleFonts.spaceGrotesk(
    fontSize: size,
    fontWeight: weight,
    color: color,
    height: height,
  );

  /// Inter body copy.
  static TextStyle body({
    double size = 15,
    Color? color,
    FontWeight weight = FontWeight.w400,
    double height = 1.45,
  }) => GoogleFonts.inter(
    fontSize: size,
    fontWeight: weight,
    color: color,
    height: height,
  );

  /// Inter label (buttons, navigation, chips).
  static TextStyle label({
    double size = 14,
    Color? color,
    FontWeight weight = FontWeight.w600,
    double letterSpacing = 0.1,
  }) => GoogleFonts.inter(
    fontSize: size,
    fontWeight: weight,
    color: color,
    letterSpacing: letterSpacing,
  );

  /// Inter caption / metadata.
  static TextStyle caption({
    double size = 12,
    Color? color,
    FontWeight weight = FontWeight.w500,
  }) => GoogleFonts.inter(
    fontSize: size,
    fontWeight: weight,
    color: color,
    height: 1.35,
  );

  // ── Material TextTheme assembly ───────────────────────────────────────────

  /// Builds the application TextTheme for [brightness], so every Material
  /// widget (buttons, lists, dialogs, app bars) inherits the type ramp.
  static TextTheme buildTextTheme(Brightness brightness) {
    Color resolve(Color? darkColor, Color? lightColor) =>
        brightness == Brightness.dark ? darkColor! : lightColor!;

    final Color primaryText = resolve(_darkTextPrimary, _lightTextPrimary);

    return TextTheme(
      // Anton is reserved; standard Material sizes are kept so defaults scale
      // predictably with accessibility settings.
      displayLarge: display(size: 46, color: primaryText),
      displayMedium: display(size: 36, color: primaryText),
      displaySmall: headline(
        size: 30,
        weight: FontWeight.w700,
        color: primaryText,
      ),
      headlineLarge: headline(
        size: 30,
        color: primaryText,
        weight: FontWeight.w600,
      ),
      headlineMedium: headline(
        size: 26,
        color: primaryText,
        weight: FontWeight.w600,
      ),
      headlineSmall: headline(
        size: 22,
        color: primaryText,
        weight: FontWeight.w600,
      ),
      titleLarge: cardTitle(size: 18, color: primaryText),
      titleMedium: body(
        size: 16,
        weight: FontWeight.w600,
        color: primaryText,
        height: 1.3,
      ),
      titleSmall: body(
        size: 14,
        weight: FontWeight.w600,
        color: primaryText,
        height: 1.3,
      ),
      bodyLarge: body(
        size: 16,
        color: resolve(_darkTextSecondary, _lightTextSecondary),
      ),
      bodyMedium: body(
        size: 14,
        color: resolve(_darkTextSecondary, _lightTextSecondary),
      ),
      bodySmall: caption(
        size: 12,
        color: resolve(_darkTextMuted, _lightTextMuted),
      ),
      labelLarge: label(size: 15, color: primaryText),
      labelMedium: label(size: 13, weight: FontWeight.w500, color: primaryText),
      labelSmall: label(
        size: 11,
        weight: FontWeight.w500,
        color: resolve(_darkTextMuted, _lightTextMuted),
      ),
    );
  }

  static const Color _lightTextPrimary = VertexLightColors.textPrimary;
  static const Color _lightTextSecondary = VertexLightColors.textSecondary;
  static const Color _lightTextMuted = VertexLightColors.textMuted;
  static const Color _darkTextPrimary = VertexDarkColors.textPrimary;
  static const Color _darkTextSecondary = VertexDarkColors.textSecondary;
  static const Color _darkTextMuted = VertexDarkColors.textMuted;
}
