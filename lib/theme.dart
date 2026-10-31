// theme.dart
//
// © 2026 Vertex Corporation
// ─────────────────────────────────────────────────────────────────────────────
// Theme state + compatibility layer.
//
// The visual truth lives in `design_system/`. This file keeps:
//   • [ThemeProvider] — persisted theme selection (light / dark / system and
//     the pre-existing custom themes), unchanged public API.
//   • [AppColors] — the legacy static accessor used across older code. For the
//     Vertex themes it now resolves to the centralized design tokens instead
//     of hardcoding its own palette.

import 'package:ally/design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  String _currentTheme;

  ThemeProvider(this._currentTheme) {
    AppColors.currentTheme = _currentTheme;
    updateSystemUIOverlayStyle();
  }

  String get currentTheme => _currentTheme;

  void changeTheme(String theme) async {
    if (_currentTheme == theme) return; // Prevent unnecessary notifications

    _currentTheme = theme;
    AppColors.currentTheme = theme;
    updateSystemUIOverlayStyle();
    notifyListeners(); // This is the ONLY place that should notify.
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedTheme', theme);
  }

  /// Resolves the platform brightness for `system` mode.
  Brightness get platformBrightness =>
      WidgetsBinding.instance.platformDispatcher.platformBrightness;

  // It's a side effect, not a state change that affects the UI tree.
  void updateSystemUIOverlayStyle() {
    SystemChrome.setSystemUIOverlayStyle(
      AppTheme.overlayStyleFor(_currentTheme, platformBrightness),
    );
  }
}

/// Per-theme raw palette record. Legacy custom themes keep their original
/// palettes; the Vertex themes are described by the design tokens.
class ThemeColors {
  final Color primaryColor;
  final Color secondaryColor;
  final Color tertiaryColor;
  final Color quaternaryColor;
  final Color quinaryColor;
  final Color senaryColor;
  final Color septenaryColor;
  final Color background;
  final Color border;

  final Color navigationBarColor;
  final Color statusBarColor;
  final Brightness navigationBarIconBrightness;
  final Brightness statusBarIconBrightness;

  const ThemeColors({
    required this.primaryColor,
    required this.secondaryColor,
    required this.tertiaryColor,
    required this.quaternaryColor,
    required this.quinaryColor,
    required this.senaryColor,
    required this.septenaryColor,
    required this.background,
    required this.border,
    required this.navigationBarColor,
    required this.statusBarColor,
    required this.navigationBarIconBrightness,
    required this.statusBarIconBrightness,
  });
}

class AppColors {
  static String currentTheme = '';

  /// Legacy custom themes are preserved verbatim.
  static Map<String, ThemeColors> get legacyThemeDefinitions {
    return {
      'love': ThemeColors(
        primaryColor: Colors.white,
        secondaryColor: const Color(0xFFFFC8D6),
        tertiaryColor: const Color(0xA8000000),
        quaternaryColor: const Color(0xFFffc2d1),
        quinaryColor: const Color(0xA8000000),
        senaryColor: const Color(0xfffb7088),
        septenaryColor: const Color(0xffff607d),
        background: const Color(0xFFffb3c6),
        border: const Color(0xFFFFE5EC),
        navigationBarColor: const Color(0xFFffb3c6),
        statusBarColor: Colors.transparent,
        navigationBarIconBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark,
      ),
      'nature': ThemeColors(
        primaryColor: Colors.black,
        secondaryColor: const Color(0xff225a41),
        tertiaryColor: const Color(0xff79b191),
        quaternaryColor: const Color(0xff204c3a),
        quinaryColor: Colors.white70,
        senaryColor: const Color(0xFF23852C),
        septenaryColor: const Color(0xFF388E3C),
        background: const Color(0xff16392a),
        border: const Color(0xff275a44),
        navigationBarColor: const Color(0xFF16392a),
        statusBarColor: Colors.transparent,
        navigationBarIconBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.dark,
      ),
      'behindTheSlaughter': ThemeColors(
        primaryColor: Colors.black,
        secondaryColor: const Color(0xFF5A189A),
        tertiaryColor: const Color(0xFFC77DFF),
        quaternaryColor: const Color(0xFF3C096C),
        quinaryColor: Colors.white70,
        senaryColor: const Color(0xFF9D4EDD),
        septenaryColor: const Color(0xFFE0AAFF),
        background: const Color(0xFF240046),
        border: const Color(0xFF4A00A0),
        navigationBarColor: const Color(0xFF240046),
        statusBarColor: Colors.transparent,
        navigationBarIconBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light,
      ),
      'grayscale': ThemeColors(
        primaryColor: Colors.black,
        secondaryColor: const Color(0xFF4D5359),
        tertiaryColor: const Color(0xFF9DA3A9),
        quaternaryColor: const Color(0xFF36393D),
        quinaryColor: Colors.white70,
        senaryColor: const Color(0xFF707478),
        septenaryColor: const Color(0xFF373739),
        background: const Color(0xFF1F2225),
        border: const Color(0xFF4D5359),
        navigationBarColor: const Color(0xFF1F2225),
        statusBarColor: Colors.transparent,
        navigationBarIconBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light,
      ),
      'ocean': ThemeColors(
        primaryColor: Colors.black,
        secondaryColor: const Color(0xff0259a1),
        tertiaryColor: const Color(0xFFB0DFFF),
        quaternaryColor: const Color(0xff025395),
        quinaryColor: Colors.white70,
        senaryColor: const Color(0xFF1435BA),
        septenaryColor: const Color(0xFF135083),
        background: const Color(0xff013077),
        border: const Color(0xff68a0f1),
        navigationBarColor: const Color(0xff013077),
        statusBarColor: Colors.transparent,
        navigationBarIconBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light,
      ),
      'scarletSnow': ThemeColors(
        primaryColor: Colors.black,
        secondaryColor: const Color(0xff771424),
        tertiaryColor: const Color(0xFFD19FA6),
        quaternaryColor: const Color(0xFF680018),
        quinaryColor: Colors.white70,
        senaryColor: const Color(0xFFBF002B),
        septenaryColor: const Color(0xFF950D21),
        background: const Color(0xFF4D0012),
        border: const Color(0xFFFD8686),
        navigationBarColor: const Color(0xFF4D0012),
        statusBarColor: Colors.transparent,
        navigationBarIconBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light,
      ),
    };
  }

  /// All theme definitions, with light/dark mapped to the Vertex tokens.
  static Map<String, ThemeColors> get themeDefinitions {
    final bool dark = resolveBrightness() == Brightness.dark;

    return {
      'light': _vertexColors(Brightness.light),
      'dark': _vertexColors(Brightness.dark),
      // `system` resolves to the active platform brightness.
      'system': _vertexColors(dark ? Brightness.dark : Brightness.light),
      ...legacyThemeDefinitions,
    };
  }

  static ThemeColors _vertexColors(Brightness brightness) {
    final bool isDark = brightness == Brightness.dark;
    if (isDark) {
      return ThemeColors(
        primaryColor: Colors.black,
        secondaryColor: VertexDarkColors.surface,
        tertiaryColor: VertexDarkColors.textSecondary,
        quaternaryColor: VertexDarkColors.elevatedSurface,
        quinaryColor: VertexDarkColors.textMuted,
        senaryColor: AllySemanticColors.info,
        septenaryColor: AllySemanticColors.error,
        background: VertexDarkColors.background,
        border: VertexDarkColors.border,
        navigationBarColor: VertexDarkColors.background,
        statusBarColor: Colors.transparent,
        navigationBarIconBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light,
      );
    }
    return ThemeColors(
      primaryColor: Colors.white,
      secondaryColor: VertexLightColors.surface,
      tertiaryColor: VertexLightColors.textSecondary,
      quaternaryColor: VertexLightColors.elevatedSurface,
      quinaryColor: VertexLightColors.textMuted,
      senaryColor: AllySemanticColors.info,
      septenaryColor: AllySemanticColors.error,
      background: VertexLightColors.background,
      border: VertexLightColors.border,
      navigationBarColor: VertexLightColors.background,
      statusBarColor: Colors.transparent,
      navigationBarIconBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.dark,
    );
  }

  /// Effective brightness of [currentTheme] ('system' follows the platform).
  static Brightness resolveBrightness() {
    final Brightness platform =
        WidgetsBinding.instance.platformDispatcher.platformBrightness;
    if (currentTheme == AppTheme.system) return platform;
    return AppTheme.resolveBrightness(currentTheme, platform);
  }

  static ThemeColors getThemeColors(String theme) {
    if (theme == AppTheme.system) {
      return _vertexColors(resolveBrightness());
    }
    return themeDefinitions[theme] ?? _vertexColors(Brightness.light);
  }

  static Map<String, dynamic> getSystemUIOverlayStyleForTheme(String theme) {
    final themeColors = getThemeColors(theme);
    return {
      'navigationBarColor': themeColors.navigationBarColor,
      'statusBarColor': themeColors.statusBarColor,
      'navigationBarIconBrightness': themeColors.navigationBarIconBrightness,
      'statusBarIconBrightness': themeColors.statusBarIconBrightness,
    };
  }

  static Color get primaryColor => getThemeColors(currentTheme).primaryColor;
  static Color get secondaryColor =>
      getThemeColors(currentTheme).secondaryColor;
  static Color get tertiaryColor => getThemeColors(currentTheme).tertiaryColor;
  static Color get quaternaryColor =>
      getThemeColors(currentTheme).quaternaryColor;
  static Color get quinaryColor => getThemeColors(currentTheme).quinaryColor;
  static Color get senaryColor => getThemeColors(currentTheme).senaryColor;
  static Color get septenaryColor =>
      getThemeColors(currentTheme).septenaryColor;
  static Color get background => getThemeColors(currentTheme).background;
  static Color get border => getThemeColors(currentTheme).border;

  static Color darken(Color color, double amount) {
    final luminance = color.computeLuminance();
    final t = (luminance - 0.5) * 1000;
    final blendFactor = (t.sign + 1) / 2;
    final targetColor = Color.lerp(Colors.white, Colors.black, blendFactor)!;
    return Color.lerp(color, targetColor, amount)!;
  }
}
