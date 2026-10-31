// heartbeat.dart
//
// © 2026 Vertex Corporation
// ─────────────────────────────────────────────────────────────────────────────
// Heart rate. The measurement logic and data source are untouched; presentation
// follows the design system with the restrained heart-red accent and honest
// empty states (no invented readings, no diagnoses).

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../design_system/design_system.dart';
import '../l10n/app_localizations.dart';
import '../providers/health.dart';

class HeartbeatScreen extends StatefulWidget {
  const HeartbeatScreen({super.key});

  @override
  State<HeartbeatScreen> createState() => _HeartbeatScreenState();
}

class _HeartbeatScreenState extends State<HeartbeatScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.12).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;
    final AllySemanticPalette semantics = context.allySemantics;
    final heartColor = semantics.heartRate;

    final healthProvider = Provider.of<HealthProvider>(context);
    final healthData = healthProvider.healthData;
    final currentBpm = healthData.currentBpm;
    final hasData = currentBpm > 0;

    return Scaffold(
      appBar: AllyAppBar(title: l10n.heartRate),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AllySpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Current heart rate ──────────────────────────────────────
              Hero(
                tag: 'heartbeat_card',
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
                                color: heartColor.withValues(alpha: 0.14),
                                borderRadius: AllyRadius.smAll,
                              ),
                              child: Icon(
                                Icons.monitor_heart_rounded,
                                color: heartColor,
                                size: AllyDimensions.iconSm,
                              ),
                            ),
                            const Spacer(),
                            if (hasData)
                              AnimatedBuilder(
                                animation: _pulseAnimation,
                                builder: (context, child) {
                                  return Transform.scale(
                                    scale: _pulseAnimation.value,
                                    child: Icon(
                                      Icons.favorite_rounded,
                                      color: heartColor,
                                      size: AllyDimensions.iconMd,
                                    ),
                                  );
                                },
                              ),
                          ],
                        ),
                        const SizedBox(height: AllySpacing.xl),
                        Text(
                          l10n.currentHeartRate,
                          style: AllyTypography.label(
                            size: 14,
                            color: scheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: AllySpacing.sm),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              hasData ? '$currentBpm' : '—',
                              style: AllyTypography.metric(
                                size: 64,
                                color: scheme.onSurface,
                                weight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(width: AllySpacing.md),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: Text(
                                l10n.bpmUnit,
                                style: AllyTypography.body(
                                  size: 20,
                                  color: scheme.onSurfaceVariant,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: AllySpacing.section),

              // ── Readings ────────────────────────────────────────────────
              AllySectionHeader(title: l10n.todaysReadings),
              const SizedBox(height: AllySpacing.lg),
              Expanded(
                child: AllyCard(
                  child: AllyEmptyState(
                    icon: Icons.monitor_heart_outlined,
                    title: l10n.noReadingsYet,
                    message: l10n.requiresMonitor,
                    compact: true,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
