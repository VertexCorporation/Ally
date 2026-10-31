// theme_base.dart
//
// © 2026 Vertex Corporation
// ─────────────────────────────────────────────────────────────────────────────
// Shared ThemeData assembly for the Vertex/Ally design language. Light and
// dark themes both route through [AllyThemeBase.build] with their own token
// bundle, guaranteeing that every component theme stays perfectly in sync.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../tokens/dimensions.dart';
import '../tokens/radius.dart';
import '../tokens/typography.dart';
import 'ally_semantics.dart';

/// Token bundle describing one full appearance.
class AllyTokenBundle {
  const AllyTokenBundle({
    required this.brightness,
    required this.background,
    required this.surface,
    required this.elevatedSurface,
    required this.hoverSurface,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.border,
    required this.borderStrong,
  });

  final Brightness brightness;
  final Color background;
  final Color surface;
  final Color elevatedSurface;
  final Color hoverSurface;
  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;
  final Color border;
  final Color borderStrong;
}

abstract final class AllyThemeBase {
  static ThemeData build(AllyTokenBundle t) {
    final bool isDark = t.brightness == Brightness.dark;
    final AllySemanticPalette semantics = isDark
        ? AllySemanticPalette.dark()
        : AllySemanticPalette.light();

    final ColorScheme scheme = ColorScheme(
      brightness: t.brightness,
      // The "primary" of this design language is the ink itself: near-black in
      // light mode, near-white in dark mode. Primary actions are monochrome.
      primary: t.textPrimary,
      onPrimary: isDark ? const Color(0xFF0F0F10) : const Color(0xFFFFFFFF),
      primaryContainer: t.hoverSurface,
      onPrimaryContainer: t.textPrimary,
      secondary: t.textSecondary,
      onSecondary: isDark ? const Color(0xFF0F0F10) : const Color(0xFFFFFFFF),
      secondaryContainer: t.hoverSurface,
      onSecondaryContainer: t.textPrimary,
      tertiary: t.textMuted,
      onTertiary: isDark ? const Color(0xFF0F0F10) : const Color(0xFFFFFFFF),
      tertiaryContainer: t.hoverSurface,
      onTertiaryContainer: t.textSecondary,
      error: semantics.error,
      onError: const Color(0xFFFFFFFF),
      errorContainer: semantics.error.withValues(alpha: 0.14),
      onErrorContainer: semantics.error,
      surface: t.surface,
      onSurface: t.textPrimary,
      surfaceContainerHighest: t.elevatedSurface,
      surfaceContainerHigh: t.elevatedSurface,
      surfaceContainer: t.surface,
      surfaceContainerLow: t.surface,
      surfaceContainerLowest: t.background,
      onSurfaceVariant: t.textSecondary,
      outline: t.borderStrong,
      outlineVariant: t.border,
      shadow: Colors.black,
      scrim: Colors.black,
      inverseSurface: t.textPrimary,
      onInverseSurface: isDark
          ? const Color(0xFF0F0F10)
          : const Color(0xFFFFFFFF),
      inversePrimary: t.textSecondary,
      surfaceTint: Colors.transparent,
    );

    final TextTheme textTheme = AllyTypography.buildTextTheme(t.brightness);

    final BorderSide hairline = BorderSide(color: t.border);

    return ThemeData(
      useMaterial3: true,
      brightness: t.brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: t.background,
      canvasColor: t.background,
      cardColor: t.surface,
      splashColor: t.textPrimary.withValues(alpha: 0.06),
      highlightColor: t.textPrimary.withValues(alpha: 0.04),
      splashFactory: InkRipple.splashFactory,
      textTheme: textTheme,
      primaryTextTheme: textTheme,
      iconTheme: IconThemeData(
        color: t.textPrimary,
        size: AllyDimensions.iconMd,
      ),
      primaryIconTheme: IconThemeData(
        color: t.textPrimary,
        size: AllyDimensions.iconMd,
      ),

      // ── App bar: quiet, borderless, background-cancelling ────────────────
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: t.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: AllyTypography.headline(size: 20, color: t.textPrimary),
        titleSpacing: 0,
        iconTheme: IconThemeData(
          color: t.textPrimary,
          size: AllyDimensions.iconLg,
        ),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
          statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
        ),
      ),

      // ── Cards: surface + hairline border, no shadows ─────────────────────
      cardTheme: CardThemeData(
        color: t.surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: AllyRadius.mdAll,
          side: hairline,
        ),
      ),

      // ── Buttons ──────────────────────────────────────────────────────────
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: t.textPrimary,
          foregroundColor: scheme.onPrimary,
          disabledBackgroundColor: t.border,
          disabledForegroundColor: t.textMuted,
          minimumSize: const Size(64, AllyDimensions.buttonHeight),
          padding: const EdgeInsets.symmetric(horizontal: 24),
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: AllyRadius.smAll),
          textStyle: AllyTypography.label(size: 15),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: t.textPrimary,
          backgroundColor: Colors.transparent,
          minimumSize: const Size(64, AllyDimensions.buttonHeight),
          padding: const EdgeInsets.symmetric(horizontal: 24),
          side: BorderSide(color: t.borderStrong),
          shape: RoundedRectangleBorder(borderRadius: AllyRadius.smAll),
          textStyle: AllyTypography.label(size: 15),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: t.textSecondary,
          minimumSize: const Size(44, 44),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          shape: RoundedRectangleBorder(borderRadius: AllyRadius.smAll),
          textStyle: AllyTypography.label(size: 14),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: t.textPrimary,
          foregroundColor: scheme.onPrimary,
          minimumSize: const Size(64, AllyDimensions.buttonHeight),
          padding: const EdgeInsets.symmetric(horizontal: 24),
          shape: RoundedRectangleBorder(borderRadius: AllyRadius.smAll),
          textStyle: AllyTypography.label(size: 15),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: t.textPrimary,
        foregroundColor: scheme.onPrimary,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: AllyRadius.mdAll),
      ),

      // ── Inputs ───────────────────────────────────────────────────────────
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: t.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        hintStyle: AllyTypography.body(color: t.textMuted),
        labelStyle: AllyTypography.label(
          size: 14,
          weight: FontWeight.w500,
          color: t.textSecondary,
        ),
        helperStyle: AllyTypography.caption(color: t.textMuted),
        errorStyle: AllyTypography.caption(color: semantics.error),
        prefixIconColor: t.textMuted,
        suffixIconColor: t.textMuted,
        border: OutlineInputBorder(
          borderRadius: AllyRadius.smAll,
          borderSide: BorderSide(color: t.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AllyRadius.smAll,
          borderSide: BorderSide(color: t.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AllyRadius.smAll,
          borderSide: BorderSide(color: t.textPrimary, width: 1.4),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AllyRadius.smAll,
          borderSide: BorderSide(color: semantics.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: AllyRadius.smAll,
          borderSide: BorderSide(color: semantics.error, width: 1.4),
        ),
      ),

      textSelectionTheme: TextSelectionThemeData(
        cursorColor: t.textPrimary,
        selectionColor: t.textPrimary.withValues(alpha: 0.18),
        selectionHandleColor: t.textPrimary,
      ),

      // ── Dividers, lists, chips ───────────────────────────────────────────
      dividerTheme: DividerThemeData(color: t.border, thickness: 1, space: 1),
      listTileTheme: ListTileThemeData(
        iconColor: t.textSecondary,
        textColor: t.textPrimary,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        shape: RoundedRectangleBorder(borderRadius: AllyRadius.smAll),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: t.hoverSurface,
        labelStyle: AllyTypography.label(size: 13, color: t.textPrimary),
        side: BorderSide(color: t.border),
        shape: RoundedRectangleBorder(borderRadius: AllyRadius.smAll),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),

      // ── Dialogs & sheets ─────────────────────────────────────────────────
      dialogTheme: DialogThemeData(
        backgroundColor: t.elevatedSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: AllyRadius.lgAll,
          side: hairline,
        ),
        titleTextStyle: AllyTypography.headline(size: 20, color: t.textPrimary),
        contentTextStyle: AllyTypography.body(color: t.textSecondary),
        actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: t.surface,
        elevation: 0,
        modalBackgroundColor: t.surface,
        modalElevation: 0,
        showDragHandle: true,
        dragHandleColor: t.borderStrong,
        dragHandleSize: const Size(36, 4),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
      ),

      // ── Controls ─────────────────────────────────────────────────────────
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) return t.borderStrong;
          if (states.contains(WidgetState.selected)) return scheme.onPrimary;
          return t.textMuted;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) return t.hoverSurface;
          if (states.contains(WidgetState.selected)) return t.textPrimary;
          return t.border;
        }),
        trackOutlineColor: WidgetStateProperty.resolveWith(
          (states) => Colors.transparent,
        ),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return t.textPrimary;
          return Colors.transparent;
        }),
        checkColor: WidgetStateProperty.all(scheme.onPrimary),
        side: BorderSide(color: t.borderStrong, width: 1.6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return t.textPrimary;
          return t.borderStrong;
        }),
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: t.textPrimary,
        inactiveTrackColor: t.border,
        thumbColor: t.textPrimary,
        overlayColor: t.textPrimary.withValues(alpha: 0.08),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: t.textPrimary,
        linearTrackColor: t.border,
        circularTrackColor: t.border,
        refreshBackgroundColor: t.elevatedSurface,
      ),
      scrollbarTheme: ScrollbarThemeData(
        thumbColor: WidgetStateProperty.all(t.borderStrong),
      ),

      // ── Misc ─────────────────────────────────────────────────────────────
      snackBarTheme: SnackBarThemeData(
        backgroundColor: t.textPrimary,
        contentTextStyle: AllyTypography.label(
          size: 14,
          color: scheme.onPrimary,
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: AllyRadius.smAll),
      ),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: t.textPrimary,
          borderRadius: AllyRadius.smAll,
        ),
        textStyle: AllyTypography.caption(size: 12, color: scheme.onPrimary),
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: t.elevatedSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: AllyRadius.mdAll,
          side: hairline,
        ),
        textStyle: AllyTypography.body(color: t.textPrimary),
      ),
      extensions: <ThemeExtension<dynamic>>[semantics],
    );
  }
}
