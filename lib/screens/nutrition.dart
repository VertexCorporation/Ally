// nutrition.dart
//
// © 2026 Vertex Corporation
// ─────────────────────────────────────────────────────────────────────────────
// Nutrition tracking: goal management, plate-type → fill-level → food flow and
// the meal log. Food categories keep their meaningful but restrained accents;
// the canvas stays monochrome.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../design_system/design_system.dart';
import '../l10n/app_localizations.dart';
import '../notifications/introvert.dart';
import '../providers/health.dart';

class NutritionScreen extends StatefulWidget {
  const NutritionScreen({super.key});

  @override
  State<NutritionScreen> createState() => _NutritionScreenState();
}

class _NutritionScreenState extends State<NutritionScreen> {
  void _showGoalDialog() {
    final healthProvider = Provider.of<HealthProvider>(context, listen: false);
    final l10n = AppLocalizations.of(context)!;
    final currentGoal = healthProvider.healthData.caloriesGoal;
    final controller = TextEditingController(text: currentGoal.toString());

    AllySheet.show(
      context,
      title: l10n.setYourCalorieGoal,
      subtitle: l10n.howManyCalories,
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
                hintText: l10n.dailyCalorieHint,
                suffixText: 'kcal',
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
                  label: l10n.setGoal,
                  small: true,
                  onPressed: () {
                    final cal = int.tryParse(controller.text);
                    if (cal != null && cal > 0) {
                      healthProvider.updateCaloriesGoal(cal);
                      Navigator.pop(context);

                      context
                          .read<IntrovertNotificationService>()
                          .showNotification(
                            message: l10n.calorieGoalSet(cal),
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

  void _showAddMealDialog() {
    final l10n = AppLocalizations.of(context)!;

    AllySheet.show(
      context,
      title: l10n.selectPlateType,
      icon: Icons.restaurant_rounded,
      child: Row(
        children: [
          Expanded(
            child: _PlateTypeOption(
              title: l10n.plate,
              icon: Icons.dinner_dining_rounded,
              onTap: () => _showFillLevelDialog(l10n.plate),
            ),
          ),
          const SizedBox(width: AllySpacing.md),
          Expanded(
            child: _PlateTypeOption(
              title: l10n.bowl,
              icon: Icons.rice_bowl_rounded,
              onTap: () => _showFillLevelDialog(l10n.bowl),
            ),
          ),
        ],
      ),
    );
  }

  void _showFillLevelDialog(String plateType) {
    final l10n = AppLocalizations.of(context)!;

    AllySheet.show(
      context,
      title: l10n.fillLevel,
      subtitle: '$plateType - ${l10n.selectPlateType}',
      icon: Icons.restaurant_rounded,
      child: Column(
        children: [
          _FillLevelOption(
            title: l10n.quarter,
            fillLevel: 0.25,
            plateType: plateType,
            onSelected: (fillTitle, grams) =>
                _showFoodSelectionDialog(plateType, fillTitle, grams),
          ),
          _FillLevelOption(
            title: l10n.half,
            fillLevel: 0.5,
            plateType: plateType,
            onSelected: (fillTitle, grams) =>
                _showFoodSelectionDialog(plateType, fillTitle, grams),
          ),
          _FillLevelOption(
            title: l10n.threeQuarters,
            fillLevel: 0.75,
            plateType: plateType,
            onSelected: (fillTitle, grams) =>
                _showFoodSelectionDialog(plateType, fillTitle, grams),
          ),
          _FillLevelOption(
            title: l10n.full,
            fillLevel: 1.0,
            plateType: plateType,
            onSelected: (fillTitle, grams) =>
                _showFoodSelectionDialog(plateType, fillTitle, grams),
          ),
        ],
      ),
    );
  }

  void _showFoodSelectionDialog(String plateType, String fillTitle, int grams) {
    final l10n = AppLocalizations.of(context)!;
    final AllySemanticPalette semantics = context.allySemantics;

    AllySheet.show(
      context,
      title: l10n.selectFood,
      subtitle: l10n.foodSelectionSubtitle(
        plateType,
        fillTitle,
        grams.toString(),
      ),
      icon: Icons.restaurant_rounded,
      child: SingleChildScrollView(
        child: Column(
          children: [
            for (final food in _foods(semantics))
              _FoodOption(
                key: ValueKey('${food.$1}_$grams'),
                foodNameKey: food.$1,
                displayName: _getLocalizedFoodName(food.$1),
                icon: food.$2,
                calPer100g: food.$3,
                grams: grams,
                accent: food.$4,
                onSelected: () => _addMeal(
                  food.$1,
                  _getLocalizedFoodName(food.$1),
                  ((food.$3 / 100) * grams).round(),
                  grams,
                  plateType,
                  fillTitle,
                  food.$4,
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _addMeal(
    String foodNameKey,
    String displayName,
    int calories,
    int grams,
    String plateType,
    String fillTitle,
    Color color,
  ) {
    final healthProvider = Provider.of<HealthProvider>(context, listen: false);
    healthProvider.addCalories(calories);
    final fullName = '$displayName - $plateType ($fillTitle)';
    healthProvider.addMealToLog(foodNameKey, fullName, calories, grams, color);
  }

  String _getLocalizedFoodName(String key) {
    final l10n = AppLocalizations.of(context)!;
    switch (key) {
      case 'egg':
        return l10n.egg;
      case 'whiteRice':
        return l10n.whiteRice;
      case 'plainPasta':
        return l10n.plainPasta;
      case 'chickenBreast':
        return l10n.chickenBreast;
      case 'grilledSalmon':
        return l10n.grilledSalmon;
      case 'boiledPotato':
        return l10n.boiledPotato;
      case 'mixedVegetables':
        return l10n.mixedVegetables;
      case 'couscous':
        return l10n.couscous;
      case 'quinoa':
        return l10n.quinoa;
      case 'bulgur':
        return l10n.bulgur;
      case 'corn':
        return l10n.corn;
      case 'peas':
        return l10n.peas;
      case 'broccoli':
        return l10n.broccoli;
      case 'mushroom':
        return l10n.mushroom;
      case 'stirFryVegetables':
        return l10n.stirFryVegetables;
      case 'sweetPotato':
        return l10n.sweetPotato;
      case 'baldoRice':
        return l10n.baldoRice;
      case 'chickenCurry':
        return l10n.chickenCurry;
      case 'beefCurry':
        return l10n.beefCurry;
      case 'spaghettiPuttanesca':
        return l10n.spaghettiPuttanesca;
      case 'ravioli':
        return l10n.ravioli;
      case 'gnocchi':
        return l10n.gnocchi;
      case 'kidneyBeans':
        return l10n.kidneyBeans;
      case 'chickpeas':
        return l10n.chickpeas;
      case 'lentils':
        return l10n.lentils;
      case 'whiteBeans':
        return l10n.whiteBeans;
      case 'tuna':
        return l10n.tuna;
      case 'mussels':
        return l10n.mussels;
      case 'shrimp':
        return l10n.shrimp;
      case 'caesarSalad':
        return l10n.caesarSalad;
      case 'tofu':
        return l10n.tofu;
      case 'salad':
        return l10n.salad;
      case 'soup':
        return l10n.soup;
      case 'fruit':
        return l10n.fruit;
      case 'vegetables':
        return l10n.vegetables;
      case 'milk':
        return l10n.milk;
      case 'yogurt':
        return l10n.yogurt;
      default:
        return key;
    }
  }

  /// Catalog of selectable foods: (key, icon, kcal per 100 g, accent).
  List<(String, IconData, int, Color)> _foods(
    AllySemanticPalette semantics,
  ) => [
    ('egg', Icons.egg_rounded, 155, semantics.nutrition),
    ('whiteRice', Icons.rice_bowl_rounded, 130, semantics.nutrition),
    ('plainPasta', Icons.restaurant_rounded, 131, semantics.nutrition),
    ('chickenBreast', Icons.set_meal_rounded, 165, semantics.heartRate),
    ('grilledSalmon', Icons.set_meal_rounded, 208, semantics.heartRate),
    ('boiledPotato', Icons.grass_rounded, 87, semantics.nutrition),
    ('mixedVegetables', Icons.eco_rounded, 65, semantics.activity),
    ('couscous', Icons.rice_bowl_rounded, 112, semantics.nutrition),
    ('quinoa', Icons.grass_rounded, 120, semantics.nutrition),
    ('bulgur', Icons.rice_bowl_rounded, 83, semantics.nutrition),
    ('corn', Icons.grass_rounded, 96, semantics.nutrition),
    ('peas', Icons.eco_rounded, 81, semantics.activity),
    ('broccoli', Icons.eco_rounded, 34, semantics.activity),
    ('mushroom', Icons.eco_rounded, 22, semantics.activity),
    (
      'stirFryVegetables',
      Icons.local_fire_department_rounded,
      120,
      semantics.activity,
    ),
    ('sweetPotato', Icons.grass_rounded, 86, semantics.nutrition),
    ('baldoRice', Icons.rice_bowl_rounded, 130, semantics.nutrition),
    ('chickenCurry', Icons.restaurant_rounded, 145, semantics.heartRate),
    ('beefCurry', Icons.restaurant_rounded, 175, semantics.heartRate),
    ('spaghettiPuttanesca', Icons.restaurant_rounded, 150, semantics.nutrition),
    ('ravioli', Icons.restaurant_rounded, 158, semantics.nutrition),
    ('gnocchi', Icons.restaurant_rounded, 130, semantics.nutrition),
    ('kidneyBeans', Icons.eco_rounded, 127, semantics.activity),
    ('chickpeas', Icons.eco_rounded, 164, semantics.activity),
    ('lentils', Icons.eco_rounded, 116, semantics.activity),
    ('whiteBeans', Icons.eco_rounded, 139, semantics.activity),
    ('tuna', Icons.set_meal_rounded, 132, semantics.heartRate),
    ('mussels', Icons.set_meal_rounded, 86, semantics.heartRate),
    ('shrimp', Icons.set_meal_rounded, 99, semantics.heartRate),
    ('caesarSalad', Icons.local_dining_rounded, 160, semantics.activity),
    ('tofu', Icons.eco_rounded, 76, semantics.activity),
    ('salad', Icons.eco_rounded, 20, semantics.activity),
    ('soup', Icons.local_dining_rounded, 45, semantics.water),
    ('fruit', Icons.apple_rounded, 60, semantics.nutrition),
    ('vegetables', Icons.eco_rounded, 35, semantics.activity),
    ('milk', Icons.local_drink_rounded, 61, semantics.water),
    ('yogurt', Icons.coffee_rounded, 61, semantics.water),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;
    final AllySemanticPalette semantics = context.allySemantics;
    final nutritionColor = semantics.nutrition;

    final healthProvider = Provider.of<HealthProvider>(context);
    final healthData = healthProvider.healthData;
    final caloriesConsumed = healthData.caloriesConsumed;
    final dailyGoal = healthData.caloriesGoal;

    return Scaffold(
      appBar: AllyAppBar(
        title: l10n.nutrition,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: AllySpacing.lg),
            child: IconButton.filled(
              icon: const Icon(Icons.add),
              onPressed: _showAddMealDialog,
              tooltip: l10n.selectPlateType,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AllySpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Calorie overview ────────────────────────────────────────
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
                            color: nutritionColor.withValues(alpha: 0.14),
                            borderRadius: AllyRadius.smAll,
                          ),
                          child: Icon(
                            Icons.restaurant_rounded,
                            color: nutritionColor,
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
                          '$caloriesConsumed',
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
                            l10n.ofValueUnit(dailyGoal.toString(), 'kcal'),
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
                        value: (caloriesConsumed / dailyGoal).clamp(0.0, 1.0),
                        minHeight: 6,
                        backgroundColor: scheme.outlineVariant,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          nutritionColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AllySpacing.section),

              // ── Meal log ────────────────────────────────────────────────
              AllySectionHeader(title: l10n.mealLog),
              const SizedBox(height: AllySpacing.lg),
              Expanded(
                child: healthData.mealLog.isEmpty
                    ? AllyEmptyState(
                        icon: Icons.restaurant_menu_rounded,
                        title: l10n.noMealsLogged,
                        message: l10n.startTrackingToSee,
                        actionLabel: l10n.quickAdd,
                        onAction: _showAddMealDialog,
                      )
                    : ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: healthData.mealLog.length,
                        itemBuilder: (context, index) {
                          final meal = healthData.mealLog[index];
                          final time = DateTime.parse(meal['time']);
                          final timeStr =
                              '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
                          final nameKey = meal['nameKey'] ?? 'unknown';
                          final displayName = _getLocalizedFoodName(nameKey);
                          final mealColor = Color(meal['color']);

                          return Container(
                            margin: const EdgeInsets.only(
                              bottom: AllySpacing.md,
                            ),
                            child: AllyCard(
                              child: Row(
                                children: [
                                  Container(
                                    width: 4,
                                    height: AllyDimensions.iconChip + 8,
                                    decoration: BoxDecoration(
                                      color: mealColor,
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  ),
                                  const SizedBox(width: AllySpacing.lg),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          displayName,
                                          style: AllyTypography.label(
                                            size: 15,
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
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        l10n.caloriesAmount(
                                          meal['calories'].toString(),
                                        ),
                                        style: AllyTypography.label(
                                          size: 15,
                                          color: scheme.onSurface,
                                        ),
                                      ),
                                      Text(
                                        '${meal['grams']}g',
                                        style: AllyTypography.caption(
                                          color: scheme.onSurfaceVariant,
                                        ),
                                      ),
                                    ],
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

class _PlateTypeOption extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const _PlateTypeOption({
    required this.title,
    required this.icon,
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
          padding: const EdgeInsets.all(AllySpacing.xl),
          decoration: BoxDecoration(
            borderRadius: AllyRadius.mdAll,
            border: Border.all(color: scheme.outlineVariant),
          ),
          child: Column(
            children: [
              Icon(icon, color: scheme.onSurface, size: AllyDimensions.iconXl),
              const SizedBox(height: AllySpacing.md),
              Text(
                title,
                style: AllyTypography.label(size: 15, color: scheme.onSurface),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FillLevelOption extends StatelessWidget {
  final String title;
  final double fillLevel;
  final String plateType;
  final void Function(String fillTitle, int grams) onSelected;

  const _FillLevelOption({
    required this.title,
    required this.fillLevel,
    required this.plateType,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;

    // Plate: ~250g, Bowl: ~150g (per 100g reference)
    final baseGrams =
        plateType.toLowerCase().contains('plate') ||
            plateType.toLowerCase().contains('tabak')
        ? 250
        : 150;
    final grams = (baseGrams * fillLevel).round();

    return InkWell(
      onTap: () {
        Navigator.pop(context);
        onSelected(title, grams);
      },
      borderRadius: AllyRadius.smAll,
      child: Container(
        margin: const EdgeInsets.only(bottom: AllySpacing.md),
        padding: const EdgeInsets.all(AllySpacing.lg),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: AllyRadius.smAll,
          border: Border.all(color: scheme.outlineVariant),
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 6,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
                color: scheme.outlineVariant,
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: fillLevel,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    color: scheme.onSurface,
                  ),
                ),
              ),
            ),
            const SizedBox(width: AllySpacing.lg),
            Expanded(
              child: Text(
                title,
                style: AllyTypography.label(size: 15, color: scheme.onSurface),
              ),
            ),
            Text(
              l10n.gramsAmount(grams.toString()),
              style: AllyTypography.label(
                size: 14,
                color: scheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FoodOption extends StatelessWidget {
  final String foodNameKey;
  final String displayName;
  final IconData icon;
  final int calPer100g;
  final int grams;
  final Color accent;
  final VoidCallback onSelected;

  const _FoodOption({
    super.key,
    required this.foodNameKey,
    required this.displayName,
    required this.icon,
    required this.calPer100g,
    required this.grams,
    required this.accent,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final actualCalories = ((calPer100g / 100) * grams).round();

    return InkWell(
      onTap: () {
        Navigator.pop(context);
        onSelected();
      },
      borderRadius: AllyRadius.smAll,
      child: Container(
        margin: const EdgeInsets.only(bottom: AllySpacing.sm),
        padding: const EdgeInsets.all(AllySpacing.lg),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: AllyRadius.smAll,
          border: Border.all(color: scheme.outlineVariant),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AllySpacing.sm),
              decoration: BoxDecoration(
                color: accent.withValues(alpha: 0.12),
                borderRadius: AllyRadius.smAll,
              ),
              child: Icon(icon, color: accent, size: AllyDimensions.iconSm),
            ),
            const SizedBox(width: AllySpacing.lg),
            Expanded(
              child: Text(
                displayName,
                style: AllyTypography.label(size: 15, color: scheme.onSurface),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  l10n.caloriesAmount(actualCalories.toString()),
                  style: AllyTypography.label(
                    size: 14,
                    color: scheme.onSurface,
                  ),
                ),
                Text(
                  l10n.caloriesPer100g(calPer100g.toString()),
                  style: AllyTypography.caption(color: scheme.onSurfaceVariant),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
