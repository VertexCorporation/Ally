// welcome.dart
//
// © 2026 Vertex Corporation
// ─────────────────────────────────────────────────────────────────────────────
// The first screen of Ally: clean, monochrome, premium.
//
// - Preserves Ally's identity (logo, name, motto) — never replaced by the
//   Vertex corporate logo.
// - Adds a subtle "BY VERTEX" attribution.
// - Inherits the active application theme (no forced theme overrides).

import 'package:flutter/material.dart';

import '../design_system/design_system.dart';
import '../l10n/app_localizations.dart';
import '../login/screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _slideAnimation =
        Tween<Offset>(begin: Offset.zero, end: const Offset(0, -1)).animate(
          CurvedAnimation(
            parent: _slideController,
            curve: Curves.easeInOutCubic,
          ),
        );
  }

  @override
  void dispose() {
    _slideController.dispose();
    super.dispose();
  }

  void _navigateToLogin() {
    _slideController.forward();

    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const LoginScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          // Slide up when going forward, slide down when going back.
          var slideAnimation =
              Tween<Offset>(
                begin: const Offset(0.0, 1.0),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeInOutCubic,
                ),
              );

          return SlideTransition(position: slideAnimation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 500),
        reverseTransitionDuration: const Duration(milliseconds: 500),
      ),
    ).then((_) {
      // Reset welcome animation when returning.
      if (mounted) _slideController.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 0,
      ),
      body: SlideTransition(
        position: _slideAnimation,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AllySpacing.xxl,
              AllySpacing.xl,
              AllySpacing.xxl,
              AllySpacing.xxl,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Brand mark ────────────────────────────────────────────
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(AllyRadius.sm),
                      child: Image.asset(
                        'assets/images/logo.png',
                        width: 32,
                        height: 32,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: AllySpacing.md),
                    Text(
                      l10n.ally,
                      style: AllyTypography.headline(
                        size: 18,
                        color: scheme.onSurface,
                      ),
                    ),
                    const SizedBox(width: AllySpacing.md),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AllySpacing.sm,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: AllyRadius.smAll,
                        border: Border.all(color: scheme.outlineVariant),
                      ),
                      child: Text(
                        'BY VERTEX',
                        style: AllyTypography.label(
                          size: 10,
                          weight: FontWeight.w600,
                          color: scheme.onSurfaceVariant,
                          letterSpacing: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),

                const Spacer(flex: 4),

                // ── Heading ───────────────────────────────────────────────
                Text(
                  l10n.welcomeText1,
                  style: AllyTypography.display(
                    size: 44,
                    color: scheme.onSurface,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: AllySpacing.md),
                RichText(
                  text: TextSpan(
                    style: AllyTypography.headline(
                      size: 26,
                      color: scheme.onSurface,
                      weight: FontWeight.w400,
                    ).copyWith(height: 1.3),
                    children: [
                      TextSpan(text: '${l10n.welcomeText2} '),
                      TextSpan(
                        text: l10n.welcomeText3,
                        style: AllyTypography.headline(
                          size: 26,
                          color: scheme.onSurface,
                          weight: FontWeight.w600,
                        ).copyWith(height: 1.3),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AllySpacing.lg),
                Text(
                  l10n.motto,
                  style: AllyTypography.body(
                    size: 15,
                    color: scheme.onSurfaceVariant,
                  ),
                ),

                const Spacer(flex: 5),

                // ── Call to action ────────────────────────────────────────
                AllyButton(
                  label: l10n.getStarted,
                  onPressed: _navigateToLogin,
                  kind: AllyButtonKind.primary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
