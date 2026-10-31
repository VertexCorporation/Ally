// home_smoke_test.dart
//
// Offline smoke test: pumps the Home dashboard with a Firebase-less
// UserProvider (local mode) and verifies that no exception escapes the build —
// the same conditions as a dev-bypass session without Firebase access.

import 'package:ally/design_system/design_system.dart';
import 'package:ally/home/home.dart';
import 'package:ally/l10n/app_localizations.dart';
import 'package:ally/notifications/introvert.dart';
import 'package:ally/providers/health.dart';
import 'package:ally/server/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  Future<void> pumpHome(WidgetTester tester, AppThemeMode mode) async {
    SharedPreferences.setMockInitialValues({});

    final navigatorKey = GlobalKey<NavigatorState>();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<HealthProvider>(create: (_) => HealthProvider()),
          ChangeNotifierProvider<UserProvider>(create: (_) => UserProvider()),
          Provider<IntrovertNotificationService>(
            create: (_) => IntrovertNotificationService(navigatorKey: navigatorKey),
          ),
        ],
        child: MaterialApp(
          navigatorKey: navigatorKey,
          theme: AppTheme.build(
            themeName: mode == AppThemeMode.light ? 'light' : 'dark',
            platformBrightness:
                mode == AppThemeMode.light ? Brightness.light : Brightness.dark,
          ),
          locale: const Locale('en'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: const HomeScreen(),
        ),
      ),
    );

    // Let localization load and the dashboard settle over a few frames.
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));
    await tester.pump(const Duration(milliseconds: 600));
  }

  testWidgets('home renders in light mode without errors', (tester) async {
    await pumpHome(tester, AppThemeMode.light);
    expect(tester.takeException(), isNull);
    expect(find.byType(HomeScreen), findsOneWidget);
  });

  testWidgets('home renders in dark mode without errors', (tester) async {
    await pumpHome(tester, AppThemeMode.dark);
    expect(tester.takeException(), isNull);
    expect(find.byType(HomeScreen), findsOneWidget);
  });
}

/// Local enum so the test table stays readable.
enum AppThemeMode { light, dark }
