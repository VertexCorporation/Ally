import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

// Project Imports
import '../providers/health.dart';
import '../server/user.dart';
import '../l10n/app_localizations.dart';
import '../utils/converter.dart';
import '../theme.dart';
import '../app.dart'; // For InvertedColor extension

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

    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
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

    // Dynamic Dimensions
    final sw = MediaQuery.of(context).size.width;
    final sh = MediaQuery.of(context).size.height;

    // Theme Colors
    final Color accentColor = AppColors.senaryColor;
    final Color cardColor = AppColors.secondaryColor;
    final Color textColor = AppColors.primaryColor.inverted;
    final Color hintColor = AppColors.tertiaryColor;
    final Color backgroundColor = AppColors.background;
    final Color borderColor = AppColors.border;

    showModalBottomSheet(
      context: context,
      backgroundColor: backgroundColor.withValues(alpha: 0), // Transparent via theme
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          margin: EdgeInsets.all(sw * 0.04), // 4% margin
          padding: EdgeInsets.all(sw * 0.06), // 6% padding inside
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(sw * 0.06),
            border: Border.all(color: borderColor, width: 1),
            boxShadow: [
              BoxShadow(
                color: textColor.withValues(alpha: 0.05),
                blurRadius: sw * 0.05,
                offset: Offset(0, sw * 0.01),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(sw * 0.04),
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: accentColor, size: sw * 0.08),
              ),
              SizedBox(height: sh * 0.02),
              Text(
                title,
                style: TextStyle(
                  fontSize: sw * 0.05,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              SizedBox(height: sh * 0.03),
              TextField(
                controller: controller,
                keyboardType: keyboardType,
                autofocus: true,
                style: TextStyle(fontSize: sw * 0.04, color: textColor),
                cursorColor: accentColor,
                decoration: InputDecoration(
                  labelText: label,
                  labelStyle: TextStyle(color: hintColor),
                  suffixText: suffix,
                  suffixStyle: TextStyle(color: hintColor),
                  filled: true,
                  fillColor: cardColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(sw * 0.03),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(sw * 0.03),
                    borderSide: BorderSide(color: accentColor, width: 2),
                  ),
                ),
              ),
              SizedBox(height: sh * 0.03),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: sh * 0.02),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(sw * 0.03),
                        ),
                      ),
                      child: Text(
                        AppLocalizations.of(context)!.cancel,
                        style: TextStyle(fontSize: sw * 0.04, color: hintColor),
                      ),
                    ),
                  ),
                  SizedBox(width: sw * 0.03),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (controller.text.isNotEmpty) {
                          onSave(controller.text);
                          Navigator.pop(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: accentColor,
                        padding: EdgeInsets.symmetric(vertical: sh * 0.02),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(sw * 0.03),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        AppLocalizations.of(context)!.save,
                        style: TextStyle(
                          fontSize: sw * 0.04,
                          fontWeight: FontWeight.w600,
                          // Ensures text is readable on accent color
                          color: AppColors.background,
                        ),
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

  // --- Logic Methods (Dialog Triggers) ---

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

    // Dimensions for dialog
    final sw = MediaQuery.of(context).size.width;
    final accentColor = AppColors.senaryColor;
    final cardColor = AppColors.secondaryColor;
    final textColor = AppColors.primaryColor.inverted;
    final hintColor = AppColors.tertiaryColor;

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
        backgroundColor: AppColors.background,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(sw * 0.06)),
        title: Row(
          children: [
            Container(
              padding: EdgeInsets.all(sw * 0.03),
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(sw * 0.03),
              ),
              child: Icon(Icons.height_rounded, color: accentColor, size: sw * 0.06),
            ),
            SizedBox(width: sw * 0.04),
            Text(
                AppLocalizations.of(context)!.editHeight,
                style: TextStyle(fontWeight: FontWeight.bold, color: textColor, fontSize: sw * 0.05)
            ),
          ],
        ),
        content: Row(
          children: [
            Expanded(
              child: TextField(
                controller: feetController,
                keyboardType: TextInputType.number,
                style: TextStyle(color: textColor),
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.feet,
                  labelStyle: TextStyle(color: hintColor),
                  filled: true,
                  fillColor: cardColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(sw * 0.03),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            SizedBox(width: sw * 0.04),
            Expanded(
              child: TextField(
                controller: inchesController,
                keyboardType: TextInputType.number,
                style: TextStyle(color: textColor),
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.inches,
                  labelStyle: TextStyle(color: hintColor),
                  filled: true,
                  fillColor: cardColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(sw * 0.03),
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
            child: Text(AppLocalizations.of(context)!.cancel, style: TextStyle(color: hintColor)),
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
            child: Text(AppLocalizations.of(context)!.save, style: TextStyle(fontWeight: FontWeight.bold, color: accentColor)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // -------------------------------------------------------------------------
    // DYNAMIC DIMENSIONS & COLORS (No Consts)
    // -------------------------------------------------------------------------
    final sw = MediaQuery.of(context).size.width;
    final sh = MediaQuery.of(context).size.height;

    // Spacing variables
    final paddingH = sw * 0.05; // 5% Horizontal Padding
    final paddingV = sh * 0.02; // 2% Vertical Padding
    final cardPadding = sw * 0.05;

    // Theme references (Directly from AppColors to ensure sync)
    final Color backgroundColor = AppColors.background;
    final Color cardColor = AppColors.secondaryColor;
    final Color accentColor = AppColors.senaryColor;
    final Color dangerColor = AppColors.septenaryColor;
    final Color textColor = AppColors.primaryColor.inverted;
    final Color subTextColor = AppColors.tertiaryColor;
    final Color shadowColor = AppColors.primaryColor.inverted.withValues(alpha: 0.05);

    // Box Shadow Style
    final List<BoxShadow> commonShadow = [
      BoxShadow(
        color: shadowColor,
        blurRadius: sw * 0.05,
        offset: Offset(0, sw * 0.01),
      ),
    ];

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _handleBack();
      },
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: backgroundColor.withValues(alpha: 0),
          elevation: 0,
          toolbarHeight: 0,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: backgroundColor.withValues(alpha: 0),
            statusBarIconBrightness: AppColors.getThemeColors(AppColors.currentTheme).statusBarIconBrightness,
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
                  child: Consumer<UserProvider>(
                    builder: (context, userProvider, child) {
                      // Extract User Data safely
                      final userData = userProvider.userData;
                      final username = userProvider.username;
                      final isAnon = userProvider.isAnonymous;
                      final country = userData?['country'] as String? ?? AppLocalizations.of(context)!.notSet;
                      final dob = AppLocalizations.of(context)!.notSet;

                      return CustomScrollView(
                        physics: const BouncingScrollPhysics(),
                        slivers: [
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: paddingH, vertical: paddingV),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // 1. Back Button & Title
                                  Row(
                                    children: [
                                      GestureDetector(
                                        onTap: _handleBack,
                                        child: Icon(Icons.chevron_left_rounded, size: sw * 0.08, color: textColor),
                                      ),
                                      SizedBox(width: sw * 0.04),
                                      Text(
                                        AppLocalizations.of(context)!.account,
                                        style: TextStyle(
                                          fontSize: sw * 0.06,
                                          fontWeight: FontWeight.bold,
                                          color: textColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: sh * 0.04),

                                  // 2. Profile Card
                                  Container(
                                    padding: EdgeInsets.all(cardPadding),
                                    decoration: BoxDecoration(
                                      color: cardColor,
                                      borderRadius: BorderRadius.circular(sw * 0.05),
                                      boxShadow: commonShadow,
                                    ),
                                    child: Row(
                                      children: [
                                        Stack(
                                          children: [
                                            Container(
                                              padding: EdgeInsets.all(sw * 0.01),
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: accentColor,
                                              ),
                                              child: Container(
                                                width: sw * 0.16,
                                                height: sw * 0.16,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: cardColor,
                                                ),
                                                alignment: Alignment.center,
                                                child: Text(
                                                  userProvider.profileInitial,
                                                  style: TextStyle(
                                                    fontSize: sw * 0.07,
                                                    fontWeight: FontWeight.bold,
                                                    color: accentColor,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            if (!isAnon)
                                              Positioned(
                                                bottom: 0,
                                                right: 0,
                                                child: Container(
                                                  padding: EdgeInsets.all(sw * 0.02),
                                                  decoration: BoxDecoration(
                                                    color: accentColor,
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: Icon(
                                                    Icons.edit,
                                                    size: sw * 0.03,
                                                    color: backgroundColor,
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                        SizedBox(width: sw * 0.04),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                username,
                                                style: TextStyle(
                                                  fontSize: sw * 0.055,
                                                  fontWeight: FontWeight.bold,
                                                  color: textColor,
                                                ),
                                              ),
                                              if (userData != null && userData['email'] != null)
                                                Padding(
                                                  padding: EdgeInsets.only(top: sh * 0.005),
                                                  child: Text(
                                                    userData['email'],
                                                    style: TextStyle(
                                                      fontSize: sw * 0.035,
                                                      color: subTextColor,
                                                    ),
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  SizedBox(height: sh * 0.04),

                                  // 3. Personal Information
                                  _buildSectionTitle(context, AppLocalizations.of(context)!.personalInfo),
                                  SizedBox(height: sh * 0.015),
                                  _buildInfoTile(
                                    context,
                                    AppLocalizations.of(context)!.fullName,
                                    username,
                                    Icons.person_rounded,
                                    accentColor,
                                  ),
                                  SizedBox(height: sh * 0.015),
                                  _buildInfoTile(
                                    context,
                                    AppLocalizations.of(context)!.country,
                                    country,
                                    Icons.flag_rounded,
                                    accentColor,
                                  ),

                                  if (!isAnon) ...[
                                    SizedBox(height: sh * 0.015),
                                    _buildInfoTile(
                                      context,
                                      AppLocalizations.of(context)!.dateOfBirth,
                                      dob,
                                      Icons.cake_rounded,
                                      accentColor,
                                    ),
                                  ],

                                  SizedBox(height: sh * 0.04),

                                  // 4. Health Information
                                  _buildSectionTitle(context, AppLocalizations.of(context)!.healthInfo),
                                  SizedBox(height: sh * 0.015),
                                  Consumer<HealthProvider>(
                                    builder: (context, healthProvider, child) {
                                      final healthData = healthProvider.healthData;
                                      final l10n = AppLocalizations.of(context)!;

                                      return Column(
                                        children: [
                                          GestureDetector(
                                            onTap: _showEditWeightDialog,
                                            child: _buildInfoTile(
                                              context,
                                              l10n.currentWeight,
                                              UnitConverter.formatWeight(healthData.currentWeight, healthProvider.units),
                                              Icons.monitor_weight_rounded,
                                              accentColor,
                                              isEditable: true,
                                            ),
                                          ),
                                          SizedBox(height: sh * 0.015),
                                          GestureDetector(
                                            onTap: _showEditGoalWeightDialog,
                                            child: _buildInfoTile(
                                              context,
                                              AppLocalizations.of(context)!.goalWeight,
                                              UnitConverter.formatWeight(healthData.goalWeight, healthProvider.units),
                                              Icons.flag_rounded,
                                              accentColor,
                                              isEditable: true,
                                            ),
                                          ),
                                          SizedBox(height: sh * 0.015),
                                          GestureDetector(
                                            onTap: _showEditHeightDialog,
                                            child: _buildInfoTile(
                                              context,
                                              AppLocalizations.of(context)!.height,
                                              UnitConverter.formatHeight(healthData.height, healthProvider.units),
                                              Icons.height_rounded,
                                              accentColor,
                                              isEditable: true,
                                            ),
                                          ),
                                          SizedBox(height: sh * 0.015),
                                          GestureDetector(
                                            onTap: _showEditWaterGoalDialog,
                                            child: _buildInfoTile(
                                              context,
                                              l10n.waterGoal,
                                              l10n.glassesPerDay(healthData.waterGoal),
                                              Icons.water_drop_rounded,
                                              accentColor,
                                              isEditable: true,
                                            ),
                                          ),
                                          SizedBox(height: sh * 0.015),
                                          GestureDetector(
                                            onTap: _showEditCalorieGoalDialog,
                                            child: _buildInfoTile(
                                              context,
                                              l10n.calorieGoal,
                                              l10n.kcalPerDay(healthData.caloriesGoal),
                                              Icons.local_fire_department_rounded,
                                              accentColor,
                                              isEditable: true,
                                            ),
                                          ),
                                          SizedBox(height: sh * 0.015),
                                          _buildInfoTile(
                                            context,
                                            l10n.exerciseStreak,
                                            l10n.daysCount(healthData.exerciseStreak),
                                            Icons.fitness_center_rounded,
                                            accentColor,
                                          ),
                                        ],
                                      );
                                    },
                                  ),

                                  SizedBox(height: sh * 0.04),

                                  // 5. BMI Section
                                  _buildSectionTitle(context, AppLocalizations.of(context)!.bodyMassIndex),
                                  SizedBox(height: sh * 0.015),
                                  Consumer<HealthProvider>(
                                    builder: (context, healthProvider, child) {
                                      final healthData = healthProvider.healthData;
                                      final bmi = healthData.bmi;
                                      final bmiCategory = healthData.bmiCategory;

                                      // Logic for BMI Color using ONLY AppColors
                                      Color categoryColor;
                                      if (bmi == 0) {
                                        categoryColor = subTextColor;
                                      } else if (bmi < 18.5) {
                                        // Underweight -> Warning -> Tertiary
                                        categoryColor = subTextColor;
                                      } else if (bmi < 25.0) {
                                        // Normal -> Good -> Senary (Accent)
                                        categoryColor = accentColor;
                                      } else if (bmi < 30.0) {
                                        // Overweight -> Warning -> Tertiary
                                        categoryColor = subTextColor;
                                      } else {
                                        // Obese -> Danger -> Septenary
                                        categoryColor = dangerColor;
                                      }

                                      return Container(
                                        padding: EdgeInsets.all(cardPadding),
                                        decoration: BoxDecoration(
                                          color: cardColor,
                                          borderRadius: BorderRadius.circular(sw * 0.04),
                                          boxShadow: commonShadow,
                                        ),
                                        child: Row(
                                          children: [
                                            Container(
                                              padding: EdgeInsets.all(sw * 0.03),
                                              decoration: BoxDecoration(
                                                color: categoryColor.withValues(alpha: 0.1),
                                                borderRadius: BorderRadius.circular(sw * 0.03),
                                              ),
                                              child: Icon(Icons.analytics_rounded, color: categoryColor, size: sw * 0.06),
                                            ),
                                            SizedBox(width: sw * 0.04),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    bmi == 0 ? AppLocalizations.of(context)!.notCalculated : bmiCategory,
                                                    style: TextStyle(
                                                      fontSize: sw * 0.035,
                                                      color: categoryColor,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                  SizedBox(height: sh * 0.005),
                                                  Text(
                                                    bmi == 0 ? AppLocalizations.of(context)!.addHeightWeight : AppLocalizations.of(context)!.bmiLabel(bmi.toStringAsFixed(1)),
                                                    style: TextStyle(
                                                      fontSize: sw * 0.045,
                                                      fontWeight: FontWeight.w600,
                                                      color: textColor,
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

                                  SizedBox(height: sh * 0.04),

                                  // 6. Danger Zone
                                  _buildSectionTitle(context, AppLocalizations.of(context)!.dangerZone),
                                  SizedBox(height: sh * 0.015),
                                  _buildActionTile(
                                    context,
                                    AppLocalizations.of(context)!.deleteAccount,
                                    AppLocalizations.of(context)!.deleteAccountDesc,
                                    Icons.delete_forever_rounded,
                                    accentColor,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SliverToBoxAdapter(child: SizedBox(height: sh * 0.1)),
                        ],
                      );
                    },
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    // Dynamic Font Size
    final sw = MediaQuery.of(context).size.width;
    return Text(
      title,
      style: TextStyle(
        fontSize: sw * 0.04,
        fontWeight: FontWeight.bold,
        color: AppColors.tertiaryColor,
      ),
    );
  }

  Widget _buildInfoTile(
      BuildContext context,
      String title,
      String value,
      IconData icon,
      Color accentColor, {
        bool isEditable = false,
      }) {
    // Dynamic Dimensions
    final sw = MediaQuery.of(context).size.width;
    final cardColor = AppColors.secondaryColor;
    final textColor = AppColors.primaryColor.inverted;
    final subTextColor = AppColors.tertiaryColor;

    return Container(
      padding: EdgeInsets.all(sw * 0.04),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(sw * 0.04),
        boxShadow: [
          BoxShadow(
            color: textColor.withValues(alpha: 0.05),
            blurRadius: sw * 0.025,
            offset: Offset(0, sw * 0.005),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(sw * 0.03),
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(sw * 0.03),
            ),
            child: Icon(icon, color: accentColor, size: sw * 0.06),
          ),
          SizedBox(width: sw * 0.04),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: sw * 0.032,
                    color: subTextColor,
                  ),
                ),
                SizedBox(height: sw * 0.01),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: sw * 0.042,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
              ],
            ),
          ),
          if (isEditable)
            Icon(
              Icons.edit_rounded,
              size: sw * 0.05,
              color: accentColor,
            ),
        ],
      ),
    );
  }

  Widget _buildActionTile(
      BuildContext context,
      String title,
      String subtitle,
      IconData icon,
      Color accentColor,
      ) {
    // Dynamic Dimensions
    final sw = MediaQuery.of(context).size.width;
    final cardColor = AppColors.secondaryColor;
    final subTextColor = AppColors.tertiaryColor;

    return Container(
      padding: EdgeInsets.all(sw * 0.04),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(sw * 0.04),
        border: Border.all(color: accentColor.withValues(alpha: 0.3), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.inverted.withValues(alpha: 0.05),
            blurRadius: sw * 0.025,
            offset: Offset(0, sw * 0.005),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(sw * 0.03),
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(sw * 0.03),
            ),
            child: Icon(icon, color: accentColor, size: sw * 0.06),
          ),
          SizedBox(width: sw * 0.04),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: sw * 0.042,
                    fontWeight: FontWeight.w600,
                    color: accentColor,
                  ),
                ),
                SizedBox(height: sw * 0.01),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: sw * 0.032,
                    color: subTextColor,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.arrow_forward_ios_rounded,
            size: sw * 0.04,
            color: accentColor,
          ),
        ],
      ),
    );
  }
}