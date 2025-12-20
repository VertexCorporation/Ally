// lib/login/upgrade.dart

import 'package:ally/l10n/app_localizations.dart';
import 'package:ally/login/controller.dart';
import 'package:ally/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UpgradeAccountScreen extends StatefulWidget {
  const UpgradeAccountScreen({super.key});

  @override
  State<UpgradeAccountScreen> createState() => _UpgradeAccountScreenState();
}

class _UpgradeAccountScreenState extends State<UpgradeAccountScreen> with TickerProviderStateMixin {
  late final LoginController _controller;

  // Input Controller'ları
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _agreeToTerms = false;
  bool _isPasswordVisible = false;

  late final AnimationController _shakeController;

  @override
  void initState() {
    super.initState();
    _controller = LoginController();
    _controller.initialize(this, context);

    _shakeController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 500)
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _shakeController.dispose();
    super.dispose();
  }

  Future<void> _submitUpgrade() async {
    if (!_agreeToTerms) {
      _shakeController.forward(from: 0);
      return;
    }
    // Backend işlemleri burada tetiklenir
    // _controller.submitUpgrade(...)
  }

  void _showTermsAndPolicy(BuildContext context) {
    // Webview modal açılışı
  }

  @override
  Widget build(BuildContext context) {
    // EKRAN BOYUTU HESAPLAMALARI (RESPONSIVE ENGINE)
    final Size screenSize = MediaQuery.of(context).size;

    // Referans tasarım genişliği (örn: 390px iPhone genişliği)
    // Tabletlerde her şeyin devasa olmaması için scale'i 1.0 civarında sabitliyoruz.
    double scale = screenSize.width / 390.0;
    if (screenSize.width > 600) {
      scale = 1.0 + (screenSize.width - 600) * 0.0001; // Tabletlerde çok az büyüme payı
    }
    // Scale faktörünü mantıklı sınırlar içinde tut (Çok küçük veya çok büyük olmasın)
    scale = scale.clamp(0.85, 1.2);

    return ChangeNotifierProvider.value(
      value: _controller,
      child: Scaffold(
        backgroundColor: AppColors.background,
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: Stack(
            children: [
              // --- ANA İÇERİK ---
              Center(
                child: ConstrainedBox(
                  // Tabletlerde içeriğin çok yayılmasını engellemek için MaxWidth
                  constraints: BoxConstraints(maxWidth: 450 * scale),
                  child: SingleChildScrollView(
                    // Klavye açılınca scroll olabilmesi için
                    padding: EdgeInsets.symmetric(
                        horizontal: 32.0 * scale,
                        vertical: 24.0 * scale
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20 * scale),

                        Text(
                          AppLocalizations.of(context)!.upgradeAccountTitle,
                          style: TextStyle(
                            fontSize: 28 * scale,
                            fontWeight: FontWeight.bold,
                            color: AppColors.tertiaryColor,
                            letterSpacing: 0.5,
                          ),
                        ),
                        SizedBox(height: 8 * scale),
                        Text(
                          AppLocalizations.of(context)!.upgradeAccountDescription,
                          style: TextStyle(
                            fontSize: 16 * scale,
                            color: AppColors.tertiaryColor.withValues(alpha: 0.7),
                            height: 1.4,
                          ),
                        ),

                        SizedBox(height: 32 * scale),

                        // --- FORM ---

                        _DynamicInput(
                          controller: _usernameController,
                          hintText: AppLocalizations.of(context)!.usernameHint,
                          icon: Icons.person_outline,
                          scale: scale,
                        ),

                        SizedBox(height: 16 * scale),

                        _DynamicInput(
                          controller: _emailController,
                          hintText: AppLocalizations.of(context)!.emailHint,
                          icon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                          scale: scale,
                        ),

                        SizedBox(height: 16 * scale),

                        _DynamicInput(
                          controller: _passwordController,
                          hintText: AppLocalizations.of(context)!.passwordHint,
                          icon: Icons.lock_outline,
                          obscureText: !_isPasswordVisible,
                          scale: scale,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                              color: AppColors.tertiaryColor.withValues(alpha: 0.6),
                              size: 24 * scale,
                            ),
                            onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                          ),
                        ),

                        SizedBox(height: 24 * scale),

                        // --- TERMS CHECKBOX ---

                        GestureDetector(
                          onTap: () => setState(() => _agreeToTerms = !_agreeToTerms),
                          child: AnimatedBuilder(
                            animation: _shakeController,
                            builder: (context, child) {
                              final offset = (10 * scale) * (0.5 - (0.5 - Curves.elasticIn.transform(_shakeController.value)).abs());
                              return Transform.translate(
                                offset: Offset(offset, 0),
                                child: child,
                              );
                            },
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 24 * scale,
                                  height: 24 * scale,
                                  child: Checkbox(
                                    value: _agreeToTerms,
                                    onChanged: (val) => setState(() => _agreeToTerms = val ?? false),
                                    activeColor: AppColors.senaryColor,
                                    checkColor: Colors.white,
                                    side: BorderSide(color: AppColors.border, width: 1.5),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4 * scale)),
                                  ),
                                ),
                                SizedBox(width: 12 * scale),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () => _showTermsAndPolicy(context),
                                    child: Text(
                                      AppLocalizations.of(context)!.iHaveReadAndAgree,
                                      style: TextStyle(
                                        fontSize: 13 * scale,
                                        color: _agreeToTerms ? AppColors.tertiaryColor : AppColors.tertiaryColor.withValues(alpha: 0.6),
                                        fontWeight: _agreeToTerms ? FontWeight.w600 : FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        SizedBox(height: 24 * scale),

                        // --- ACTION BUTTON ---

                        Consumer<LoginController>(
                          builder: (context, controller, _) {
                            return GestureDetector(
                              onTap: controller.isLoading ? null : _submitUpgrade,
                              child: Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(vertical: 18 * scale),
                                decoration: BoxDecoration(
                                  color: _agreeToTerms ? AppColors.senaryColor : AppColors.secondaryColor,
                                  borderRadius: BorderRadius.circular(30 * scale),
                                  border: _agreeToTerms ? null : Border.all(color: AppColors.border),
                                ),
                                child: controller.isLoading
                                    ? SizedBox(
                                  height: 20 * scale,
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          _agreeToTerms ? Colors.white : AppColors.tertiaryColor
                                      ),
                                    ),
                                  ),
                                )
                                    : Text(
                                  AppLocalizations.of(context)!.createAccount,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: _agreeToTerms ? Colors.white : AppColors.tertiaryColor.withValues(alpha: 0.5),
                                    fontSize: 16 * scale,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),

                        SizedBox(height: 30 * scale),

                        // --- DIVIDER ---

                        Row(
                          children: [
                            Expanded(child: Divider(color: AppColors.border, thickness: 1)),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16 * scale),
                              child: Text(
                                AppLocalizations.of(context)!.or,
                                style: TextStyle(
                                  color: AppColors.tertiaryColor.withValues(alpha: 0.5),
                                  fontSize: 12 * scale,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Expanded(child: Divider(color: AppColors.border, thickness: 1)),
                          ],
                        ),

                        SizedBox(height: 30 * scale),

                        // --- SOCIAL BUTTONS ---

                        _DynamicSocialButton(
                          text: AppLocalizations.of(context)!.continueWithApple,
                          icon: Icons.apple,
                          scale: scale,
                          onTap: () => _controller.signInWithApple(context),
                        ),

                        SizedBox(height: 16 * scale),

                        _DynamicSocialButton(
                          text: AppLocalizations.of(context)!.continueWithGoogle,
                          icon: Icons.g_mobiledata_rounded,
                          scale: scale,
                          onTap: () => _controller.signInWithGoogle(context),
                        ),

                        SizedBox(height: 40 * scale),
                      ],
                    ),
                  ),
                ),
              ),

              // --- KAPAT BUTONU ---
              Positioned(
                top: 16 * scale,
                left: 16 * scale, // Sol üst Ally standartlarına daha uygun olabilir
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    padding: EdgeInsets.all(8 * scale),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.secondaryColor.withValues(alpha: 0.5),
                    ),
                    child: Icon(
                      Icons.close,
                      color: AppColors.tertiaryColor,
                      size: 24 * scale,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// --- DINAMIK WIDGETLER ---

class _DynamicInput extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  final double scale;
  final bool obscureText;
  final TextInputType? keyboardType;
  final Widget? suffixIcon;

  const _DynamicInput({
    required this.controller,
    required this.hintText,
    required this.icon,
    required this.scale,
    this.obscureText = false,
    this.keyboardType,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: TextStyle(
        color: AppColors.tertiaryColor,
        fontSize: 16 * scale, // Yazı boyutu dinamik
      ),
      cursorColor: AppColors.tertiaryColor,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: AppColors.tertiaryColor.withValues(alpha: 0.5),
          fontSize: 16 * scale,
        ),
        prefixIcon: Icon(
          icon,
          color: AppColors.tertiaryColor.withValues(alpha: 0.7),
          size: 24 * scale, // İkon boyutu dinamik
        ),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: AppColors.secondaryColor,
        // Kenarlıklar
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16 * scale),
          borderSide: BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16 * scale),
          borderSide: BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16 * scale),
          borderSide: BorderSide(color: AppColors.tertiaryColor, width: 1.5),
        ),
        contentPadding: EdgeInsets.symmetric(
            horizontal: 20 * scale,
            vertical: 18 * scale // Yükseklik dinamik padding ile belirleniyor
        ),
      ),
    );
  }
}

class _DynamicSocialButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final double scale;
  final VoidCallback onTap;

  const _DynamicSocialButton({
    required this.text,
    required this.icon,
    required this.scale,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 16 * scale),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(16 * scale),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
                icon,
                color: AppColors.tertiaryColor,
                size: 24 * scale
            ),
            SizedBox(width: 12 * scale),
            Text(
              text,
              style: TextStyle(
                color: AppColors.tertiaryColor,
                fontSize: 15 * scale,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}