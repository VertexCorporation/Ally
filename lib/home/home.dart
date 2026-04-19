import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../l10n/app_localizations.dart';
import '../providers/health.dart';
import '../services/pedometer.dart';
import '../utils/converter.dart';
import '../screens/water.dart';
import '../screens/nutrition.dart';
import '../screens/exercises.dart';
import '../screens/sleep.dart';
import '../screens/weight.dart';
import '../screens/heartbeat.dart';
import '../screens/pedometer.dart';
import '../screens/score.dart';
import '../screens/activity.dart';
import '../screens/achievements.dart';
import '../screens/settings.dart';
import '../screens/account.dart';
import '../screens/premium.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  int _selectedIndex = 0;
  bool _isMenuExpanded = false;
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _menuController;
  AnimationController? _waveController;
  late Animation<double> _menuAnimation;
  
  int healthScore = 78;
  
  @override
  void initState() {
    super.initState();

    _updateStatusBar();
    _checkPermissionAndStartService();

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _menuController = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    
    _waveController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
    
    _menuAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _menuController, curve: Curves.easeInOut),
    );
    
    _fadeController.forward();
    _slideController.forward();
  }

  void _updateStatusBar() {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    );
  }

  Future<void> _checkPermissionAndStartService() async {
    final status = await Permission.activityRecognition.status;

    if (!status.isGranted) {
      if (mounted) {
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            _showPermissionDialog();
          }
        });
      }
    } else {
      final pedometerService = PedometerService();
      await pedometerService.startNativeService();
    }
  }

  void _showPermissionDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isDismissible: false,
      builder: (BuildContext sheetContext) {
        return Container(
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(sheetContext).cardColor,
            borderRadius: const BorderRadius.all(Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF4BAADF).withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.directions_walk_rounded,
                    color: Color(0xFF4BAADF), size: 32),
              ),
              const SizedBox(height: 16),
              Text(
                AppLocalizations.of(sheetContext)!.enableStepTracking,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  AppLocalizations.of(sheetContext)!.stepPermissionMessage,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          Navigator.pop(sheetContext);
                        },
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          AppLocalizations.of(sheetContext)!.later,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          Navigator.pop(sheetContext);

                          final messenger = ScaffoldMessenger.of(context);
                          final localizations = AppLocalizations.of(context)!;

                          final status = await Permission.activityRecognition.request();

                          if (!mounted) return;

                          if (status.isGranted) {
                            final pedometerService = PedometerService();
                            await pedometerService.startNativeService();

                            messenger.showSnackBar(
                              SnackBar(
                                content: Text(localizations.stepTrackingEnabled),
                                backgroundColor: const Color(0xFF4BAADF),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          } else {
                            messenger.showSnackBar(
                              SnackBar(
                                content: Text(localizations.permissionDenied),
                                backgroundColor: Colors.orange[700],
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4BAADF),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          AppLocalizations.of(sheetContext)!.allow,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }
  
  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _menuController.dispose();
    _waveController?.dispose();
    super.dispose();
  }
  
  void _toggleMenu() {
    setState(() {
      _isMenuExpanded = !_isMenuExpanded;
      if (_isMenuExpanded) {
        _menuController.forward();
      } else {
        _menuController.reverse();
      }
    });
  }

  int _previousIndex = 0;

  Widget _getCurrentScreen() {
    switch (_selectedIndex) {
      case 0:
        return _buildHomeScreen();
      case 1:
        return const ActivityScreen();
      case 2:
        return const AchievementsScreen();
      default:
        return _buildHomeScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 0,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
      ),
      body: Stack(
        children: [
          SafeArea(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 450),
              switchInCurve: Curves.easeInOutCubic,
              switchOutCurve: Curves.easeInOutCubic,
              layoutBuilder: (currentChild, previousChildren) {
                return Stack(
                  children: <Widget>[
                    ...previousChildren,
                    if (currentChild != null) currentChild,
                  ],
                );
              },
              transitionBuilder: (Widget child, Animation<double> animation) {
                final isGoingForward = _previousIndex < _selectedIndex;
                final offsetAnimation = Tween<Offset>(
                  begin: Offset(isGoingForward ? -1.0 : 1.0, 0.0),
                  end: Offset.zero,
                ).animate(CurvedAnimation(
                  parent: animation,
                  curve: Curves.fastOutSlowIn,
                ));
                
                return SlideTransition(
                  position: offsetAnimation,
                  child: child,
                );
              },
              child: Container(
                key: ValueKey<int>(_selectedIndex),
                child: _getCurrentScreen(),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _buildTransparentNav(),
          ),
        ],
      ),
    );
  }

  Widget _buildHomeScreen() {
    
    return CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(3),
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(0xFF4BAADF),
                                  ),
                                  child: Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(color: Theme.of(context).cardColor,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.person, size: 24),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      AppLocalizations.of(context)!.dailyReflection,
                                      style: const TextStyle(fontSize: 12, color: Color(0xFF888888)),
                                    ),
                                    Text(
                                      AppLocalizations.of(context)!.helloAnonymous,
                                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).cardColor,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 2))],
                                  ),
                                  child: IconButton(
                                    icon: const Icon(Icons.workspace_premium_rounded),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => const PremiumScreen()),
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).cardColor,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 2))],
                                  ),
                                  child: IconButton(icon: const Icon(Icons.notifications_rounded), onPressed: () {}),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Consumer<HealthProvider>(
                          builder: (context, provider, _) {
                            final healthScore = provider.healthData.healthScore;
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const HealthScoreScreen()),
                                );
                              },
                              child: FadeTransition(
                                opacity: _fadeController,
                                child: Container(
                                  padding: const EdgeInsets.all(24),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF64B5F6),
                                    borderRadius: BorderRadius.circular(24),
                                    boxShadow: [BoxShadow(color: const Color(0xFF64B5F6).withValues(alpha:0.3), blurRadius: 20, offset: const Offset(0, 10))],
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(AppLocalizations.of(context)!.healthScore, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                            decoration: BoxDecoration(color: Colors.white.withValues(alpha:0.25), borderRadius: BorderRadius.circular(20)),
                                            child: Text(AppLocalizations.of(context)!.today, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 20),
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Text('${healthScore.toInt()}', style: const TextStyle(fontSize: 52, fontWeight: FontWeight.bold, color: Colors.white, height: 1)),
                                          const SizedBox(width: 8),
                                          Padding(
                                            padding: const EdgeInsets.only(bottom: 8),
                                            child: Text(AppLocalizations.of(context)!.of100, style: const TextStyle(fontSize: 16, color: Colors.white70, fontWeight: FontWeight.w500)),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 16),
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: Stack(
                                          children: [
                                            Container(
                                              height: 12,
                                              decoration: BoxDecoration(
                                                color: Colors.white.withValues(alpha:0.3),
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                            ),
                                            FractionallySizedBox(
                                              widthFactor: (healthScore / 100),
                                              child: Container(
                                                height: 12,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: BorderRadius.circular(12),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    
                    const SliverToBoxAdapter(child: SizedBox(height: 20)),
                    
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      sliver: Consumer<HealthProvider>(
                        builder: (context, provider, _) {
                          final healthData = provider.healthData;
                          return SliverGrid(
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 12,
                              crossAxisSpacing: 12,
                              childAspectRatio: 1.1,
                            ),
                            delegate: SliverChildListDelegate([
                              _buildMetricCard(AppLocalizations.of(context)!.exercises, AppLocalizations.of(context)!.daysCount(healthData.exerciseStreak), Icons.fitness_center_rounded, const Color(0xFFE57373), 0),
                              _buildMetricCard(AppLocalizations.of(context)!.nutrition, AppLocalizations.of(context)!.calories(healthData.caloriesConsumed), Icons.restaurant_rounded, const Color(0xFFFFB74D), 100),
                              _buildMetricCard(AppLocalizations.of(context)!.sleep, AppLocalizations.of(context)!.hours(healthData.sleepHours.toStringAsFixed(1)), Icons.bedtime_rounded, const Color(0xFFCE93D8), 200),
                              _buildMetricCard(
                                AppLocalizations.of(context)!.water,
                                UnitConverter.formatWater(healthData.waterGlasses, provider.units),
                                Icons.water_drop_rounded,
                                const Color(0xFF64B5F6),
                                300,
                              ),
                              _buildMetricCard(AppLocalizations.of(context)!.weight, UnitConverter.formatWeight(healthData.currentWeight, provider.units), Icons.monitor_weight_rounded, const Color(0xFF81C784), 400),
                              _buildMetricCard(AppLocalizations.of(context)!.pedometer, AppLocalizations.of(context)!.steps(healthData.currentSteps, healthData.stepsGoal), Icons.directions_walk_rounded, const Color(0xFF4BAADF), 500),
                            ]),
                          );
                        }
                      ),
                    ),
                    
                    const SliverToBoxAdapter(child: SizedBox(height: 100)),
                  ],
                );
  }

  Widget _buildMetricCard(String title, String value, IconData icon, Color color, int delay) {
    final l10n = AppLocalizations.of(context)!;

    // Special handling for Water card with wave animation
    if (title == l10n.water) {
      return _buildWaterCard(value, color, delay);
    }

    // Special handling for Nutrition card
    if (title == l10n.nutrition) {
      return _buildNutritionCard(value, color, delay);
    }

    // Special handling for Exercises card
    if (title == l10n.exercises) {
      return _buildExercisesCard(value, color, delay, icon);
    }

    // Special handling for Sleep card
    if (title == l10n.sleep) {
      return _buildSleepCard(value, color, delay, icon);
    }
    
    return FadeTransition(
      opacity: _fadeController,
      child: GestureDetector(
        onTap: () {
          final l10n = AppLocalizations.of(context)!;
          Widget? screen;
          
          if (title == l10n.exercises) {
            screen = const ExercisesScreen();
          } else if (title == l10n.sleep) {
            screen = const SleepScreen();
          } else if (title == l10n.weight) {
            screen = const WeightScreen();
          } else if (title == l10n.heartbeat) {
            screen = const HeartbeatScreen();
          } else if (title == l10n.pedometer) {
            screen = const PedometerScreen();
          }
          
          if (screen != null) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => screen!),
            );
          }
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [BoxShadow(color: color.withValues(alpha:0.3), blurRadius: 15, offset: const Offset(0, 8))],
          ),
          child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(icon, size: 32, color: Colors.white),
                        const Spacer(),
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          value,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white70,
                            height: 1.2,
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
      },
    );
  }

  Widget _buildWaterCard(String value, Color color, int delay) {
    return Consumer<HealthProvider>(
      builder: (context, healthProvider, child) {
        final progress = healthProvider.healthData.waterGlasses / healthProvider.healthData.waterGoal;
        
        return FadeTransition(
          opacity: _fadeController,
          child: GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const WaterScreen()));
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: color.withValues(alpha:0.3), blurRadius: 15, offset: const Offset(0, 8))],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  decoration: const BoxDecoration(),
                  child: Stack(
                    children: [
                      // Background
                      Container(color: color),
                      // Wave animation only when not empty and not full
                      if (progress > 0 && progress < 1)
                        Positioned.fill(
                          child: CustomPaint(
                            painter: WavePainter(
                              progress: progress,
                              color: Colors.white70,
                              animation: _waveController ?? _fadeController,
                            ),
                          ),
                        ),
                      // Bubble animation ONLY when completely full
                      if (progress >= 1.0)
                        Positioned.fill(
                          child: AnimatedBuilder(
                            animation: _waveController ?? _fadeController,
                            builder: (context, child) {
                              return CustomPaint(
                                painter: HomeBubblePainter(
                                  animationValue: (_waveController ?? _fadeController).value,
                                ),
                              );
                            },
                          ),
                        ),
                      // Content
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Icon(Icons.water_drop_rounded, size: 32, color: Colors.white),
                            const Spacer(),
                            Text(
                              AppLocalizations.of(context)!.water,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                height: 1.2,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              value,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.white70,
                                height: 1.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildNutritionCard(String value, Color color, int delay) {
    return Consumer<HealthProvider>(
      builder: (context, healthProvider, child) {
        return FadeTransition(
          opacity: _fadeController,
          child: GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const NutritionScreen()));
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: color.withValues(alpha:0.3), blurRadius: 15, offset: const Offset(0, 8))],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  decoration: const BoxDecoration(),
                  child: Stack(
                    children: [
                      // Background
                      Container(color: color),
                      // Content
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Icon(Icons.restaurant_rounded, size: 32, color: Colors.white),
                            const Spacer(),
                            Text(
                              AppLocalizations.of(context)!.nutrition,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                height: 1.2,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              value,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.white70,
                                height: 1.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTransparentNav() {
    return AnimatedBuilder(
      animation: _menuAnimation,
      builder: (context, child) {
        return Container(
          margin: const EdgeInsets.fromLTRB(20, 0, 20, 30),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(32),
            border: Border.all(
              color: Theme.of(context).brightness == Brightness.dark ? Colors.grey[800]! : Colors.grey[300]!,
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha:0.2),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRect(
                child: AnimatedSize(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeInOut,
                  child: _isMenuExpanded
                      ? Container(
                          padding: const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 12),
                          child: Column(
                            children: [
                              _buildExpandedMenuItem(Icons.person_rounded, AppLocalizations.of(context)!.account, 0),
                              const SizedBox(height: 10),
                              _buildExpandedMenuItem(Icons.settings_rounded, AppLocalizations.of(context)!.settings, 1),
                            ],
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildNavItem(Icons.home_rounded, AppLocalizations.of(context)!.home, 0),
                    _buildNavItem(Icons.bar_chart_rounded, AppLocalizations.of(context)!.activity, 1),
                    _buildNavItem(Icons.emoji_events_rounded, AppLocalizations.of(context)!.achievements, 2),
                    _buildNavItem(Icons.menu_rounded, '', 3, isMenu: true),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildExpandedMenuItem(IconData icon, String label, int index) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 200 + (index * 40)),
      tween: Tween(begin: 0.0, end: _isMenuExpanded ? 1.0 : 0.0),
      curve: Curves.easeOut,
      builder: (context, animValue, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - animValue)),
          child: Opacity(
            opacity: animValue,
            child: GestureDetector(
              onTap: () {
                final l10n = AppLocalizations.of(context)!;
                _toggleMenu();

                if (label == l10n.account) {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) => const AccountScreen(),
                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                        return FadeTransition(opacity: animation, child: child);
                      },
                      transitionDuration: const Duration(milliseconds: 250),
                    ),
                  );
                } else if (label == l10n.settings) {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) => const SettingsScreen(),
                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                        return FadeTransition(opacity: animation, child: child);
                      },
                      transitionDuration: const Duration(milliseconds: 250),
                    ),
                  );
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(icon, color: Theme.of(context).textTheme.bodyLarge?.color, size: 22),
                    const SizedBox(width: 12),
                    Text(
                      label,
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),

              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index, {bool isMenu = false}) {
    final isSelected = _selectedIndex == index;
    
    if (isMenu) {
      return GestureDetector(
        onTap: _toggleMenu,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: _isMenuExpanded ? Colors.grey.withValues(alpha:0.15) : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: AnimatedRotation(
            turns: _isMenuExpanded ? 0.125 : 0.0,
            duration: const Duration(milliseconds: 300),
            child: Icon(
              _isMenuExpanded ? Icons.close_rounded : Icons.menu_rounded,
              color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
              size: 24,
            ),
          ),
        ),
      );
    }
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _previousIndex = _selectedIndex;
          _selectedIndex = index;
          if (_isMenuExpanded) {
            _toggleMenu();
          }
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
        padding: EdgeInsets.symmetric(horizontal: isSelected ? 16 : 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.grey.withValues(alpha:0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: isSelected ? (Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black) : Colors.grey[600], size: 24),
            if (isSelected && label.isNotEmpty) ...[
              const SizedBox(width: 8),
              Text(label, style: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black, fontSize: 14, fontWeight: FontWeight.w600)),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildExercisesCard(String value, Color color, int delay, IconData icon) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 600 + delay),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeOut,
      builder: (context, animValue, child) {
        return Transform.scale(
          scale: 0.8 + (0.2 * animValue),
          child: Opacity(
            opacity: animValue,
            child: GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const ExercisesScreen()));
              },
              child: Hero(
                tag: 'exercises_card',
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [BoxShadow(color: color.withValues(alpha:0.3), blurRadius: 15, offset: const Offset(0, 8))],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(icon, size: 32, color: Colors.white),
                        const Spacer(),
                        Text(
                          AppLocalizations.of(context)!.exercises,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          value,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white70,
                            height: 1.2,
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
      },
    );
  }

  Widget _buildSleepCard(String value, Color color, int delay, IconData icon) {
    return Consumer<HealthProvider>(
      builder: (context, healthProvider, child) {
        return TweenAnimationBuilder<double>(
          duration: Duration(milliseconds: 600 + delay),
          tween: Tween(begin: 0.0, end: 1.0),
          curve: Curves.easeOut,
          builder: (context, animValue, child) {
            return Transform.scale(
              scale: 0.8 + (0.2 * animValue),
              child: Opacity(
                opacity: animValue,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const SleepScreen()));
                  },
                  child: Hero(
                    tag: 'sleep_card',
                    child: Material(
                      color: Colors.transparent,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [BoxShadow(color: color.withValues(alpha:0.3), blurRadius: 15, offset: const Offset(0, 8))],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(icon, size: 32, color: Colors.white),
                            const Spacer(),
                            Text(
                              AppLocalizations.of(context)!.sleep,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                height: 1.2,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              value,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.white70,
                                height: 1.2,
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
        },
      );
      },
    );
  }
}

class HealthScorePainter extends CustomPainter {
  final int score;
  final int maxScore;
  HealthScorePainter({required this.score, required this.maxScore});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 10;
    final bgPaint = Paint()
      ..color = Colors.white.withValues(alpha:0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius, bgPaint);
    final progressPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;
    final sweepAngle = (score / maxScore) * 2 * math.pi;
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), -math.pi / 2, sweepAngle, false, progressPaint);
  }

  @override
  bool shouldRepaint(HealthScorePainter oldDelegate) => oldDelegate.score != score || oldDelegate.maxScore != maxScore;
}

class CircleProgressPainter extends CustomPainter {
  final double progress;
  final Color color;
  CircleProgressPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 4;
    final bgPaint = Paint()
      ..color = Colors.grey[200]!
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;
    canvas.drawCircle(center, radius, bgPaint);
    final progressPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;
    final sweepAngle = progress * 2 * math.pi;
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), -math.pi / 2, sweepAngle, false, progressPaint);
  }

  @override
  bool shouldRepaint(CircleProgressPainter oldDelegate) => oldDelegate.progress != progress || oldDelegate.color != color;
}

class WavePainter extends CustomPainter {
  final double progress;
  final Color color;
  final Animation<double> animation;

  WavePainter({required this.progress, required this.color, required this.animation}) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    final waveHeight = 8.0;
    final waveLength = size.width / 2;
    
    // Start from bottom left
    path.moveTo(0, size.height);
    path.lineTo(0, size.height * (1 - progress));

    // Draw wave
    for (double x = 0; x <= size.width; x++) {
      final y = size.height * (1 - progress) + 
                math.sin((x / waveLength + animation.value * 2) * 2 * math.pi) * waveHeight;
      path.lineTo(x, y);
    }

    // Complete the path
    path.lineTo(size.width, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(WavePainter oldDelegate) => true;
}

class HomeBubblePainter extends CustomPainter {
  final double animationValue;

  HomeBubblePainter({required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha:0.5)
      ..style = PaintingStyle.fill;


    for (int i = 0; i < 3; i++) {
      final bubbleStart = i * 0.2;
      final bubbleDuration = 0.8; 
      
      final bubblePhase = ((animationValue - bubbleStart) % 1.0) / bubbleDuration;
      
      if (bubblePhase >= 0 && bubblePhase <= 1.0) {
        final seed = i * 137;
        final random = math.Random(seed);
        
        final x = 0.2 + random.nextDouble() * 0.6;
        final startY = 0.85 + random.nextDouble() * 0.15;
        final baseSize = 4.0 + random.nextDouble() * 4.0;
        final speed = 0.6 + random.nextDouble() * 0.3;
        
        final spawnPhase = (bubblePhase / 0.1).clamp(0.0, 1.0);
        
        final popPhase = ((bubblePhase - 0.9) / 0.1).clamp(0.0, 1.0);
        
        double sizeMultiplier = 1.0;
        if (bubblePhase < 0.1) {
          sizeMultiplier = spawnPhase;
        } else if (bubblePhase > 0.9) {
          sizeMultiplier = 1.0 - popPhase;
        }
        
        final bubbleSize = baseSize * sizeMultiplier;
        
        if (bubbleSize > 0.5) { 
          final riseProgress = bubblePhase.clamp(0.1, 0.9) - 0.1;
          final currentY = startY * size.height - (riseProgress * speed * size.height);
          
          final xPos = x * size.width;
          final wobble = math.sin(bubblePhase * math.pi * 6) * 2;
          
          canvas.drawCircle(
            Offset(xPos + wobble, currentY),
            bubbleSize,
            paint,
          );
          
          final highlightPaint = Paint()
            ..color = Colors.white.withValues(alpha:0.7)
            ..style = PaintingStyle.fill;
          
          canvas.drawCircle(
            Offset(xPos + wobble - bubbleSize * 0.3, currentY - bubbleSize * 0.3),
            bubbleSize * 0.3,
            highlightPaint,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(HomeBubblePainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}

class PizzaPainter extends CustomPainter {
  final int slices;
  final int totalSlices;
  final Color color;

  PizzaPainter({required this.slices, required this.totalSlices, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 3;
    
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final anglePerSlice = (2 * math.pi) / totalSlices;
    
    // Draw eaten slices (darker overlay)
    for (int i = 0; i < slices; i++) {
      final startAngle = -math.pi / 2 + (i * anglePerSlice);
      final path = Path();
      path.moveTo(center.dx, center.dy);
      path.arcTo(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        anglePerSlice,
        false,
      );
      path.close();
      canvas.drawPath(path, paint);
    }
    
    // Draw slice separators
    final linePaint = Paint()
      ..color = Colors.white.withValues(alpha:0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    
    for (int i = 0; i < totalSlices; i++) {
      final angle = -math.pi / 2 + (i * anglePerSlice);
      final x = center.dx + radius * math.cos(angle);
      final y = center.dy + radius * math.sin(angle);
      canvas.drawLine(center, Offset(x, y), linePaint);
    }
    
    // Draw circle outline
    canvas.drawCircle(center, radius, linePaint);
  }

  @override
  bool shouldRepaint(PizzaPainter oldDelegate) => 
    oldDelegate.slices != slices || oldDelegate.totalSlices != totalSlices;
}