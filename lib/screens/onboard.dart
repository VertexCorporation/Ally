// onboard.dart
//
// © 2026 Vertex Corporation
// ─────────────────────────────────────────────────────────────────────────────
// Onboarding: units → weight → height → age. All data handling, unit
// conversion and completion persistence are preserved unchanged; the screen
// now inherits the active application theme.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../design_system/design_system.dart';
import '../l10n/app_localizations.dart';
import '../providers/health.dart';
import '../utils/converter.dart';
import '../home/home.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  int _currentPage = 0;
  int _previousPageIndex = 0;

  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _feetController = TextEditingController();
  final TextEditingController _inchesController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  bool _isAnimating = false;
  late AnimationController _slideOutController;
  late Animation<Offset> _slideOutAnimation;
  late AnimationController _slideInController;
  late Animation<Offset> _slideInAnimation;

  @override
  void initState() {
    super.initState();

    _slideOutController = AnimationController(
      duration: const Duration(milliseconds: 450),
      vsync: this,
    );

    _slideOutAnimation =
        Tween<Offset>(begin: Offset.zero, end: const Offset(0, -1)).animate(
          CurvedAnimation(
            parent: _slideOutController,
            curve: Curves.easeInOutCubic,
          ),
        );

    _slideInController = AnimationController(
      duration: const Duration(milliseconds: 450),
      vsync: this,
    );

    _slideInAnimation =
        Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _slideInController,
            curve: Curves.easeInOutCubic,
          ),
        );
  }

  @override
  void dispose() {
    _weightController.dispose();
    _heightController.dispose();
    _feetController.dispose();
    _inchesController.dispose();
    _ageController.dispose();
    _slideOutController.dispose();
    _slideInController.dispose();
    super.dispose();
  }

  void _nextPage() {
    FocusScope.of(context).unfocus();

    if (_currentPage < 3) {
      setState(() {
        _isAnimating = true;
        _previousPageIndex = _currentPage;
        _currentPage++;
      });
      _slideOutController.forward();
      _slideInController.forward().then((_) {
        setState(() {
          _isAnimating = false;
        });
        _slideOutController.reset();
        _slideInController.reset();
      });
    } else {
      _completeOnboarding();
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      setState(() {
        _isAnimating = true;
        _previousPageIndex = _currentPage;
        _currentPage--;
      });

      _slideInAnimation =
          Tween<Offset>(begin: const Offset(0, -1), end: Offset.zero).animate(
            CurvedAnimation(
              parent: _slideInController,
              curve: Curves.easeInOutCubic,
            ),
          );

      _slideOutController.forward();
      _slideInController.forward().then((_) {
        setState(() {
          _isAnimating = false;
        });
        _slideOutController.reset();

        _slideInAnimation =
            Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero).animate(
              CurvedAnimation(
                parent: _slideInController,
                curve: Curves.easeInOutCubic,
              ),
            );
      });
    }
  }

  void _completeOnboarding() async {
    final healthProvider = Provider.of<HealthProvider>(context, listen: false);
    final isImperial = healthProvider.units == 'imperial';

    double weight =
        double.tryParse(_weightController.text) ?? (isImperial ? 150.0 : 70.0);
    double height;

    if (isImperial) {
      double feet = double.tryParse(_feetController.text) ?? 5.0;
      double inches = double.tryParse(_inchesController.text) ?? 7.0;
      height = UnitConverter.feetAndInchesToCm(
        feet.round(),
        inches.round(),
      ).toDouble();

      // Convert weight to kg for storage
      weight = UnitConverter.lbsToKg(weight);
    } else {
      height = double.tryParse(_heightController.text) ?? 170.0;
    }

    final age = int.tryParse(_ageController.text) ?? 25;

    final calorieGoal = 2000;
    final waterGoal = 8;

    healthProvider.updateWeight(weight);
    healthProvider.updateTargetWeight(weight);
    healthProvider.updateCaloriesGoal(calorieGoal);
    healthProvider.updateWaterGoal(waterGoal);

    await healthProvider.saveUserProfile({
      'weight': weight,
      'height': height,
      'age': age,
      'onboardingCompleted': true,
    });

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 0,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            // Previous screen sliding out
            if (_isAnimating)
              SlideTransition(
                position: _slideOutAnimation,
                child: _buildPage(_previousPageIndex),
              ),

            // New screen sliding in
            if (_isAnimating)
              SlideTransition(
                position: _slideInAnimation,
                child: _buildPage(_currentPage),
              ),

            // Static screen when not animating
            if (!_isAnimating) _buildPage(_currentPage),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(int pageIndex) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      children: [
        const SizedBox(height: AllySpacing.md),

        // Step indicators: monochrome hairline segments.
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AllySpacing.xxl),
          child: Row(
            children: List.generate(4, (index) {
              return Expanded(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                  height: 3,
                  margin: EdgeInsets.only(
                    right: index == 3 ? 0 : AllySpacing.sm,
                  ),
                  decoration: BoxDecoration(
                    color: pageIndex >= index
                        ? Theme.of(context).colorScheme.onSurface
                        : Theme.of(context).colorScheme.outlineVariant,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              );
            }),
          ),
        ),

        Expanded(
          child: pageIndex == 0
              ? _buildUnitsPage()
              : pageIndex == 1
              ? _buildWeightPage()
              : pageIndex == 2
              ? _buildHeightPage()
              : _buildAgePage(),
        ),

        Padding(
          padding: const EdgeInsets.all(AllySpacing.xxl),
          child: Row(
            children: [
              if (pageIndex > 0) ...[
                Expanded(
                  child: AllyButton(
                    label: l10n.back,
                    kind: AllyButtonKind.secondary,
                    small: true,
                    onPressed: _previousPage,
                  ),
                ),
                const SizedBox(width: AllySpacing.md),
              ],
              Expanded(
                flex: 2,
                child: AllyButton(
                  label: pageIndex == 3 ? l10n.startJourney : l10n.continueAlly,
                  small: true,
                  onPressed: _nextPage,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildUnitsPage() {
    return Consumer<HealthProvider>(
      builder: (context, healthProvider, child) {
        final l10n = AppLocalizations.of(context)!;
        final isImperial = healthProvider.units == 'imperial';
        final ThemeData theme = Theme.of(context);
        final ColorScheme scheme = theme.colorScheme;

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AllySpacing.xxl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: AllySpacing.huge),
              Text(
                l10n.chooseUnitsTitle,
                style: AllyTypography.headline(
                  size: 30,
                  color: scheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AllySpacing.md),
              Text(
                l10n.chooseUnitsSubtitle,
                style: AllyTypography.body(
                  size: 15,
                  color: scheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AllySpacing.xxxl),

              Row(
                children: [
                  Expanded(
                    child: _UnitOptionCard(
                      title: l10n.metricUnits,
                      subtitle: 'kg, cm',
                      selected: !isImperial,
                      onTap: () => healthProvider.setUnits('metric'),
                    ),
                  ),
                  const SizedBox(width: AllySpacing.lg),
                  Expanded(
                    child: _UnitOptionCard(
                      title: l10n.imperialUnits,
                      subtitle: 'lbs, in',
                      selected: isImperial,
                      onTap: () => healthProvider.setUnits('imperial'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AllySpacing.massive),
            ],
          ),
        );
      },
    );
  }

  Widget _buildWeightPage() {
    return Consumer<HealthProvider>(
      builder: (context, healthProvider, child) {
        final l10n = AppLocalizations.of(context)!;
        final isImperial = healthProvider.units == 'imperial';

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AllySpacing.xxl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: AllySpacing.huge),
              Text(
                l10n.onboardWeightTitle,
                style: AllyTypography.headline(
                  size: 30,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AllySpacing.md),
              Text(
                l10n.onboardWeightSubtitle,
                style: AllyTypography.body(
                  size: 15,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AllySpacing.huge),
              _MetricInputCard(
                controller: _weightController,
                hint: isImperial ? '150' : '70',
                unit: isImperial ? 'lbs' : 'kg',
              ),
              const SizedBox(height: AllySpacing.massive),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeightPage() {
    return Consumer<HealthProvider>(
      builder: (context, healthProvider, child) {
        final l10n = AppLocalizations.of(context)!;
        final isImperial = healthProvider.units == 'imperial';
        final ThemeData theme = Theme.of(context);
        final ColorScheme scheme = theme.colorScheme;

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AllySpacing.xxl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: AllySpacing.huge),
              Text(
                l10n.onboardHeightTitle,
                style: AllyTypography.headline(
                  size: 30,
                  color: scheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AllySpacing.md),
              Text(
                l10n.onboardHeightSubtitle,
                style: AllyTypography.body(
                  size: 15,
                  color: scheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AllySpacing.huge),
              isImperial
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        SizedBox(
                          width: 130,
                          child: _MetricInputCard(
                            controller: _feetController,
                            hint: l10n.heightFeetHint,
                            unit: '\'',
                          ),
                        ),
                        const SizedBox(width: AllySpacing.md),
                        SizedBox(
                          width: 130,
                          child: _MetricInputCard(
                            controller: _inchesController,
                            hint: '7',
                            unit: '"',
                          ),
                        ),
                      ],
                    )
                  : _MetricInputCard(
                      controller: _heightController,
                      hint: '170',
                      unit: 'cm',
                    ),
              const SizedBox(height: AllySpacing.massive),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAgePage() {
    final l10n = AppLocalizations.of(context)!;
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: AllySpacing.xxl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: AllySpacing.huge),
          Text(
            l10n.onboardAgeTitle,
            style: AllyTypography.headline(size: 30, color: scheme.onSurface),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AllySpacing.md),
          Text(
            l10n.onboardAgeSubtitle,
            style: AllyTypography.body(
              size: 15,
              color: scheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AllySpacing.huge),
          _MetricInputCard(
            controller: _ageController,
            hint: '25',
            unit: l10n.yearsUnit,
          ),
          const SizedBox(height: AllySpacing.massive),
        ],
      ),
    );
  }
}

/// Selectable units card (metric / imperial).
class _UnitOptionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  const _UnitOptionCard({
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;

    return Material(
      color: selected
          ? scheme.onSurface.withValues(alpha: 0.06)
          : theme.cardColor,
      borderRadius: AllyRadius.lgAll,
      child: InkWell(
        onTap: onTap,
        borderRadius: AllyRadius.lgAll,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(AllySpacing.xl),
          decoration: BoxDecoration(
            borderRadius: AllyRadius.lgAll,
            border: Border.all(
              color: selected ? scheme.onSurface : scheme.outlineVariant,
              width: selected ? 1.4 : 1,
            ),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    selected
                        ? Icons.check_circle_rounded
                        : Icons.radio_button_unchecked_rounded,
                    size: 20,
                    color: scheme.onSurface,
                  ),
                  const SizedBox(width: AllySpacing.sm),
                  Text(
                    title,
                    style: AllyTypography.cardTitle(
                      size: 18,
                      color: scheme.onSurface,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AllySpacing.sm),
              Text(
                subtitle,
                style: AllyTypography.caption(color: scheme.onSurfaceVariant),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Large bordered numeric input used across onboarding steps.
class _MetricInputCard extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final String unit;

  const _MetricInputCard({
    required this.controller,
    required this.hint,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AllySpacing.xl,
        vertical: AllySpacing.lg,
      ),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: AllyRadius.lgAll,
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 130,
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              style: AllyTypography.metric(
                size: 40,
                color: scheme.onSurface,
                height: 1.2,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                isDense: true,
                hintText: hint,
                hintStyle: AllyTypography.metric(
                  size: 40,
                  color: scheme.outline,
                  height: 1.2,
                ),
              ),
            ),
          ),
          const SizedBox(width: AllySpacing.md),
          Text(
            unit,
            style: AllyTypography.cardTitle(
              size: 20,
              color: scheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
