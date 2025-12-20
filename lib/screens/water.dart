import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Project Imports
import '../providers/health.dart';
import '../notifications/introvert.dart';
import '../l10n/app_localizations.dart';
import '../utils/converter.dart';
import '../theme.dart';
import '../app.dart'; // For InvertedColor extension

class WaterScreen extends StatefulWidget {
  const WaterScreen({super.key});

  @override
  State<WaterScreen> createState() => _WaterScreenState();
}

class _WaterScreenState extends State<WaterScreen> {
  // Semantic Water Color (Blue)
  final Color _waterColor = const Color(0xFF64B5F6);

  void _addWater(int ml) {
    final healthProvider = Provider.of<HealthProvider>(context, listen: false);
    healthProvider.addWaterMl(ml);
  }

  void _showGoalDialog() {
    final healthProvider = Provider.of<HealthProvider>(context, listen: false);
    final isImperial = healthProvider.units == 'imperial';
    final currentGoalMl = healthProvider.healthData.waterGoal * 250;

    final displayGoal = isImperial
        ? UnitConverter.mlToOz(currentGoalMl).round()
        : currentGoalMl;

    final controller = TextEditingController(text: displayGoal.toString());

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
                  color: _waterColor.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.flag_rounded, color: _waterColor, size: sw * 0.08),
              ),
              SizedBox(height: sh * 0.02),
              Text(
                'Set Your Water Goal', // Recommend adding to AppLocalizations
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
                  'How much water do you want to drink daily?', // Recommend adding to AppLocalizations
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
                      color: _waterColor,
                    ),
                    decoration: InputDecoration(
                      hintText: isImperial ? '64' : '2000',
                      hintStyle: TextStyle(
                        color: hintColor.withValues(alpha: 0.5),
                      ),
                      border: InputBorder.none,
                      suffix: Text(
                        isImperial ? 'oz' : 'ml',
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
                          'Cancel', // Recommend adding to AppLocalizations
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
                          final val = int.tryParse(controller.text);
                          if (val != null && val > 0) {
                            final ml = isImperial ? UnitConverter.ozToMl(val.toDouble()).round() : val;
                            healthProvider.updateWaterGoalMl(ml);
                            Navigator.pop(context);

                            // Use IntrovertNotificationService
                            context.read<IntrovertNotificationService>().showNotification(
                              message: AppLocalizations.of(context)!.dailyGoalSetTo(val.toString(), isImperial ? 'oz' : 'ml'),
                              type: NotificationType.success,
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _waterColor,
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
    final textColor = AppColors.primaryColor.inverted;

    final healthProvider = Provider.of<HealthProvider>(context);
    final isImperial = healthProvider.units == 'imperial';
    final glassesConsumed = healthProvider.healthData.waterGlasses;
    final dailyGoal = healthProvider.healthData.waterGoal;
    final mlConsumed = glassesConsumed * 250; // Each glass is 250ml
    final mlGoal = dailyGoal * 250;

    final displayConsumed = isImperial ? UnitConverter.mlToOz(mlConsumed).round() : mlConsumed;
    final displayGoal = isImperial ? UnitConverter.mlToOz(mlGoal).round() : mlGoal;
    final unit = isImperial ? 'oz' : 'ml';

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.chevron_left_rounded, color: textColor, size: sw * 0.08),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(AppLocalizations.of(context)!.waterIntake, style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: paddingH, vertical: paddingV),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Hero(
                tag: 'water_card',
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    padding: EdgeInsets.all(sw * 0.06),
                    decoration: BoxDecoration(
                      color: _waterColor,
                      borderRadius: BorderRadius.circular(sw * 0.06),
                      boxShadow: [
                        BoxShadow(
                            color: _waterColor.withValues(alpha: 0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 10)
                        )
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.waterIntake,
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
                            value: (glassesConsumed / dailyGoal).clamp(0.0, 1.0),
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
                              '$displayConsumed',
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
                                AppLocalizations.of(context)!.ofValueUnit(displayGoal.toString(), unit),
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
                                    color: Colors.white,
                                    fontSize: sw * 0.035,
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
                AppLocalizations.of(context)!.quickAdd,
                style: TextStyle(fontSize: sw * 0.05, fontWeight: FontWeight.bold, color: textColor),
              ),
              SizedBox(height: sh * 0.02),
              Row(
                children: [
                  Expanded(
                    child: _buildQuickAddButton(
                        isImperial ? '8oz' : '200ml',
                        isImperial ? UnitConverter.ozToMl(8).round() : 200,
                        Icons.water_drop_rounded,
                        _waterColor
                    ),
                  ),
                  SizedBox(width: sw * 0.03),
                  Expanded(
                    child: _buildQuickAddButton(
                        isImperial ? '16oz' : '500ml',
                        isImperial ? UnitConverter.ozToMl(16).round() : 500,
                        Icons.water_drop_rounded,
                        _waterColor
                    ),
                  ),
                  SizedBox(width: sw * 0.03),
                  Expanded(
                    child: _buildQuickAddButton(
                        isImperial ? '32oz' : '1L',
                        isImperial ? UnitConverter.ozToMl(32).round() : 1000,
                        Icons.water_drop_rounded,
                        _waterColor
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

  Widget _buildQuickAddButton(String label, int ml, IconData icon, Color color) {
    // Dynamic Dimensions
    final sw = MediaQuery.of(context).size.width;
    final sh = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: () => _addWater(ml),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: sh * 0.025),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(sw * 0.04),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.white, size: sw * 0.08),
            SizedBox(height: sh * 0.01),
            Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontSize: sw * 0.045,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}