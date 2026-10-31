// activity.dart
//
// © 2026 Vertex Corporation
// ─────────────────────────────────────────────────────────────────────────────
// Activity feed. Friends invitation flow and real activity entries (water,
// nutrition, exercise, sleep) are preserved with restrained metric accents.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../design_system/design_system.dart';
import '../l10n/app_localizations.dart';
import '../notifications/introvert.dart';
import '../providers/health.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key});

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  void _showAddFriendDialog() {
    final l10n = AppLocalizations.of(context)!;
    final usernameController = TextEditingController();

    AllySheet.show(
      context,
      title: l10n.addFriend,
      subtitle: l10n.enterFriendUsername,
      icon: Icons.person_add_rounded,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AllyTextField(
            controller: usernameController,
            autofocus: true,
            hint: l10n.usernameAtHint,
            prefixIcon: Icons.alternate_email_rounded,
          ),
          const SizedBox(height: AllySpacing.xl),
          Row(
            children: [
              Expanded(
                child: AllyButton(
                  label: l10n.cancel,
                  kind: AllyButtonKind.ghost,
                  small: true,
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              Expanded(
                child: AllyButton(
                  label: l10n.sendRequest,
                  small: true,
                  onPressed: () {
                    final username = usernameController.text.trim();
                    if (username.isNotEmpty) {
                      Navigator.pop(context);

                      context
                          .read<IntrovertNotificationService>()
                          .showNotification(
                            message: l10n.requestSentTo(username),
                            type: NotificationType.success,
                          );
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;
    final AllySemanticPalette semantics = context.allySemantics;

    final healthData = context.watch<HealthProvider>().healthData;

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
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
                        Text(
                          l10n.activity,
                          style: AllyTypography.headline(
                            size: 24,
                            color: scheme.onSurface,
                          ),
                        ),
                        const Spacer(),
                        AllyIconButton(
                          icon: Icons.notifications_rounded,
                          onTap: () {},
                          tooltip: l10n.notifications,
                        ),
                      ],
                    ),
                    const SizedBox(height: AllySpacing.section),

                    // ── Friends activity ──────────────────────────────────
                    AllySectionHeader(title: l10n.friendsActivity),
                    const SizedBox(height: AllySpacing.lg),
                    AllyCard(
                      child: AllyEmptyState(
                        icon: Icons.people_outline_rounded,
                        title: l10n.noFriendsYet,
                        message: l10n.addFriendsToSee,
                        actionLabel: l10n.addFriend,
                        onAction: _showAddFriendDialog,
                        compact: true,
                      ),
                    ),

                    const SizedBox(height: AllySpacing.section),

                    // ── My activity ───────────────────────────────────────
                    AllySectionHeader(title: l10n.myActivity),
                    const SizedBox(height: AllySpacing.lg),

                    if (healthData.waterGlasses > 0) ...[
                      _buildActivityCard(
                        context,
                        icon: Icons.water_drop_rounded,
                        color: semantics.water,
                        title: l10n.waterIntake,
                        description: l10n.drankGlasses(healthData.waterGlasses),
                        time: l10n.today,
                      ),
                      const SizedBox(height: AllySpacing.md),
                    ],

                    if (healthData.caloriesConsumed > 0) ...[
                      _buildActivityCard(
                        context,
                        icon: Icons.restaurant_rounded,
                        color: semantics.nutrition,
                        title: l10n.mealLogged,
                        description: l10n.caloriesConsumed(
                          healthData.caloriesConsumed,
                        ),
                        time: l10n.today,
                      ),
                      const SizedBox(height: AllySpacing.md),
                    ],

                    if (healthData.exerciseStreak > 0) ...[
                      _buildActivityCard(
                        context,
                        icon: Icons.fitness_center_rounded,
                        color: semantics.activity,
                        title: l10n.exerciseStreak,
                        description: l10n.dayStreakMaintained(
                          healthData.exerciseStreak,
                        ),
                        time: l10n.today,
                      ),
                      const SizedBox(height: AllySpacing.md),
                    ],

                    if (healthData.sleepHours > 0) ...[
                      _buildActivityCard(
                        context,
                        icon: Icons.bedtime_rounded,
                        color: semantics.sleep,
                        title: l10n.sleepLogged,
                        description: l10n.hoursOfSleep(
                          healthData.sleepHours.toStringAsFixed(1),
                        ),
                        time: l10n.lastNight,
                      ),
                      const SizedBox(height: AllySpacing.md),
                    ],

                    // Empty state if no activity
                    if (healthData.waterGlasses == 0 &&
                        healthData.caloriesConsumed == 0 &&
                        healthData.exerciseStreak == 0 &&
                        healthData.sleepHours == 0)
                      AllyCard(
                        child: AllyEmptyState(
                          icon: Icons.timeline_rounded,
                          title: l10n.noActivityYet,
                          message: l10n.startTrackingToSee,
                          compact: true,
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 120)),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityCard(
    BuildContext context, {
    required IconData icon,
    required Color color,
    required String title,
    required String description,
    required String time,
  }) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;

    return AllyCard(
      child: Row(
        children: [
          Container(
            width: AllyDimensions.iconChip,
            height: AllyDimensions.iconChip,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.14),
              borderRadius: AllyRadius.smAll,
            ),
            child: Icon(icon, color: color, size: AllyDimensions.iconSm),
          ),
          const SizedBox(width: AllySpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AllyTypography.label(
                    size: 15,
                    color: scheme.onSurface,
                  ),
                ),
                Text(
                  description,
                  style: AllyTypography.caption(color: scheme.onSurfaceVariant),
                ),
              ],
            ),
          ),
          Text(
            time,
            style: AllyTypography.caption(color: scheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}
