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
          resizeToAvoidBottomInset: false,
          body: LayoutBuilder(
            builder: (context, constraints) {
              return SizedBox(
                width: constraints.maxWidth,
                height: constraints.maxHeight,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 600),
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

    return Container(
      width: constraints.maxWidth,
      height: constraints.maxHeight,
      color: AppColors.background, // Tema rengi
      child: SafeArea(
        child: Center(
          child: SizedBox(
            width: contentWidth,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: constraints.maxHeight * 0.05),

                  Text(
                    l10n.signIn, // "Sign in"
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.tertiaryColor, // Tema metin rengi
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.chooseSignInMethod, // "Choose your sign in method"
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.tertiaryColor.withValues(alpha: 0.7),
                    ),
                  ),

                  const Spacer(),

                  // --- Butonlar ---

                  _AuthButton(
                    text: l10n.continueWithGoogle,
                    icon: Icons.g_mobiledata_rounded,
                    onTap: isLoading ? null : () => controller.signInWithGoogle(context),
                  ),

                  const SizedBox(height: 16),

                  _AuthButton(
                    text: l10n.continueWithApple, // "Continue with Apple"
                    icon: Icons.apple,
                    onTap: isLoading ? null : () => controller.signInWithApple(context),
                  ),

                  const SizedBox(height: 16),

                  _AuthButton(
                    text: l10n.continueWithEmail,
                    icon: Icons.email_outlined,
                    onTap: isLoading ? null : controller.goToEmailStep,
                  ),

                  const SizedBox(height: 16),

                  _AuthButton(
                    text: l10n.continueAsAnonymous,
                    icon: Icons.person_outline_rounded,
                    onTap: isLoading ? null : () => controller.signInAnonymously(context),
                  ),

                  SizedBox(height: constraints.maxHeight * 0.04),

                  // Footer
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        l10n.dontHaveAccount, // "Don't have an account? "
                        style: TextStyle(color: AppColors.tertiaryColor.withValues(alpha: 0.7), fontSize: 14),
                      ),
                      GestureDetector(
                        onTap: () => controller.goToSignUp(context),
                        child: Text(
                          l10n.signUp, // "Sign Up"
                          style: TextStyle(
                            color: AppColors.tertiaryColor,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),
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
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: controller.goToPasswordStep,
                        borderRadius: BorderRadius.circular(30),
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
                      color: AppColors.background, // Temanın arka plan rengi (outline stili için)
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: AppColors.tertiaryColor, width: 2), // Çerçeve
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: isLoading ? null : () => controller.submitEmailLogin(context),
                        borderRadius: BorderRadius.circular(30),
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
                                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.tertiaryColor),
                                ),
                              ),
                            ),
                          )
                              : Text(
                            l10n.signIn, // "Sign In"
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors.tertiaryColor,
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

  const _AuthButton({
    required this.text,
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.secondaryColor, // Buton arka planı
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(30),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: AppColors.tertiaryColor, size: 24),
                const SizedBox(width: 12),
                Text(
                  text,
                  style: TextStyle(
                    color: AppColors.tertiaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
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
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(
                  color: errorText != null ? AppColors.septenaryColor : AppColors.border,
                  width: 1.5,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(
                  color: errorText != null ? AppColors.septenaryColor : AppColors.border,
                  width: 1.5,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
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
