// premium.dart
//
// © 2026 Vertex Corporation
// ─────────────────────────────────────────────────────────────────────────────
// Premium plans. Same plan carousel and behaviour; the temporary placeholder
// string in the Individual plan description was replaced by the real
// localization key. Plans keep a single restrained accent — the Vertex way.

import 'package:flutter/material.dart';

import '../design_system/design_system.dart';
import '../l10n/app_localizations.dart';
import '../widgets/notification.dart';

class PremiumScreen extends StatefulWidget {
  const PremiumScreen({super.key});

  @override
  State<PremiumScreen> createState() => _PremiumScreenState();
}

class _PremiumScreenState extends State<PremiumScreen> {
  final PageController _pageController = PageController(viewportFraction: 0.88);
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      int next = _pageController.page!.round();
      if (_currentPage != next) {
        setState(() {
          _currentPage = next;
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;

    return Scaffold(
      appBar: AllyAppBar(title: l10n.upgradeYourPlan, showBackButton: true),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: AllySpacing.lg),
            Text(
              l10n.unlockMore,
              textAlign: TextAlign.center,
              style: AllyTypography.headline(size: 30, color: scheme.onSurface),
            ),
            Text(
              l10n.goPremium,
              textAlign: TextAlign.center,
              style: AllyTypography.headline(
                size: 30,
                weight: FontWeight.w400,
                color: scheme.onSurfaceVariant,
              ),
            ),

            const SizedBox(height: AllySpacing.xxl),

            Expanded(
              child: PageView(
                controller: _pageController,
                children: [
                  _PlanCard(
                    title: 'Individual',
                    price: '4.99',
                    currentPage: _currentPage == 0,
                    description: l10n.allIndividualFeatures,
                  ),
                  _PlanCard(
                    title: 'Family',
                    price: '9.99',
                    currentPage: _currentPage == 1,
                    description: l10n.allIndividualFeatures,
                  ),
                ],
              ),
            ),

            const SizedBox(height: AllySpacing.xl),
          ],
        ),
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  final String title;
  final String price;
  final bool currentPage;
  final String description;

  const _PlanCard({
    required this.title,
    required this.price,
    required this.currentPage,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 250),
      opacity: currentPage ? 1.0 : 0.5,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AllySpacing.md),
        child: AllyCard(
          elevated: true,
          padding: const EdgeInsets.all(AllySpacing.xxl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Plan header
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(AllySpacing.lg),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: scheme.onSurface.withValues(alpha: 0.06),
                    ),
                    child: Icon(
                      title == 'Individual'
                          ? Icons.person_rounded
                          : Icons.family_restroom_rounded,
                      size: AllyDimensions.iconXl,
                      color: scheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: AllySpacing.lg),
                  Text(
                    title,
                    style: AllyTypography.headline(
                      size: 20,
                      color: scheme.onSurface,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AllySpacing.xl),

              // Price
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      '\$',
                      style: AllyTypography.metric(
                        size: 24,
                        color: scheme.onSurface,
                      ),
                    ),
                  ),
                  Text(
                    price,
                    style: AllyTypography.metric(
                      size: 56,
                      color: scheme.onSurface,
                      weight: FontWeight.w700,
                      height: 1.1,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 14),
                    child: Text(
                      '/${l10n.month}',
                      style: AllyTypography.body(
                        size: 16,
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AllySpacing.lg),

              // Description
              Text(
                description,
                style: AllyTypography.body(
                  size: 13,
                  color: scheme.onSurfaceVariant,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),

              const Spacer(),

              // Button
              AllyButton(
                label: title == 'Individual'
                    ? l10n.getAllyPlan
                    : l10n.getFamilyPlan,
                onPressed: () {
                  CustomNotification.show(
                    context,
                    message: l10n.subscribeToPlan(title),
                    icon: Icons.star_rounded,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
