// lib/login/verify.dart

import 'dart:async';
import 'dart:developer' as dev;
import 'dart:math' as math;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

import 'package:ally/l10n/app_localizations.dart';
import 'package:ally/theme.dart';
import 'package:ally/notifications/introvert.dart';

import '../screen.dart';

class EmailVerificationScreen extends StatefulWidget {
  final String email;
  final String username;
  final String userId;
  final String? password;

  const EmailVerificationScreen({
    super.key,
    required this.email,
    required this.username,
    required this.userId,
    this.password,
  });

  @override
  State<EmailVerificationScreen> createState() => _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  // --- State Variables ---
  late IntrovertNotificationService _notificationService;

  static const int totalVerificationDuration = 86400; // 24 Hours
  int _remainingSeconds = totalVerificationDuration;

  Timer? _countdownTimer;
  Timer? _emailCheckTimer;

  bool _isVerified = false;
  bool _isResendLoading = false;
  bool _isContinuing = false;

  @override
  void initState() {
    super.initState();
    _notificationService = Provider.of<IntrovertNotificationService>(context, listen: false);
    _initializeRemainingTime();
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

    // 1. Visual Countdown (For UI)
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        if (mounted) setState(() => _remainingSeconds--);
      } else {
        timer.cancel();
      }
    });

    // 2. Periodic Email Check (For Firebase)
    _emailCheckTimer = Timer.periodic(const Duration(seconds: 3), (timer) async {
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
          dev.log('[Verify] Email verified automatically.', name: 'EmailVerification');
          _handleVerified();
          timer.cancel();
        }
      } on FirebaseAuthException catch (e) {
        // Ignore network errors to prevent log spamming when offline
        if (e.code != 'network-request-failed') {
          dev.log('[Verify] Firebase Error: ${e.code}', name: 'EmailVerification');
        }
      } catch (e) {
        dev.log('[Verify] Generic Error checking verification', name: 'EmailVerification');
      }
    });
  }

  void _cancelTimers() {
    _countdownTimer?.cancel();
    _emailCheckTimer?.cancel();
  }

  Future<void> _initializeRemainingTime() async {
    try {
      final doc = await FirebaseFirestore.instance.collection('users').doc(widget.userId).get();
      if (doc.exists && doc.data()?['createdAt'] != null) {
        final Timestamp createdAtTimestamp = doc.data()!['createdAt'];
        final DateTime createdAt = createdAtTimestamp.toDate();
        final int verifyAttempts = doc.data()?['verifyAttempts'] ?? 0;

        // Deadline is 24 hours * number of attempts
        final DateTime deadline = createdAt.add(Duration(hours: 24 * (verifyAttempts + 1)));
        final remaining = deadline.difference(DateTime.now()).inSeconds;

        if (mounted) {
          setState(() {
            _remainingSeconds = remaining > 0 ? remaining : 0;
          });
        }
      }
    } catch (_) {
      // Fallback to default if error occurs
    }
  }

  // --- Actions ---

  Future<void> _handleVerified() async {
    if (_isVerified) return;
    setState(() => _isVerified = true);
    _cancelTimers();

    await _navigateToMainScreen();
  }

  Future<void> _continueWithoutVerification() async {
    if (_isContinuing) return;
    setState(() => _isContinuing = true);
    _cancelTimers();

    try {
      await _saveRememberMeState();

      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => const MainScreen(),
            transitionsBuilder: (_, animation, __, child) => FadeTransition(opacity: animation, child: child),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        _notificationService.showNotification(
            message: AppLocalizations.of(context)!.authFailed,
            type: NotificationType.error
        );
        setState(() => _isContinuing = false);
        _startTimers();
      }
    }
  }

  Future<void> _resendVerificationEmail() async {
    final l10n = AppLocalizations.of(context)!;
    setState(() => _isResendLoading = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception("No user");

      // Check Limit
      final userDocRef = FirebaseFirestore.instance.collection('users').doc(widget.userId);
      final docSnapshot = await userDocRef.get();
      final int verifyAttempts = docSnapshot.exists ? (docSnapshot.data()?['verifyAttempts'] ?? 0) : 0;

      if (verifyAttempts >= 2) {
        _notificationService.showNotification(
          message: l10n.maxResendLimitReached,
          type: NotificationType.error,
        );
        return;
      }

      await user.sendEmailVerification();

      // Increment attempt count
      await userDocRef.update({'verifyAttempts': FieldValue.increment(1)});
      await _initializeRemainingTime();

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
    // Add purchase reconciliation logic here if needed:
    // await reconcileAndSyncPurchases();

    if (mounted) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => const MainScreen(),
          transitionsBuilder: (_, animation, __, child) => FadeTransition(opacity: animation, child: child),
        ),
      );
    }
  }

  String _formatTime(int totalSeconds) {
    final h = (totalSeconds ~/ 3600).toString().padLeft(2, '0');
    final m = ((totalSeconds % 3600) ~/ 60).toString().padLeft(2, '0');
    final s = (totalSeconds % 60).toString().padLeft(2, '0');
    return '$h:$m:$s';
  }

  // --- UI Build ---

  @override
  Widget build(BuildContext context) {
    // DYNAMIC SCALING
    final size = MediaQuery.of(context).size;

    // Base Reference Width (iPhone 14 approx: ~390px)
    double scale = size.width / 390.0;

    // Cap scale for Tablets to prevent UI from becoming too huge
    if (size.width > 600) {
      scale = 1.0 + (size.width - 600) * 0.0001;
    }
    scale = scale.clamp(0.85, 1.3);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 450 * scale),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 32.0 * scale),
              child: Column(
                children: [
                  const Spacer(flex: 2),

                  // 1. HEADER ICON
                  _VerificationIcon(scale: scale),

                  const Spacer(flex: 2),

                  // 2. BODY TEXT
                  _VerificationBody(
                    email: widget.email,
                    scale: scale,
                  ),

                  const Spacer(flex: 2),

                  // 3. ACTIONS
                  if (!_isVerified)
                    Column(
                      children: [
                        // Resend Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.senaryColor,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(vertical: 18 * scale),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30 * scale),
                              ),
                              elevation: 0,
                            ),
                            onPressed: _isResendLoading ? null : _resendVerificationEmail,
                            child: _isResendLoading
                                ? SizedBox(
                              height: 20 * scale,
                              width: 20 * scale,
                              child: const CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                                : Text(
                              AppLocalizations.of(context)!.resendCode,
                              style: TextStyle(
                                fontSize: 16 * scale,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 16 * scale),

                        // Continue Button (Ghost/Text Button)
                        TextButton(
                          onPressed: _isContinuing ? null : _continueWithoutVerification,
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 12 * scale, horizontal: 16 * scale),
                          ),
                          child: _isContinuing
                              ? SizedBox(
                            height: 20 * scale,
                            width: 20 * scale,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(AppColors.tertiaryColor),
                            ),
                          )
                              : Text(
                            AppLocalizations.of(context)!.verificationScreenContinueWithoutVerification,
                            style: TextStyle(
                              fontSize: 14 * scale,
                              fontWeight: FontWeight.w600,
                              color: AppColors.tertiaryColor.withValues(alpha: 0.8),
                            ),
                          ),
                        ),

                        SizedBox(height: 20 * scale),

                        // Warning Text
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0 * scale),
                          child: Text(
                            AppLocalizations.of(context)!.verificationScreenWarning,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12 * scale,
                              color: AppColors.tertiaryColor.withValues(alpha: 0.5),
                              height: 1.5,
                            ),
                          ),
                        ),

                        SizedBox(height: 16 * scale),

                        // Timer
                        _AnimatedTime(
                          time: _formatTime(_remainingSeconds),
                          style: TextStyle(
                            fontSize: 18 * scale,
                            color: AppColors.septenaryColor, // Warning color
                            fontWeight: FontWeight.w600,
                            fontFeatures: const [FontFeature.tabularFigures()], // Keeps numbers stable
                          ),
                        ),
                      ],
                    ),

                  const Spacer(flex: 1),
                ],
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
  final double scale;

  const _VerificationIcon({required this.scale});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        // Decorative Circle Background
        Transform.rotate(
          angle: -15 * math.pi / 180,
          child: Container(
            width: 140 * scale,
            height: 140 * scale,
            decoration: BoxDecoration(
              color: AppColors.secondaryColor,
              borderRadius: BorderRadius.circular(40 * scale),
            ),
          ),
        ),
        // Icon
        Icon(
          Icons.mark_email_unread_outlined,
          size: 80 * scale,
          color: AppColors.tertiaryColor,
        ),
      ],
    );
  }
}

class _VerificationBody extends StatelessWidget {
  final String email;
  final double scale;

  const _VerificationBody({
    required this.email,
    required this.scale,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      children: [
        Text(
          l10n.verifyYourEmail,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 24 * scale,
            fontWeight: FontWeight.bold,
            color: AppColors.tertiaryColor,
          ),
        ),
        SizedBox(height: 12 * scale),
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: TextStyle(
              fontSize: 15 * scale,
              color: AppColors.tertiaryColor.withValues(alpha: 0.7),
              fontFamily: Theme.of(context).textTheme.bodyMedium?.fontFamily,
              height: 1.5,
            ),
            children: [
              TextSpan(text: '${l10n.pleaseCheckYourEmail} '),
              TextSpan(
                text: email,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.tertiaryColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// --- ANIMATED TIMER WIDGETS ---

class _AnimatedDigit extends StatelessWidget {
  final String digit;
  final TextStyle? style;
  const _AnimatedDigit({required this.digit, this.style});

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(opacity: animation, child: SlideTransition(
          position: Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(animation),
          child: child,
        ));
      },
      child: Text(
          digit,
          key: ValueKey<String>(digit),
          style: style
      ),
    );
  }
}

class _AnimatedTime extends StatelessWidget {
  final String time;
  final TextStyle? style;
  const _AnimatedTime({required this.time, this.style});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: time.split('').map((char) {
        // Animate only digits, keep separators static
        return RegExp(r'\d').hasMatch(char)
            ? _AnimatedDigit(digit: char, style: style)
            : Text(char, style: style);
      }).toList(),
    );
  }
}