// weight.dart
//
// © 2026 Vertex Corporation
// ─────────────────────────────────────────────────────────────────────────────
// Weight tracking. Conversion logic and history storage are unchanged; deltas
// use the semantic success color for loss and error tone for gain — always
// paired with a sign, never color alone.

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../design_system/design_system.dart';
import '../l10n/app_localizations.dart';
import '../providers/health.dart';
import '../utils/converter.dart';

class WeightScreen extends StatefulWidget {
  const WeightScreen({super.key});

  @override
  State<WeightScreen> createState() => _WeightScreenState();
}

class _WeightScreenState extends State<WeightScreen> {
  void _showUpdateWeightDialog() {
    final TextEditingController weightController = TextEditingController();
    final l10n = AppLocalizations.of(context)!;

    AllySheet.show(
      context,
      title: l10n.updateWeight,
      icon: Icons.monitor_weight_rounded,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AllyTextField(
            controller: weightController,
            autofocus: true,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            hint:
                Provider.of<HealthProvider>(context, listen: false).units ==
                    'imperial'
                ? l10n.enterWeightLbs
                : l10n.enterWeightKg,
          ),
          const SizedBox(height: AllySpacing.xl),
          Row(
            children: [
              Expanded(
                child: AllyButton(
                  label: l10n.cancel,
                  kind: AllyButtonKind.ghost,
                  small: true,
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              Expanded(
                child: AllyButton(
                  label: l10n.save,
                  small: true,
                  onPressed: () {
                    final weight = double.tryParse(weightController.text);
                    if (weight != null && weight > 0) {
                      // Convert to kg if imperial
                      final units = Provider.of<HealthProvider>(
                        context,
                        listen: false,
                      ).units;
                      final weightInKg = units == 'imperial'
                          ? UnitConverter.lbsToKg(weight)
                          : weight;
                      Provider.of<HealthProvider>(
                        context,
                        listen: false,
                      ).updateWeight(weightInKg);
                      Navigator.pop(context);
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;
    final AllySemanticPalette semantics = context.allySemantics;
    final weightColor = semantics.weight;

    final healthProvider = Provider.of<HealthProvider>(context);
    final healthData = healthProvider.healthData;
    final currentWeight = healthData.currentWeight;
    final goalWeight = healthData.goalWeight;

    final bool hasWeight = currentWeight > 0;

    return Scaffold(
      appBar: AllyAppBar(title: l10n.weight),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AllySpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Current weight ──────────────────────────────────────────
              AllyCard(
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
                            color: weightColor.withValues(alpha: 0.14),
                            borderRadius: AllyRadius.smAll,
                          ),
                          child: Icon(
                            Icons.monitor_weight_rounded,
                            color: weightColor,
                            size: AllyDimensions.iconSm,
                          ),
                        ),
                        const Spacer(),
                        AllyButton(
                          label: l10n.editGoal,
                          kind: AllyButtonKind.ghost,
                          small: true,
                          expanded: false,
                          onPressed: _showUpdateWeightDialog,
                        ),
                      ],
                    ),
                    const SizedBox(height: AllySpacing.xl),
                    Text(
                      hasWeight
                          ? UnitConverter.formatWeight(
                              currentWeight,
                              healthProvider.units,
                            )
                          : '—',
                      style: AllyTypography.metric(
                        size: 56,
                        color: scheme.onSurface,
                        weight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: AllySpacing.sm),
                    Text(
                      goalWeight > 0
                          ? '${l10n.goalWeight}: ${UnitConverter.formatWeight(goalWeight, healthProvider.units)}'
                          : l10n.noWeightHistory,
                      style: AllyTypography.body(
                        size: 15,
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AllySpacing.section),

              // ── History ──────────────────────────────────────────────────
              AllySectionHeader(title: l10n.weightHistory),
              const SizedBox(height: AllySpacing.lg),

              // Trend of the recorded entries (real data only, ≥2 points).
              if (healthData.weightHistory.length >= 2) ...[
                AllyCard(
                  padding: const EdgeInsets.all(AllySpacing.lg),
                  child: SizedBox(
                    height: 150,
                    child: _WeightTrendChart(
                      entries: healthData.weightHistory,
                      accent: weightColor,
                    ),
                  ),
                ),
                const SizedBox(height: AllySpacing.md),
              ],

              Expanded(
                child: healthData.weightHistory.isEmpty
                    ? AllyEmptyState(
                        icon: Icons.show_chart_rounded,
                        title: l10n.noWeightHistory,
                        message: l10n.personalizeHealthGoals,
                      )
                    : ListView.builder(
                        itemCount: healthData.weightHistory.length,
                        itemBuilder: (context, index) {
                          final entry = healthData.weightHistory[index];
                          final weight = entry['weight'] as double;
                          final dateStr = entry['date'] as String;
                          final date = DateTime.parse(dateStr);

                          final timeStr =
                              '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';

                          final bool isLoss =
                              index < healthData.weightHistory.length - 1 &&
                              (weight -
                                      (healthData.weightHistory[index +
                                              1]['weight']
                                          as double)) <
                                  0;
                          final bool hasDelta =
                              index < healthData.weightHistory.length - 1;

                          return Container(
                            margin: const EdgeInsets.only(
                              bottom: AllySpacing.md,
                            ),
                            child: AllyCard(
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(
                                      AllySpacing.md,
                                    ),
                                    decoration: BoxDecoration(
                                      color: weightColor.withValues(
                                        alpha: 0.12,
                                      ),
                                      borderRadius: AllyRadius.smAll,
                                    ),
                                    child: Icon(
                                      Icons.monitor_weight_rounded,
                                      color: weightColor,
                                      size: AllyDimensions.iconSm,
                                    ),
                                  ),
                                  const SizedBox(width: AllySpacing.lg),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          UnitConverter.formatWeight(
                                            weight,
                                            healthProvider.units,
                                          ),
                                          style: AllyTypography.label(
                                            size: 16,
                                            color: scheme.onSurface,
                                          ),
                                        ),
                                        Text(
                                          timeStr,
                                          style: AllyTypography.caption(
                                            color: scheme.onSurfaceVariant,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (hasDelta)
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: AllySpacing.md,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color:
                                            (isLoss
                                                    ? semantics.success
                                                    : semantics.error)
                                                .withValues(alpha: 0.12),
                                        borderRadius: AllyRadius.smAll,
                                      ),
                                      child: Text(
                                        '${(weight - (healthData.weightHistory[index + 1]['weight'] as double)) > 0 ? '+' : ''}${(weight - (healthData.weightHistory[index + 1]['weight'] as double)).toStringAsFixed(1)}',
                                        style: AllyTypography.label(
                                          size: 13,
                                          color: isLoss
                                              ? semantics.success
                                              : semantics.error,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Smooth line chart over the recorded weight entries (oldest → newest).
class _WeightTrendChart extends StatelessWidget {
  final List<Map<String, dynamic>> entries;
  final Color accent;

  const _WeightTrendChart({required this.entries, required this.accent});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;

    // Entries are stored newest-first; charts read oldest → newest.
    final List<double> values = [
      for (final entry in entries.reversed) entry['weight'] as double,
    ];

    final double minY = values.reduce((a, b) => a < b ? a : b);
    final double maxY = values.reduce((a, b) => a > b ? a : b);
    final double pad = ((maxY - minY) * 0.2).clamp(0.5, 4.0);

    return LineChart(
      LineChartData(
        minY: minY - pad,
        maxY: maxY + pad,
        lineTouchData: const LineTouchData(enabled: true),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: (maxY - minY) / 2 <= 0 ? 1 : (maxY - minY) / 2,
          getDrawingHorizontalLine: (value) =>
              FlLine(color: scheme.outlineVariant, strokeWidth: 1),
        ),
        titlesData: const FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: [
              for (int i = 0; i < values.length; i++)
                FlSpot(i.toDouble(), values[i]),
            ],
            isCurved: true,
            curveSmoothness: 0.25,
            barWidth: 2.2,
            color: accent,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  accent.withValues(alpha: 0.10),
                  accent.withValues(alpha: 0.0),
                ],
              ),
            ),
          ),
        ],
      ),
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOutCubic,
    );
  }
}
