// signup_screen.dart
//
// © 2026 Vertex Corporation
// ─────────────────────────────────────────────────────────────────────────────
// Multi-step sign-up (username → email → password). Authentication behaviour
// (LoginBackendService + verification) is untouched; this file is presentation.

import 'package:ally/design_system/design_system.dart';
import 'package:ally/l10n/app_localizations.dart';
import 'package:ally/login/backend.dart';
import 'package:ally/login/verify.dart';
import 'package:ally/main.dart' show isFirebaseInitialized;
import 'package:ally/notifications/introvert.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum _SignUpStep { username, email, password }

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _backend = LoginBackendService();

  _SignUpStep _step = _SignUpStep.username;
  bool _isLoading = false;
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _back() {
    if (_isLoading) return;
    if (_step == _SignUpStep.password) {
      setState(() => _step = _SignUpStep.email);
    } else if (_step == _SignUpStep.email) {
      setState(() => _step = _SignUpStep.username);
    } else {
      Navigator.of(context).pop();
    }
  }

  void _continue() {
    if (_isLoading || !(_formKey.currentState?.validate() ?? false)) return;
    FocusScope.of(context).unfocus();
    setState(() {
      _step = switch (_step) {
        _SignUpStep.username => _SignUpStep.email,
        _SignUpStep.email => _SignUpStep.password,
        _SignUpStep.password => _SignUpStep.password,
      };
    });
  }

  Future<void> _submit() async {
    if (_isLoading || !(_formKey.currentState?.validate() ?? false)) return;
    FocusScope.of(context).unfocus();

    if (!isFirebaseInitialized) {
      _showError(AppLocalizations.of(context)!.firebaseNotConfiguredSignup);
      return;
    }

    setState(() => _isLoading = true);
    try {
      final result = await _backend.registerWithEmail(
        context: context,
        notificationService: context.read<IntrovertNotificationService>(),
        username: _usernameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      if (!mounted) return;
      final l10n = AppLocalizations.of(context)!;
      switch (result) {
        case RegistrationSuccess() || RegistrationVerificationEmailFailed():
          final user = FirebaseAuth.instance.currentUser;
          if (user == null || user.email == null) {
            _showError(l10n.authenticationFailed);
            return;
          }
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => EmailVerificationScreen(
                email: user.email!,
                password: _passwordController.text,
              ),
            ),
          );
        case RegistrationUsernameTaken():
          _showError(l10n.usernameTaken);
        case RegistrationEmailInUse():
          _showError(l10n.emailAlreadyInUse);
        case RegistrationWeakPassword():
          _showError(l10n.invalidPassword);
        case RegistrationNetworkError():
        case RegistrationUnknownError():
          break;
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showError(String message) {
    final notificationService = context.read<IntrovertNotificationService>();
    notificationService.showNotification(
      message: message,
      type: NotificationType.error,
    );
  }

  String get _title {
    final l10n = AppLocalizations.of(context)!;
    return switch (_step) {
      _SignUpStep.username => l10n.createYourAccount,
      _SignUpStep.email => l10n.email,
      _SignUpStep.password => l10n.createPassword,
    };
  }

  String get _subtitle {
    final l10n = AppLocalizations.of(context)!;
    return switch (_step) {
      _SignUpStep.username => l10n.registerSubtitle,
      _SignUpStep.email => l10n.enterEmailAddress,
      _SignUpStep.password => l10n.pleaseCheckYourEmail,
    };
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;
    final stepIndex = _step.index;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Opacity(
            opacity: 0.10,
            child: Image.asset(
              _step == _SignUpStep.password
                  ? 'assets/images/background_signin.png'
                  : 'assets/images/background_password.png',
              fit: BoxFit.cover,
              alignment: Alignment.bottomCenter,
            ),
          ),
          SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(
                    AllySpacing.xxl,
                    AllySpacing.xl,
                    AllySpacing.xxl,
                    AllySpacing.xxl,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: IconButton(
                            onPressed: _back,
                            tooltip: l10n.backToLogin,
                            icon: Icon(
                              Icons.arrow_back_rounded,
                              color: scheme.onSurface,
                            ),
                          ),
                        ),
                        const SizedBox(height: AllySpacing.md),

                        // ── Step progress: monochrome hairline segments ──
                        Row(
                          children: List.generate(3, (index) {
                            return Expanded(
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 220),
                                height: 3,
                                margin: EdgeInsets.only(
                                  right: index == 2 ? 0 : AllySpacing.sm,
                                ),
                                decoration: BoxDecoration(
                                  color: index <= stepIndex
                                      ? scheme.onSurface
                                      : scheme.outlineVariant,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                            );
                          }),
                        ),
                        const SizedBox(height: AllySpacing.xl),

                        Text(
                          _title,
                          style: AllyTypography.headline(
                            size: 26,
                            color: scheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: AllySpacing.sm),
                        Text(
                          _subtitle,
                          style: AllyTypography.body(
                            size: 15,
                            color: scheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: AllySpacing.huge),

                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 220),
                          child: _buildCurrentField(l10n),
                        ),
                        const SizedBox(height: AllySpacing.xxl),

                        AllyButton(
                          label: _step == _SignUpStep.password
                              ? l10n.signUp
                              : l10n.next,
                          isLoading: _isLoading,
                          onPressed: _isLoading
                              ? null
                              : _step == _SignUpStep.password
                              ? _submit
                              : _continue,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentField(AppLocalizations l10n) {
    return switch (_step) {
      _SignUpStep.username => AllyTextField(
        key: const ValueKey(_SignUpStep.username),
        controller: _usernameController,
        autofocus: true,
        textInputAction: TextInputAction.next,
        textCapitalization: TextCapitalization.none,
        maxLength: 16,
        hint: l10n.usernameHint,
        prefixIcon: Icons.person_outline_rounded,
        validator: (value) {
          final username = value?.trim() ?? '';
          if (username.length < 3) return l10n.usernameTooShort;
          if (username.length > 16) return l10n.usernameTooLong;
          if (!RegExp(
            r'^[a-z0-9çğıöşü._-]+$',
            caseSensitive: false,
          ).hasMatch(username)) {
            return l10n.invalidUsernameCharacters;
          }
          return null;
        },
        onFieldSubmitted: (_) => _continue(),
      ),
      _SignUpStep.email => AllyTextField(
        key: const ValueKey(_SignUpStep.email),
        controller: _emailController,
        autofocus: true,
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.next,
        autocorrect: false,
        enableSuggestions: false,
        hint: l10n.emailHint,
        prefixIcon: Icons.mail_outline_rounded,
        validator: (value) {
          if (!EmailValidator.validate(value?.trim() ?? '')) {
            return l10n.invalidEmail;
          }
          return null;
        },
        onFieldSubmitted: (_) => _continue(),
      ),
      _SignUpStep.password => AllyTextField(
        key: const ValueKey(_SignUpStep.password),
        controller: _passwordController,
        autofocus: true,
        obscureText: !_isPasswordVisible,
        textInputAction: TextInputAction.done,
        maxLength: 64,
        autocorrect: false,
        enableSuggestions: false,
        hint: l10n.passwordHint,
        prefixIcon: Icons.lock_outline_rounded,
        suffix: IconButton(
          onPressed: () {
            setState(() => _isPasswordVisible = !_isPasswordVisible);
          },
          icon: Icon(
            _isPasswordVisible
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
          ),
        ),
        validator: (value) {
          final password = value ?? '';
          if (password.length < 6) return l10n.invalidPassword;
          if (password.length > 64) return l10n.passwordTooLong;
          return null;
        },
        onFieldSubmitted: (_) => _submit(),
      ),
    };
  }
}
