import 'package:ally/l10n/app_localizations.dart';
import 'package:ally/login/controller.dart';
import 'package:ally/theme.dart'; // Theme dosyanın yolu
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with TickerProviderStateMixin {
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
    // Tema değişikliğinde rebuild olması için context'i dinliyoruz
    // Not: AppColors statik olsa da Flutter'ın theme yapısı değiştikçe build tetiklenir.

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
      child: Theme(
        // Burası uygulamanın genel temasını kullanır, özel bir override yapmıyoruz
        data: Theme.of(context),
        child: Scaffold(
          backgroundColor: AppColors.background,
          resizeToAvoidBottomInset: true,
          body: LayoutBuilder(
            builder: (context, constraints) {
              return SizedBox(
                width: constraints.maxWidth,
                height: constraints.maxHeight,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 280),
                  transitionBuilder: (Widget child, Animation<double> animation) {
                    final offsetAnimation = Tween<Offset>(
                      begin: const Offset(0.0, 1.0),
                      end: Offset.zero,
                    ).animate(CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeInOutCubic,
                    ));
                    return SlideTransition(
                      position: offsetAnimation,
                      child: child,
                    );
                  },
                  child: _buildStepView(
                    controller.currentStep,
                    constraints,
                    contentWidth,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildStepView(LoginStep step, BoxConstraints constraints, double contentWidth) {
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
    final accent = AppColors.senaryColor;

    return Container(
      width: constraints.maxWidth,
      height: constraints.maxHeight,
      color: AppColors.background,
      child: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: contentWidth),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      width: 58,
                      height: 58,
                      decoration: BoxDecoration(
                        color: accent.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(19),
                      ),
                      child: Icon(
                        Icons.favorite_rounded,
                        color: accent,
                        size: 31,
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  Text(
                    l10n.signIn,
                    style: TextStyle(
                      color: AppColors.tertiaryColor,
                      fontSize: 32,
                      height: 1.1,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.7,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    l10n.chooseSignInMethod,
                    style: TextStyle(
                      color: AppColors.tertiaryColor.withValues(alpha: 0.72),
                      fontSize: 15,
                      height: 1.45,
                    ),
                  ),
                  const SizedBox(height: 30),
                  _AuthButton(
                    text: l10n.continueWithGoogle,
                    icon: Icons.g_mobiledata_rounded,
                    onTap: isLoading ? null : () => controller.signInWithGoogle(context),
                  ),
                  const SizedBox(height: 12),
                  _AuthButton(
                    text: l10n.continueWithApple,
                    icon: Icons.apple,
                    onTap: isLoading ? null : () => controller.signInWithApple(context),
                  ),
                  const SizedBox(height: 12),
                  _AuthButton(
                    text: l10n.continueWithEmail,
                    icon: Icons.mail_outline_rounded,
                    onTap: isLoading ? null : controller.goToEmailStep,
                  ),
                  const SizedBox(height: 12),
                  _AuthButton(
                    text: l10n.continueAsAnonymous,
                    icon: Icons.person_outline_rounded,
                    isPrimary: true,
                    onTap: isLoading ? null : () => controller.signInAnonymously(context),
                  ),
                  if (isLoading) ...[
                    const SizedBox(height: 18),
                    const Center(
                      child: SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(strokeWidth: 2.4),
                      ),
                    ),
                  ],
                  const SizedBox(height: 28),
                  Wrap(
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        l10n.dontHaveAccount,
                        style: TextStyle(
                          color: AppColors.tertiaryColor.withValues(alpha: 0.72),
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: 5),
                      TextButton(
                        onPressed: isLoading ? null : () => controller.goToSignUp(context),
                        style: TextButton.styleFrom(
                          foregroundColor: accent,
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          l10n.signUp,
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
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
    final errorText = context.select<LoginController, String?>((c) => c.emailError);
    final l10n = AppLocalizations.of(context)!;

    return Container(
      width: constraints.maxWidth,
      height: constraints.maxHeight,
      color: AppColors.background,
      child: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: SizedBox(
              width: contentWidth,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  const SizedBox(height: 20),

                  GestureDetector(
                    onTap: controller.goBack,
                    child: Icon(Icons.chevron_left, color: AppColors.tertiaryColor, size: 32),
                  ),

                  SizedBox(height: constraints.maxHeight * 0.02),

                  Text(
                    l10n.signInWithEmail, // "Sign in with email"
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.tertiaryColor,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.enterEmailAddress, // "Enter your email address"
                    style: TextStyle(fontSize: 16, color: AppColors.tertiaryColor.withValues(alpha: 0.7)),
                  ),

                  SizedBox(height: constraints.maxHeight * 0.1),

                  _ShakeableInput(
                    controller: controller.emailController,
                    animationController: controller.emailShakeController,
                    hintText: l10n.emailHint,
                    icon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (_) => controller.clearErrorsOnInput(),
                    errorText: errorText == " " ? null : errorText,
                  ),

                  const SizedBox(height: 16),

                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.senaryColor, // Tema vurgu rengi
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: controller.goToPasswordStep,
                        borderRadius: BorderRadius.circular(18),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          child: Text(
                            l10n.next, // "Next"
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white, // Vurgu rengi üzerinde genelde beyaz okunur
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
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
    final isVisible = context.select<LoginController, bool>((c) => c.isPasswordVisible);
    final errorText = context.select<LoginController, String?>((c) => c.passwordError);
    final l10n = AppLocalizations.of(context)!;

    return Container(
      width: constraints.maxWidth,
      height: constraints.maxHeight,
      color: AppColors.background,
      child: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: SizedBox(
              width: contentWidth,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  const SizedBox(height: 20),

                  GestureDetector(
                    onTap: controller.goBack,
                    child: Icon(Icons.chevron_left, color: AppColors.tertiaryColor, size: 32),
                  ),

                  SizedBox(height: constraints.maxHeight * 0.02),

                  Text(
                    l10n.signInWithEmail,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.tertiaryColor,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.enterPassword, // "Enter your password"
                    style: TextStyle(fontSize: 16, color: AppColors.tertiaryColor.withValues(alpha: 0.7)),
                  ),

                  SizedBox(height: constraints.maxHeight * 0.1),

                  _ShakeableInput(
                    controller: controller.passwordController,
                    animationController: controller.passwordShakeController,
                    hintText: l10n.passwordHint,
                    icon: Icons.lock_outline,
                    obscureText: !isVisible,
                    suffixIcon: IconButton(
                      icon: Icon(isVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                      color: AppColors.tertiaryColor.withValues(alpha: 0.6),
                      onPressed: controller.togglePasswordVisibility,
                    ),
                    onChanged: (_) => controller.clearErrorsOnInput(),
                    errorText: errorText == " " ? null : errorText,
                  ),

                  const SizedBox(height: 16),

                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.senaryColor,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: AppColors.senaryColor, width: 1),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: isLoading ? null : () => controller.submitEmailLogin(context),
                        borderRadius: BorderRadius.circular(18),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          child: isLoading
                              ? SizedBox(
                            height: 20,
                            child: Center(
                              child: SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              ),
                            ),
                          )
                              : Text(
                            l10n.signIn, // "Sign In"
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
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

// --- YARDIMCI WIDGET'LAR ---

class _AuthButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback? onTap;
  final bool isPrimary;

  const _AuthButton({
    required this.text,
    required this.icon,
    this.onTap,
    this.isPrimary = false,
  });

  @override
  Widget build(BuildContext context) {
    final foreground = isPrimary ? Colors.white : AppColors.tertiaryColor;

    return SizedBox(
      width: double.infinity,
      child: Material(
        color: isPrimary ? AppColors.senaryColor : AppColors.secondaryColor,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: Container(
            constraints: const BoxConstraints(minHeight: 56),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: isPrimary ? AppColors.senaryColor : AppColors.border,
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(icon, color: foreground, size: 23),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    text,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: foreground,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 23),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Shake (Titreme) animasyonlu Input alanı.
/// Tema renklerini (Secondary, Border, Tertiary) kullanır.
class _ShakeableInput extends StatelessWidget {
  final TextEditingController controller;
  final AnimationController animationController;
  final String hintText;
  final IconData icon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final Widget? suffixIcon;
  final ValueChanged<String>? onChanged;
  final String? errorText;

  const _ShakeableInput({
    required this.controller,
    required this.animationController,
    required this.hintText,
    required this.icon,
    this.obscureText = false,
    this.keyboardType,
    this.suffixIcon,
    this.onChanged,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (context, child) {
        // Basit bir sinüs dalgası simülasyonu
        // (math kütüphanesi import etmeden temiz kod için)
        final double translateX = 10.0 * (
            animationController.value > 0 && animationController.value < 0.25 ? -1 :
            animationController.value >= 0.25 && animationController.value < 0.75 ? 1 :
            animationController.value >= 0.75 && animationController.value < 1.0 ? -0.5 : 0
        );

        return Transform.translate(
          offset: Offset(translateX * (1 - animationController.value), 0),
          child: child,
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: controller,
            obscureText: obscureText,
            keyboardType: keyboardType,
            onChanged: onChanged,
            style: TextStyle(color: AppColors.tertiaryColor), // Yazılan metin rengi
            cursorColor: AppColors.tertiaryColor,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(color: AppColors.tertiaryColor.withValues(alpha: 0.5)),
              prefixIcon: Icon(icon, color: AppColors.tertiaryColor.withValues(alpha: 0.7)),
              suffixIcon: suffixIcon,
              filled: true,
              fillColor: AppColors.secondaryColor, // Input arka planı

              // Hata ve Normal Durum Sınırları
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide(
                  color: errorText != null ? AppColors.septenaryColor : AppColors.border,
                  width: 1.5,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide(
                  color: errorText != null ? AppColors.septenaryColor : AppColors.border,
                  width: 1.5,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide(
                  color: errorText != null ? AppColors.septenaryColor : AppColors.tertiaryColor,
                  width: 1.5,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            ),
          ),
          if (errorText != null && errorText!.trim().isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(left: 20.0, top: 8.0),
              child: Text(
                errorText!,
                style: TextStyle(color: AppColors.septenaryColor, fontSize: 12),
              ),
            ),
        ],
      ),
    );
  }
}
