import 'package:flutter_test/flutter_test.dart';
import 'package:ally/models/health.dart';

void main() {
  group('HealthData water amounts', () {
    test('migrates legacy glass values to milliliters', () {
      final healthData = HealthData.fromJson({
        'waterGlasses': 3,
        'waterGoal': 8,
      });

      expect(healthData.waterMl, 750);
      expect(healthData.waterGoalMl, 2000);
    });

    test('round-trips exact milliliter values', () {
      final healthData = HealthData(waterMl: 200, waterGoalMl: 1750);
      final restored = HealthData.fromJson(healthData.toJson());

      expect(restored.waterMl, 200);
      expect(restored.waterGoalMl, 1750);
    });
  });
}
