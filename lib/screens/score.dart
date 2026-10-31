// score.dart
//
// © 2026 Vertex Corporation
// ─────────────────────────────────────────────────────────────────────────────
// Health score breakdown. All component scores are derived from real
// [HealthData] values; each contributor keeps its restrained health accent.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../design_system/design_system.dart';
import '../l10n/app_localizations.dart';
import '../providers/health.dart';

class HealthScoreScreen extends StatefulWidget {
  const HealthScoreScreen({super.key});

  @override
  State<HealthScoreScreen> createState() => _HealthScoreScreenState();
}

class _HealthScoreScreenState extends State<HealthScoreScreen> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;
    final AllySemanticPalette semantics = context.allySemantics;

    final healthProvider = Provider.of<HealthProvider>(context);
    final healthData = healthProvider.healthData;
    final healthScore = healthData.healthScore;

    // Calculate individual scores based on real data
    final waterScore = ((healthData.waterGlasses / healthData.waterGoal) * 25)
        .clamp(0, 25);
    final exerciseScore = ((healthData.exerciseStreak / 7) * 25).clamp(0, 25);
    final sleepScore = ((healthData.sleepHours / healthData.sleepGoal) * 25)
        .clamp(0, 25);
    final stepsScore = healthData.stepsGoal > 0
        ? ((healthData.currentSteps / healthData.stepsGoal) * 25).clamp(0, 25)
        : 0.0;

    final List<Map<String, dynamic>> scoreBreakdown = [
      {
        'name': l10n.exercises,
        'icon': Icons.fitness_center_rounded,
        'color': semantics.activity,
        'weight': 25,
        'currentScore': exerciseScore.round(),
        'description': l10n.workoutStreakDesc,
      },
      {
        'name': l10n.sleep,
        'icon': Icons.bedtime_rounded,
        'color': semantics.sleep,
        'weight': 25,
        'currentScore': sleepScore.round(),
        'description': l10n.sleepQualityDesc,
      },
      {
        'name': l10n.water,
        'icon': Icons.water_drop_rounded,
        'color': semantics.water,
        'weight': 25,
        'currentScore': waterScore.round(),
        'description': l10n.hydrationGoalDesc,
      },
      {
        'name': l10n.pedometer,
        'icon': Icons.directions_walk_rounded,
        'color': semantics.steps,
        'weight': 25,
        'currentScore': stepsScore.round(),
        'description': l10n.dailyStepGoal,
      },
    ];

    return Scaffold(
      appBar: AllyAppBar(title: l10n.healthScore),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AllySpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Main score ring (inverse monochrome hero) ────────────────
              Hero(
                tag: 'health_score_card',
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AllySpacing.huge),
                    decoration: BoxDecoration(
                      color: scheme.onSurface,
                      borderRadius: AllyRadius.lgAll,
                    ),
                    child: Column(
                      children: [
                        Text(
                          l10n.yourHealthScore,
                          style: AllyTypography.label(
                            size: 16,
                            color: scheme.surface,
                          ),
                        ),
                        const SizedBox(height: AllySpacing.xl),
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              width: 190,
                              height: 190,
                              child: CircularProgressIndicator(
                                value: healthScore / 100,
                                strokeWidth: 10,
                                strokeCap: StrokeCap.round,
                                backgroundColor: scheme.surface.withValues(
                                  alpha: 0.18,
                                ),
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  scheme.surface,
                                ),
                              ),
                            ),
                            Column(
                              children: [
                                Text(
                                  '$healthScore',
                                  style: AllyTypography.metric(
                                    size: 68,
                                    color: scheme.surface,
                                    weight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  l10n.outOf100,
                                  style: AllyTypography.caption(
                                    color: scheme.surface.withValues(
                                      alpha: 0.65,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AllySpacing.sectionLg),
              AllySectionHeader(title: l10n.scoreBreakdown),
              const SizedBox(height: AllySpacing.lg),
              ...scoreBreakdown.map(
                (item) => Container(
                  margin: const EdgeInsets.only(bottom: AllySpacing.md),
                  child: AllyCard(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              width: AllyDimensions.iconChip,
                              height: AllyDimensions.iconChip,
                              decoration: BoxDecoration(
                                color: (item['color'] as Color).withValues(
                                  alpha: 0.14,
                                ),
                                borderRadius: AllyRadius.smAll,
                              ),
                              child: Icon(
                                item['icon'] as IconData,
                                color: item['color'] as Color,
                                size: AllyDimensions.iconSm,
                              ),
                            ),
                            const SizedBox(width: AllySpacing.lg),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item['name'] as String,
                                    style: AllyTypography.label(
                                      size: 15,
                                      color: scheme.onSurface,
                                    ),
                                  ),
                                  Text(
                                    item['description'] as String,
                                    style: AllyTypography.caption(
                                      color: scheme.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  l10n.scoreSlashWeight(
                                    item['currentScore'].toString(),
                                    item['weight'].toString(),
                                  ),
                                  style: AllyTypography.metric(
                                    size: 18,
                                    color: item['color'] as Color,
                                  ),
                                ),
                                Text(
                                  l10n.weightPercent(item['weight']),
                                  style: AllyTypography.caption(
                                    color: scheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: AllySpacing.lg),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(2),
                          child: LinearProgressIndicator(
                            value:
                                (item['currentScore'] as int) /
                                (item['weight'] as int),
                            minHeight: 4,
                            backgroundColor: scheme.outlineVariant,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              item['color'] as Color,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AllySpacing.huge),
            ],
          ),
        ),
      ),
    );
  }
}
