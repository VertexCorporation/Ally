import 'package:ally/l10n/app_localizations.dart';
import 'package:ally/theme.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import '../../shake.dart';

class RegisterForm extends StatefulWidget {
  final Future<void> Function(String username, String email, String password) onSubmit;
  final VoidCallback onInputChanged;
  final bool isLoading;
  final bool agreeToTerms;
  final String? usernameError;
  final String? emailError;
  final String? passwordError;
  final AnimationController usernameShakeController;
  final AnimationController emailShakeController;
  final AnimationController passwordShakeController;
  final double fontScale;

  const RegisterForm({
    super.key,
    required this.onSubmit,
    required this.onInputChanged,
    required this.isLoading,
    required this.agreeToTerms,
    this.usernameError,
    this.emailError,
    this.passwordError,
    required this.usernameShakeController,
    required this.emailShakeController,
    required this.passwordShakeController,
    required this.fontScale,
  });

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _usernameController;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  bool _isPasswordVisible = false;
  String _username = '';
  String _email = '';
  String _password = '';
  final RegExp _usernameRegExp = RegExp(r'^[a-z0-9çğıöşü._-]{3,20}$', caseSensitive: false);

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void didUpdateWidget(RegisterForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.usernameError != null && widget.usernameError != oldWidget.usernameError) {
      _formKey.currentState?.validate();
    }
    if (widget.emailError != null && widget.emailError != oldWidget.emailError) {
      _formKey.currentState?.validate();
    }
    if (widget.passwordError != null && widget.passwordError != oldWidget.passwordError) {
      _formKey.currentState?.validate();
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submitForm() {
    FocusScope.of(context).unfocus();
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;
    _formKey.currentState?.save();
    widget.onSubmit(_username, _email, _password);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final bool isDisabled = widget.isLoading || !widget.agreeToTerms;
    final double spacer = 16 * widget.fontScale;
    final textColor = AppColors.tertiaryColor;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: spacer),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              l10n.createAccount, // "Create your account"
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 38 * widget.fontScale,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 4 * widget.fontScale),
            child: Text(
              l10n.registerSubtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12 * widget.fontScale, // Biraz büyüttüm
                color: textColor.withValues(alpha: 0.6),
                height: 1.2,
              ),
            ),
          ),

          SizedBox(height: spacer),

          // --- Username Field ---
          ShakeWidget(
            controller: widget.usernameShakeController,
            child: TextFormField(
              controller: _usernameController,
              onChanged: (_) => widget.onInputChanged(),
              cursorColor: textColor,
              style: TextStyle(
                  color: textColor,
                  fontSize: 14 * widget.fontScale
              ),
              decoration: _inputDecoration(
                hint: l10n.usernameHint,
                icon: Icons.person_outline,
                scale: widget.fontScale,
              ),
              maxLength: 20,
              validator: (value) {
                if (widget.usernameError != null) return widget.usernameError;
                if (value == null || value.trim().length < 3) return l10n.usernameTooShort; // Key control
                if (value.trim().length > 20) return l10n.usernameTooLong; // Key control
                if (!_usernameRegExp.hasMatch(value.trim())) return l10n.invalidUsernameCharacters; // Key control
                return null;
              },
              onSaved: (value) => _username = value!.trim().toLowerCase(),
            ),
          ),

          SizedBox(height: spacer),

          // --- Email Field ---
          ShakeWidget(
            controller: widget.emailShakeController,
            child: TextFormField(
              controller: _emailController,
              onChanged: (_) => widget.onInputChanged(),
              cursorColor: textColor,
              style: TextStyle(
                  color: textColor,
                  fontSize: 14 * widget.fontScale
              ),
              decoration: _inputDecoration(
                hint: l10n.emailHint,
                icon: Icons.email_outlined,
                scale: widget.fontScale,
              ),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (widget.emailError != null) return widget.emailError;
                if (value == null || !EmailValidator.validate(value.trim())) return l10n.invalidEmail;
                return null;
              },
              onSaved: (value) => _email = value!.trim(),
            ),
          ),

          SizedBox(height: spacer),

          // --- Password Field ---
          ShakeWidget(
            controller: widget.passwordShakeController,
            child: TextFormField(
              controller: _passwordController,
              onChanged: (_) => widget.onInputChanged(),
              cursorColor: textColor,
              style: TextStyle(
                  color: textColor,
                  fontSize: 14 * widget.fontScale
              ),
              decoration: _inputDecoration(
                hint: l10n.passwordHint,
                icon: Icons.lock_outline,
                scale: widget.fontScale,
              ).copyWith(
                suffixIcon: IconButton(
                  icon: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder: (child, animation) => FadeTransition(opacity: animation, child: child),
                    child: Icon(
                      _isPasswordVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                      key: ValueKey(_isPasswordVisible ? 'icon1' : 'icon2'),
                      color: textColor.withValues(alpha: 0.6),
                      size: 24 * widget.fontScale,
                    ),
                  ),
                  onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                ),
              ),
              obscureText: !_isPasswordVisible,
              maxLength: 64,
              validator: (value) {
                if (widget.passwordError != null) return widget.passwordError;
                if (value == null || value.length < 6) return l10n.weakPassword;
                return null;
              },
              onSaved: (value) => _password = value!.trim(),
            ),
          ),

          SizedBox(height: spacer),

          // --- Submit Button ---
          AnimatedOpacity(
            opacity: isDisabled ? 0.5 : 1.0,
            duration: const Duration(milliseconds: 200),
            child: IgnorePointer(
              ignoring: isDisabled,
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.background,
                    foregroundColor: textColor,
                    disabledBackgroundColor: AppColors.background,
                    disabledForegroundColor: textColor.withValues(alpha: 0.5),
                    padding: EdgeInsets.symmetric(vertical: 14 * widget.fontScale),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10 * widget.fontScale),
                    ),
                    elevation: 0,
                    side: BorderSide(color: AppColors.border),
                  ),
                  onPressed: _submitForm,
                  child: Text(
                      l10n.signUp,
                      style: TextStyle(
                          fontSize: 16 * widget.fontScale,
                          fontWeight: FontWeight.bold
                      )
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration({required String hint, required IconData icon, required double scale}) {
    return InputDecoration(
      filled: true,
      fillColor: AppColors.secondaryColor,
      labelText: hint,
      labelStyle: TextStyle(
          color: AppColors.tertiaryColor.withValues(alpha: 0.6),
          fontSize: 14 * scale
      ),
      prefixIcon: Icon(icon, color: AppColors.tertiaryColor.withValues(alpha: 0.7), size: 24 * scale),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10 * scale), borderSide: BorderSide.none),
      counterText: '',
      errorMaxLines: 3,
      errorStyle: TextStyle(fontSize: 12 * scale, color: AppColors.septenaryColor),
      contentPadding: EdgeInsets.symmetric(vertical: 14 * scale, horizontal: 12 * scale),
    );
  }
}