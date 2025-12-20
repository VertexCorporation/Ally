import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Project Imports
import '../providers/health.dart';
import '../notifications/introvert.dart';
import '../l10n/app_localizations.dart';
import '../theme.dart';
import '../app.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key});

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {

  void _showAddFriendDialog() {
    final usernameController = TextEditingController();
    final l10n = AppLocalizations.of(context)!;

    // Dynamic Dimensions
    final sw = MediaQuery.of(context).size.width;
    final sh = MediaQuery.of(context).size.height;

    // Theme Colors
    final cardColor = AppColors.secondaryColor;
    final backgroundColor = AppColors.background;
    final accentColor = AppColors.senaryColor;
    final textColor = AppColors.primaryColor.inverted;
    final subTextColor = AppColors.tertiaryColor;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          margin: EdgeInsets.all(sw * 0.04),
          padding: EdgeInsets.all(sw * 0.06),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.all(Radius.circular(sw * 0.06)),
            border: Border.all(color: AppColors.border, width: 1),
            boxShadow: [
              BoxShadow(
                color: textColor.withValues(alpha: 0.05),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(sw * 0.04),
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.person_add_rounded, color: accentColor, size: sw * 0.08),
              ),
              SizedBox(height: sh * 0.02),
              Text(
                'Add Friend', // Recommend adding to AppLocalizations later
                style: TextStyle(
                  fontSize: sw * 0.055,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              SizedBox(height: sh * 0.01),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: sw * 0.08),
                child: Text(
                  l10n.enterFriendUsername,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: sw * 0.035,
                    color: subTextColor,
                  ),
                ),
              ),
              SizedBox(height: sh * 0.03),
              TextField(
                controller: usernameController,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: sw * 0.045,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
                cursorColor: accentColor,
                decoration: InputDecoration(
                  hintText: l10n.usernameAtHint,
                  hintStyle: TextStyle(color: subTextColor.withValues(alpha: 0.5)),
                  filled: true,
                  fillColor: cardColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(sw * 0.03),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(sw * 0.03),
                    borderSide: BorderSide(color: accentColor, width: 2),
                  ),
                  prefixIcon: Icon(Icons.alternate_email_rounded, color: accentColor),
                ),
              ),
              SizedBox(height: sh * 0.03),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: sh * 0.02),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(sw * 0.03),
                        ),
                      ),
                      child: Text(
                        l10n.cancel,
                        style: TextStyle(
                          fontSize: sw * 0.04,
                          fontWeight: FontWeight.w600,
                          color: subTextColor,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: sw * 0.03),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        final username = usernameController.text.trim();
                        if (username.isNotEmpty) {
                          Navigator.pop(context);

                          // Use the IntrovertNotificationService
                          context.read<IntrovertNotificationService>().showNotification(
                            message: l10n.requestSentTo(username),
                            type: NotificationType.success,
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: accentColor,
                        foregroundColor: AppColors.background,
                        padding: EdgeInsets.symmetric(vertical: sh * 0.02),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(sw * 0.03),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        l10n.sendRequest,
                        style: TextStyle(
                          fontSize: sw * 0.04,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: sh * 0.02),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // -------------------------------------------------------------------------
    // DYNAMIC DIMENSIONS & COLORS
    // -------------------------------------------------------------------------
    final sw = MediaQuery.of(context).size.width;
    final sh = MediaQuery.of(context).size.height;

    final paddingH = sw * 0.05; // 5% Horizontal
    final paddingV = sh * 0.025; // 2.5% Vertical
    final cardPadding = sw * 0.05;

    // Theme Colors
    final backgroundColor = AppColors.background;
    final cardColor = AppColors.secondaryColor;
    final accentColor = AppColors.senaryColor;
    final textColor = AppColors.primaryColor.inverted;
    final subTextColor = AppColors.tertiaryColor;

    final healthProvider = Provider.of<HealthProvider>(context);
    final healthData = healthProvider.healthData;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: paddingH, vertical: paddingV),
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
                          color: accentColor,
                        ),
                        child: Container(
                          padding: EdgeInsets.all(sw * 0.035),
                          decoration: BoxDecoration(
                            color: cardColor,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.person, size: sw * 0.06, color: accentColor),
                        ),
                      ),
                      SizedBox(width: sw * 0.03),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.activity,
                            style: TextStyle(fontSize: sw * 0.03, color: subTextColor),
                          ),
                          Text(
                            AppLocalizations.of(context)!.helloAnonymous,
                            style: TextStyle(
                                fontSize: sw * 0.045,
                                fontWeight: FontWeight.bold,
                                color: textColor
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Container(
                        decoration: BoxDecoration(
                          color: cardColor,
                          borderRadius: BorderRadius.circular(sw * 0.03),
                          boxShadow: [
                            BoxShadow(
                                color: textColor.withValues(alpha: 0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 2)
                            )
                          ],
                        ),
                        child: IconButton(
                            icon: Icon(Icons.notifications_rounded, color: textColor),
                            onPressed: () {}
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: sh * 0.04),

                  // Friends Activity Section
                  Text(
                    AppLocalizations.of(context)!.friendsActivity,
                    style: TextStyle(
                      fontSize: sw * 0.05,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  SizedBox(height: sh * 0.02),
                  Container(
                    padding: EdgeInsets.all(cardPadding),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(sw * 0.05),
                      boxShadow: [
                        BoxShadow(
                          color: textColor.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Column(
                        children: [
                          Icon(
                            Icons.people_outline_rounded,
                            size: sw * 0.15,
                            color: subTextColor.withValues(alpha: 0.3),
                          ),
                          SizedBox(height: sh * 0.015),
                          Text(
                            AppLocalizations.of(context)!.noFriendsYet,
                            style: TextStyle(
                              fontSize: sw * 0.04,
                              fontWeight: FontWeight.w600,
                              color: subTextColor,
                            ),
                          ),
                          SizedBox(height: sh * 0.005),
                          Text(
                            AppLocalizations.of(context)!.addFriendsToSee,
                            style: TextStyle(
                              fontSize: sw * 0.035,
                              color: subTextColor,
                            ),
                          ),
                          SizedBox(height: sh * 0.025),
                          ElevatedButton.icon(
                            onPressed: _showAddFriendDialog,
                            icon: Icon(Icons.person_add_rounded, size: sw * 0.05),
                            label: Text(AppLocalizations.of(context)!.addFriend),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: accentColor,
                              foregroundColor: backgroundColor,
                              padding: EdgeInsets.symmetric(horizontal: sw * 0.06, vertical: sh * 0.015),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(sw * 0.03),
                              ),
                              elevation: 0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: sh * 0.04),

                  // My Activity Section
                  Text(
                    AppLocalizations.of(context)!.myActivity,
                    style: TextStyle(
                      fontSize: sw * 0.05,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  SizedBox(height: sh * 0.02),

                  // Recent activities based on user data
                  // Note: We keep specific semantic colors for health metrics (Blue/Orange/Red/Purple)
                  // but use them with the AppColors system where possible or as distinct data visualizations.

                  if (healthData.waterGlasses > 0) ...[
                    _buildActivityCard(
                      context,
                      icon: Icons.water_drop_rounded,
                      color: const Color(0xFF64B5F6), // Semantic Water Color
                      title: AppLocalizations.of(context)!.waterIntake,
                      description: AppLocalizations.of(context)!.drankGlasses(healthData.waterGlasses),
                      time: AppLocalizations.of(context)!.today,
                    ),
                    SizedBox(height: sh * 0.015),
                  ],

                  if (healthData.caloriesConsumed > 0) ...[
                    _buildActivityCard(
                      context,
                      icon: Icons.restaurant_rounded,
                      color: const Color(0xFFFFB74D), // Semantic Food Color
                      title: AppLocalizations.of(context)!.mealLogged,
                      description: AppLocalizations.of(context)!.caloriesConsumed(healthData.caloriesConsumed),
                      time: AppLocalizations.of(context)!.today,
                    ),
                    SizedBox(height: sh * 0.015),
                  ],

                  if (healthData.exerciseStreak > 0) ...[
                    _buildActivityCard(
                      context,
                      icon: Icons.fitness_center_rounded,
                      color: const Color(0xFFE57373), // Semantic Exercise Color
                      title: AppLocalizations.of(context)!.exerciseStreak,
                      description: AppLocalizations.of(context)!.dayStreakMaintained(healthData.exerciseStreak),
                      time: AppLocalizations.of(context)!.today,
                    ),
                    SizedBox(height: sh * 0.015),
                  ],

                  if (healthData.sleepHours > 0) ...[
                    _buildActivityCard(
                      context,
                      icon: Icons.bedtime_rounded,
                      color: const Color(0xFF9D50BB), // Semantic Sleep Color
                      title: AppLocalizations.of(context)!.sleepLogged,
                      description: AppLocalizations.of(context)!.hoursOfSleep(healthData.sleepHours.toStringAsFixed(1)),
                      time: AppLocalizations.of(context)!.lastNight,
                    ),
                    SizedBox(height: sh * 0.015),
                  ],

                  // Empty state if no activity
                  if (healthData.waterGlasses == 0 &&
                      healthData.caloriesConsumed == 0 &&
                      healthData.exerciseStreak == 0 &&
                      healthData.sleepHours == 0)
                    Padding(
                      padding: EdgeInsets.all(sw * 0.1),
                      child: Center(
                        child: Column(
                          children: [
                            Icon(
                              Icons.timeline_rounded,
                              size: sw * 0.15,
                              color: subTextColor.withValues(alpha: 0.3),
                            ),
                            SizedBox(height: sh * 0.015),
                            Text(
                              AppLocalizations.of(context)!.noActivityYet,
                              style: TextStyle(
                                fontSize: sw * 0.04,
                                fontWeight: FontWeight.w600,
                                color: textColor,
                              ),
                            ),
                            SizedBox(height: sh * 0.005),
                            Text(
                              AppLocalizations.of(context)!.startTrackingToSee,
                              style: TextStyle(
                                fontSize: sw * 0.035,
                                color: subTextColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: sh * 0.1)), // Bottom padding
        ],
      ),
    );
  }

  Widget _buildActivityCard(
      BuildContext context, {
        required IconData icon,
        required Color color, // Semantic color (passed from build)
        required String title,
        required String description,
        required String time,
      }) {
    // Dynamic Dimensions
    final sw = MediaQuery.of(context).size.width;
    final cardColor = AppColors.secondaryColor;
    final textColor = AppColors.primaryColor.inverted;
    final subTextColor = AppColors.tertiaryColor;

    return Container(
      padding: EdgeInsets.all(sw * 0.04),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(sw * 0.04),
        boxShadow: [
          BoxShadow(
            color: textColor.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: sw * 0.14,
            height: sw * 0.14,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(sw * 0.03),
            ),
            child: Icon(icon, color: color, size: sw * 0.07),
          ),
          SizedBox(width: sw * 0.04),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: sw * 0.04,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                SizedBox(height: sw * 0.01),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: sw * 0.035,
                    color: subTextColor,
                  ),
                ),
              ],
            ),
          ),
          Text(
            time,
            style: TextStyle(
              fontSize: sw * 0.03,
              color: subTextColor.withValues(alpha: 0.6),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}