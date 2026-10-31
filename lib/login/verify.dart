// login/verify.dart
//
// © 2026 Vertex Corporation
// ─────────────────────────────────────────────────────────────────────────────
// Email verification interstitial. Verification polling, resend, remember-me
// persistence and navigation are preserved from the original implementation.

import 'dart:async';
import 'dart:developer' as dev;

import 'package:ally/design_system/design_system.dart';
import 'package:ally/l10n/app_localizations.dart';
import 'package:ally/notifications/introvert.dart';
import 'package:ally/screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

import 'screen.dart';

class EmailVerificationScreen extends StatefulWidget {
  final String email;
  final String? password;

  const EmailVerificationScreen({
    super.key,
    required this.email,
    this.password,
  });

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  // --- State Variables ---
  late IntrovertNotificationService _notificationService;

  Timer? _emailCheckTimer;

  bool _isVerified = false;
  bool _isResendLoading = false;

  @override
  void initState() {
    super.initState();
    _notificationService = Provider.of<IntrovertNotificationService>(
      context,
      listen: false,
    );
    _startTimers();
  }

  @override
  void dispose() {
    _cancelTimers();
    super.dispose();
  }

  // --- Timer & Control Logic ---

  void _startTimers() {
    _cancelTimers();

    _emailCheckTimer = Timer.periodic(const Duration(seconds: 3), (
      timer,
    ) async {
      try {
        final user = FirebaseAuth.instance.currentUser;
        if (user == null) {
          timer.cancel();
          return;
        }

        // Refresh user data from server
        await user.reload();
        final freshUser = FirebaseAuth.instance.currentUser;

        if (freshUser != null && freshUser.emailVerified) {
          dev.log(
            '[Verify] Email verified automatically.',
            name: 'EmailVerification',
          );
          _handleVerified();
          timer.cancel();
        }
      } on FirebaseAuthException catch (e) {
        // Ignore network errors to prevent log spamming when offline
        if (e.code != 'network-request-failed') {
          dev.log(
            '[Verify] Firebase Error: ${e.code}',
            name: 'EmailVerification',
          );
        }
      } catch (e) {
        dev.log(
          '[Verify] Generic Error checking verification',
          name: 'EmailVerification',
        );
      }
    });
  }

  void _cancelTimers() {
    _emailCheckTimer?.cancel();
  }

  // --- Actions ---

  Future<void> _handleVerified() async {
    if (_isVerified) return;
    setState(() => _isVerified = true);
    _cancelTimers();

    await _navigateToMainScreen();
  }

  Future<void> _returnToLogin() async {
    try {
      await FirebaseAuth.instance.signOut();

      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const LoginScreen()),
          (_) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        _notificationService.showNotification(
          message: AppLocalizations.of(context)!.authFailed,
          type: NotificationType.error,
        );
      }
    }
  }

  Future<void> _resendVerificationEmail() async {
    final l10n = AppLocalizations.of(context)!;
    setState(() => _isResendLoading = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception("No user");

      await user.sendEmailVerification();

      _notificationService.showNotification(
        message: l10n.linkSent,
        type: NotificationType.success,
      );
    } catch (e) {
      dev.log('Resend Error: $e');
      _notificationService.showNotification(
        message: l10n.authError,
        type: NotificationType.error,
      );
    } finally {
      if (mounted) setState(() => _isResendLoading = false);
    }
  }

  Future<void> _saveRememberMeState() async {
    const secureStorage = FlutterSecureStorage();
    await secureStorage.write(key: 'remember_me', value: 'true');
    await secureStorage.write(key: 'email', value: widget.email);
    if (widget.password != null) {
      await secureStorage.write(key: 'password', value: widget.password);
    }
  }

  Future<void> _navigateToMainScreen() async {
    await _saveRememberMeState();

    if (mounted) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => const MainScreen(),
          transitionsBuilder: (_, animation, __, child) =>
              FadeTransition(opacity: animation, child: child),
        ),
      );
    }
  }

  // --- UI Build ---

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;
    final AllySemanticPalette semantics = context.allySemantics;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _returnToLogin();
      },
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 450),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AllySpacing.xxl,
                ),
                child: Column(
                  children: [
                    const Spacer(flex: 2),

                    // 1. HEADER ICON
                    _VerificationIcon(
                      color: _isVerified
                          ? semantics.success
                          : scheme.onSurfaceVariant,
                      icon: _isVerified
                          ? Icons.mark_email_read_outlined
                          : Icons.mark_email_unread_outlined,
                    ),

                    const Spacer(flex: 2),

                    // 2. BODY TEXT
                    _VerificationBody(email: widget.email),

                    const Spacer(flex: 2),

                    // 3. ACTIONS
                    if (!_isVerified) ...[
                      AllyButton(
                        label: l10n.resendCode,
                        isLoading: _isResendLoading,
                        onPressed: _isResendLoading
                            ? null
                            : _resendVerificationEmail,
                      ),
                      const SizedBox(height: AllySpacing.md),
                      AllyButton(
                        label: l10n.backToLogin,
                        kind: AllyButtonKind.ghost,
                        onPressed: _returnToLogin,
                      ),
                      const SizedBox(height: AllySpacing.xl),

                      // Warning Text
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AllySpacing.lg,
                        ),
                        child: Text(
                          l10n.pleaseCheckYourEmail,
                          textAlign: TextAlign.center,
                          style: AllyTypography.caption(
                            color: scheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ] else
                      Text(
                        l10n.linkSent,
                        style: AllyTypography.label(
                          size: 14,
                          color: semantics.success,
                        ),
                      ),

                    const Spacer(flex: 1),
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

// --- EXTRACTED UI WIDGETS ---

class _VerificationIcon extends StatelessWidget {
  final Color color;
  final IconData icon;

  const _VerificationIcon({required this.color, required this.icon});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        // Decorative square background, rotated — quiet geometry, not a glow.
        Transform.rotate(
          angle: -15 * 3.1415926535897932 / 180,
          child: Container(
            width: 128,
            height: 128,
            decoration: BoxDecoration(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(32),
            ),
          ),
        ),
        Icon(icon, size: 72, color: color),
      ],
    );
  }
}

class _VerificationBody extends StatelessWidget {
  final String email;

  const _VerificationBody({required this.email});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    return Column(
      children: [
        Text(
          l10n.verifyYourEmail,
          textAlign: TextAlign.center,
          style: AllyTypography.headline(
            size: 24,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: AllySpacing.md),
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: AllyTypography.body(
              size: 15,
              color: theme.colorScheme.onSurfaceVariant,
            ).copyWith(height: 1.5),
            children: [
              TextSpan(text: '${l10n.pleaseCheckYourEmail} '),
              TextSpan(
                text: email,
                style: AllyTypography.body(
                  size: 15,
                  weight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ).copyWith(height: 1.5),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
