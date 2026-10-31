// account.dart
//
// © 2026 Vertex Corporation
// ─────────────────────────────────────────────────────────────────────────────
// Account & profile management. All edit dialogs, unit-aware conversions, BMI
// calculation and the danger zone are preserved; presentation uses the design
// system.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../design_system/design_system.dart';
import '../l10n/app_localizations.dart';
import '../providers/health.dart';
import '../server/user.dart';
import '../utils/converter.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.98,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleBack() {
    _controller.reverse().then((_) {
      if (mounted) {
        Navigator.pop(context);
      }
    });
  }

  // --- Helper: Dynamic Modal ---
  void _showEditDialog({
    required String title,
    required IconData icon,
    required String currentValue,
    required String label,
    required String? suffix,
    required Function(String) onSave,
    TextInputType keyboardType = TextInputType.text,
  }) {
    final controller = TextEditingController(text: currentValue);

    AllySheet.show(
      context,
      title: title,
      icon: icon,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AllyTextField(
            controller: controller,
            autofocus: true,
            keyboardType: keyboardType,
            label: label,
          ),
          const SizedBox(height: AllySpacing.xl),
          Row(
            children: [
              Expanded(
                child: AllyButton(
                  label: AppLocalizations.of(context)!.cancel,
                  kind: AllyButtonKind.ghost,
                  small: true,
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              Expanded(
                child: AllyButton(
                  label: AppLocalizations.of(context)!.save,
                  small: true,
                  onPressed: () {
                    if (controller.text.isNotEmpty) {
                      onSave(controller.text);
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

  // --- Logic Methods (Dialog Triggers) ---

  void _showEditWeightDialog() {
    final healthProvider = Provider.of<HealthProvider>(context, listen: false);
    final isImperial = healthProvider.units == 'imperial';
    final currentWeight = healthProvider.healthData.currentWeight;
    final displayWeight = isImperial
        ? UnitConverter.kgToLbs(currentWeight)
        : currentWeight;

    _showEditDialog(
      title: AppLocalizations.of(context)!.editWeight,
      icon: Icons.monitor_weight_rounded,
      currentValue: displayWeight.toStringAsFixed(1),
      label: AppLocalizations.of(context)!.currentWeight,
      suffix: isImperial ? 'lbs' : 'kg',
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      onSave: (value) {
        final weight = double.tryParse(value);
        if (weight != null && weight > 0) {
          final weightInKg = isImperial
              ? UnitConverter.lbsToKg(weight)
              : weight;
          healthProvider.updateWeight(weightInKg);
        }
      },
    );
  }

  void _showEditWaterGoalDialog() {
    final healthProvider = Provider.of<HealthProvider>(context, listen: false);
    _showEditDialog(
      title: AppLocalizations.of(context)!.editWaterGoal,
      icon: Icons.water_drop_rounded,
      currentValue: healthProvider.healthData.waterGoal.toString(),
      label: AppLocalizations.of(context)!.waterGoalLabel,
      suffix: AppLocalizations.of(context)!.glasses,
      keyboardType: TextInputType.number,
      onSave: (value) {
        final goal = int.tryParse(value);
        if (goal != null && goal > 0) {
          healthProvider.updateWaterGoal(goal);
        }
      },
    );
  }

  void _showEditCalorieGoalDialog() {
    final healthProvider = Provider.of<HealthProvider>(context, listen: false);
    _showEditDialog(
      title: AppLocalizations.of(context)!.editCalorieGoal,
      icon: Icons.local_fire_department_rounded,
      currentValue: healthProvider.healthData.caloriesGoal.toString(),
      label: AppLocalizations.of(context)!.calorieGoalLabel,
      suffix: AppLocalizations.of(context)!.kcal,
      keyboardType: TextInputType.number,
      onSave: (value) {
        final goal = int.tryParse(value);
        if (goal != null && goal > 0) {
          healthProvider.updateCaloriesGoal(goal);
        }
      },
    );
  }

  void _showEditGoalWeightDialog() {
    final healthProvider = Provider.of<HealthProvider>(context, listen: false);
    final isImperial = healthProvider.units == 'imperial';
    final goalWeight = healthProvider.healthData.goalWeight;
    final displayWeight = isImperial
        ? UnitConverter.kgToLbs(goalWeight)
        : goalWeight;

    _showEditDialog(
      title: AppLocalizations.of(context)!.editWeight,
      icon: Icons.flag_rounded,
      currentValue: displayWeight.toStringAsFixed(1),
      label: AppLocalizations.of(context)!.goalWeight,
      suffix: isImperial ? 'lbs' : 'kg',
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      onSave: (value) {
        final weight = double.tryParse(value);
        if (weight != null && weight > 0) {
          final weightInKg = isImperial
              ? UnitConverter.lbsToKg(weight)
              : weight;
          healthProvider.updateTargetWeight(weightInKg);
        }
      },
    );
  }

  void _showEditHeightDialog() {
    final healthProvider = Provider.of<HealthProvider>(context, listen: false);
    final l10n = AppLocalizations.of(context)!;
    final isImperial = healthProvider.units == 'imperial';

    if (!isImperial) {
      final height = healthProvider.healthData.height;
      _showEditDialog(
        title: l10n.editHeight,
        icon: Icons.height_rounded,
        currentValue: height.toStringAsFixed(1),
        label: l10n.height,
        suffix: l10n.cm,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        onSave: (value) {
          final h = double.tryParse(value);
          if (h != null && h > 0) {
            healthProvider.updateHeight(h);
          }
        },
      );
      return;
    }

    // Imperial - Custom Dialog
    final heightCm = healthProvider.healthData.height;
    final totalInches = heightCm / 2.54;
    final feet = (totalInches / 12).floor();
    final inches = (totalInches % 12).round();

    final feetController = TextEditingController(text: feet.toString());
    final inchesController = TextEditingController(text: inches.toString());

    showDialog(
      context: context,
      builder: (dialogContext) {
        final ThemeData theme = Theme.of(dialogContext);
        return AlertDialog(
          title: Text(l10n.editHeight),
          content: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: feetController,
                  keyboardType: TextInputType.number,
                  style: theme.textTheme.bodyLarge,
                  decoration: InputDecoration(labelText: l10n.feet),
                ),
              ),
              const SizedBox(width: AllySpacing.md),
              Expanded(
                child: TextField(
                  controller: inchesController,
                  keyboardType: TextInputType.number,
                  style: theme.textTheme.bodyLarge,
                  decoration: InputDecoration(labelText: l10n.inches),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(l10n.cancel),
            ),
            TextButton(
              onPressed: () {
                final f = double.tryParse(feetController.text) ?? 0;
                final i = double.tryParse(inchesController.text) ?? 0;
                if (f > 0 || i > 0) {
                  final heightInCm = UnitConverter.feetAndInchesToCm(
                    f.round(),
                    i.round(),
                  );
                  healthProvider.updateHeight(heightInCm.toDouble());
                  Navigator.pop(dialogContext);
                }
              },
              child: Text(l10n.save),
            ),
          ],
        );
      },
    );
  }

  Color _bmiCategoryColor(String category, AllySemanticPalette semantics) {
    if (category.contains('Normal')) return semantics.success;
    if (category.contains('Underweight')) return semantics.info;
    if (category.contains('Overweight')) return semantics.warning;
    return semantics.error;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;
    final AllySemanticPalette semantics = context.allySemantics;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _handleBack();
      },
      child: Scaffold(
        appBar: AllyAppBar(title: l10n.account, onBack: _handleBack),
        body: FadeTransition(
          opacity: _fadeAnimation,
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: SafeArea(
              child: Consumer<UserProvider>(
                builder: (context, userProvider, child) {
                  // Extract User Data safely
                  final userData = userProvider.userData;
                  final username = userProvider.username;
                  final isAnon = userProvider.isAnonymous;
                  final country =
                      userData?['country'] as String? ?? l10n.notSet;
                  final healthData = context.watch<HealthProvider>().healthData;

                  final bmi = healthData.bmi;
                  final bmiCategory = healthData.bmiCategory;
                  final bmiColor = _bmiCategoryColor(bmiCategory, semantics);

                  return CustomScrollView(
                    physics: const BouncingScrollPhysics(),
                    slivers: [
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.all(AllySpacing.xl),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // 1. Profile Card
                              AllyCard(
                                padding: const EdgeInsets.all(AllySpacing.xxl),
                                child: Row(
                                  children: [
                                    Stack(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(3),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: scheme.onSurface,
                                          ),
                                          child: Container(
                                            width: 64,
                                            height: 64,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: theme.cardColor,
                                            ),
                                            alignment: Alignment.center,
                                            child: Text(
                                              userProvider.profileInitial,
                                              style: AllyTypography.metric(
                                                size: 28,
                                                color: scheme.onSurface,
                                              ),
                                            ),
                                          ),
                                        ),
                                        if (!isAnon)
                                          Positioned(
                                            bottom: 0,
                                            right: 0,
                                            child: Container(
                                              padding: const EdgeInsets.all(6),
                                              decoration: BoxDecoration(
                                                color: scheme.onSurface,
                                                shape: BoxShape.circle,
                                              ),
                                              child: Icon(
                                                Icons.edit_rounded,
                                                size: 12,
                                                color: scheme.surface,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                    const SizedBox(width: AllySpacing.lg),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            username,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: AllyTypography.headline(
                                              size: 20,
                                              color: scheme.onSurface,
                                            ),
                                          ),
                                          if (userData != null &&
                                              userData['email'] != null)
                                            Text(
                                              userData['email'] as String,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: AllyTypography.caption(
                                                color: scheme.onSurfaceVariant,
                                              ),
                                            ),
                                          if (isAnon)
                                            Container(
                                              margin: const EdgeInsets.only(
                                                top: AllySpacing.sm,
                                              ),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: AllySpacing.md,
                                                    vertical: 2,
                                                  ),
                                              decoration: BoxDecoration(
                                                borderRadius: AllyRadius.pill,
                                                border: Border.all(
                                                  color: scheme.outlineVariant,
                                                ),
                                              ),
                                              child: Text(
                                                l10n.helloAnonymous.replaceAll(
                                                  ',',
                                                  '',
                                                ),
                                                style: AllyTypography.caption(
                                                  color:
                                                      scheme.onSurfaceVariant,
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: AllySpacing.section),

                              // 2. Personal Information
                              AllySectionHeader(
                                title: l10n.personalInformation,
                              ),
                              const SizedBox(height: AllySpacing.md),
                              _InfoTile(
                                title: l10n.username,
                                value: username,
                                icon: Icons.person_rounded,
                                accent: scheme.onSurfaceVariant,
                                isEditable: true,
                              ),
                              const SizedBox(height: AllySpacing.md),
                              _InfoTile(
                                title: l10n.country,
                                value: country,
                                icon: Icons.public_rounded,
                                accent: scheme.onSurfaceVariant,
                              ),
                              const SizedBox(height: AllySpacing.md),
                              _InfoTile(
                                title: l10n.height,
                                value: UnitConverter.formatHeight(
                                  healthData.height,
                                  context.read<HealthProvider>().units,
                                ),
                                icon: Icons.height_rounded,
                                accent: scheme.onSurfaceVariant,
                                isEditable: true,
                                onTap: _showEditHeightDialog,
                              ),
                              const SizedBox(height: AllySpacing.md),
                              _InfoTile(
                                title: l10n.currentWeight,
                                value: UnitConverter.formatWeight(
                                  healthData.currentWeight,
                                  context.read<HealthProvider>().units,
                                ),
                                icon: Icons.monitor_weight_rounded,
                                accent: semantics.weight,
                                isEditable: true,
                                onTap: _showEditWeightDialog,
                              ),

                              const SizedBox(height: AllySpacing.section),

                              // 3. Goals
                              AllySectionHeader(title: l10n.goals),
                              const SizedBox(height: AllySpacing.md),
                              _InfoTile(
                                title: l10n.goalWeight,
                                value: UnitConverter.formatWeight(
                                  healthData.goalWeight,
                                  context.read<HealthProvider>().units,
                                ),
                                icon: Icons.flag_rounded,
                                accent: semantics.weight,
                                isEditable: true,
                                onTap: _showEditGoalWeightDialog,
                              ),
                              const SizedBox(height: AllySpacing.md),
                              _InfoTile(
                                title: l10n.waterGoalLabel,
                                value:
                                    '${healthData.waterGoal} ${l10n.glasses}',
                                icon: Icons.water_drop_rounded,
                                accent: semantics.water,
                                isEditable: true,
                                onTap: _showEditWaterGoalDialog,
                              ),
                              const SizedBox(height: AllySpacing.md),
                              _InfoTile(
                                title: l10n.calorieGoalLabel,
                                value:
                                    '${healthData.caloriesGoal} ${l10n.kcal}',
                                icon: Icons.local_fire_department_rounded,
                                accent: semantics.nutrition,
                                isEditable: true,
                                onTap: _showEditCalorieGoalDialog,
                              ),

                              const SizedBox(height: AllySpacing.section),

                              // 4. Body Metrics — BMI
                              AllySectionHeader(title: l10n.bmiTitle),
                              const SizedBox(height: AllySpacing.md),
                              AllyCard(
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(
                                        AllySpacing.md,
                                      ),
                                      decoration: BoxDecoration(
                                        color: bmiColor.withValues(alpha: 0.12),
                                        borderRadius: AllyRadius.smAll,
                                      ),
                                      child: Icon(
                                        Icons.analytics_rounded,
                                        color: bmiColor,
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
                                            bmi == 0
                                                ? l10n.notCalculated
                                                : bmiCategory,
                                            style: AllyTypography.label(
                                              size: 14,
                                              color: bmiColor,
                                            ),
                                          ),
                                          Text(
                                            bmi == 0
                                                ? l10n.addHeightWeight
                                                : l10n.bmiLabel(
                                                    bmi.toStringAsFixed(1),
                                                  ),
                                            style: AllyTypography.label(
                                              size: 16,
                                              color: scheme.onSurface,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: AllySpacing.section),

                              // 5. Danger Zone
                              AllySectionHeader(title: l10n.dangerZone),
                              const SizedBox(height: AllySpacing.md),
                              AllyCard(
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(
                                        AllySpacing.md,
                                      ),
                                      decoration: BoxDecoration(
                                        color: semantics.error.withValues(
                                          alpha: 0.12,
                                        ),
                                        borderRadius: AllyRadius.smAll,
                                      ),
                                      child: Icon(
                                        Icons.delete_forever_rounded,
                                        color: semantics.error,
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
                                            l10n.deleteAccount,
                                            style: AllyTypography.label(
                                              size: 15,
                                              color: semantics.error,
                                            ),
                                          ),
                                          Text(
                                            l10n.deleteAccountDesc,
                                            style: AllyTypography.caption(
                                              color: scheme.onSurfaceVariant,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Icon(
                                      Icons.chevron_right_rounded,
                                      size: AllyDimensions.iconMd,
                                      color: scheme.outline,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SliverToBoxAdapter(child: SizedBox(height: 100)),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Read-only information row with optional edit affordance.
class _InfoTile extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color accent;
  final bool isEditable;
  final VoidCallback? onTap;

  const _InfoTile({
    required this.title,
    required this.value,
    required this.icon,
    required this.accent,
    this.isEditable = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;

    return AllyCard(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AllySpacing.md),
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.12),
              borderRadius: AllyRadius.smAll,
            ),
            child: Icon(icon, color: accent, size: AllyDimensions.iconSm),
          ),
          const SizedBox(width: AllySpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AllyTypography.caption(color: scheme.onSurfaceVariant),
                ),
                Text(
                  value,
                  style: AllyTypography.label(
                    size: 16,
                    color: scheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
          if (isEditable)
            Icon(
              Icons.edit_rounded,
              size: AllyDimensions.iconSm,
              color: scheme.onSurfaceVariant,
            ),
        ],
      ),
    );
  }
}
