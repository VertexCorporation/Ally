import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/health_provider.dart';
import '../l10n/app_localizations.dart';
import '../utils/unit_converter.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> with SingleTickerProviderStateMixin {
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

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleBack() {
    _controller.reverse().then((_) => Navigator.pop(context));
  }

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
                  color: const Color(0xFF4BAADF).withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: const Color(0xFF4BAADF), size: 32),
              ),
              const SizedBox(height: 16),
              Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),
              TextField(
                controller: controller,
                keyboardType: keyboardType,
                autofocus: true,
                style: const TextStyle(fontSize: 16),
                decoration: InputDecoration(
                  labelText: label,
                  suffixText: suffix,
                  filled: true,
                  fillColor: Theme.of(context).cardColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF4BAADF), width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text(
                        AppLocalizations.of(context)!.cancel,
                        style: const TextStyle(fontSize: 16, color: Color(0xFF888888)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (controller.text.isNotEmpty) {
                          onSave(controller.text);
                          Navigator.pop(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4BAADF),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                      ),
                      child: Text(
                        AppLocalizations.of(context)!.save,
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Theme.of(context).cardColor),
                      ),
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

  void _showEditWeightDialog() {
    final healthProvider = Provider.of<HealthProvider>(context, listen: false);
    final isImperial = healthProvider.units == 'imperial';
    final currentWeight = healthProvider.healthData.currentWeight;
    final displayWeight = isImperial ? UnitConverter.kgToLbs(currentWeight) : currentWeight;

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
          final weightInKg = isImperial ? UnitConverter.lbsToKg(weight) : weight;
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
    final displayWeight = isImperial ? UnitConverter.kgToLbs(goalWeight) : goalWeight;

    _showEditDialog(
      title: AppLocalizations.of(context)!.editWeight,
      icon: Icons.flag_rounded,
      currentValue: displayWeight.toStringAsFixed(1),
      label: 'Goal Weight',
      suffix: isImperial ? 'lbs' : 'kg',
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      onSave: (value) {
        final weight = double.tryParse(value);
        if (weight != null && weight > 0) {
          final weightInKg = isImperial ? UnitConverter.lbsToKg(weight) : weight;
          healthProvider.updateTargetWeight(weightInKg);
        }
      },
    );
  }

  void _showEditHeightDialog() {
    final healthProvider = Provider.of<HealthProvider>(context, listen: false);
    final isImperial = healthProvider.units == 'imperial';
    
    if (!isImperial) {
      final height = healthProvider.healthData.height;
      _showEditDialog(
        title: AppLocalizations.of(context)!.editHeight,
        icon: Icons.height_rounded,
        currentValue: height.toStringAsFixed(1),
        label: AppLocalizations.of(context)!.height,
        suffix: AppLocalizations.of(context)!.cm,
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
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF4BAADF).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.height_rounded, color: Color(0xFF4BAADF), size: 24),
            ),
            const SizedBox(width: 16),
            Text(AppLocalizations.of(context)!.editHeight, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        content: Row(
          children: [
            Expanded(
              child: TextField(
                controller: feetController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.feet,
                  filled: true,
                  fillColor: Theme.of(context).cardColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextField(
                controller: inchesController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.inches,
                  filled: true,
                  fillColor: Theme.of(context).cardColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.cancel, style: const TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              final f = double.tryParse(feetController.text) ?? 0;
              final i = double.tryParse(inchesController.text) ?? 0;
              if (f > 0 || i > 0) {
                final heightInCm = UnitConverter.feetAndInchesToCm(f.round(), i.round());
                healthProvider.updateHeight(heightInCm.toDouble());
                Navigator.pop(context);
              }
            },
            child: Text(AppLocalizations.of(context)!.save, style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _handleBack();
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          toolbarHeight: 0,
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.light,
            statusBarBrightness: Brightness.dark,
          ),
        ),
        body: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Opacity(
                opacity: _fadeAnimation.value,
                child: SafeArea(
                  child: CustomScrollView(
                    physics: const BouncingScrollPhysics(),
                    slivers: [
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: _handleBack,
                                    child: const Icon(Icons.chevron_left_rounded, size: 28),
                                  ),
                                  const SizedBox(width: 16),
                                  Text(
                                    AppLocalizations.of(context)!.account,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 30),
                              
                              // Profile Card - Horizontal
                              Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).cardColor,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 20,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    Stack(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(3),
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Color(0xFF4BAADF),
                                          ),
                                          child: Container(
                                            padding: const EdgeInsets.all(20),
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Theme.of(context).cardColor,
                                            ),
                                            child: const Icon(
                                              Icons.person,
                                              size: 32,
                                              color: Color(0xFF4BAADF),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          bottom: 0,
                                          right: 0,
                                          child: Container(
                                            padding: const EdgeInsets.all(6),
                                            decoration: const BoxDecoration(
                                              color: Color(0xFF4BAADF),
                                              shape: BoxShape.circle,
                                            ),
                                            child: Icon(
                                              Icons.edit,
                                              size: 12,
                                              color: Theme.of(context).cardColor,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            AppLocalizations.of(context)!.anonymousUser,
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Theme.of(context).textTheme.bodyLarge?.color,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              
                              const SizedBox(height: 30),
                              
                              // Personal Information
                              _buildSectionTitle(AppLocalizations.of(context)!.personalInfo),
                              const SizedBox(height: 12),
                              _buildInfoTile(
                                AppLocalizations.of(context)!.fullName,
                                AppLocalizations.of(context)!.anonymousUser,
                                Icons.person_rounded,
                                const Color(0xFF4BAADF),
                              ),
                              const SizedBox(height: 12),
                              _buildInfoTile(
                                AppLocalizations.of(context)!.country,
                                AppLocalizations.of(context)!.unitedStates,
                                Icons.flag_rounded,
                                const Color(0xFF4BAADF),
                              ),
                              const SizedBox(height: 12),
                              _buildInfoTile(
                                AppLocalizations.of(context)!.dateOfBirth,
                                AppLocalizations.of(context)!.january1,
                                Icons.cake_rounded,
                                const Color(0xFF4BAADF),
                              ),
                              
                              const SizedBox(height: 30),
                              
                              // Health Information
                              _buildSectionTitle(AppLocalizations.of(context)!.healthInfo),
                              const SizedBox(height: 12),
                              Consumer<HealthProvider>(
                                builder: (context, healthProvider, child) {
                                  final healthData = healthProvider.healthData;
                                  final l10n = AppLocalizations.of(context)!;
                                  return Column(
                                    children: [
                                      GestureDetector(
                                        onTap: _showEditWeightDialog,
                                        child: _buildInfoTile(
                                          l10n.currentWeight,
                                          UnitConverter.formatWeight(healthData.currentWeight, healthProvider.units),
                                          Icons.monitor_weight_rounded,
                                          const Color(0xFF4BAADF),
                                          isEditable: true,
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      GestureDetector(
                                        onTap: _showEditGoalWeightDialog,
                                        child: _buildInfoTile(
                                          AppLocalizations.of(context)!.goalWeight,
                                          UnitConverter.formatWeight(healthData.goalWeight, healthProvider.units),
                                          Icons.flag_rounded,
                                          const Color(0xFF4BAADF),
                                          isEditable: true,
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      GestureDetector(
                                        onTap: _showEditHeightDialog,
                                        child: _buildInfoTile(
                                          AppLocalizations.of(context)!.height,
                                          UnitConverter.formatHeight(healthData.height, healthProvider.units),
                                          Icons.height_rounded,
                                          const Color(0xFF4BAADF),
                                          isEditable: true,
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      GestureDetector(
                                        onTap: _showEditWaterGoalDialog,
                                        child: _buildInfoTile(
                                          l10n.waterGoal,
                                          l10n.glassesPerDay(healthData.waterGoal),
                                          Icons.water_drop_rounded,
                                          const Color(0xFF4BAADF),
                                          isEditable: true,
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      GestureDetector(
                                        onTap: _showEditCalorieGoalDialog,
                                        child: _buildInfoTile(
                                          l10n.calorieGoal,
                                          l10n.kcalPerDay(healthData.caloriesGoal),
                                          Icons.local_fire_department_rounded,
                                          const Color(0xFF4BAADF),
                                          isEditable: true,
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      _buildInfoTile(
                                        l10n.exerciseStreak,
                                        l10n.daysCount(healthData.exerciseStreak),
                                        Icons.fitness_center_rounded,
                                        const Color(0xFF4BAADF),
                                      ),
                                    ],
                                  );
                                },
                              ),


                              const SizedBox(height: 30),

                              // BMI Section
                              _buildSectionTitle(AppLocalizations.of(context)!.bodyMassIndex),
                              const SizedBox(height: 12),
                              Consumer<HealthProvider>(
                                builder: (context, healthProvider, child) {
                                  final healthData = healthProvider.healthData;
                                  final bmi = healthData.bmi;
                                  final bmiCategory = healthData.bmiCategory;

                                  Color categoryColor;
                                  if (bmi == 0) {
                                    categoryColor = const Color(0xFF888888);
                                  } else if (bmi < 18.5) {
                                    categoryColor = const Color(0xFF4BAADF);
                                  } else if (bmi < 25.0) {
                                    categoryColor = const Color(0xFF4CAF50);
                                  } else if (bmi < 30.0) {
                                    categoryColor = const Color(0xFFFFA726);
                                  } else {
                                    categoryColor = const Color(0xFFEF5350);
                                  }

                                  return Container(
                                    padding: const EdgeInsets.all(20),
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
                                    child: Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                            color: categoryColor.withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: Icon(Icons.analytics_rounded, color: categoryColor, size: 24),
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                bmi == 0 ? AppLocalizations.of(context)!.notCalculated : bmiCategory,
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  color: categoryColor,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                bmi == 0 ? AppLocalizations.of(context)!.addHeightWeight : AppLocalizations.of(context)!.bmiLabel(bmi.toStringAsFixed(1)),
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                              
                              const SizedBox(height: 30),
                              
                              // Danger Zone
                              _buildSectionTitle(AppLocalizations.of(context)!.dangerZone),
                              const SizedBox(height: 12),
                              _buildActionTile(
                                AppLocalizations.of(context)!.deleteAccount,
                                AppLocalizations.of(context)!.deleteAccountDesc,
                                Icons.delete_forever_rounded,
                                const Color(0xFF4BAADF),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SliverToBoxAdapter(child: SizedBox(height: 100)),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Color(0xFF888888),
      ),
    );
  }

  Widget _buildInfoTile(
    String title,
    String value,
    IconData icon,
    Color color, {
    bool isEditable = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
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
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF888888),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.edit_rounded,
            size: 20,
            color: Color(0xFF4BAADF),
          ),
        ],
      ),
    );
  }

  Widget _buildActionTile(
    String title,
    String subtitle,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3), width: 1.5),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF888888),
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.arrow_forward_ios_rounded,
            size: 16,
            color: color,
          ),
        ],
      ),
    );
  }
}
