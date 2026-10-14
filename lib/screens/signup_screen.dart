import 'package:ally/login/backend.dart';
import 'package:ally/login/verify.dart';
import 'package:ally/l10n/app_localizations.dart';
import 'package:ally/notifications/introvert.dart';
import 'package:ally/theme.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  int _step = 0;
  bool _isLoading = false;
  bool _passwordVisible = false;
  String? _fieldError;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _back() {
    if (_isLoading) return;
    if (_step == 0) {
      Navigator.of(context).pop();
      return;
    }
    setState(() {
      _step--;
      _fieldError = null;
    });
  }

  void _next() {
    final l10n = AppLocalizations.of(context)!;
    FocusScope.of(context).unfocus();

    if (_step == 0) {
      if (_usernameController.text.trim().isEmpty) {
        setState(() => _fieldError = l10n.invalidUsername);
        return;
      }
    } else if (_step == 1) {
      final email = _emailController.text.trim();
      if (!EmailValidator.validate(email)) {
        setState(() => _fieldError = l10n.invalidEmail);
        return;
      }
    } else {
      _submit();
      return;
    }

    setState(() {
      _step++;
      _fieldError = null;
    });
  }

  Future<void> _submit() async {
    if (_isLoading) return;

    final l10n = AppLocalizations.of(context)!;
    final username = _usernameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (password.length < 6) {
      setState(() => _fieldError = l10n.weakPassword);
      return;
    }

    final notifications = context.read<IntrovertNotificationService>();
    setState(() {
      _isLoading = true;
      _fieldError = null;
    });

    try {
      final result = await LoginBackendService().registerWithEmail(
        context: context,
        notificationService: notifications,
        username: username,
        email: email,
        password: password,
      );

      if (!mounted) return;

      switch (result) {
        case RegistrationSuccess():
          final user = FirebaseAuth.instance.currentUser;
          if (user == null) {
            notifications.showNotification(
              message: l10n.authError,
              type: NotificationType.error,
            );
            return;
          }

          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => EmailVerificationScreen(
                email: user.email ?? email,
                username: username,
                userId: user.uid,
              ),
            ),
          );
          break;
        case RegistrationUsernameTaken():
          notifications.showNotification(
            message: l10n.usernameTaken,
            type: NotificationType.error,
          );
          break;
        case RegistrationEmailInUse():
          notifications.showNotification(
            message: l10n.emailAlreadyInUse,
            type: NotificationType.error,
          );
          break;
        case RegistrationWeakPassword():
          setState(() => _fieldError = l10n.weakPassword);
          break;
        case RegistrationNetworkError():
          notifications.showNotification(
            message: l10n.noInternetConnection,
            type: NotificationType.error,
          );
          break;
        case RegistrationUnknownError():
          notifications.showNotification(
            message: l10n.authError,
            type: NotificationType.error,
          );
          break;
      }
    } catch (_) {
      if (mounted) {
        notifications.showNotification(
          message: l10n.authError,
          type: NotificationType.error,
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final accent = AppColors.senaryColor;
    final headings = <String>[
      l10n.signUp,
      l10n.enterEmailAddress,
      l10n.enterPassword,
    ];

    return PopScope(
      canPop: _step == 0 && !_isLoading,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && !_isLoading) _back();
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(26, 18, 26, 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        onPressed: _isLoading ? null : _back,
                        tooltip: MaterialLocalizations.of(context).backButtonTooltip,
                        icon: Icon(
                          Icons.arrow_back_rounded,
                          color: AppColors.tertiaryColor,
                        ),
                        style: IconButton.styleFrom(
                          backgroundColor: AppColors.secondaryColor,
                          minimumSize: const Size(46, 46),
                        ),
                      ),
                    ),
                    const SizedBox(height: 22),
                    Container(
                      width: 58,
                      height: 58,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: accent.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(19),
                      ),
                      child: Icon(Icons.favorite_rounded, color: accent, size: 30),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      headings[_step],
                      style: TextStyle(
                        color: AppColors.tertiaryColor,
                        fontSize: 30,
                        height: 1.12,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.6,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      _step == 0
                          ? l10n.chooseUsername
                          : _step == 1
                              ? l10n.enterEmailAddress
                              : l10n.enterPassword,
                      style: TextStyle(
                        color: AppColors.tertiaryColor.withValues(alpha: 0.7),
                        fontSize: 15,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 22),
                    Row(
                      children: List.generate(3, (index) {
                        final active = index <= _step;
                        return Expanded(
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            height: 4,
                            margin: EdgeInsets.only(right: index == 2 ? 0 : 7),
                            decoration: BoxDecoration(
                              color: active
                                  ? accent
                                  : AppColors.border.withValues(alpha: 0.55),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 30),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 220),
                      switchInCurve: Curves.easeOutCubic,
                      switchOutCurve: Curves.easeInCubic,
                      transitionBuilder: (child, animation) => FadeTransition(
                        opacity: animation,
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0.035, 0),
                            end: Offset.zero,
                          ).animate(animation),
                          child: child,
                        ),
                      ),
                      child: KeyedSubtree(
                        key: ValueKey<int>(_step),
                        child: _buildField(l10n),
                      ),
                    ),
                    if (_fieldError != null) ...[
                      const SizedBox(height: 10),
                      Text(
                        _fieldError!,
                        style: TextStyle(
                          color: AppColors.septenaryColor,
                          fontSize: 13,
                        ),
                      ),
                    ],
                    const SizedBox(height: 22),
                    SizedBox(
                      height: 56,
                      child: FilledButton(
                        onPressed: _isLoading ? null : _next,
                        style: FilledButton.styleFrom(
                          backgroundColor: accent,
                          foregroundColor: Colors.white,
                          disabledBackgroundColor: accent.withValues(alpha: 0.55),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(17),
                          ),
                          textStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.3,
                                  color: Colors.white,
                                ),
                              )
                            : Text(_step == 2 ? l10n.signUp : l10n.next),
                      ),
                    ),
                    const SizedBox(height: 14),
                    if (_step == 0)
                      Center(
                        child: TextButton(
                          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
                          child: Text(
                            l10n.signIn,
                            style: TextStyle(
                              color: AppColors.tertiaryColor,
                              fontWeight: FontWeight.w600,
                            ),
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

  Widget _buildField(AppLocalizations l10n) {
    final inputDecoration = InputDecoration(
      filled: true,
      fillColor: AppColors.secondaryColor,
      prefixIcon: Icon(
        _step == 0
            ? Icons.person_outline_rounded
            : _step == 1
                ? Icons.mail_outline_rounded
                : Icons.lock_outline_rounded,
        color: AppColors.tertiaryColor.withValues(alpha: 0.7),
      ),
      suffixIcon: _step == 2
          ? IconButton(
              onPressed: () => setState(() => _passwordVisible = !_passwordVisible),
              icon: Icon(
                _passwordVisible
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                color: AppColors.tertiaryColor.withValues(alpha: 0.7),
              ),
            )
          : null,
      hintText: _step == 0
          ? l10n.usernameHint
          : _step == 1
              ? l10n.emailHint
              : l10n.passwordHint,
      hintStyle: TextStyle(
        color: AppColors.tertiaryColor.withValues(alpha: 0.5),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(17),
        borderSide: BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(17),
        borderSide: BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(17),
        borderSide: BorderSide(color: AppColors.senaryColor, width: 1.6),
      ),
    );

    if (_step == 0) {
      return TextField(
        controller: _usernameController,
        autofocus: true,
        autofillHints: const [AutofillHints.newUsername],
        textInputAction: TextInputAction.next,
        onSubmitted: (_) => _next(),
        onChanged: (_) {
          if (_fieldError != null) setState(() => _fieldError = null);
        },
        decoration: inputDecoration,
        style: TextStyle(color: AppColors.tertiaryColor),
      );
    }
    if (_step == 1) {
      return TextField(
        controller: _emailController,
        autofocus: true,
        autofillHints: const [AutofillHints.email],
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.next,
        autocorrect: false,
        onSubmitted: (_) => _next(),
        onChanged: (_) {
          if (_fieldError != null) setState(() => _fieldError = null);
        },
        decoration: inputDecoration,
        style: TextStyle(color: AppColors.tertiaryColor),
      );
    }
    return TextField(
      controller: _passwordController,
      autofocus: true,
      autofillHints: const [AutofillHints.newPassword],
      obscureText: !_passwordVisible,
      autocorrect: false,
      enableSuggestions: false,
      textInputAction: TextInputAction.done,
      onSubmitted: (_) => _next(),
      onChanged: (_) {
        if (_fieldError != null) setState(() => _fieldError = null);
      },
      decoration: inputDecoration,
      style: TextStyle(color: AppColors.tertiaryColor),
    );
  }
}
