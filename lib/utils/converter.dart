class UnitConverter {
  static const double kgToLbsRatio = 2.20462;

  // Weight conversion
  static double kgToLbs(double kg) {
    return kg * kgToLbsRatio;
  }

  static double lbsToKg(double lbs) {
    return lbs / kgToLbsRatio;
  }

  static String formatWeight(double kg, String units) {
    if (units == 'imperial') {
      return '${kgToLbs(kg).toStringAsFixed(1)} lbs';
    }
    return '${kg.toStringAsFixed(1)} kg';
  }

  // Height conversion
  static double cmToInches(double cm) {
    return cm / 2.54;
  }

  static double inchesToCm(double inches) {
    return inches * 2.54;
  }

  static String formatHeight(double cm, String units) {
    if (units == 'imperial') {
      final totalInches = cmToInches(cm);
      final feet = (totalInches / 12).floor();
      final inches = (totalInches % 12).round();
      return '$feet\'$inches"';
    }
    return '${cm.toStringAsFixed(0)} cm';
  }
  // Water conversion
  static double mlToOz(int ml) {
    return ml * 0.033814;
  }

  static int ozToMl(double oz) {
    return (oz / 0.033814).round();
  }

  static String formatWater(int glasses, String units) {
    // 1 glass = 250 ml
    final ml = glasses * 250;
    if (units == 'imperial') {
      return '${mlToOz(ml).toStringAsFixed(0)} oz';
    }
    return '$ml ml';
  }

  // Helper for height input
  static double feetAndInchesToCm(int feet, int inches) {
    return inchesToCm((feet * 12) + inches.toDouble());
  }
}
