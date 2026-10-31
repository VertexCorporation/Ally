// dialogs.dart
//
// © 2026 Vertex Corporation
// ─────────────────────────────────────────────────────────────────────────────
// Shared dialogs for the pedometer service and daily step goal. Behaviour and
// notification hooks are unchanged; presentation uses the design system.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../design_system/design_system.dart';
import '../l10n/app_localizations.dart';
import '../notifications/introvert.dart';
import '../services/pedometer.dart';

class CustomDialogs {
  // Service Management Dialog
  static Future<void> showServiceControlDialog(BuildContext context) async {
    final pedometerService = PedometerService();
    final notificationService = context.read<IntrovertNotificationService>();
    final l10n = AppLocalizations.of(context)!;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (sheetContext) {
        final ThemeData theme = Theme.of(sheetContext);
        final ColorScheme scheme = theme.colorScheme;

        return Container(
          margin: const EdgeInsets.all(AllySpacing.lg),
          decoration: BoxDecoration(
            color: scheme.surface,
            borderRadius: AllyRadius.lgAll,
            border: Border.all(color: scheme.outlineVariant),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: AllySpacing.xl),
              Container(
                padding: const EdgeInsets.all(AllySpacing.lg),
                decoration: BoxDecoration(
                  color: scheme.onSurface.withValues(alpha: 0.06),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.settings_suggest_rounded,
                  color: scheme.onSurface,
                  size: AllyDimensions.iconXl,
                ),
              ),
              const SizedBox(height: AllySpacing.lg),
              Text(
                l10n.serviceControls,
                style: AllyTypography.headline(
                  size: 20,
                  color: scheme.onSurface,
                ),
              ),
              const SizedBox(height: AllySpacing.xl),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AllySpacing.lg),
                child: Column(
                  children: [
                    _buildDialogOption(
                      sheetContext,
                      l10n.startService,
                      Icons.play_circle_rounded,
                      () async {
                        await pedometerService.startNativeService();
                        if (sheetContext.mounted) {
                          Navigator.pop(sheetContext);
                          notificationService.showNotification(
                            message:
                                "${l10n.serviceStarted}: ${l10n.serviceStartedDesc}",
                            type: NotificationType.success,
                          );
                        }
                      },
                    ),
                    const SizedBox(height: AllySpacing.sm),
                    _buildDialogOption(
                      sheetContext,
                      l10n.restartService,
                      Icons.refresh_rounded,
                      () async {
                        await pedometerService.stopNativeService();
                        await Future.delayed(const Duration(milliseconds: 500));
                        await pedometerService.startNativeService();
                        if (sheetContext.mounted) {
                          Navigator.pop(sheetContext);
                          notificationService.showNotification(
                            message:
                                "${l10n.serviceRestarted}: ${l10n.serviceRestartedDesc}",
                            type: NotificationType.success,
                          );
                        }
                      },
                    ),
                    const SizedBox(height: AllySpacing.sm),
                    _buildDialogOption(
                      sheetContext,
                      l10n.stopService,
                      Icons.stop_circle_rounded,
                      () async {
                        await pedometerService.stopNativeService();
                        if (sheetContext.mounted) {
                          Navigator.pop(sheetContext);
                          notificationService.showNotification(
                            message:
                                "${l10n.serviceStopped}: ${l10n.serviceStoppedDesc}",
                            type: NotificationType.neutral,
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AllySpacing.xl),
            ],
          ),
        );
      },
    );
  }

  // Goal Setting Dialog
  static Future<void> showSetGoalDialog(
    BuildContext context,
    int currentGoal,
    Function(int) onGoalSet,
  ) async {
    final TextEditingController controller = TextEditingController(
      text: currentGoal.toString(),
    );
    final notificationService = context.read<IntrovertNotificationService>();
    final l10n = AppLocalizations.of(context)!;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (sheetContext) {
        final ThemeData theme = Theme.of(sheetContext);
        final ColorScheme scheme = theme.colorScheme;

        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(sheetContext).viewInsets.bottom,
          ),
          child: Container(
            margin: const EdgeInsets.all(AllySpacing.lg),
            decoration: BoxDecoration(
              color: scheme.surface,
              borderRadius: AllyRadius.lgAll,
              border: Border.all(color: scheme.outlineVariant),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: AllySpacing.xl),
                Container(
                  padding: const EdgeInsets.all(AllySpacing.lg),
                  decoration: BoxDecoration(
                    color: scheme.onSurface.withValues(alpha: 0.06),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.flag_rounded,
                    color: scheme.onSurface,
                    size: AllyDimensions.iconXl,
                  ),
                ),
                const SizedBox(height: AllySpacing.lg),
                Text(
                  l10n.setYourGoal,
                  style: AllyTypography.headline(
                    size: 20,
                    color: scheme.onSurface,
                  ),
                ),
                const SizedBox(height: AllySpacing.xl),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AllySpacing.xxl,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: controller,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          style: AllyTypography.metric(
                            size: 32,
                            color: scheme.onSurface,
                          ),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: scheme.surface,
                            border: OutlineInputBorder(
                              borderRadius: AllyRadius.smAll,
                              borderSide: BorderSide(
                                color: scheme.outlineVariant,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: AllyRadius.smAll,
                              borderSide: BorderSide(
                                color: scheme.outlineVariant,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: AllyRadius.smAll,
                              borderSide: BorderSide(
                                color: scheme.primary,
                                width: 1.4,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: AllySpacing.md),
                      Expanded(
                        child: AllyButton(
                          label: l10n.save,
                          onPressed: () {
                            final goal = int.tryParse(controller.text) ?? 6000;
                            onGoalSet(goal);
                            Navigator.pop(sheetContext);
                            notificationService.showNotification(
                              message: l10n.dailyGoalSetTo(
                                goal.toString(),
                                l10n.stepsLabel,
                              ),
                              type: NotificationType.success,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AllySpacing.xl),
              ],
            ),
          ),
        );
      },
    );
  }

  static Widget _buildDialogOption(
    BuildContext context,
    String text,
    IconData icon,
    VoidCallback onTap,
  ) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: AllyRadius.smAll,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AllySpacing.lg,
          vertical: AllySpacing.lg,
        ),
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
                color: scheme.onSurface.withValues(alpha: 0.06),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: scheme.onSurface,
                size: AllyDimensions.iconSm,
              ),
            ),
            const SizedBox(width: AllySpacing.lg),
            Expanded(
              child: Text(
                text,
                style: AllyTypography.label(size: 15, color: scheme.onSurface),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
