import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Project Imports
import '../providers/health.dart';
import '../notifications/introvert.dart'; // The Notification Service
import '../l10n/app_localizations.dart';
import '../theme.dart';
import '../app.dart'; // For InvertedColor extension

class NutritionScreen extends StatefulWidget {
  const NutritionScreen({super.key});

  @override
  State<NutritionScreen> createState() => _NutritionScreenState();
}

class _NutritionScreenState extends State<NutritionScreen> {

  // Semantic Color for Nutrition (Orange)
  final Color _nutritionColor = const Color(0xFFFFB74D);

  void _showGoalDialog() {
    final healthProvider = Provider.of<HealthProvider>(context, listen: false);
    final currentGoal = healthProvider.healthData.caloriesGoal;
    final controller = TextEditingController(text: currentGoal.toString());

    // Dynamic Dimensions
    final sw = MediaQuery.of(context).size.width;
    final sh = MediaQuery.of(context).size.height;

    // Theme Colors
    final backgroundColor = AppColors.background;
    final cardColor = AppColors.secondaryColor;
    final textColor = AppColors.primaryColor.inverted;
    final hintColor = AppColors.tertiaryColor;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          margin: EdgeInsets.all(sw * 0.04),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.all(Radius.circular(sw * 0.06)),
            border: Border.all(color: AppColors.border, width: 1),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: sh * 0.025),
              Container(
                padding: EdgeInsets.all(sw * 0.04),
                decoration: BoxDecoration(
                  color: _nutritionColor.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.flag_rounded, color: _nutritionColor, size: sw * 0.08),
              ),
              SizedBox(height: sh * 0.02),
              Text(
                AppLocalizations.of(context)!.setYourCalorieGoal,
                style: TextStyle(
                  fontSize: sw * 0.055,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              SizedBox(height: sh * 0.01),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: sw * 0.06),
                child: Text(
                  AppLocalizations.of(context)!.howManyCalories,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: sw * 0.035,
                    color: hintColor,
                  ),
                ),
              ),
              SizedBox(height: sh * 0.03),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: sw * 0.04),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: sw * 0.05, vertical: sh * 0.005),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(sw * 0.04),
                    boxShadow: [
                      BoxShadow(
                        color: textColor.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: controller,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: sw * 0.06,
                      fontWeight: FontWeight.bold,
                      color: _nutritionColor,
                    ),
                    decoration: InputDecoration(
                      hintText: AppLocalizations.of(context)!.dailyCalorieHint,
                      hintStyle: TextStyle(
                        color: hintColor.withValues(alpha: 0.5),
                      ),
                      border: InputBorder.none,
                      suffix: Text(
                        'kcal',
                        style: TextStyle(
                          fontSize: sw * 0.035,
                          color: hintColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: sh * 0.03),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: sw * 0.04),
                child: Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: sh * 0.02),
                        ),
                        child: Text(
                          AppLocalizations.of(context)!.cancel,
                          style: TextStyle(
                            color: hintColor,
                            fontSize: sw * 0.04,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: sw * 0.03),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          final cal = int.tryParse(controller.text);
                          if (cal != null && cal > 0) {
                            healthProvider.updateCaloriesGoal(cal);
                            Navigator.pop(context);

                            context.read<IntrovertNotificationService>().showNotification(
                              message: AppLocalizations.of(context)!.calorieGoalSet(cal),
                              type: NotificationType.success,
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _nutritionColor,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: sh * 0.02),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(sw * 0.03),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          AppLocalizations.of(context)!.setGoal,
                          style: TextStyle(
                            fontSize: sw * 0.04,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: sh * 0.025),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddMealDialog() {
    final l10n = AppLocalizations.of(context)!;

    // Dynamic Dimensions
    final sw = MediaQuery.of(context).size.width;
    final sh = MediaQuery.of(context).size.height;
    final backgroundColor = AppColors.background;
    final textColor = AppColors.primaryColor.inverted;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        margin: EdgeInsets.all(sw * 0.04),
        padding: EdgeInsets.all(sw * 0.06),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(sw * 0.06),
          border: Border.all(color: AppColors.border, width: 1),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(sw * 0.04),
              decoration: BoxDecoration(
                color: _nutritionColor.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.restaurant_rounded, color: _nutritionColor, size: sw * 0.08),
            ),
            SizedBox(height: sh * 0.02),
            Text(
              l10n.selectPlateType,
              style: TextStyle(fontSize: sw * 0.05, fontWeight: FontWeight.bold, color: textColor),
            ),
            SizedBox(height: sh * 0.03),
            Row(
              children: [
                Expanded(
                  child: _buildPlateTypeOption(l10n.plate, Icons.dinner_dining_rounded, _nutritionColor),
                ),
                SizedBox(width: sw * 0.03),
                Expanded(
                  child: _buildPlateTypeOption(l10n.bowl, Icons.rice_bowl_rounded, _nutritionColor),
                ),
              ],
            ),
            SizedBox(height: sh * 0.02),
          ],
        ),
      ),
    );
  }

  Widget _buildPlateTypeOption(String title, IconData icon, Color color) {
    // Dynamic Dimensions
    final sw = MediaQuery.of(context).size.width;
    final sh = MediaQuery.of(context).size.height;
    final cardColor = AppColors.secondaryColor;
    final textColor = AppColors.primaryColor.inverted;

    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        _showFillLevelDialog(title, icon, color);
      },
      child: Container(
        padding: EdgeInsets.all(sw * 0.05),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(sw * 0.04),
          boxShadow: [
            BoxShadow(
                color: textColor.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 2)
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(sw * 0.04),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: sw * 0.08),
            ),
            SizedBox(height: sh * 0.015),
            Text(
              title,
              style: TextStyle(fontSize: sw * 0.04, fontWeight: FontWeight.w600, color: textColor),
            ),
          ],
        ),
      ),
    );
  }

  void _showFillLevelDialog(String plateType, IconData plateIcon, Color plateColor) {
    final l10n = AppLocalizations.of(context)!;

    // Dynamic Dimensions
    final sw = MediaQuery.of(context).size.width;
    final sh = MediaQuery.of(context).size.height;
    final backgroundColor = AppColors.background;
    final textColor = AppColors.primaryColor.inverted;
    final subTextColor = AppColors.tertiaryColor;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        margin: EdgeInsets.all(sw * 0.04),
        padding: EdgeInsets.all(sw * 0.06),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(sw * 0.06),
          border: Border.all(color: AppColors.border, width: 1),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(sw * 0.04),
              decoration: BoxDecoration(
                color: plateColor.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(plateIcon, color: plateColor, size: sw * 0.08),
            ),
            SizedBox(height: sh * 0.02),
            Text(
              l10n.fillLevel,
              style: TextStyle(fontSize: sw * 0.05, fontWeight: FontWeight.bold, color: textColor),
            ),
            SizedBox(height: sh * 0.01),
            Text(
              '$plateType - ${l10n.selectPlateType}',
              style: TextStyle(fontSize: sw * 0.035, color: subTextColor),
            ),
            SizedBox(height: sh * 0.03),
            _buildFillLevelOption(l10n.quarter, 0.25, plateType, plateColor),
            SizedBox(height: sh * 0.015),
            _buildFillLevelOption(l10n.half, 0.5, plateType, plateColor),
            SizedBox(height: sh * 0.015),
            _buildFillLevelOption(l10n.threeQuarters, 0.75, plateType, plateColor),
            SizedBox(height: sh * 0.015),
            _buildFillLevelOption(l10n.full, 1.0, plateType, plateColor),
            SizedBox(height: sh * 0.025),
          ],
        ),
      ),
    );
  }

  Widget _buildFillLevelOption(String title, double fillLevel, String plateType, Color color) {
    // Dynamic Dimensions
    final sw = MediaQuery.of(context).size.width;
    final cardColor = AppColors.secondaryColor;
    final textColor = AppColors.primaryColor.inverted;
    final subTextColor = AppColors.tertiaryColor;

    // Plate: ~250g, Bowl: ~150g (per 100g reference)
    final baseGrams = plateType.toLowerCase().contains('plate') || plateType.toLowerCase().contains('tabak') ? 250 : 150;
    final grams = (baseGrams * fillLevel).round();

    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        _showFoodSelectionDialog(plateType, title, fillLevel, grams, color);
      },
      child: Container(
        padding: EdgeInsets.all(sw * 0.04),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(sw * 0.04),
          boxShadow: [
            BoxShadow(
                color: textColor.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 2)
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: sw * 0.15,
              height: sw * 0.02,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: subTextColor.withValues(alpha: 0.2),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: fillLevel,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: color,
                  ),
                ),
              ),
            ),
            SizedBox(width: sw * 0.04),
            Expanded(
              child: Text(
                title,
                style: TextStyle(fontSize: sw * 0.04, fontWeight: FontWeight.w600, color: textColor),
              ),
            ),
            Text(
              AppLocalizations.of(context)!.gramsAmount(grams.toString()),
              style: TextStyle(fontSize: sw * 0.035, color: subTextColor, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  void _showFoodSelectionDialog(String plateType, String fillTitle, double fillLevel, int grams, Color plateColor) {
    final l10n = AppLocalizations.of(context)!;

    // Dynamic Dimensions
    final sw = MediaQuery.of(context).size.width;
    final sh = MediaQuery.of(context).size.height;
    final backgroundColor = AppColors.background;
    final textColor = AppColors.primaryColor.inverted;
    final subTextColor = AppColors.tertiaryColor;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        margin: EdgeInsets.all(sw * 0.04),
        padding: EdgeInsets.all(sw * 0.06),
        constraints: BoxConstraints(
          maxHeight: sh * 0.7,
        ),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(sw * 0.06),
          border: Border.all(color: AppColors.border, width: 1),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(sw * 0.04),
              decoration: BoxDecoration(
                color: _nutritionColor.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.restaurant_rounded, color: _nutritionColor, size: sw * 0.08),
            ),
            SizedBox(height: sh * 0.02),
            Text(
              l10n.selectFood,
              style: TextStyle(fontSize: sw * 0.05, fontWeight: FontWeight.bold, color: textColor),
            ),
            SizedBox(height: sh * 0.01),
            Text(
              AppLocalizations.of(context)!.foodSelectionSubtitle(plateType, fillTitle, grams.toString()),
              style: TextStyle(fontSize: sw * 0.035, color: subTextColor),
            ),
            SizedBox(height: sh * 0.03),
            Flexible(
              child: ListView(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                children: [
                  _buildFoodOption('egg', Icons.egg_rounded, 155, grams, plateType, fillTitle, const Color(0xFFFFB74D)),
                  SizedBox(height: sh * 0.01),
                  _buildFoodOption('whiteRice', Icons.rice_bowl_rounded, 130, grams, plateType, fillTitle, const Color(0xFFFFB74D)),
                  SizedBox(height: sh * 0.01),
                  _buildFoodOption('plainPasta', Icons.restaurant_rounded, 131, grams, plateType, fillTitle, const Color(0xFFFFB74D)),
                  SizedBox(height: sh * 0.01),
                  _buildFoodOption('chickenBreast', Icons.set_meal_rounded, 165, grams, plateType, fillTitle, const Color(0xFFE57373)),
                  SizedBox(height: sh * 0.01),
                  _buildFoodOption('grilledSalmon', Icons.set_meal_rounded, 208, grams, plateType, fillTitle, const Color(0xFF64B5F6)),
                  SizedBox(height: sh * 0.01),
                  _buildFoodOption('boiledPotato', Icons.breakfast_dining_rounded, 87, grams, plateType, fillTitle, const Color(0xFFFFB74D)),
                  SizedBox(height: sh * 0.01),
                  _buildFoodOption('mixedVegetables', Icons.eco_rounded, 70, grams, plateType, fillTitle, const Color(0xFF4CAF50)),
                  SizedBox(height: sh * 0.01),
                  _buildFoodOption('couscous', Icons.grain_rounded, 112, grams, plateType, fillTitle, const Color(0xFFFFB74D)),
                  SizedBox(height: sh * 0.01),
                  _buildFoodOption('quinoa', Icons.grain_rounded, 120, grams, plateType, fillTitle, const Color(0xFFFFB74D)),
                  SizedBox(height: sh * 0.01),
                  _buildFoodOption('bulgur', Icons.grain_rounded, 110, grams, plateType, fillTitle, const Color(0xFFFFB74D)),
                  SizedBox(height: sh * 0.01),
                  _buildFoodOption('corn', Icons.agriculture_rounded, 96, grams, plateType, fillTitle, const Color(0xFFFFB74D)),
                  SizedBox(height: sh * 0.01),
                  _buildFoodOption('peas', Icons.eco_rounded, 80, grams, plateType, fillTitle, const Color(0xFF4CAF50)),
                  SizedBox(height: sh * 0.01),
                  _buildFoodOption('broccoli', Icons.eco_rounded, 55, grams, plateType, fillTitle, const Color(0xFF4CAF50)),
                  SizedBox(height: sh * 0.01),
                  _buildFoodOption('mushroom', Icons.nature_rounded, 45, grams, plateType, fillTitle, const Color(0xFF4CAF50)),
                  SizedBox(height: sh * 0.01),
                  _buildFoodOption('stirFryVegetables', Icons.restaurant_rounded, 120, grams, plateType, fillTitle, const Color(0xFF4CAF50)),
                  SizedBox(height: sh * 0.01),
                  _buildFoodOption('sweetPotato', Icons.breakfast_dining_rounded, 86, grams, plateType, fillTitle, const Color(0xFFFFB74D)),
                  SizedBox(height: sh * 0.01),
                  _buildFoodOption('baldoRice', Icons.rice_bowl_rounded, 115, grams, plateType, fillTitle, const Color(0xFFFFB74D)),
                  SizedBox(height: sh * 0.01),
                  _buildFoodOption('chickenCurry', Icons.restaurant_rounded, 150, grams, plateType, fillTitle, const Color(0xFFE57373)),
                  SizedBox(height: sh * 0.01),
                  _buildFoodOption('beefCurry', Icons.restaurant_rounded, 180, grams, plateType, fillTitle, const Color(0xFFE57373)),
                  SizedBox(height: sh * 0.01),
                  _buildFoodOption('spaghettiPuttanesca', Icons.restaurant_rounded, 140, grams, plateType, fillTitle, const Color(0xFFFFB74D)),
                  SizedBox(height: sh * 0.01),
                  _buildFoodOption('ravioli', Icons.restaurant_rounded, 150, grams, plateType, fillTitle, const Color(0xFFFFB74D)),
                  SizedBox(height: sh * 0.01),
                  _buildFoodOption('gnocchi', Icons.restaurant_rounded, 130, grams, plateType, fillTitle, const Color(0xFFFFB74D)),
                  SizedBox(height: sh * 0.01),
                  _buildFoodOption('kidneyBeans', Icons.eco_rounded, 130, grams, plateType, fillTitle, const Color(0xFF4CAF50)),
                  SizedBox(height: sh * 0.01),
                  _buildFoodOption('chickpeas', Icons.eco_rounded, 164, grams, plateType, fillTitle, const Color(0xFFFFB74D)),
                  SizedBox(height: sh * 0.01),
                  _buildFoodOption('lentils', Icons.eco_rounded, 116, grams, plateType, fillTitle, const Color(0xFF4CAF50)),
                  SizedBox(height: sh * 0.01),
                  _buildFoodOption('whiteBeans', Icons.eco_rounded, 130, grams, plateType, fillTitle, const Color(0xFF4CAF50)),
                  SizedBox(height: sh * 0.01),
                  _buildFoodOption('tuna', Icons.set_meal_rounded, 132, grams, plateType, fillTitle, const Color(0xFF64B5F6)),
                  SizedBox(height: sh * 0.01),
                  _buildFoodOption('mussels', Icons.set_meal_rounded, 86, grams, plateType, fillTitle, const Color(0xFF64B5F6)),
                  SizedBox(height: sh * 0.01),
                  _buildFoodOption('shrimp', Icons.set_meal_rounded, 105, grams, plateType, fillTitle, const Color(0xFF64B5F6)),
                  SizedBox(height: sh * 0.01),
                  _buildFoodOption('caesarSalad', Icons.eco_rounded, 120, grams, plateType, fillTitle, const Color(0xFF4CAF50)),
                  SizedBox(height: sh * 0.01),
                  _buildFoodOption('tofu', Icons.food_bank_rounded, 95, grams, plateType, fillTitle, const Color(0xFF4CAF50)),
                  SizedBox(height: sh * 0.01),
                  _buildFoodOption('salad', Icons.eco_rounded, 15, grams, plateType, fillTitle, const Color(0xFF4CAF50)),
                  SizedBox(height: sh * 0.01),
                  _buildFoodOption('soup', Icons.soup_kitchen_rounded, 38, grams, plateType, fillTitle, const Color(0xFFFFB74D)),
                  SizedBox(height: sh * 0.01),
                  _buildFoodOption('fruit', Icons.apple_rounded, 52, grams, plateType, fillTitle, const Color(0xFFE57373)),
                  SizedBox(height: sh * 0.01),
                  _buildFoodOption('vegetables', Icons.grass_rounded, 35, grams, plateType, fillTitle, const Color(0xFF4CAF50)),
                  SizedBox(height: sh * 0.01),
                  _buildFoodOption('milk', Icons.local_drink_rounded, 42, grams, plateType, fillTitle, const Color(0xFF64B5F6)),
                  SizedBox(height: sh * 0.01),
                  _buildFoodOption('yogurt', Icons.coffee_rounded, 61, grams, plateType, fillTitle, const Color(0xFF64B5F6)),
                  SizedBox(height: sh * 0.025),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFoodOption(String foodNameKey, IconData icon, int calPer100g, int grams, String plateType, String fillTitle, Color color) {
    // Dynamic Dimensions
    final sw = MediaQuery.of(context).size.width;
    final cardColor = AppColors.secondaryColor;
    final textColor = AppColors.primaryColor.inverted;
    final subTextColor = AppColors.tertiaryColor;

    final actualCalories = ((calPer100g / 100) * grams).round();
    final displayName = _getLocalizedFoodName(foodNameKey);

    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        _addMeal(foodNameKey, displayName, actualCalories, grams, plateType, fillTitle, color);
      },
      child: Container(
        padding: EdgeInsets.all(sw * 0.04),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(sw * 0.04),
          boxShadow: [
            BoxShadow(
                color: textColor.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 2)
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(sw * 0.03),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(sw * 0.03),
              ),
              child: Icon(icon, color: color, size: sw * 0.06),
            ),
            SizedBox(width: sw * 0.04),
            Expanded(
              child: Text(
                displayName,
                style: TextStyle(fontSize: sw * 0.04, fontWeight: FontWeight.w600, color: textColor),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  AppLocalizations.of(context)!.caloriesAmount(actualCalories.toString()),
                  style: TextStyle(fontSize: sw * 0.035, color: subTextColor, fontWeight: FontWeight.bold),
                ),
                Text(
                  AppLocalizations.of(context)!.caloriesPer100g(calPer100g.toString()),
                  style: TextStyle(fontSize: sw * 0.025, color: subTextColor.withValues(alpha: 0.7)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _addMeal(String foodNameKey, String displayName, int calories, int grams, String plateType, String fillTitle, Color color) {
    final healthProvider = Provider.of<HealthProvider>(context, listen: false);
    healthProvider.addCalories(calories);
    final fullName = '$displayName - $plateType ($fillTitle)';
    healthProvider.addMealToLog(foodNameKey, fullName, calories, grams, color);
  }

  String _getLocalizedFoodName(String key) {
    final l10n = AppLocalizations.of(context)!;
    switch(key) {
      case 'egg': return l10n.egg;
      case 'whiteRice': return l10n.whiteRice;
      case 'plainPasta': return l10n.plainPasta;
      case 'chickenBreast': return l10n.chickenBreast;
      case 'grilledSalmon': return l10n.grilledSalmon;
      case 'boiledPotato': return l10n.boiledPotato;
      case 'mixedVegetables': return l10n.mixedVegetables;
      case 'couscous': return l10n.couscous;
      case 'quinoa': return l10n.quinoa;
      case 'bulgur': return l10n.bulgur;
      case 'corn': return l10n.corn;
      case 'peas': return l10n.peas;
      case 'broccoli': return l10n.broccoli;
      case 'mushroom': return l10n.mushroom;
      case 'stirFryVegetables': return l10n.stirFryVegetables;
      case 'sweetPotato': return l10n.sweetPotato;
      case 'baldoRice': return l10n.baldoRice;
      case 'chickenCurry': return l10n.chickenCurry;
      case 'beefCurry': return l10n.beefCurry;
      case 'spaghettiPuttanesca': return l10n.spaghettiPuttanesca;
      case 'ravioli': return l10n.ravioli;
      case 'gnocchi': return l10n.gnocchi;
      case 'kidneyBeans': return l10n.kidneyBeans;
      case 'chickpeas': return l10n.chickpeas;
      case 'lentils': return l10n.lentils;
      case 'whiteBeans': return l10n.whiteBeans;
      case 'tuna': return l10n.tuna;
      case 'mussels': return l10n.mussels;
      case 'shrimp': return l10n.shrimp;
      case 'caesarSalad': return l10n.caesarSalad;
      case 'tofu': return l10n.tofu;
      case 'salad': return l10n.salad;
      case 'soup': return l10n.soup;
      case 'fruit': return l10n.fruit;
      case 'vegetables': return l10n.vegetables;
      case 'milk': return l10n.milk;
      case 'yogurt': return l10n.yogurt;
      default: return key;
    }
  }

  @override
  Widget build(BuildContext context) {
    // -------------------------------------------------------------------------
    // DYNAMIC DIMENSIONS & COLORS
    // -------------------------------------------------------------------------
    final sw = MediaQuery.of(context).size.width;
    final sh = MediaQuery.of(context).size.height;

    // Spacing
    final paddingH = sw * 0.05;
    final paddingV = sh * 0.025;

    // Theme Colors
    final backgroundColor = AppColors.background;
    final cardColor = AppColors.secondaryColor;
    final textColor = AppColors.primaryColor.inverted;
    final subTextColor = AppColors.tertiaryColor;

    final healthProvider = Provider.of<HealthProvider>(context);
    final healthData = healthProvider.healthData;
    final caloriesConsumed = healthData.caloriesConsumed;
    final dailyGoal = healthData.caloriesGoal;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.chevron_left_rounded, color: textColor, size: sw * 0.08),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(l10n.nutrition, style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: Container(
              padding: EdgeInsets.all(sw * 0.02),
              decoration: BoxDecoration(
                color: _nutritionColor,
                borderRadius: BorderRadius.circular(sw * 0.03),
              ),
              child: Icon(Icons.add, color: Colors.white, size: sw * 0.05),
            ),
            onPressed: _showAddMealDialog,
          ),
          SizedBox(width: sw * 0.02),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: paddingH, vertical: paddingV),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Hero(
                tag: 'nutrition_card',
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    padding: EdgeInsets.all(sw * 0.06),
                    decoration: BoxDecoration(
                      color: _nutritionColor,
                      borderRadius: BorderRadius.circular(sw * 0.06),
                      boxShadow: [
                        BoxShadow(
                          color: _nutritionColor.withValues(alpha: 0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.nutrition,
                          style: TextStyle(
                            fontSize: sw * 0.04,
                            color: Colors.white70,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: sh * 0.015),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(sw * 0.03),
                          child: LinearProgressIndicator(
                            value: (caloriesConsumed / dailyGoal).clamp(0.0, 1.0),
                            minHeight: sh * 0.015,
                            backgroundColor: Colors.white70,
                            valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ),
                        SizedBox(height: sh * 0.02),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '$caloriesConsumed',
                              style: TextStyle(
                                fontSize: sw * 0.16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                height: 1,
                              ),
                            ),
                            SizedBox(width: sw * 0.03),
                            Padding(
                              padding: EdgeInsets.only(bottom: sh * 0.01),
                              child: Text(
                                AppLocalizations.of(context)!.valueOfTarget(caloriesConsumed.toString(), dailyGoal.toString()),
                                style: TextStyle(
                                  fontSize: sw * 0.06,
                                  color: Colors.white70,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: sh * 0.02),
                        GestureDetector(
                          onTap: _showGoalDialog,
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: sw * 0.04, vertical: sh * 0.01),
                            decoration: BoxDecoration(
                              color: Colors.white70,
                              borderRadius: BorderRadius.circular(sw * 0.05),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.edit, color: Colors.white, size: sw * 0.04),
                                SizedBox(width: sw * 0.02),
                                Text(
                                  AppLocalizations.of(context)!.editGoal,
                                  style: TextStyle(
                                    fontSize: sw * 0.035,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              SizedBox(height: sh * 0.04),
              Text(
                l10n.todaysMeals,
                style: TextStyle(
                  fontSize: sw * 0.05,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              SizedBox(height: sh * 0.02),
              Expanded(
                child: healthData.mealLog.isEmpty
                    ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.restaurant_menu_rounded,
                        size: sw * 0.2,
                        color: subTextColor.withValues(alpha: 0.3),
                      ),
                      SizedBox(height: sh * 0.02),
                      Text(
                        l10n.noMealsYet,
                        style: TextStyle(
                          fontSize: sw * 0.045,
                          fontWeight: FontWeight.w600,
                          color: subTextColor,
                        ),
                      ),
                    ],
                  ),
                )
                    : ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: healthData.mealLog.length,
                  itemBuilder: (context, index) {
                    final meal = healthData.mealLog[index];
                    final time = DateTime.parse(meal['time']);
                    final timeStr = '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
                    final nameKey = meal['nameKey'] ?? 'unknown';
                    final displayName = _getLocalizedFoodName(nameKey);

                    return Container(
                      margin: EdgeInsets.only(bottom: sh * 0.015),
                      padding: EdgeInsets.all(sw * 0.04),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(sw * 0.04),
                        boxShadow: [
                          BoxShadow(
                              color: textColor.withValues(alpha: 0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 2)
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: sw * 0.01,
                            height: sw * 0.1,
                            decoration: BoxDecoration(
                              color: Color(meal['color']),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          SizedBox(width: sw * 0.04),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  displayName,
                                  style: TextStyle(fontSize: sw * 0.04, fontWeight: FontWeight.bold, color: textColor),
                                ),
                                Text(
                                  timeStr,
                                  style: TextStyle(fontSize: sw * 0.03, color: subTextColor),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '${meal['calories']} cal',
                                style: TextStyle(fontSize: sw * 0.04, fontWeight: FontWeight.bold, color: Color(meal['color'])),
                              ),
                              Text(
                                '${meal['grams']}g',
                                style: TextStyle(fontSize: sw * 0.03, color: subTextColor),
                              ),
                            ],
                          ),
                        ],
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