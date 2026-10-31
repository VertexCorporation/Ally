// pedometer.dart
//
// © 2026 Vertex Corporation
// ─────────────────────────────────────────────────────────────────────────────
// Step tracking. The 2-second native-preference polling loop, service control
// dialog and goal setting are preserved; the visual is now the shared metric
// layout with the restrained steps accent.

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../design_system/design_system.dart';
import '../l10n/app_localizations.dart';
import '../providers/health.dart';
import '../widgets/dialogs.dart';

class PedometerScreen extends StatefulWidget {
  const PedometerScreen({super.key});

  @override
  State<PedometerScreen> createState() => _PedometerScreenState();
}

class _PedometerScreenState extends State<PedometerScreen> {
  Timer? _updateTimer;

  @override
  void initState() {
    super.initState();

    // Load initial steps directly
    _loadInitialSteps();

    // Read steps every 2 seconds from SharedPreferences
    _updateTimer = Timer.periodic(const Duration(seconds: 2), (timer) async {
      await _loadStepsFromPrefs();
    });
  }

  Future<void> _loadInitialSteps() async {
    await _loadStepsFromPrefs();
  }

  Future<void> _loadStepsFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now();
    final today = '${now.day}/${now.month}/${now.year}';
    final steps = prefs.getInt('steps_$today') ?? 0;

    if (mounted) {
      final healthProvider = Provider.of<HealthProvider>(
        context,
        listen: false,
      );
      healthProvider.updateStepsFromSensor(steps);
    }
  }

  @override
  void dispose() {
    _updateTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;
    final AllySemanticPalette semantics = context.allySemantics;
    final stepsColor = semantics.steps;

    final healthProvider = Provider.of<HealthProvider>(context);
    final healthData = healthProvider.healthData;

    final progress = (healthData.currentSteps / healthData.stepsGoal).clamp(
      0.0,
      1.0,
    );

    return Scaffold(
      appBar: AllyAppBar(title: l10n.pedometer),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AllySpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Steps overview ──────────────────────────────────────────
              Hero(
                tag: 'pedometer_card',
                child: Material(
                  color: Colors.transparent,
                  child: AllyCard(
                    padding: const EdgeInsets.all(AllySpacing.xxl),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: AllyDimensions.iconChip,
                              height: AllyDimensions.iconChip,
                              decoration: BoxDecoration(
                                color: stepsColor.withValues(alpha: 0.14),
                                borderRadius: AllyRadius.smAll,
                              ),
                              child: Icon(
                                Icons.directions_walk_rounded,
                                color: stepsColor,
                                size: AllyDimensions.iconSm,
                              ),
                            ),
                            const Spacer(),
                          ],
                        ),
                        const SizedBox(height: AllySpacing.xl),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '${healthData.currentSteps}',
                              style: AllyTypography.metric(
                                size: 56,
                                color: scheme.onSurface,
                                weight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(width: AllySpacing.md),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Text(
                                l10n.steps(
                                  healthData.currentSteps,
                                  healthData.stepsGoal,
                                ),
                                style: AllyTypography.body(
                                  size: 15,
                                  color: scheme.onSurfaceVariant,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AllySpacing.xl),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(2),
                          child: LinearProgressIndicator(
                            value: progress,
                            minHeight: 6,
                            backgroundColor: scheme.outlineVariant,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              stepsColor,
                            ),
                          ),
                        ),
                        const SizedBox(height: AllySpacing.sm),
                        Center(
                          child: Text(
                            '${(progress * 100).toInt()}% ${l10n.completed}',
                            style: AllyTypography.caption(
                              color: scheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: AllySpacing.section),

              // ── Quick actions ───────────────────────────────────────────
              AllySectionHeader(title: l10n.quickActions),
              const SizedBox(height: AllySpacing.lg),
              Row(
                children: [
                  Expanded(
                    child: _PedometerActionButton(
                      label: l10n.service,
                      icon: Icons.settings_suggest_rounded,
                      onTap: () {
                        CustomDialogs.showServiceControlDialog(context);
                      },
                    ),
                  ),
                  const SizedBox(width: AllySpacing.md),
                  Expanded(
                    child: _PedometerActionButton(
                      label: l10n.setGoal,
                      icon: Icons.flag_rounded,
                      onTap: () {
                        CustomDialogs.showSetGoalDialog(
                          context,
                          healthProvider.healthData.stepsGoal,
                          (goal) {
                            healthProvider.updateStepsGoal(goal);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PedometerActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _PedometerActionButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;

    return AllyCard(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: scheme.onSurface, size: AllyDimensions.iconSm),
          const SizedBox(width: AllySpacing.sm),
          Flexible(
            child: Text(
              label,
              overflow: TextOverflow.ellipsis,
              style: AllyTypography.label(size: 15, color: scheme.onSurface),
            ),
          ),
        ],
      ),
    );
  }
}
