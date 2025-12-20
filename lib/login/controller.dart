// lib/login/controller.dart

import 'package:ally/l10n/app_localizations.dart';
import 'package:ally/screens/onboard.dart';
import 'package:ally/screens/signup_screen.dart';
import 'package:ally/notifications/introvert.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'backend.dart';

/// Defines the specific step the user is currently viewing in the login flow.
enum LoginStep { methodSelection, emailInput, passwordInput }

/// The central orchestrator (ViewModel) for the Login Screen.
///
/// This class manages:
/// 1. The multi-step navigation state (Method -> Email -> Password).
/// 2. Input text controllers and validation.
/// 3. Interaction with the [LoginBackendService].
/// 4. Animation controllers for step transitions and error shaking.
class LoginController extends ChangeNotifier {
  // --- Dependencies ---
  late final LoginBackendService _backendService;
  late final IntrovertNotificationService _notificationService;

  // --- UI State ---
  LoginStep _currentStep = LoginStep.methodSelection;
  bool _isLoading = false;
  bool _isPasswordVisible = false;

  // --- Input Controllers ---
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // --- Error State ---
  String? _emailError;
  String? _passwordError;

  // --- Animation Controllers ---
  // These are initialized in [initialize] to decoupled them from the constructor.
  late final AnimationController emailShakeController;
  late final AnimationController passwordShakeController;

  // --- Public Getters ---
  LoginStep get currentStep => _currentStep;
  bool get isLoading => _isLoading;
  bool get isPasswordVisible => _isPasswordVisible;
  String? get emailError => _emailError;
  String? get passwordError => _passwordError;

  // --- Initialization & Disposal ---

  /// Initializes dependencies and animation controllers.
  /// Must be called from the View's `initState`.
  void initialize(TickerProvider vsync, BuildContext context) {
    _backendService = LoginBackendService();
    _notificationService = Provider.of<IntrovertNotificationService>(context, listen: false);

    const shakeDuration = Duration(milliseconds: 500);
    emailShakeController = AnimationController(vsync: vsync, duration: shakeDuration);
    passwordShakeController = AnimationController(vsync: vsync, duration: shakeDuration);
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    emailShakeController.dispose();
    passwordShakeController.dispose();
    super.dispose();
  }

  // --- Navigation Logic (Step Management) ---

  /// Advances from Method Selection to Email Input.
  void goToEmailStep() {
    _clearErrors();
    _currentStep = LoginStep.emailInput;
    notifyListeners();
  }

  /// Advances from Email Input to Password Input.
  void goToPasswordStep() {
    _clearErrors();
    if (emailController.text.trim().isEmpty) {
      _emailError = " "; // Trigger visual error state
      emailShakeController.forward(from: 0);
      notifyListeners();
      return;
    }
    _currentStep = LoginStep.passwordInput;
    notifyListeners();
  }

  /// Handles the "Back" button logic based on the current step.
  void goBack() {
    _clearErrors();
    if (_currentStep == LoginStep.passwordInput) {
      _currentStep = LoginStep.emailInput;
    } else if (_currentStep == LoginStep.emailInput) {
      _currentStep = LoginStep.methodSelection;
      // Optional: Clear inputs when returning to start
      // emailController.clear();
      // passwordController.clear();
    }
    notifyListeners();
  }

  /// Navigates to the separate Sign Up screen.
  void goToSignUp(BuildContext context) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const SignUpScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOutCubic;
          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          return SlideTransition(position: animation.drive(tween), child: child);
        },
        transitionDuration: const Duration(milliseconds: 600),
      ),
    );
  }

  // --- UI Interactions ---

  void togglePasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    notifyListeners();
  }

  /// Clears errors when the user starts typing again.
  void clearErrorsOnInput() {
    if (_emailError != null || _passwordError != null) {
      _clearErrors();
      notifyListeners();
    }
  }

  // --- Authentication Actions ---

  /// Submits the Email/Password login.
  Future<void> submitEmailLogin(BuildContext context) async {
    if (_isLoading) return;

    final email = emailController.text.trim();
    final password = passwordController.text;

    if (email.isEmpty) {
      goToEmailStep(); // Should not happen if flow is followed, but safety first
      return;
    }
    if (password.isEmpty) {
      _passwordError = " ";
      passwordShakeController.forward(from: 0);
      notifyListeners();
      return;
    }

    _setLoading(true);
    _clearErrors();

    final result = await _backendService.loginWithEmail(
      context: context,
      notificationService: _notificationService,
      email: email,
      password: password,
      rememberMe: true,
    );

    if (!context.mounted) return;
    final l10n = AppLocalizations.of(context)!;

    switch (result) {
      case LoginSuccess():
        _navigateAfterSuccess(context);
        break;
      case LoginInvalidCredentials():
      // We shake the password field for invalid creds usually
        _passwordError = l10n.invalidCredentials; // Ensure this key exists or use authFailed
        passwordShakeController.forward(from: 0);
        break;
      case LoginUserDisabled():
        _emailError = l10n.userDisabled; // Ensure this key exists
        emailShakeController.forward(from: 0);
        break;
      case LoginNetworkError():
      case LoginUnknownError():
      // Notification is handled by backend
        break;
    }

    _setLoading(false);
  }

  Future<void> signInWithGoogle(BuildContext context) async {
    if (_isLoading) return;

    _setLoading(true);

    final result = await _backendService.signInWithGoogle(
      context: context,
      notificationService: _notificationService,
    );

    if (!context.mounted) return;

    if (result is GoogleSignInSuccess) {
      _navigateAfterSuccess(context);
    }
    // Failures are handled via notifications in backend
    _setLoading(false);
  }

  Future<void> signInWithApple(BuildContext context) async {
    if (_isLoading) return;

    _setLoading(true);

    final result = await _backendService.signInWithApple(
      context: context,
      notificationService: _notificationService,
    );

    if (!context.mounted) return;

    if (result is AppleSignInSuccess) {
      _navigateAfterSuccess(context);
    }
    _setLoading(false);
  }

  Future<void> signInAnonymously(BuildContext context) async {
    if (_isLoading) return;

    _setLoading(true);

    final result = await _backendService.signInAnonymously(
      context: context,
      notificationService: _notificationService,
    );

    if (!context.mounted) return;

    if (result is AnonymousSignInSuccess) {
      _navigateAfterSuccess(context);
    }
    _setLoading(false);
  }

  // --- Private Helpers ---

  void _setLoading(bool value) {
    if (_isLoading == value) return;
    _isLoading = value;
    notifyListeners();
  }

  void _clearErrors() {
    _emailError = null;
    _passwordError = null;
  }

  void _navigateAfterSuccess(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const OnboardingScreen()),
    );
  }
}