import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'onboard.dart';
import '../main.dart' show isFirebaseInitialized;
import '../widgets/notification.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> with TickerProviderStateMixin {
  bool _isLoading = false;
  String _currentStep = 'username'; // username, email, password
  String _previousStep = 'username';
  bool _isAnimating = false;
  late AnimationController _slideOutController;
  late Animation<Offset> _slideOutAnimation;
  late AnimationController _slideInController;
  late Animation<Offset> _slideInAnimation;

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    
    _slideOutController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _slideOutAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0, -1),
    ).animate(CurvedAnimation(
      parent: _slideOutController,
      curve: Curves.easeInOutCubic,
    ));
    
    _slideInController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _slideInAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideInController,
      curve: Curves.easeInOutCubic,
    ));
  }

  @override
  void dispose() {
    _slideOutController.dispose();
    _slideInController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onUsernameNext() {
    if (_usernameController.text.isNotEmpty) {
      setState(() {
        _isAnimating = true;
        _previousStep = _currentStep;
        _currentStep = 'email';
      });
      _slideOutController.forward();
      _slideInController.forward().then((_) {
        setState(() {
          _isAnimating = false;
        });
        _slideOutController.reset();
        _slideInController.reset();
      });
    }
  }

  void _onEmailNext() {
    if (_emailController.text.isNotEmpty) {
      setState(() {
        _isAnimating = true;
        _previousStep = _currentStep;
        _currentStep = 'password';
      });
      _slideOutController.forward();
      _slideInController.forward().then((_) {
        setState(() {
          _isAnimating = false;
        });
        _slideOutController.reset();
        _slideInController.reset();
      });
    }
  }

  void _onBack() {
    String newStep;
    if (_currentStep == 'password') {
      newStep = 'email';
    } else if (_currentStep == 'email') {
      newStep = 'username';
    } else {
      Navigator.pop(context);
      return;
    }
    
    setState(() {
      _isAnimating = true;
      _previousStep = _currentStep;
      _currentStep = newStep;
    });
    
    // Reverse animation - slide down
    _slideOutAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0, 1),
    ).animate(CurvedAnimation(
      parent: _slideOutController,
      curve: Curves.easeInOutCubic,
    ));
    
    _slideInAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideInController,
      curve: Curves.easeInOutCubic,
    ));
    
    _slideOutController.forward();
    _slideInController.forward().then((_) {
      setState(() {
        _isAnimating = false;
      });
      _slideOutController.reset();
      _slideInController.reset();
      
      // Reset animations back to normal direction
      _slideOutAnimation = Tween<Offset>(
        begin: Offset.zero,
        end: const Offset(0, -1),
      ).animate(CurvedAnimation(
        parent: _slideOutController,
        curve: Curves.easeInOutCubic,
      ));
      
      _slideInAnimation = Tween<Offset>(
        begin: const Offset(0, 1),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: _slideInController,
        curve: Curves.easeInOutCubic,
      ));
    });
  }

  Future<void> _signUp() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // If Firebase not initialized, skip auth
      if (!isFirebaseInitialized) {
        if (mounted) {
          CustomNotification.show(
            context,
            message: AppLocalizations.of(context)!.firebaseNotConfiguredSignup,
            backgroundColor: Colors.orange,
            icon: Icons.warning,
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const OnboardingScreen()),
          );
        }
        return;
      }

      //firebase account creation
      final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      await userCredential.user?.updateDisplayName(_usernameController.text.trim());
      
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const OnboardingScreen()),
        );
      }
    } catch (e) {
      if (mounted) {
        CustomNotification.show(
          context,
          message: AppLocalizations.of(context)!.signUpFailed(e.toString()),
          backgroundColor: Colors.red,
          icon: Icons.error,
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _currentStep == 'username',
      onPopInvokedWithResult: (bool didPop, dynamic) {
        if (didPop) return;
        
        if (_currentStep != 'username') {
          _onBack();
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              // Current/Previous screen sliding out
              if (_isAnimating)
                SlideTransition(
                  position: _slideOutAnimation,
                  child: _buildScreen(_previousStep),
                ),
              
              // New screen sliding in
              if (_isAnimating)
                SlideTransition(
                  position: _slideInAnimation,
                  child: _buildScreen(_currentStep),
                ),
              
              // Static screen when not animating
              if (!_isAnimating)
                _buildScreen(_currentStep),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScreen(String step) {
    switch (step) {
      case 'email':
        return _buildEmailInput();
      case 'password':
        return _buildPasswordInput();
      default:
        return _buildUsernameInput();
    }
  }

  Widget _buildUsernameInput() {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/background_welcome.png'),
          fit: BoxFit.cover,
          alignment: Alignment(0, -0.6),
        ),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            
            GestureDetector(
              onTap: _onBack,
              child: const Icon(
                Icons.chevron_left,
                color: Colors.black87,
                size: 32,
              ),
            ),
            
            const SizedBox(height: 12),
            
            Text(
              'Sign up',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.bodyLarge?.color,
                letterSpacing: 1,
              ),
            ),
            
            const SizedBox(height: 8),
            
            Text(
              'Choose your username',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            
            const SizedBox(height: 60),
            
            TextField(
              controller: _usernameController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.usernameHint,
                prefixIcon: const Icon(Icons.person_outline),
                filled: true,
                fillColor: Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey[800]
                    : Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.grey[600]!
                        : Colors.black87,
                    width: 1.5,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: Colors.grey[400]!, width: 1.5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black87,
                    width: 1.5,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 18,
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            GestureDetector(
              onTap: _onUsernameNext,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 18),
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? const Color(0xFFE57373)
                      : Colors.black87,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  'Next',
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
            
            const SizedBox(height: 20),
          ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmailInput() {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/background_welcome.png'),
          fit: BoxFit.cover,
          alignment: Alignment(0, -0.6),
        ),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            
            GestureDetector(
              onTap: _onBack,
              child: const Icon(
                Icons.chevron_left,
                color: Colors.black87,
                size: 32,
              ),
            ),
            
            const SizedBox(height: 12),
            
            Text(
              'Sign up',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.bodyLarge?.color,
                letterSpacing: 1,
              ),
            ),
            
            const SizedBox(height: 8),
            
            Text(
              'Enter your email address',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            
            const SizedBox(height: 60),
            
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.emailHint,
                prefixIcon: const Icon(Icons.email_outlined),
                filled: true,
                fillColor: Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey[800]
                    : Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.grey[600]!
                        : Colors.black87,
                    width: 1.5,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: Colors.grey[400]!, width: 1.5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(color: Colors.black87, width: 1.5),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 18,
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            GestureDetector(
              onTap: _onEmailNext,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 18),
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? const Color(0xFFE57373)
                      : Colors.black87,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  'Next',
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
            
            const SizedBox(height: 20),
          ],
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordInput() {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/background_password.png'),
          fit: BoxFit.cover,
          alignment: Alignment(0, -0.6),
        ),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            
            GestureDetector(
              onTap: _onBack,
              child: const Icon(
                Icons.chevron_left,
                color: Colors.black87,
                size: 32,
              ),
            ),
            
            const SizedBox(height: 12),
            
            Text(
              'Sign up',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.bodyLarge?.color,
                letterSpacing: 1,
              ),
            ),
            
            const SizedBox(height: 8),
            
            Text(
              'Create a password',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            
            const SizedBox(height: 60),
            
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.passwordHint,
                prefixIcon: const Icon(Icons.lock_outline),
                filled: true,
                fillColor: Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey[800]
                    : Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.grey[600]!
                        : Colors.black87,
                    width: 1.5,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: Colors.grey[400]!, width: 1.5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(color: Colors.black87, width: 1.5),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 18,
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            GestureDetector(
              onTap: _isLoading ? null : _signUp,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 18),
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? const Color(0xFFE57373)
                      : Colors.black87,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        child: Center(
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          ),
                        ),
                      )
                    : Text(
                        'Sign Up',
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
            
            const SizedBox(height: 20),
          ],
          ),
        ),
      ),
    );
  }
}