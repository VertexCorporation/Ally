// dark_theme.dart
//
// © 2026 Vertex Corporation
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';

import '../tokens/colors.dart';
import 'theme_base.dart';

abstract final class DarkTheme {
  static const AllyTokenBundle tokens = AllyTokenBundle(
    brightness: Brightness.dark,
    background: VertexDarkColors.background,
    surface: VertexDarkColors.surface,
    elevatedSurface: VertexDarkColors.elevatedSurface,
    hoverSurface: VertexDarkColors.hoverSurface,
    textPrimary: VertexDarkColors.textPrimary,
    textSecondary: VertexDarkColors.textSecondary,
    textMuted: VertexDarkColors.textMuted,
    border: VertexDarkColors.border,
    borderStrong: VertexDarkColors.borderStrong,
  );

  static ThemeData data() => AllyThemeBase.build(tokens);
}
