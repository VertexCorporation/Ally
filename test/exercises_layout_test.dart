import 'package:ally/l10n/app_localizations.dart';
import 'package:ally/providers/health.dart';
import 'package:ally/providers/workout.dart';
import 'package:ally/screens/exercises.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('exercise streak hero does not overflow during its transition', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final healthProvider = HealthProvider();
    final workoutProvider = WorkoutProvider();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: healthProvider),
          ChangeNotifierProvider.value(value: workoutProvider),
        ],
        child: MaterialApp(
          locale: const Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Builder(
            builder: (context) => Scaffold(
              body: Center(
                child: GestureDetector(
                  key: const Key('open-exercises'),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ExercisesScreen()),
                  ),
                  child: Hero(
                    tag: 'exercises_card',
                    child: Material(
                      color: Colors.transparent,
                      child: Container(
                        width: 346.5,
                        height: 111.8,
                        padding: const EdgeInsets.all(16),
                        color: const Color(0xFFE57373),
                        child: const Text(
                          'Exercise',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('open-exercises')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(tester.takeException(), isNull);

    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    await tester.pumpWidget(const SizedBox.shrink());
    healthProvider.dispose();
    workoutProvider.dispose();
  });
}
