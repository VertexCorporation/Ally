// light_theme.dart
//
// © 2026 Vertex Corporation
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';

import '../tokens/colors.dart';
import 'theme_base.dart';

abstract final class LightTheme {
  static const AllyTokenBundle tokens = AllyTokenBundle(
    brightness: Brightness.light,
    background: VertexLightColors.background,
    surface: VertexLightColors.surface,
    elevatedSurface: VertexLightColors.elevatedSurface,
    hoverSurface: VertexLightColors.hoverSurface,
    textPrimary: VertexLightColors.textPrimary,
    textSecondary: VertexLightColors.textSecondary,
    textMuted: VertexLightColors.textMuted,
    border: VertexLightColors.border,
    borderStrong: VertexLightColors.borderStrong,
  );

  static ThemeData data() => AllyThemeBase.build(tokens);
}
