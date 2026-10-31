// home.dart
//
// © 2026 Vertex Corporation
// ─────────────────────────────────────────────────────────────────────────────
// Ally's home dashboard.
//
// Information hierarchy:
//   1. Greeting and user context   2. Profile / notification actions
//   3. Daily health overview       4. Important health metrics
//   5. Vitals (sleep, heart rate)  6. Ally AI entry point
//
// Every value comes from [HealthProvider] / [UserProvider] — no synthetic
// data. Unavailable metrics show professional empty states. The dashboard is
// fully theme-aware and uses the shared design system components.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../design_system/design_system.dart';
import '../l10n/app_localizations.dart';
import '../providers/health.dart';
import '../screens/achievements.dart';
import '../screens/activity.dart';
import '../screens/account.dart';
import '../screens/exercises.dart';
import '../screens/heartbeat.dart';
import '../screens/ally_ai_insights.dart';
import '../screens/nutrition.dart';
import '../screens/pedometer.dart';
import '../screens/premium.dart';
import '../screens/score.dart';
import '../screens/settings.dart';
import '../screens/sleep.dart';
import '../screens/water.dart';
import '../screens/weight.dart';
import '../services/pedometer.dart';
import '../server/user.dart';
import '../utils/converter.dart';
import '../widgets/notification.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  int _selectedIndex = 0;
  int _previousIndex = 0;
  bool _isMenuExpanded = false;

  late AnimationController _fadeController;
  late AnimationController _menuController;
  late Animation<double> _menuAnimation;

  @override
  void initState() {
    super.initState();

    _checkPermissionAndStartService();

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _menuController = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );

    _menuAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _menuController, curve: Curves.easeInOut),
    );

    _fadeController.forward();
  }

  Future<void> _checkPermissionAndStartService() async {
    try {
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
    } catch (e) {
      // Platform without the step-tracking channel (web/desktop/tests) or a
      // denied lifecycle — the dashboard still renders, tracking stays off.
      debugPrint('[Home] Step tracking setup skipped: $e');
    }
  }

  void _showPermissionDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isDismissible: false,
      builder: (BuildContext sheetContext) {
        final l10n = AppLocalizations.of(sheetContext)!;
        final ThemeData theme = Theme.of(sheetContext);
        final AllySemanticPalette semantics = sheetContext.allySemantics;

        return Container(
          margin: const EdgeInsets.all(AllySpacing.lg),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: AllyRadius.lgAll,
            border: Border.all(color: theme.colorScheme.outlineVariant),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: AllySpacing.xl),
              Container(
                padding: const EdgeInsets.all(AllySpacing.lg),
                decoration: BoxDecoration(
                  color: semantics.steps.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.directions_walk_rounded,
                  color: semantics.steps,
                  size: AllyDimensions.iconXl,
                ),
              ),
              const SizedBox(height: AllySpacing.lg),
              Text(
                l10n.enableStepTracking,
                style: AllyTypography.headline(
                  size: 20,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: AllySpacing.sm),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AllySpacing.huge,
                ),
                child: Text(
                  l10n.stepPermissionMessage,
                  textAlign: TextAlign.center,
                  style: AllyTypography.body(
                    size: 14,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              const SizedBox(height: AllySpacing.xl),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AllySpacing.xl),
                child: Row(
                  children: [
                    Expanded(
                      child: AllyButton(
                        label: l10n.later,
                        kind: AllyButtonKind.ghost,
                        small: true,
                        onPressed: () => Navigator.pop(sheetContext),
                      ),
                    ),
                    const SizedBox(width: AllySpacing.md),
                    Expanded(
                      child: AllyButton(
                        label: l10n.allow,
                        small: true,
                        onPressed: () async {
                          Navigator.pop(sheetContext);

                          final status = await Permission.activityRecognition
                              .request();

                          if (!mounted) return;

                          if (status.isGranted) {
                            final pedometerService = PedometerService();
                            await pedometerService.startNativeService();
                            if (!mounted) return;

                            CustomNotification.show(
                              context,
                              message: l10n.stepTrackingEnabled,
                              icon: Icons.directions_walk_rounded,
                            );
                          } else {
                            CustomNotification.show(
                              context,
                              message: l10n.permissionDenied,
                              isError: true,
                              icon: Icons.warning_rounded,
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AllySpacing.xl),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _menuController.dispose();
    super.dispose();
  }

  void _toggleMenu() {
    HapticFeedback.selectionClick();
    setState(() {
      _isMenuExpanded = !_isMenuExpanded;
      if (_isMenuExpanded) {
        _menuController.forward();
      } else {
        _menuController.reverse();
      }
    });
  }

  void _onNavDestinationSelected(int index) {
    HapticFeedback.selectionClick();
    setState(() {
      _previousIndex = _selectedIndex;
      _selectedIndex = index;
    });
  }

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
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 0,
      ),
      body: Stack(
        children: [
          SafeArea(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
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
                final offsetAnimation =
                    Tween<Offset>(
                      begin: Offset(isGoingForward ? -1.0 : 1.0, 0.0),
                      end: Offset.zero,
                    ).animate(
                      CurvedAnimation(
                        parent: animation,
                        curve: Curves.fastOutSlowIn,
                      ),
                    );

                return SlideTransition(position: offsetAnimation, child: child);
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
            child: _buildBottomNav(l10n),
          ),
        ],
      ),
    );
  }

  // ── Bottom navigation ─────────────────────────────────────────────────────

  Widget _buildBottomNav(AppLocalizations l10n) {
    final ThemeData theme = Theme.of(context);

    return AnimatedBuilder(
      animation: _menuAnimation,
      builder: (context, child) {
        return Container(
          margin: const EdgeInsets.fromLTRB(
            AllySpacing.lg,
            0,
            AllySpacing.lg,
            AllySpacing.md,
          ),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: AllyRadius.lgAll,
            border: Border.all(color: theme.colorScheme.outlineVariant),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRect(
                child: AnimatedSize(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  child: _isMenuExpanded
                      ? Container(
                          padding: const EdgeInsets.fromLTRB(
                            AllySpacing.lg,
                            AllySpacing.lg,
                            AllySpacing.lg,
                            AllySpacing.sm,
                          ),
                          child: Column(
                            children: [
                              _buildExpandedMenuItem(
                                Icons.person_rounded,
                                l10n.account,
                                0,
                              ),
                              const SizedBox(height: AllySpacing.xs),
                              _buildExpandedMenuItem(
                                Icons.settings_rounded,
                                l10n.settings,
                                1,
                              ),
                            ],
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: AllySpacing.sm,
                  horizontal: AllySpacing.xs,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildNavItem(Icons.home_rounded, l10n.home, 0),
                    _buildNavItem(Icons.bar_chart_rounded, l10n.activity, 1),
                    _buildNavItem(
                      Icons.emoji_events_rounded,
                      l10n.achievements,
                      2,
                    ),
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
    final l10n = AppLocalizations.of(context)!;

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
                _toggleMenu();

                if (label == l10n.account) {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          const AccountScreen(),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                            return FadeTransition(
                              opacity: animation,
                              child: child,
                            );
                          },
                      transitionDuration: const Duration(milliseconds: 250),
                    ),
                  );
                } else if (label == l10n.settings) {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          const SettingsScreen(),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                            return FadeTransition(
                              opacity: animation,
                              child: child,
                            );
                          },
                      transitionDuration: const Duration(milliseconds: 250),
                    ),
                  );
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AllySpacing.lg,
                  vertical: AllySpacing.md,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: AllyRadius.mdAll,
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outlineVariant,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      icon,
                      color: Theme.of(context).colorScheme.onSurface,
                      size: AllyDimensions.iconSm + 2,
                    ),
                    const SizedBox(width: AllySpacing.md),
                    Text(
                      label,
                      style: AllyTypography.label(
                        size: 15,
                        color: Theme.of(context).colorScheme.onSurface,
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

  Widget _buildNavItem(
    IconData icon,
    String label,
    int index, {
    bool isMenu = false,
  }) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;
    final bool isSelected = isMenu ? _isMenuExpanded : _selectedIndex == index;

    return GestureDetector(
      onTap: isMenu ? _toggleMenu : () => _onNavDestinationSelected(index),
      behavior: HitTestBehavior.opaque,
      child: Semantics(
        button: true,
        selected: isSelected,
        label: isMenu ? 'Menu' : label,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(
            horizontal: AllySpacing.lg,
            vertical: AllySpacing.md,
          ),
          decoration: BoxDecoration(
            color: isSelected
                ? scheme.onSurface.withValues(alpha: 0.07)
                : Colors.transparent,
            borderRadius: AllyRadius.pill,
          ),
          child: Icon(
            icon,
            size: AllyDimensions.iconMd,
            color: isSelected ? scheme.onSurface : scheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }

  // ── Home dashboard ────────────────────────────────────────────────────────

  Widget _buildHomeScreen() {
    final l10n = AppLocalizations.of(context)!;

    return FadeTransition(
      opacity: _fadeController,
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(child: _buildHeader(l10n)),
          SliverToBoxAdapter(child: _buildHealthScoreHero(l10n)),
          SliverToBoxAdapter(child: _buildMetricsSection(l10n)),
          SliverToBoxAdapter(child: _buildVitalsSection(l10n)),
          SliverToBoxAdapter(child: _buildAiEntry(l10n)),
          const SliverToBoxAdapter(child: SizedBox(height: 140)),
        ],
      ),
    );
  }

  /// 1. Greeting + user context + quick actions.
  Widget _buildHeader(AppLocalizations l10n) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;
    final userProvider = context.watch<UserProvider>();

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AllySpacing.xl,
        AllySpacing.md,
        AllySpacing.xl,
        AllySpacing.xl,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.dailyReflection,
                  style: AllyTypography.caption(color: scheme.onSurfaceVariant),
                ),
                const SizedBox(height: AllySpacing.xs),
                Text(
                  l10n.hello(userProvider.username),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AllyTypography.headline(
                    size: 24,
                    color: scheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
          AllyIconButton(
            icon: Icons.workspace_premium_rounded,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PremiumScreen()),
              );
            },
            tooltip: l10n.goPremium,
          ),
          const SizedBox(width: AllySpacing.md),
          AllyIconButton(
            icon: Icons.notifications_rounded,
            onTap: () {},
            tooltip: l10n.notifications,
          ),
        ],
      ),
    );
  }

  /// 3. Daily health overview — the inverse monochrome hero panel.
  Widget _buildHealthScoreHero(AppLocalizations l10n) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AllySpacing.xl),
      child: Consumer<HealthProvider>(
        builder: (context, provider, _) {
          final healthScore = provider.healthData.healthScore;

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const HealthScoreScreen(),
                ),
              );
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AllySpacing.xxl),
              decoration: BoxDecoration(
                // Subtle obsidian depth: the ink panel darkens a touch toward
                // the baseline instead of sitting perfectly flat.
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    scheme.onSurface,
                    Color.lerp(scheme.onSurface, scheme.surface, 0.12)!,
                  ],
                ),
                borderRadius: AllyRadius.lgAll,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        l10n.healthScore,
                        style: AllyTypography.label(
                          size: 14,
                          color: scheme.surface,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AllySpacing.md,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: scheme.surface.withValues(alpha: 0.14),
                          borderRadius: AllyRadius.pill,
                        ),
                        child: Text(
                          l10n.today,
                          style: AllyTypography.label(
                            size: 12,
                            color: scheme.surface,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AllySpacing.xl),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${healthScore.toInt()}',
                        style: AllyTypography.metric(
                          size: 56,
                          color: scheme.surface,
                          weight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(width: AllySpacing.sm),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Text(
                          l10n.of100,
                          style: AllyTypography.body(
                            size: 16,
                            color: scheme.surface.withValues(alpha: 0.65),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AllySpacing.lg),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Stack(
                      children: [
                        Container(
                          height: 8,
                          color: scheme.surface.withValues(alpha: 0.22),
                        ),
                        FractionallySizedBox(
                          widthFactor: (healthScore / 100).clamp(0.0, 1.0),
                          child: Container(height: 8, color: scheme.surface),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  /// 4. Important health metrics.
  Widget _buildMetricsSection(AppLocalizations l10n) {
    final AllySemanticPalette semantics = context.allySemantics;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AllySpacing.xl,
        AllySpacing.section,
        AllySpacing.xl,
        0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AllySectionHeader(title: l10n.todaysMetrics),
          const SizedBox(height: AllySpacing.lg),
          Consumer<HealthProvider>(
            builder: (context, provider, _) {
              final healthData = provider.healthData;

              return GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: AllySpacing.md,
                crossAxisSpacing: AllySpacing.md,
                childAspectRatio: 1.15,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                children: [
                  _MetricGridCard(
                    title: l10n.exercises,
                    value: l10n.daysCount(healthData.exerciseStreak),
                    icon: Icons.fitness_center_rounded,
                    accent: semantics.activity,
                    onTap: () => _openScreen(const ExercisesScreen()),
                  ),
                  _MetricGridCard(
                    title: l10n.nutrition,
                    value: l10n.calories(healthData.caloriesConsumed),
                    icon: Icons.restaurant_rounded,
                    accent: semantics.nutrition,
                    onTap: () => _openScreen(const NutritionScreen()),
                  ),
                  _MetricGridCard(
                    title: l10n.sleep,
                    value: l10n.hours(healthData.sleepHours.toStringAsFixed(1)),
                    icon: Icons.bedtime_rounded,
                    accent: semantics.sleep,
                    onTap: () => _openScreen(const SleepScreen()),
                  ),
                  _MetricGridCard(
                    title: l10n.water,
                    value: UnitConverter.formatWater(
                      healthData.waterGlasses,
                      provider.units,
                    ),
                    icon: Icons.water_drop_rounded,
                    accent: semantics.water,
                    onTap: () => _openScreen(const WaterScreen()),
                  ),
                  _MetricGridCard(
                    title: l10n.weight,
                    value: UnitConverter.formatWeight(
                      healthData.currentWeight,
                      provider.units,
                    ),
                    icon: Icons.monitor_weight_rounded,
                    accent: semantics.weight,
                    onTap: () => _openScreen(const WeightScreen()),
                  ),
                  _MetricGridCard(
                    title: l10n.pedometer,
                    value:
                        '${healthData.currentSteps} / ${healthData.stepsGoal}',
                    icon: Icons.directions_walk_rounded,
                    accent: semantics.steps,
                    onTap: () => _openScreen(const PedometerScreen()),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  /// 5. Vitals — sleep overview and heart rate with honest empty states.
  Widget _buildVitalsSection(AppLocalizations l10n) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;
    final AllySemanticPalette semantics = context.allySemantics;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AllySpacing.xl,
        AllySpacing.section,
        AllySpacing.xl,
        0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AllySectionHeader(title: l10n.vitals),
          const SizedBox(height: AllySpacing.lg),
          // IntrinsicHeight keeps both vital cards equal in height without
          // requiring a bounded parent (CustomScrollView gives none).
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Consumer<HealthProvider>(
                    builder: (context, provider, _) {
                      final healthData = provider.healthData;
                      final progress =
                          (healthData.sleepHours / healthData.sleepGoal).clamp(
                            0.0,
                            1.0,
                          );
                      final hasData = healthData.sleepHours > 0;

                      return _VitalsCard(
                        title: l10n.sleep,
                        icon: Icons.bedtime_rounded,
                        accent: semantics.sleep,
                        value: hasData
                            ? l10n.hours(
                                healthData.sleepHours.toStringAsFixed(1),
                              )
                            : '—',
                        hint: hasData
                            ? l10n.sleepGoalHint(
                                healthData.sleepGoal.toStringAsFixed(0),
                              )
                            : l10n.noSleepData,
                        progress: hasData ? progress : null,
                        progressColor: semantics.sleep,
                        onTap: () => _openScreen(const SleepScreen()),
                      );
                    },
                  ),
                ),
                const SizedBox(width: AllySpacing.md),
                Expanded(
                  child: Consumer<HealthProvider>(
                    builder: (context, provider, _) {
                      final healthData = provider.healthData;
                      final hasData = healthData.currentBpm > 0;

                      return _VitalsCard(
                        title: l10n.heartRate,
                        icon: Icons.monitor_heart_rounded,
                        accent: semantics.heartRate,
                        value: hasData ? '${healthData.currentBpm}' : '—',
                        hint: hasData ? l10n.bpmUnit : l10n.requiresMonitor,
                        onTap: () => _openScreen(const HeartbeatScreen()),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AllySpacing.md),
          // 6b. Compact activity preview — opens the Activity tab.
          AllyCard(
            onTap: () => _onNavDestinationSelected(1),
            child: Row(
              children: [
                Container(
                  width: AllyDimensions.iconChip,
                  height: AllyDimensions.iconChip,
                  decoration: BoxDecoration(
                    color: scheme.onSurface.withValues(alpha: 0.06),
                    borderRadius: AllyRadius.smAll,
                  ),
                  child: Icon(
                    Icons.history_rounded,
                    size: AllyDimensions.iconSm,
                    color: scheme.onSurface,
                  ),
                ),
                const SizedBox(width: AllySpacing.lg),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.recentActivity,
                        style: AllyTypography.label(
                          size: 15,
                          color: scheme.onSurface,
                        ),
                      ),
                      Text(
                        l10n.activity,
                        style: AllyTypography.caption(
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  size: AllyDimensions.iconMd,
                  color: scheme.outline,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 7. Ally AI entry point.
  Widget _buildAiEntry(AppLocalizations l10n) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;
    final AllySemanticPalette semantics = context.allySemantics;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AllySpacing.xl,
        AllySpacing.section,
        AllySpacing.xl,
        0,
      ),
      child: AllyCard(
        onTap: () => _openScreen(const AllyAiInsightsScreen()),
        child: Row(
          children: [
            Container(
              width: AllyDimensions.iconChip,
              height: AllyDimensions.iconChip,
              decoration: BoxDecoration(
                color: semantics.ai.withValues(alpha: 0.12),
                borderRadius: AllyRadius.smAll,
              ),
              child: Icon(
                Icons.auto_awesome_rounded,
                size: AllyDimensions.iconSm,
                color: semantics.ai,
              ),
            ),
            const SizedBox(width: AllySpacing.lg),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.allyAi,
                    style: AllyTypography.label(
                      size: 15,
                      color: scheme.onSurface,
                    ),
                  ),
                  Text(
                    l10n.allyAiTagline,
                    style: AllyTypography.caption(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              size: AllyDimensions.iconMd,
              color: scheme.outline,
            ),
          ],
        ),
      ),
    );
  }

  void _openScreen(Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
  }
}

/// One metric tile of the dashboard grid.
class _MetricGridCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color accent;
  final VoidCallback onTap;

  const _MetricGridCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.accent,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AllyMetricCard(
      title: title,
      value: value,
      icon: icon,
      accent: accent,
      onTap: onTap,
    );
  }
}

/// A wider card in the vitals row with an optional progress bar.
class _VitalsCard extends StatelessWidget {
  final String title;
  final String value;
  final String hint;
  final IconData icon;
  final Color accent;
  final VoidCallback onTap;
  final double? progress;
  final Color? progressColor;

  const _VitalsCard({
    required this.title,
    required this.value,
    required this.hint,
    required this.icon,
    required this.accent,
    required this.onTap,
    this.progress,
    this.progressColor,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;

    return AllyCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: AllyDimensions.iconChipSm,
                height: AllyDimensions.iconChipSm,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.14),
                  borderRadius: AllyRadius.smAll,
                ),
                child: Icon(icon, size: AllyDimensions.iconSm, color: accent),
              ),
              const Spacer(),
              Icon(
                Icons.chevron_right_rounded,
                size: AllyDimensions.iconSm,
                color: scheme.outline,
              ),
            ],
          ),
          const SizedBox(height: AllySpacing.lg),
          Text(
            value,
            style: AllyTypography.metric(size: 30, color: scheme.onSurface),
          ),
          const SizedBox(height: AllySpacing.xs),
          Text(
            title,
            style: AllyTypography.label(size: 13, color: scheme.onSurface),
          ),
          const SizedBox(height: AllySpacing.xs),
          Text(
            hint,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AllyTypography.caption(color: scheme.onSurfaceVariant),
          ),
          if (progress != null && progressColor != null) ...[
            const SizedBox(height: AllySpacing.md),
            ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 4,
                backgroundColor: scheme.outlineVariant,
                valueColor: AlwaysStoppedAnimation<Color>(progressColor!),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
