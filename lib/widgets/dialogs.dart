import 'package:ally/notifications/introvert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../services/pedometer.dart';

class CustomDialogs {
  // Service Management Dialog
  static Future<void> showServiceControlDialog(BuildContext context) async {
    final pedometerService = PedometerService();
    final notificationService = context.read<IntrovertNotificationService>();
    final l10n = AppLocalizations.of(context)!;

    // Ekran boyutlarını alıyoruz
    final size = MediaQuery.of(context).size;
    final double w = size.width;
    final double h = size.height;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        margin: EdgeInsets.all(w * 0.04), // %4 kenar boşluğu
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.all(Radius.circular(w * 0.06)), // Dinamik yuvarlatma
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: h * 0.025), // %2.5 dikey boşluk
            Container(
              padding: EdgeInsets.all(w * 0.04),
              decoration: BoxDecoration(
                color: const Color(0xFF4BAADF).withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(
                  Icons.settings_suggest_rounded,
                  color: const Color(0xFF4BAADF),
                  size: w * 0.08 // İkon boyutu ekran genişliğinin %8'i
              ),
            ),
            SizedBox(height: h * 0.02),
            Text(
              l10n.serviceControls,
              style: TextStyle(
                fontSize: w * 0.055, // Yazı boyutu ekranın %5.5'i
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: h * 0.025),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: w * 0.04),
              child: Column(
                children: [
                  _buildDialogOption(
                    context,
                    l10n.startService,
                    Icons.play_circle_rounded,
                        () async {
                      await pedometerService.startNativeService();
                      if (context.mounted) {
                        Navigator.pop(context);
                        notificationService.showNotification(
                          message: "${l10n.serviceStarted}: ${l10n.serviceStartedDesc}",
                          type: NotificationType.success,
                        );
                      }
                    },
                  ),
                  SizedBox(height: h * 0.01), // Butonlar arası boşluk

                  _buildDialogOption(
                    context,
                    l10n.restartService,
                    Icons.refresh_rounded,
                        () async {
                      await pedometerService.stopNativeService();
                      await Future.delayed(const Duration(milliseconds: 500));
                      await pedometerService.startNativeService();
                      if (context.mounted) {
                        Navigator.pop(context);
                        notificationService.showNotification(
                          message: "${l10n.serviceRestarted}: ${l10n.serviceRestartedDesc}",
                          type: NotificationType.success,
                        );
                      }
                    },
                  ),
                  SizedBox(height: h * 0.01),

                  _buildDialogOption(
                    context,
                    l10n.stopService,
                    Icons.stop_circle_rounded,
                        () async {
                      await pedometerService.stopNativeService();
                      if (context.mounted) {
                        Navigator.pop(context);
                        notificationService.showNotification(
                          message: "${l10n.serviceStopped}: ${l10n.serviceStoppedDesc}",
                          type: NotificationType.error,
                        );
                      }
                    },
                  ),
                  SizedBox(height: h * 0.03), // Alt boşluk
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Set Goal Dialog
  static Future<void> showSetGoalDialog(BuildContext context, int currentGoal, Function(int) onGoalSet) async {
    final controller = TextEditingController(text: currentGoal.toString());
    final notificationService = context.read<IntrovertNotificationService>();
    final l10n = AppLocalizations.of(context)!;

    // Ekran boyutları (Klavye açıldığında değişmemesi için builder dışında almak yerine padding'i MediaQuery ile yönetiyoruz)
    // Ancak font ve genel paddingler için referans boyut:
    final size = MediaQuery.of(context).size;
    final double w = size.width;
    final double h = size.height;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          margin: EdgeInsets.all(w * 0.04),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.all(Radius.circular(w * 0.06)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: h * 0.025),
              Container(
                padding: EdgeInsets.all(w * 0.04),
                decoration: BoxDecoration(
                  color: const Color(0xFF4BAADF).withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                    Icons.flag_rounded,
                    color: const Color(0xFF4BAADF),
                    size: w * 0.08
                ),
              ),
              SizedBox(height: h * 0.02),
              Text(
                l10n.setYourGoal,
                style: TextStyle(
                  fontSize: w * 0.055,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: h * 0.01),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: w * 0.06),
                child: Text(
                  l10n.howManySteps,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: w * 0.035, // Küçük açıklama metni
                    color: Colors.grey[600],
                  ),
                ),
              ),
              SizedBox(height: h * 0.03),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: w * 0.04),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: w * 0.05, vertical: h * 0.005),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(w * 0.04),
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
                    style: TextStyle(
                      fontSize: w * 0.065, // Input fontu büyük
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF4BAADF),
                    ),
                    decoration: InputDecoration(
                      hintText: l10n.defaultStepGoal,
                      hintStyle: TextStyle(
                        color: Colors.grey[400],
                      ),
                      border: InputBorder.none,
                      suffix: Text(
                        l10n.stepsLabel,
                        style: TextStyle(
                          fontSize: w * 0.035,
                          color: Colors.grey[500],
                        ),
                      ),
                    ),
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                ),
              ),
              SizedBox(height: h * 0.03),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: w * 0.04),
                child: Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: h * 0.02),
                        ),
                        child: Text(
                          l10n.cancel,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: w * 0.042,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: w * 0.03),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          final goal = int.tryParse(controller.text) ?? 6000;
                          onGoalSet(goal);
                          Navigator.pop(context);
                          notificationService.showNotification(
                            message: l10n.dailyGoalSetTo(goal.toString(), l10n.stepsLabel),
                            type: NotificationType.success,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4BAADF),
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: h * 0.02),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(w * 0.03),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          l10n.save,
                          style: TextStyle(
                            fontSize: w * 0.042,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: h * 0.025),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _buildDialogOption(BuildContext context, String text, IconData icon, VoidCallback onTap) {
    // Yardımcı widget içinde de dinamik boyutlar için MediaQuery kullanıyoruz
    final size = MediaQuery.of(context).size;
    final double w = size.width;
    final double h = size.height;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: h * 0.008), // Liste elemanları arası dikey boşluk
        padding: EdgeInsets.symmetric(horizontal: w * 0.05, vertical: h * 0.02), // İç boşluk
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(w * 0.04),
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
              padding: EdgeInsets.all(w * 0.02),
              decoration: BoxDecoration(
                color: const Color(0xFF4BAADF).withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                  icon,
                  color: const Color(0xFF4BAADF),
                  size: w * 0.05 // Küçük ikon boyutu
              ),
            ),
            SizedBox(width: w * 0.04),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: w * 0.042, // Liste metni boyutu
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