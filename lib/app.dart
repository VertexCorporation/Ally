// app.dart
//
// © 2026 Vertex Corporation
// ─────────────────────────────────────────────────────────────────────────────
// Root application widget and shared app-level utilities.
//
// - Ally: wraps [MaterialApp] with the design-system theme, localization and
//   the global [navigatorKey]. Listens to platform brightness changes so the
//   `system` theme option follows the OS live.
// - InvertedColor: color utility extension (re-exported from the design
//   system for backward compatibility).
// - kUnsupportedMaterialLocales: locales with incomplete Material translations.

import 'package:ally/design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'l10n/app_localizations.dart';
import 'language.dart';
import 'theme.dart';

export 'design_system/extensions/color_invert.dart';

/// Root application widget. Wraps [MaterialApp] with localization, theming,
/// and the global [navigatorKey].
class Ally extends StatefulWidget {
  const Ally({super.key, required this.navigatorKey, this.startupScreen});

  final GlobalKey<NavigatorState> navigatorKey;
  final Widget? startupScreen;

  @override
  State<Ally> createState() => _AllyState();
}

class _AllyState extends State<Ally> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangePlatformBrightness() {
    // Rebuild so a persisted `system` theme follows the OS immediately.
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    final LocaleProvider localeProvider = Provider.of<LocaleProvider>(context);

    final Brightness platformBrightness =
        WidgetsBinding.instance.platformDispatcher.platformBrightness;

    return MaterialApp(
      navigatorKey: widget.navigatorKey,
      theme: AppTheme.build(
        themeName: themeProvider.currentTheme,
        platformBrightness: platformBrightness,
      ),
      builder: (BuildContext context, Widget? child) {
        try {
          themeProvider.updateSystemUIOverlayStyle();
        } catch (_) {}
        return child!;
      },
      locale: localeProvider.locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      localeResolutionCallback:
          (Locale? locale, Iterable<Locale> supportedLocales) {
            final Locale chosenLocale = localeProvider.locale;
            if (kUnsupportedMaterialLocales.contains(
              chosenLocale.languageCode,
            )) {
              return const Locale('en');
            }
            return chosenLocale;
          },
      home: widget.startupScreen,
    );
  }
}

// List of locales with incomplete Material translations.
const List<String> kUnsupportedMaterialLocales = <String>['ku'];
