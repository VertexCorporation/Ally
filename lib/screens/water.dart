// water.dart
//
// © 2026 Vertex Corporation
// ─────────────────────────────────────────────────────────────────────────────
// Hydration screen. Data flow (HealthProvider + unit conversion) is unchanged;
// the giant tinted panel is replaced by the shared metric layout with a
// restrained water-blue accent and a quiet ring progress.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../design_system/design_system.dart';
import '../l10n/app_localizations.dart';
import '../notifications/introvert.dart';
import '../providers/health.dart';
import '../utils/converter.dart';

class WaterScreen extends StatefulWidget {
  const WaterScreen({super.key});

  @override
  State<WaterScreen> createState() => _WaterScreenState();
}

class _WaterScreenState extends State<WaterScreen> {
  void _addWater(int ml) {
    final healthProvider = Provider.of<HealthProvider>(context, listen: false);
    healthProvider.addWaterMl(ml);
  }

  void _showGoalDialog() {
    final healthProvider = Provider.of<HealthProvider>(context, listen: false);
    final l10n = AppLocalizations.of(context)!;
    final isImperial = healthProvider.units == 'imperial';
    final currentGoalMl = healthProvider.healthData.waterGoal * 250;

    final displayGoal = isImperial
        ? UnitConverter.mlToOz(currentGoalMl).round()
        : currentGoalMl;

    final controller = TextEditingController(text: displayGoal.toString());

    AllySheet.show(
      context,
      title: l10n.setWaterGoal,
      subtitle: l10n.howMuchWater,
      icon: Icons.flag_rounded,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: AllySpacing.lg),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: AllyRadius.smAll,
              border: Border.all(
                color: Theme.of(context).colorScheme.outlineVariant,
              ),
            ),
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              style: AllyTypography.metric(
                size: 32,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: isImperial ? '64' : '2000',
                suffixText: isImperial ? 'oz' : 'ml',
                suffixStyle: AllyTypography.caption(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ),
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
                    final val = int.tryParse(controller.text);
                    if (val != null && val > 0) {
                      final ml = isImperial
                          ? UnitConverter.ozToMl(val.toDouble()).round()
                          : val;
                      healthProvider.updateWaterGoalMl(ml);
                      Navigator.pop(context);

                      context
                          .read<IntrovertNotificationService>()
                          .showNotification(
                            message: l10n.dailyGoalSetTo(
                              val.toString(),
                              isImperial ? 'oz' : 'ml',
                            ),
                            type: NotificationType.success,
                          );
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
    final waterColor = semantics.water;

    return Scaffold(
      appBar: AllyAppBar(title: l10n.water),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AllySpacing.xl),
          child: Consumer<HealthProvider>(
            builder: (context, healthProvider, _) {
              final healthData = healthProvider.healthData;
              final isImperial = healthProvider.units == 'imperial';
              final dailyGoal = healthData.waterGoal;
              final glassesConsumed = healthData.waterGlasses;

              final displayConsumed = isImperial
                  ? UnitConverter.mlToOz(glassesConsumed * 250).round()
                  : glassesConsumed * 250;
              final displayGoalValue = isImperial
                  ? UnitConverter.mlToOz(dailyGoal * 250).round()
                  : dailyGoal * 250;
              final unit = isImperial ? 'oz' : 'ml';

              final progress = (glassesConsumed / dailyGoal).clamp(0.0, 1.0);

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Intake overview ─────────────────────────────────────
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
                                color: waterColor.withValues(alpha: 0.14),
                                borderRadius: AllyRadius.smAll,
                              ),
                              child: Icon(
                                Icons.water_drop_rounded,
                                color: waterColor,
                                size: AllyDimensions.iconSm,
                              ),
                            ),
                            const Spacer(),
                            AllyButton(
                              label: l10n.editGoal,
                              kind: AllyButtonKind.ghost,
                              small: true,
                              expanded: false,
                              onPressed: _showGoalDialog,
                            ),
                          ],
                        ),
                        const SizedBox(height: AllySpacing.xl),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '$displayConsumed',
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
                                l10n.ofValueUnit(
                                  displayGoalValue.toString(),
                                  unit,
                                ),
                                style: AllyTypography.body(
                                  size: 16,
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
                              waterColor,
                            ),
                          ),
                        ),
                        const SizedBox(height: AllySpacing.sm),
                        Text(
                          l10n.waterGoalLabel,
                          style: AllyTypography.caption(
                            color: scheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: AllySpacing.section),

                  // ── Quick add ────────────────────────────────────────────
                  AllySectionHeader(title: l10n.quickAdd),
                  const SizedBox(height: AllySpacing.lg),
                  Row(
                    children: [
                      Expanded(
                        child: _QuickAddButton(
                          label: isImperial ? '8oz' : '200ml',
                          icon: Icons.water_drop_rounded,
                          accent: waterColor,
                          onTap: () => _addWater(
                            isImperial ? UnitConverter.ozToMl(8).round() : 200,
                          ),
                        ),
                      ),
                      const SizedBox(width: AllySpacing.md),
                      Expanded(
                        child: _QuickAddButton(
                          label: isImperial ? '16oz' : '500ml',
                          icon: Icons.water_drop_rounded,
                          accent: waterColor,
                          onTap: () => _addWater(
                            isImperial ? UnitConverter.ozToMl(16).round() : 500,
                          ),
                        ),
                      ),
                      const SizedBox(width: AllySpacing.md),
                      Expanded(
                        child: _QuickAddButton(
                          label: isImperial ? '32oz' : '1L',
                          icon: Icons.water_drop_rounded,
                          accent: waterColor,
                          onTap: () => _addWater(
                            isImperial
                                ? UnitConverter.ozToMl(32).round()
                                : 1000,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _QuickAddButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color accent;
  final VoidCallback onTap;

  const _QuickAddButton({
    required this.label,
    required this.icon,
    required this.accent,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;

    return Material(
      color: theme.cardColor,
      borderRadius: AllyRadius.mdAll,
      child: InkWell(
        onTap: onTap,
        borderRadius: AllyRadius.mdAll,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: AllySpacing.xl),
          decoration: BoxDecoration(
            borderRadius: AllyRadius.mdAll,
            border: Border.all(color: scheme.outlineVariant),
          ),
          child: Column(
            children: [
              Icon(icon, color: accent, size: AllyDimensions.iconLg),
              const SizedBox(height: AllySpacing.sm),
              Text(
                label,
                style: AllyTypography.label(size: 15, color: scheme.onSurface),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
