// maintenance.dart
//
// © 2026 Vertex Corporation
// ─────────────────────────────────────────────────────────────────────────────
// Maintenance interstitial. The status check via the Vertex backend callable
// is unchanged; the screen no longer depends on the missing neuro asset and
// uses the design system instead.

import 'package:cloud_functions/cloud_functions.dart';
import 'package:ally/design_system/design_system.dart';
import 'package:ally/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

/// Checks whether the server is currently in maintenance mode.
///
/// Returns `true` if maintenance is active, otherwise `false`.
Future<bool> checkMaintenanceMode() async {
  try {
    final callable = FirebaseFunctions.instanceFor(
      region: 'europe-west1',
    ).httpsCallable('getServerStatus');

    final result = await callable.call();
    return result.data['isUnderMaintenance'] ?? false;
  } catch (e) {
    debugPrint(
      "Could not check maintenance mode, assuming it's off. Error: $e",
    );
    return false;
  }
}

/// A screen that informs the user that the app is temporarily down for
/// maintenance.
class MaintenanceScreen extends StatefulWidget {
  const MaintenanceScreen({super.key});

  @override
  State<MaintenanceScreen> createState() => _MaintenanceScreenState();
}

class _MaintenanceScreenState extends State<MaintenanceScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutCubic,
          ),
        );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _animationController.forward();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AllySpacing.xxl,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: scheme.onSurface.withValues(alpha: 0.05),
                        borderRadius: AllyRadius.lgAll,
                      ),
                      child: Icon(
                        Icons.engineering_rounded,
                        size: 64,
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: AllySpacing.xxl),
                    Text(
                      l10n.maintenanceTitle,
                      textAlign: TextAlign.center,
                      style: AllyTypography.headline(
                        size: 28,
                        color: scheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: AllySpacing.md),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 320),
                      child: Text(
                        l10n.maintenanceMessage,
                        textAlign: TextAlign.center,
                        style: AllyTypography.body(
                          size: 15,
                          color: scheme.onSurfaceVariant,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
