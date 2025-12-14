import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/health_provider.dart';
import '../l10n/app_localizations.dart';
import '../utils/notification_helper.dart';

class NutritionScreen extends StatefulWidget {
  const NutritionScreen({super.key});

  @override
  State<NutritionScreen> createState() => _NutritionScreenState();
}

class _NutritionScreenState extends State<NutritionScreen> {

  void _showGoalDialog() {
    final healthProvider = Provider.of<HealthProvider>(context, listen: false);
    final currentGoal = healthProvider.healthData.caloriesGoal;
    final controller = TextEditingController(text: currentGoal.toString());

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.all(Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFB74D).withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.flag_rounded, color: Color(0xFFFFB74D), size: 32),
              ),
              const SizedBox(height: 16),
              Text(
                AppLocalizations.of(context)!.setYourCalorieGoal,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  AppLocalizations.of(context)!.howManyCalories,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: controller,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFFB74D),
                    ),
                    decoration: InputDecoration(
                      hintText: AppLocalizations.of(context)!.dailyCalorieHint,
                      hintStyle: TextStyle(
                        color: Colors.grey[400],
                      ),
                      border: InputBorder.none,
                      suffix: Text(
                        'kcal',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[500],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: Text(
                          AppLocalizations.of(context)!.cancel,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          final cal = int.tryParse(controller.text);
                          if (cal != null && cal > 0) {
                            healthProvider.updateCaloriesGoal(cal);
                            Navigator.pop(context);
                            NotificationHelper.showSuccess(context, AppLocalizations.of(context)!.goalSet, AppLocalizations.of(context)!.calorieGoalSet(cal), backgroundColor: const Color(0xFFFFB74D), icon: Icons.flag);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFFB74D),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          AppLocalizations.of(context)!.setGoal,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddMealDialog() {
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFFB74D).withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.restaurant_rounded, color: Color(0xFFFFB74D), size: 32),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.selectPlateType,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _buildPlateTypeOption(l10n.plate, Icons.dinner_dining_rounded, const Color(0xFFFFB74D)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildPlateTypeOption(l10n.bowl, Icons.rice_bowl_rounded, const Color(0xFFFFB74D)),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildPlateTypeOption(String title, IconData icon, Color color) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        _showFillLevelDialog(title, icon, color);
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 2)),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 32),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  void _showFillLevelDialog(String plateType, IconData plateIcon, Color plateColor) {
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: plateColor.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(plateIcon, color: plateColor, size: 32),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.fillLevel,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              '$plateType - ${l10n.selectPlateType}',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            const SizedBox(height: 20),
            _buildFillLevelOption(l10n.quarter, 0.25, plateType, plateColor),
            const SizedBox(height: 12),
            _buildFillLevelOption(l10n.half, 0.5, plateType, plateColor),
            const SizedBox(height: 12),
            _buildFillLevelOption(l10n.threeQuarters, 0.75, plateType, plateColor),
            const SizedBox(height: 12),
            _buildFillLevelOption(l10n.full, 1.0, plateType, plateColor),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildFillLevelOption(String title, double fillLevel, String plateType, Color color) {
    // Plate: ~250g, Bowl: ~150g (per 100g reference)
    final baseGrams = plateType.toLowerCase().contains('plate') || plateType.toLowerCase().contains('tabak') ? 250 : 150;
    final grams = (baseGrams * fillLevel).round();
    
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        _showFoodSelectionDialog(plateType, title, fillLevel, grams, color);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 2)),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: Colors.grey[300],
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
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
            Text(
              AppLocalizations.of(context)!.gramsAmount(grams.toString()),
              style: TextStyle(fontSize: 14, color: Colors.grey[600], fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  void _showFoodSelectionDialog(String plateType, String fillTitle, double fillLevel, int grams, Color plateColor) {
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(24),
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.7,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFFB74D).withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.restaurant_rounded, color: Color(0xFFFFB74D), size: 32),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.selectFood,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              AppLocalizations.of(context)!.foodSelectionSubtitle(plateType, fillTitle, grams.toString()),
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            const SizedBox(height: 20),
            Flexible(
              child: ListView(
                shrinkWrap: true,
                children: [
                  _buildFoodOption('egg', Icons.egg_rounded, 155, grams, plateType, fillTitle, const Color(0xFFFFB74D)),
                  const SizedBox(height: 8),
                  _buildFoodOption('whiteRice', Icons.rice_bowl_rounded, 130, grams, plateType, fillTitle, const Color(0xFFFFB74D)),
                  const SizedBox(height: 8),
                  _buildFoodOption('plainPasta', Icons.restaurant_rounded, 131, grams, plateType, fillTitle, const Color(0xFFFFB74D)),
                  const SizedBox(height: 8),
                  _buildFoodOption('chickenBreast', Icons.set_meal_rounded, 165, grams, plateType, fillTitle, const Color(0xFFE57373)),
                  const SizedBox(height: 8),
                  _buildFoodOption('grilledSalmon', Icons.set_meal_rounded, 208, grams, plateType, fillTitle, const Color(0xFF64B5F6)),
                  const SizedBox(height: 8),
                  _buildFoodOption('boiledPotato', Icons.breakfast_dining_rounded, 87, grams, plateType, fillTitle, const Color(0xFFFFB74D)),
                  const SizedBox(height: 8),
                  _buildFoodOption('mixedVegetables', Icons.eco_rounded, 70, grams, plateType, fillTitle, const Color(0xFF4CAF50)),
                  const SizedBox(height: 8),
                  _buildFoodOption('couscous', Icons.grain_rounded, 112, grams, plateType, fillTitle, const Color(0xFFFFB74D)),
                  const SizedBox(height: 8),
                  _buildFoodOption('quinoa', Icons.grain_rounded, 120, grams, plateType, fillTitle, const Color(0xFFFFB74D)),
                  const SizedBox(height: 8),
                  _buildFoodOption('bulgur', Icons.grain_rounded, 110, grams, plateType, fillTitle, const Color(0xFFFFB74D)),
                  const SizedBox(height: 8),
                  _buildFoodOption('corn', Icons.agriculture_rounded, 96, grams, plateType, fillTitle, const Color(0xFFFFB74D)),
                  const SizedBox(height: 8),
                  _buildFoodOption('peas', Icons.eco_rounded, 80, grams, plateType, fillTitle, const Color(0xFF4CAF50)),
                  const SizedBox(height: 8),
                  _buildFoodOption('broccoli', Icons.eco_rounded, 55, grams, plateType, fillTitle, const Color(0xFF4CAF50)),
                  const SizedBox(height: 8),
                  _buildFoodOption('mushroom', Icons.nature_rounded, 45, grams, plateType, fillTitle, const Color(0xFF4CAF50)),
                  const SizedBox(height: 8),
                  _buildFoodOption('stirFryVegetables', Icons.restaurant_rounded, 120, grams, plateType, fillTitle, const Color(0xFF4CAF50)),
                  const SizedBox(height: 8),
                  _buildFoodOption('sweetPotato', Icons.breakfast_dining_rounded, 86, grams, plateType, fillTitle, const Color(0xFFFFB74D)),
                  const SizedBox(height: 8),
                  _buildFoodOption('baldoRice', Icons.rice_bowl_rounded, 115, grams, plateType, fillTitle, const Color(0xFFFFB74D)),
                  const SizedBox(height: 8),
                  _buildFoodOption('chickenCurry', Icons.restaurant_rounded, 150, grams, plateType, fillTitle, const Color(0xFFE57373)),
                  const SizedBox(height: 8),
                  _buildFoodOption('beefCurry', Icons.restaurant_rounded, 180, grams, plateType, fillTitle, const Color(0xFFE57373)),
                  const SizedBox(height: 8),
                  _buildFoodOption('spaghettiPuttanesca', Icons.restaurant_rounded, 140, grams, plateType, fillTitle, const Color(0xFFFFB74D)),
                  const SizedBox(height: 8),
                  _buildFoodOption('ravioli', Icons.restaurant_rounded, 150, grams, plateType, fillTitle, const Color(0xFFFFB74D)),
                  const SizedBox(height: 8),
                  _buildFoodOption('gnocchi', Icons.restaurant_rounded, 130, grams, plateType, fillTitle, const Color(0xFFFFB74D)),
                  const SizedBox(height: 8),
                  _buildFoodOption('kidneyBeans', Icons.eco_rounded, 130, grams, plateType, fillTitle, const Color(0xFF4CAF50)),
                  const SizedBox(height: 8),
                  _buildFoodOption('chickpeas', Icons.eco_rounded, 164, grams, plateType, fillTitle, const Color(0xFFFFB74D)),
                  const SizedBox(height: 8),
                  _buildFoodOption('lentils', Icons.eco_rounded, 116, grams, plateType, fillTitle, const Color(0xFF4CAF50)),
                  const SizedBox(height: 8),
                  _buildFoodOption('whiteBeans', Icons.eco_rounded, 130, grams, plateType, fillTitle, const Color(0xFF4CAF50)),
                  const SizedBox(height: 8),
                  _buildFoodOption('tuna', Icons.set_meal_rounded, 132, grams, plateType, fillTitle, const Color(0xFF64B5F6)),
                  const SizedBox(height: 8),
                  _buildFoodOption('mussels', Icons.set_meal_rounded, 86, grams, plateType, fillTitle, const Color(0xFF64B5F6)),
                  const SizedBox(height: 8),
                  _buildFoodOption('shrimp', Icons.set_meal_rounded, 105, grams, plateType, fillTitle, const Color(0xFF64B5F6)),
                  const SizedBox(height: 8),
                  _buildFoodOption('caesarSalad', Icons.eco_rounded, 120, grams, plateType, fillTitle, const Color(0xFF4CAF50)),
                  const SizedBox(height: 8),
                  _buildFoodOption('tofu', Icons.food_bank_rounded, 95, grams, plateType, fillTitle, const Color(0xFF4CAF50)),
                  const SizedBox(height: 8),
                  _buildFoodOption('salad', Icons.eco_rounded, 15, grams, plateType, fillTitle, const Color(0xFF4CAF50)),
                  const SizedBox(height: 8),
                  _buildFoodOption('soup', Icons.soup_kitchen_rounded, 38, grams, plateType, fillTitle, const Color(0xFFFFB74D)),
                  const SizedBox(height: 8),
                  _buildFoodOption('fruit', Icons.apple_rounded, 52, grams, plateType, fillTitle, const Color(0xFFE57373)),
                  const SizedBox(height: 8),
                  _buildFoodOption('vegetables', Icons.grass_rounded, 35, grams, plateType, fillTitle, const Color(0xFF4CAF50)),
                  const SizedBox(height: 8),
                  _buildFoodOption('milk', Icons.local_drink_rounded, 42, grams, plateType, fillTitle, const Color(0xFF64B5F6)),
                  const SizedBox(height: 8),
                  _buildFoodOption('yogurt', Icons.coffee_rounded, 61, grams, plateType, fillTitle, const Color(0xFF64B5F6)),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFoodOption(String foodNameKey, IconData icon, int calPer100g, int grams, String plateType, String fillTitle, Color color) {
    final l10n = AppLocalizations.of(context)!;
    final actualCalories = ((calPer100g / 100) * grams).round();
    final displayName = _getLocalizedFoodName(foodNameKey);
    
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        _addMeal(foodNameKey, displayName, actualCalories, grams, plateType, fillTitle, color);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 2)),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                displayName,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  AppLocalizations.of(context)!.caloriesAmount(actualCalories.toString()),
                  style: TextStyle(fontSize: 14, color: Colors.grey[800], fontWeight: FontWeight.bold),
                ),
                Text(
                  AppLocalizations.of(context)!.caloriesPer100g(calPer100g.toString()),
                  style: TextStyle(fontSize: 11, color: Colors.grey[500]),
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
    final healthProvider = Provider.of<HealthProvider>(context);
    final healthData = healthProvider.healthData;
    final caloriesConsumed = healthData.caloriesConsumed;
    final dailyGoal = healthData.caloriesGoal;
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.chevron_left_rounded, color: Theme.of(context).textTheme.bodyLarge?.color, size: 32),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(l10n.nutrition, style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFFFB74D),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.add, color: Colors.white),
            ),
            onPressed: _showAddMealDialog,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Hero(
                tag: 'nutrition_card',
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFB74D),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [BoxShadow(color: const Color(0xFFFFB74D).withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10))],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.nutrition,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white70,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: LinearProgressIndicator(
                            value: (caloriesConsumed / dailyGoal).clamp(0.0, 1.0),
                            minHeight: 12,
                            backgroundColor: Colors.white70,
                            valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '$caloriesConsumed',
                              style: const TextStyle(
                                fontSize: 64,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                height: 1,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Text(
                              AppLocalizations.of(context)!.valueOfTarget(caloriesConsumed.toString(), dailyGoal.toString()),
                                style: TextStyle(
                                  fontSize: 24,
                                  color: Colors.white70,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        GestureDetector(
                          onTap: _showGoalDialog,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.white70,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.edit, color: Colors.white, size: 16),
                                SizedBox(width: 8),
                                Text(
                                  AppLocalizations.of(context)!.editGoal,
                                  style: TextStyle(
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

              const SizedBox(height: 32),
              Text(
                l10n.todaysMeals,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: healthData.mealLog.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.restaurant_menu_rounded,
                              size: 80,
                              color: Colors.grey[300],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              l10n.noMealsYet,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[400],
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: healthData.mealLog.length,
                        itemBuilder: (context, index) {
                          final meal = healthData.mealLog[index];
                          final time = DateTime.parse(meal['time']);
                          final timeStr = '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
                          final nameKey = meal['nameKey'] ?? 'unknown';
                          final displayName = _getLocalizedFoodName(nameKey);
                          
                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: const [
                                BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 2)),
                              ],
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 4,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: Color(meal['color']),
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        displayName,
                                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        timeStr,
                                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      '${meal['calories']} cal',
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(meal['color'])),
                                    ),
                                    Text(
                                      '${meal['grams']}g',
                                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
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
