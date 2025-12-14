import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../l10n/app_localizations.dart';
import '../services/pedometer_service.dart';
import '../utils/notification_helper.dart';

class CustomDialogs {
  // Service Management Dialog - Settings style BOTTOM SHEET
  static Future<void> showServiceControlDialog(BuildContext context) async {
    final pedometerService = PedometerService();
    
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.all(Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF4BAADF).withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.settings_suggest_rounded, color: Color(0xFF4BAADF), size: 32),
            ),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context)!.serviceControls,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  _buildDialogOption(
                    context,
                    AppLocalizations.of(context)!.startService,
                    Icons.play_circle_rounded,
                    () async {
                      await pedometerService.startNativeService();
                      if (context.mounted) {
                        Navigator.pop(context);
                        NotificationHelper.showSuccess(context, AppLocalizations.of(context)!.serviceStarted, AppLocalizations.of(context)!.serviceStartedDesc);
                      }
                    },
                  ),
                  const SizedBox(height: 8),
                  _buildDialogOption(
                    context,
                    AppLocalizations.of(context)!.restartService,
                    Icons.refresh_rounded,
                    () async {
                      await pedometerService.stopNativeService();
                      await Future.delayed(const Duration(milliseconds: 500));
                      await pedometerService.startNativeService();
                      if (context.mounted) {
                        Navigator.pop(context);
                        NotificationHelper.showInfo(context, AppLocalizations.of(context)!.serviceRestarted, AppLocalizations.of(context)!.serviceRestartedDesc);
                      }
                    },
                  ),
                  const SizedBox(height: 8),
                  _buildDialogOption(
                    context,
                    AppLocalizations.of(context)!.stopService,
                    Icons.stop_circle_rounded,
                    () async {
                      await pedometerService.stopNativeService();
                      if (context.mounted) {
                        Navigator.pop(context);
                        NotificationHelper.showError(context, AppLocalizations.of(context)!.serviceStopped, AppLocalizations.of(context)!.serviceStoppedDesc);
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Set Goal Dialog - Settings style
  static Future<void> showSetGoalDialog(BuildContext context, int currentGoal, Function(int) onGoalSet) async {
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
            borderRadius: const BorderRadius.all(Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF4BAADF).withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.flag_rounded, color: Color(0xFF4BAADF), size: 32),
              ),
              const SizedBox(height: 16),
              Text(
                AppLocalizations.of(context)!.setYourGoal,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  AppLocalizations.of(context)!.howManySteps,
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
                      color: Color(0xFF4BAADF),
                    ),
                    decoration: InputDecoration(
                      hintText: AppLocalizations.of(context)!.defaultStepGoal,
                      hintStyle: TextStyle(
                        color: Colors.grey[400],
                      ),
                      border: InputBorder.none,
                      suffix: Text(
                        AppLocalizations.of(context)!.stepsLabel,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[500],
                        ),
                      ),
                    ),
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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
                          final goal = int.tryParse(controller.text) ?? 6000;
                          onGoalSet(goal);
                          Navigator.pop(context);
                          NotificationHelper.showSuccess(context, AppLocalizations.of(context)!.goalSet, AppLocalizations.of(context)!.dailyGoalSet(goal.toString()), backgroundColor: const Color(0xFF4BAADF), icon: Icons.flag);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4BAADF),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          AppLocalizations.of(context)!.save,
                          style: TextStyle(
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

  static Widget _buildCustomDialog(BuildContext context, String title, IconData icon, Color color, List<Widget> options) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.all(Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 32),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: options,
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  static Widget _buildDialogOption(BuildContext context, String text, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
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
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF4BAADF).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: const Color(0xFF4BAADF), size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
