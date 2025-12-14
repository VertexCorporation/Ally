import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../l10n/app_localizations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'onboarding_screen.dart';
import 'signup_screen.dart';
import '../main.dart' show isFirebaseInitialized;

class LoginScreen extends StatefulWidget {
  final bool fromSignUp;
  
  const LoginScreen({super.key, this.fromSignUp = false});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with TickerProviderStateMixin {
  bool _isLoading = false;
  String _currentStep = 'method'; // method, email, password
  String _previousStep = 'method';
  bool _isAnimating = false;
  late AnimationController _slideOutController;
  late Animation<Offset> _slideOutAnimation;
  late AnimationController _slideInController;
  late Animation<Offset> _slideInAnimation;

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
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _selectMethod(String method) {
    if (method == 'anonymous') {
      _signInAnonymously();
    } else if (method == 'email') {
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
    } else if (method == 'google') {
      _signInWithGoogle();
    }
  }  void _onEmailNext() {
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
    String newStep = _currentStep == 'password' ? 'email' : 'method';
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

  Future<void> _signInAnonymously() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // If Firebase not initialized, skip auth and go directly to onboarding
      if (!isFirebaseInitialized) {
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const OnboardingScreen()),
          );
        }
        return;
      }

      await FirebaseAuth.instance.signInAnonymously();
      
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const OnboardingScreen()),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.authFailed),
            backgroundColor: Colors.orange,
          ),
        );
        // Still navigate to onboarding
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const OnboardingScreen()),
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

  Future<void> _signInWithGoogle() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // If Firebase not initialized, skip auth
      if (!isFirebaseInitialized) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!.firebaseNotConfigured),
              backgroundColor: Colors.orange,
            ),
          );
          setState(() {
            _isLoading = false;
          });
        }
        return;
      }

      // Try Google Sign In
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      
      if (googleUser == null) {
        // User cancelled
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
        return;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
      
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const OnboardingScreen()),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.googleSignInFailed),
            backgroundColor: Colors.orange,
          ),
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

  Future<void> _signInWithEmail() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // If Firebase not initialized, skip auth
      if (!isFirebaseInitialized) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!.firebaseNotConfigured),
              backgroundColor: Colors.orange,
            ),
          );
          setState(() {
            _isLoading = false;
          });
        }
        return;
      }

      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const OnboardingScreen()),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.emailSignInFailed(e.toString())),
            backgroundColor: Colors.red,
          ),
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
      canPop: _currentStep == 'method',
      onPopInvoked: (bool didPop) async {
        if (didPop) return;
        if (_currentStep != 'method') {
          _onBack();
        }
      },
      child: Theme(
        data: ThemeData.light(),
        child: Scaffold(
          body: SafeArea(
            child: Stack(
              children: [
                if (_isAnimating)
                  SlideTransition(
                    position: _slideOutAnimation,
                    child: _buildScreen(_previousStep),
                  ),
                if (_isAnimating)
                  SlideTransition(
                    position: _slideInAnimation,
                    child: _buildScreen(_currentStep),
                  ),
                if (!_isAnimating)
                  _buildScreen(_currentStep),
              ],
            ),
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
        return _buildMethodSelection();
    }
  }

  Widget _buildMethodSelection() {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/background_signin.png'),
          fit: BoxFit.cover,
          alignment: Alignment(0, -0.6),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            
            Text(
              'Sign in',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                letterSpacing: 1,
              ),
            ),
          
          const SizedBox(height: 8),
          
          Text(
            'Choose your sign in method',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          
          const Spacer(),
          
          // Google Button
          GestureDetector(
            onTap: () => _selectMethod('google'),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 18),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.grey[300]!, width: 1),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.g_mobiledata_rounded, color: Colors.grey[700], size: 24),
                  const SizedBox(width: 8),
                  Text(
                    AppLocalizations.of(context)!.continueWithGoogle,
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Email Button
          GestureDetector(
            onTap: () => _selectMethod('email'),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 18),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.grey[300]!, width: 1),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.email_outlined, color: Colors.grey[700], size: 20),
                  const SizedBox(width: 12),
                  Text(
                    AppLocalizations.of(context)!.continueWithEmail,
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Anonymous Button
          GestureDetector(
            onTap: _isLoading ? null : () => _selectMethod('anonymous'),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 18),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.grey[300]!, width: 1),
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
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.black87),
                          ),
                        ),
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.person_outline_rounded, color: Colors.grey[700], size: 20),
                        const SizedBox(width: 12),
                        Text(
                          AppLocalizations.of(context)!.continueAsAnonymous,
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Don\'t have an account? ',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) => const SignUpScreen(),
                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                        const begin = Offset(1.0, 0.0);
                        const end = Offset.zero;
                        const curve = Curves.easeInOutCubic;

                        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                        var offsetAnimation = animation.drive(tween);

                        return SlideTransition(
                          position: offsetAnimation,
                          child: child,
                        );
                      },
                      transitionDuration: const Duration(milliseconds: 600),
                    ),
                  );
                },
                child: Text(
                  'Sign Up',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          Text(
            'By signing in/up, you agree to our Privacy Policy and Terms of Service',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 12,
              height: 1.5,
            ),
          ),
          
          const SizedBox(height: 20),
        ],
      ),
      ),
    );
  }

  Widget _buildEmailInput() {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/background_signin.png'),
          fit: BoxFit.cover,
          alignment: Alignment(0, -0.6),
        ),
      ),
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
              'Sign in with email',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
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
            
            const Spacer(),
            
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.emailHint,
                prefixIcon: const Icon(Icons.email_outlined),
                filled: true,
                fillColor: Colors.white,
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
                color: Colors.black87,
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
              'Sign in with email',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                letterSpacing: 1,
              ),
            ),
            
            const SizedBox(height: 8),
            
            Text(
              'Enter your password',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            
            const Spacer(),
            
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.passwordHint,
                prefixIcon: const Icon(Icons.lock_outline),
                filled: true,
                fillColor: Colors.white,
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
            onTap: _isLoading ? null : _signInWithEmail,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.black87, width: 2),
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
                      'Sign In',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
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
    );
  }
}
