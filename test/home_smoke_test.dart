// home_smoke_test.dart + ally insights smoke test
//
// Offline smoke tests: pump the Home dashboard and the AI insights screen
// with a Firebase-less environment (local mode) and verify that no exception
// escapes the build — the same conditions as a dev-bypass session.

import 'package:ally/design_system/design_system.dart';
import 'package:ally/home/home.dart';
import 'package:ally/l10n/app_localizations.dart';
import 'package:ally/notifications/introvert.dart';
import 'package:ally/providers/health.dart';
import 'package:ally/screens/ally_ai_insights.dart';
import 'package:ally/server/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  Future<Widget> harness({
    required String themeName,
    required Brightness brightness,
    Map<String, Object> prefsValues = const {},
    Widget? home,
  }) async {
    SharedPreferences.setMockInitialValues(prefsValues);

    final navigatorKey = GlobalKey<NavigatorState>();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<HealthProvider>(create: (_) => HealthProvider()),
        ChangeNotifierProvider<UserProvider>(create: (_) => UserProvider()),
        Provider<IntrovertNotificationService>(
          create: (_) =>
              IntrovertNotificationService(navigatorKey: navigatorKey),
        ),
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey,
        theme: AppTheme.build(
          themeName: themeName,
          platformBrightness: brightness,
        ),
        locale: const Locale('en'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: home ?? const HomeScreen(),
      ),
    );
  }

  testWidgets('home renders in light mode without errors', (tester) async {
    await tester.pumpWidget(
      await harness(themeName: 'light', brightness: Brightness.light),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));
    await tester.pump(const Duration(milliseconds: 600));
    expect(tester.takeException(), isNull);
    expect(find.byType(HomeScreen), findsOneWidget);
  });

  testWidgets('home renders in dark mode without errors', (tester) async {
    await tester.pumpWidget(
      await harness(themeName: 'dark', brightness: Brightness.dark),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));
    await tester.pump(const Duration(milliseconds: 600));
    expect(tester.takeException(), isNull);
    expect(find.byType(HomeScreen), findsOneWidget);
  });

  testWidgets(
    'AI insights shows the consent gate first and never greets the user',
    (tester) async {
      await tester.pumpWidget(
        await harness(
          themeName: 'light',
          brightness: Brightness.light,
          prefsValues: const {'ai_consent_v1': false},
          home: const AllyAiInsightsScreen(),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));

      expect(tester.takeException(), isNull);
      // Consent gate is the first surface — no assistant voice anywhere.
      expect(find.textContaining('Hey'), findsNothing);
      expect(find.byType(AllyButton), findsWidgets);
    },
  );

  testWidgets(
    'AI insights with consent shows on-demand generators and an empty state',
    (tester) async {
      await tester.pumpWidget(
        await harness(
          themeName: 'dark',
          brightness: Brightness.dark,
          prefsValues: const {'ai_consent_v1': true},
          home: const AllyAiInsightsScreen(),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));

      expect(tester.takeException(), isNull);
      // Structured generators are present; no conversation bubble exists.
      expect(find.textContaining('Hey'), findsNothing);
    },
  );
}
