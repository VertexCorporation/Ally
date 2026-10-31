// ally_semantics.dart
//
// © 2026 Vertex Corporation
// ─────────────────────────────────────────────────────────────────────────────
// ThemeExtension carrying Ally's semantic + health palette.
//
// Standard ColorScheme slots are fully wired to the monochrome Vertex
// foundation, so this extension only exists for colors Material has no slot
// for: status colors and per-metric health accents. Access it via
// `context.allySemantics` (extension in this file).

import 'package:flutter/material.dart';

import '../tokens/colors.dart';

@immutable
class AllySemanticPalette extends ThemeExtension<AllySemanticPalette> {
  const AllySemanticPalette({
    required this.success,
    required this.warning,
    required this.error,
    required this.info,
    required this.heartRate,
    required this.sleep,
    required this.water,
    required this.nutrition,
    required this.activity,
    required this.steps,
    required this.weight,
    required this.ai,
  });

  final Color success;
  final Color warning;
  final Color error;
  final Color info;

  final Color heartRate;
  final Color sleep;
  final Color water;
  final Color nutrition;
  final Color activity;
  final Color steps;
  final Color weight;
  final Color ai;

  static AllySemanticPalette light() => const AllySemanticPalette(
    success: AllySemanticColors.success,
    warning: AllySemanticColors.warning,
    error: AllySemanticColors.error,
    info: AllySemanticColors.info,
    heartRate: AllyHealthColors.heartRateLight,
    sleep: AllyHealthColors.sleepLight,
    water: AllyHealthColors.waterLight,
    nutrition: AllyHealthColors.nutritionLight,
    activity: AllyHealthColors.activityLight,
    steps: AllyHealthColors.stepsLight,
    weight: AllyHealthColors.weightLight,
    ai: AllyHealthColors.aiLight,
  );

  static AllySemanticPalette dark() => const AllySemanticPalette(
    success: AllySemanticColors.success,
    warning: AllySemanticColors.warning,
    error: AllySemanticColors.error,
    info: AllySemanticColors.info,
    heartRate: AllyHealthColors.heartRateDark,
    sleep: AllyHealthColors.sleepDark,
    water: AllyHealthColors.waterDark,
    nutrition: AllyHealthColors.nutritionDark,
    activity: AllyHealthColors.activityDark,
    steps: AllyHealthColors.stepsDark,
    weight: AllyHealthColors.weightDark,
    ai: AllyHealthColors.aiDark,
  );

  @override
  AllySemanticPalette copyWith({
    Color? success,
    Color? warning,
    Color? error,
    Color? info,
    Color? heartRate,
    Color? sleep,
    Color? water,
    Color? nutrition,
    Color? activity,
    Color? steps,
    Color? weight,
    Color? ai,
  }) {
    return AllySemanticPalette(
      success: success ?? this.success,
      warning: warning ?? this.warning,
      error: error ?? this.error,
      info: info ?? this.info,
      heartRate: heartRate ?? this.heartRate,
      sleep: sleep ?? this.sleep,
      water: water ?? this.water,
      nutrition: nutrition ?? this.nutrition,
      activity: activity ?? this.activity,
      steps: steps ?? this.steps,
      weight: weight ?? this.weight,
      ai: ai ?? this.ai,
    );
  }

  @override
  AllySemanticPalette lerp(
    ThemeExtension<AllySemanticPalette>? other,
    double t,
  ) {
    if (other is! AllySemanticPalette) return this;
    return AllySemanticPalette(
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      error: Color.lerp(error, other.error, t)!,
      info: Color.lerp(info, other.info, t)!,
      heartRate: Color.lerp(heartRate, other.heartRate, t)!,
      sleep: Color.lerp(sleep, other.sleep, t)!,
      water: Color.lerp(water, other.water, t)!,
      nutrition: Color.lerp(nutrition, other.nutrition, t)!,
      activity: Color.lerp(activity, other.activity, t)!,
      steps: Color.lerp(steps, other.steps, t)!,
      weight: Color.lerp(weight, other.weight, t)!,
      ai: Color.lerp(ai, other.ai, t)!,
    );
  }
}

extension AllySemanticsContext on BuildContext {
  /// Typed access to Ally's semantic palette from any widget.
  AllySemanticPalette get allySemantics =>
      Theme.of(this).extension<AllySemanticPalette>()!;
}
