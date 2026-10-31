// login/screen.dart
//
// © 2026 Vertex Corporation
// ─────────────────────────────────────────────────────────────────────────────
// Sign-in flow: method selection → email → password.
//
// Presentation notes:
//  • A persistent brand bar (Ally mark + "BY VERTEX" + hairline rule) anchors
//    the screen to the Vertex/Ally identity on every step.
//  • Sign-in methods are a structured, bordered group instead of floating
//    buttons — quiet, precise, monochrome.
//  • A developer entry (visible only in debug builds) opens the dev sheet;
//    it is compiled out of release builds.

import 'package:ally/design_system/design_system.dart';
import 'package:ally/l10n/app_localizations.dart';
import 'package:ally/login/controller.dart';
import 'package:ally/main.dart' show isFirebaseInitialized;
import 'package:ally/theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../shake.dart';
import '../notifications/introvert.dart';
import '../providers/health.dart';
import '../screen.dart';
import '../screens/onboard.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  late final LoginController _controller;

  @override
  void initState() {
    super.initState();
    _controller = LoginController();
    _controller.initialize(this, context);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Controller'ı ağaca enjekte et
    return ChangeNotifierProvider.value(
      value: _controller,
      child: const _LoginScreenContent(),
    );
  }
}

class _LoginScreenContent extends StatelessWidget {
  const _LoginScreenContent();

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<LoginController>();
    final size = MediaQuery.of(context).size;

    // Responsive Hesaplamalar
    final bool isLargeScreen = size.width > 600;
    final double contentWidth = isLargeScreen ? 400.0 : double.infinity;

    return PopScope(
      canPop: controller.currentStep == LoginStep.methodSelection,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        controller.goBack();
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        resizeToAvoidBottomInset: true,
        body: Stack(
          fit: StackFit.expand,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 350),
              child: Opacity(
                key: ValueKey(controller.currentStep),
                opacity: 0.12,
                child: Image.asset(
                  controller.currentStep == LoginStep.passwordInput
                      ? 'assets/images/background_signin.png'
                      : 'assets/images/background_password.png',
                  fit: BoxFit.cover,
                  alignment: Alignment.bottomCenter,
                ),
              ),
            ),
            SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const _BrandBar(),
                  Container(
                    height: 1,
                    color: Theme.of(context).colorScheme.outlineVariant,
                  ),
                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return AnimatedSwitcher(
                          duration: const Duration(milliseconds: 350),
                          transitionBuilder:
                              (Widget child, Animation<double> animation) {
                                final offsetAnimation =
                                    Tween<Offset>(
                                      begin: const Offset(0.0, 0.06),
                                      end: Offset.zero,
                                    ).animate(
                                      CurvedAnimation(
                                        parent: animation,
                                        curve: Curves.easeOutCubic,
                                      ),
                                    );
                                return FadeTransition(
                                  opacity: animation,
                                  child: SlideTransition(
                                    position: offsetAnimation,
                                    child: child,
                                  ),
                                );
                              },
                          child: _buildStepView(
                            controller.currentStep,
                            constraints,
                            contentWidth,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepView(
    LoginStep step,
    BoxConstraints constraints,
    double contentWidth,
  ) {
    switch (step) {
      case LoginStep.methodSelection:
        return _MethodSelectionView(
          key: const ValueKey('method'),
          constraints: constraints,
          contentWidth: contentWidth,
        );
      case LoginStep.emailInput:
        return _EmailInputView(
          key: const ValueKey('email'),
          constraints: constraints,
          contentWidth: contentWidth,
        );
      case LoginStep.passwordInput:
        return _PasswordInputView(
          key: const ValueKey('password'),
          constraints: constraints,
          contentWidth: contentWidth,
        );
    }
  }
}
// ── Persistent brand bar ─────────────────────────────────────────────────────

class _BrandBar extends StatelessWidget {
  const _BrandBar();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AllySpacing.xxl,
        AllySpacing.lg,
        AllySpacing.xxl,
        AllySpacing.md,
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AllyRadius.sm),
            child: Image.asset(
              'assets/images/logo.png',
              width: 26,
              height: 26,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: AllySpacing.md),
          Text(
            l10n.ally,
            style: AllyTypography.headline(size: 16, color: scheme.onSurface),
          ),
          const SizedBox(width: AllySpacing.md),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AllySpacing.sm,
              vertical: 2,
            ),
            decoration: BoxDecoration(
              borderRadius: AllyRadius.smAll,
              border: Border.all(color: scheme.outlineVariant),
            ),
            child: Text(
              'BY VERTEX',
              style: AllyTypography.label(
                size: 9,
                weight: FontWeight.w700,
                color: scheme.onSurfaceVariant,
                letterSpacing: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// --- ALT GÖRÜNÜMLER (SUB-VIEWS) ---

class _MethodSelectionView extends StatelessWidget {
  final BoxConstraints constraints;
  final double contentWidth;

  const _MethodSelectionView({
    super.key,
    required this.constraints,
    required this.contentWidth,
  });

  @override
  Widget build(BuildContext context) {
    final controller = context.read<LoginController>();
    final l10n = AppLocalizations.of(context)!;
    final isLoading = context.select<LoginController, bool>((c) => c.isLoading);
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;

    return Container(
      width: constraints.maxWidth,
      color: Colors.transparent,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          AllySpacing.xxl,
          AllySpacing.xxl,
          AllySpacing.xxl,
          AllySpacing.xl,
        ),
        child: SizedBox(
          width: contentWidth,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Anton display moment — the wordmark voice, used sparingly.
              Text(
                l10n.signIn.toUpperCase(),
                style: AllyTypography.display(
                  size: 38,
                  color: scheme.onSurface,
                ),
              ),
              const SizedBox(height: AllySpacing.md),
              Text(
                l10n.chooseSignInMethod,
                style: AllyTypography.body(
                  size: 15,
                  color: scheme.onSurfaceVariant,
                ),
              ),

              const SizedBox(height: AllySpacing.xxl),

              // --- Structured method group ---
              AllySettingsGroup(
                tiles: [
                  AllySettingsTile(
                    title: l10n.continueWithGoogle,
                    icon: Icons.g_mobiledata_rounded,
                    onTap: isLoading
                        ? null
                        : () => controller.signInWithGoogle(context),
                  ),
                  AllySettingsTile(
                    title: l10n.continueWithApple,
                    icon: Icons.apple,
                    onTap: isLoading
                        ? null
                        : () => controller.signInWithApple(context),
                  ),
                  AllySettingsTile(
                    title: l10n.continueWithEmail,
                    icon: Icons.mail_outline_rounded,
                    onTap: isLoading ? null : controller.goToEmailStep,
                  ),
                ],
              ),

              const SizedBox(height: AllySpacing.md),

              AllyButton(
                label: l10n.continueAsAnonymous,
                icon: Icons.person_outline_rounded,
                kind: AllyButtonKind.ghost,
                onPressed: isLoading
                    ? null
                    : () => controller.signInAnonymously(context),
              ),

              SizedBox(height: constraints.maxHeight * 0.06),

              // Footer
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    l10n.dontHaveAccount,
                    style: AllyTypography.body(
                      size: 14,
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                  TextButton(
                    onPressed: () => controller.goToSignUp(context),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AllySpacing.sm,
                      ),
                    ),
                    child: Text(
                      l10n.signUp,
                      style: AllyTypography.label(
                        size: 14,
                        color: scheme.onSurface,
                      ),
                    ),
                  ),
                ],
              ),

              // ── Developer entry (debug builds only) ────────────────────
              if (kDebugMode) ...[
                SizedBox(height: constraints.maxHeight * 0.04),
                Center(child: _DevEntryChip(onTap: _showDevSheet)),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _showDevSheet(BuildContext context) {
    final themeProvider = context.read<ThemeProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    AllySheet.show(
      context,
      title: 'Developer',
      subtitle: 'Dev-mode utilities. Compiled out of release builds.',
      icon: Icons.terminal_rounded,
      child: Column(
        children: [
          AllySettingsGroup(
            tiles: [
              AllySettingsTile(
                title: 'Dev sign-in (local bypass)',
                subtitle: 'No Firebase session is created — offline dev entry.',
                icon: Icons.bolt_rounded,
                onTap: () {
                  Navigator.pop(context);
                  _enterDevBypass(context);
                },
              ),
              AllySettingsTile(
                title: 'Toggle theme',
                subtitle: isDark ? 'Dark → Light' : 'Light → Dark',
                icon: Icons.contrast_rounded,
                onTap: () {
                  themeProvider.changeTheme(
                    isDark ? AppTheme.light : AppTheme.dark,
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: AllySpacing.md),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Firebase: ${isFirebaseInitialized ? 'initialized' : 'offline mode'}',
              style: AllyTypography.caption(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Developer bypass: enters the app without any Firebase session (no
  /// anonymous account either). Everything keeps working from the local
  /// providers; server-backed features degrade to their offline states.
  Future<void> _enterDevBypass(BuildContext context) async {
    if (!kDebugMode) return;

    final notificationService = context.read<IntrovertNotificationService>();
    final health = context.read<HealthProvider>();
    final onboardingCompleted = await health.isOnboardingCompleted();

    if (!context.mounted) return;

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) =>
            onboardingCompleted ? const MainScreen() : const OnboardingScreen(),
      ),
    );

    notificationService.showNotification(
      message: 'Dev mode — local session (no Firebase).',
      type: NotificationType.neutral,
    );
  }
}

/// Small, intentional-looking developer affordance.
class _DevEntryChip extends StatelessWidget {
  final void Function(BuildContext) onTap;

  const _DevEntryChip({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;

    return Tooltip(
      message: 'Developer entry (debug only)',
      child: Material(
        color: Colors.transparent,
        borderRadius: AllyRadius.pill,
        child: InkWell(
          onTap: () => onTap(context),
          borderRadius: AllyRadius.pill,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AllySpacing.lg,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              borderRadius: AllyRadius.pill,
              border: Border.all(color: scheme.outlineVariant),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.terminal_rounded,
                  size: 14,
                  color: scheme.onSurfaceVariant,
                ),
                const SizedBox(width: AllySpacing.sm),
                Text(
                  'DEV',
                  style: AllyTypography.label(
                    size: 11,
                    weight: FontWeight.w700,
                    color: scheme.onSurfaceVariant,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EmailInputView extends StatelessWidget {
  final BoxConstraints constraints;
  final double contentWidth;

  const _EmailInputView({
    super.key,
    required this.constraints,
    required this.contentWidth,
  });

  @override
  Widget build(BuildContext context) {
    final controller = context.read<LoginController>();
    final errorText = context.select<LoginController, String?>(
      (c) => c.emailError,
    );
    final l10n = AppLocalizations.of(context)!;
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;

    return Container(
      width: constraints.maxWidth,
      color: Colors.transparent,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          AllySpacing.xxl,
          AllySpacing.xl,
          AllySpacing.xxl,
          AllySpacing.xl,
        ),
        child: SizedBox(
          width: contentWidth,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _AuthBackButton(onTap: controller.goBack),
              const SizedBox(height: AllySpacing.md),
              Text(
                l10n.signInWithEmail,
                style: AllyTypography.headline(
                  size: 26,
                  color: scheme.onSurface,
                ),
              ),
              const SizedBox(height: AllySpacing.sm),
              Text(
                l10n.enterEmailAddress,
                style: AllyTypography.body(
                  size: 15,
                  color: scheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AllySpacing.huge),
              _ShakeableInput(
                controller: controller.emailController,
                animationController: controller.emailShakeController,
                hintText: l10n.emailHint,
                icon: Icons.mail_outline_rounded,
                keyboardType: TextInputType.emailAddress,
                onChanged: (_) => controller.clearErrorsOnInput(),
                errorText: errorText == " " ? null : errorText,
              ),
              const SizedBox(height: AllySpacing.lg),
              AllyButton(
                label: l10n.next,
                onPressed: () => controller.goToPasswordStep(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PasswordInputView extends StatelessWidget {
  final BoxConstraints constraints;
  final double contentWidth;

  const _PasswordInputView({
    super.key,
    required this.constraints,
    required this.contentWidth,
  });

  @override
  Widget build(BuildContext context) {
    final controller = context.read<LoginController>();
    final isLoading = context.select<LoginController, bool>((c) => c.isLoading);
    final isVisible = context.select<LoginController, bool>(
      (c) => c.isPasswordVisible,
    );
    final errorText = context.select<LoginController, String?>(
      (c) => c.passwordError,
    );
    final l10n = AppLocalizations.of(context)!;
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;

    return Container(
      width: constraints.maxWidth,
      color: Colors.transparent,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          AllySpacing.xxl,
          AllySpacing.xl,
          AllySpacing.xxl,
          AllySpacing.xl,
        ),
        child: SizedBox(
          width: contentWidth,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _AuthBackButton(onTap: controller.goBack),
              const SizedBox(height: AllySpacing.md),
              Text(
                l10n.enterPassword,
                style: AllyTypography.headline(
                  size: 26,
                  color: scheme.onSurface,
                ),
              ),
              const SizedBox(height: AllySpacing.sm),
              Text(
                controller.emailController.text,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AllyTypography.body(
                  size: 15,
                  color: scheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AllySpacing.huge),
              _ShakeableInput(
                controller: controller.passwordController,
                animationController: controller.passwordShakeController,
                hintText: l10n.passwordHint,
                icon: Icons.lock_outline_rounded,
                obscureText: !isVisible,
                onChanged: (_) => controller.clearErrorsOnInput(),
                errorText: errorText == " " ? null : errorText,
                suffix: IconButton(
                  onPressed: controller.togglePasswordVisibility,
                  icon: Icon(
                    isVisible
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    size: 22,
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ),
              const SizedBox(height: AllySpacing.lg),
              AllyButton(
                label: l10n.signIn,
                isLoading: isLoading,
                onPressed: isLoading
                    ? null
                    : () => controller.submitEmailLogin(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Themed back affordance for auth sub-steps.
class _AuthBackButton extends StatelessWidget {
  final VoidCallback onTap;

  const _AuthBackButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return IconButton(
      onPressed: onTap,
      icon: const Icon(Icons.arrow_back_rounded),
      color: theme.colorScheme.onSurface,
      tooltip: MaterialLocalizations.of(context).backButtonTooltip,
    );
  }
}

/// Input field with the error shake feedback preserved from the old design.
class _ShakeableInput extends StatelessWidget {
  final TextEditingController controller;
  final AnimationController animationController;
  final String hintText;
  final IconData icon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;
  final String? errorText;
  final Widget? suffix;

  const _ShakeableInput({
    required this.controller,
    required this.animationController,
    required this.hintText,
    required this.icon,
    this.obscureText = false,
    this.keyboardType,
    this.onChanged,
    this.errorText,
    this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    return ShakeWidget(
      controller: animationController,
      child: AllyTextField(
        controller: controller,
        hint: hintText,
        prefixIcon: icon,
        obscureText: obscureText,
        keyboardType: keyboardType,
        onChanged: onChanged,
        errorText: errorText,
        suffix: suffix,
        autocorrect: false,
        enableSuggestions: false,
      ),
    );
  }
}
