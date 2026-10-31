// achievements.dart
//
// © 2026 Vertex Corporation
// ─────────────────────────────────────────────────────────────────────────────
// Achievements. Data sources and the empty state are preserved; presentation
// follows the design system.

import 'package:flutter/material.dart';

import '../design_system/design_system.dart';
import '../l10n/app_localizations.dart';

class AchievementsScreen extends StatefulWidget {
  const AchievementsScreen({super.key});

  @override
  State<AchievementsScreen> createState() => _AchievementsScreenState();
}

class _AchievementsScreenState extends State<AchievementsScreen> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(AllySpacing.xl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: context.allySemantics.activity,
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(AllySpacing.lg),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.person_rounded,
                          size: AllyDimensions.iconMd,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ),
                    const SizedBox(width: AllySpacing.md),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.achievements,
                          style: AllyTypography.caption(
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurfaceVariant,
                          ),
                        ),
                        Text(
                          l10n.helloAnonymous,
                          style: AllyTypography.headline(
                            size: 20,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    AllyIconButton(
                      icon: Icons.notifications_rounded,
                      onTap: () {},
                      tooltip: l10n.notifications,
                    ),
                  ],
                ),
                const SizedBox(height: AllySpacing.sectionLg),

                AllySectionHeader(title: l10n.availableAchievements),
                const SizedBox(height: AllySpacing.lg),

                // Empty state - no achievements yet
                AllyCard(
                  child: AllyEmptyState(
                    icon: Icons.emoji_events_outlined,
                    title: l10n.noAchievementsYet,
                    message: l10n.startTrackingForAchievements,
                    compact: true,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 100)),
      ],
    );
  }
}
