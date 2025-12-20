import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Project Imports
import '../providers/health.dart';
import '../notifications/introvert.dart';
import '../l10n/app_localizations.dart';
import '../services/sleep.dart';
import '../theme.dart';
import '../app.dart';

class SleepScreen extends StatefulWidget {
  const SleepScreen({super.key});

  @override
  State<SleepScreen> createState() => _SleepScreenState();
}

class _SleepScreenState extends State<SleepScreen> {
  final _sleepService = SleepTrackerService();
  TimeOfDay _sleepStart = const TimeOfDay(hour: 22, minute: 0);
  TimeOfDay _sleepEnd = const TimeOfDay(hour: 7, minute: 0);

  // Semantic Sleep Color (Purple)
  final Color _sleepColor = const Color(0xFFCE93D8);

  @override
  void initState() {
    super.initState();
    _loadSettings();
    _checkAndShowSetup();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final enabled = prefs.getBool('sleep_tracking_enabled') ?? false;

    if (mounted) {
      setState(() {
        if (enabled) {
          final startHour = prefs.getInt('sleep_start_hour') ?? 23;
          final startMinute = prefs.getInt('sleep_start_minute') ?? 0;
          final endHour = prefs.getInt('sleep_end_hour') ?? 7;
          final endMinute = prefs.getInt('sleep_end_minute') ?? 0;
          _sleepStart = TimeOfDay(hour: startHour, minute: startMinute);
          _sleepEnd = TimeOfDay(hour: endHour, minute: endMinute);
        }
      });
    }
  }

  Future<void> _checkAndShowSetup() async {
    final prefs = await SharedPreferences.getInstance();
    final hasSetup = prefs.getBool('sleep_setup_done') ?? false;

    if (!hasSetup && mounted) {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          _showSleepSetupDialog();
        }
      });
    }
  }

  void _showSleepSetupDialog() {
    // Dynamic Dimensions
    final sw = MediaQuery.of(context).size.width;
    final sh = MediaQuery.of(context).size.height;

    // Theme Colors
    final backgroundColor = AppColors.background;
    final cardColor = AppColors.secondaryColor;
    final textColor = AppColors.primaryColor.inverted;
    final subTextColor = AppColors.tertiaryColor;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      isDismissible: false,
      builder: (context) => PopScope(
        canPop: false,
        child: Container(
          margin: EdgeInsets.all(sw * 0.04),
          padding: EdgeInsets.all(sw * 0.06),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(sw * 0.06),
            border: Border.all(color: AppColors.border, width: 1),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(sw * 0.04),
                decoration: BoxDecoration(
                  color: _sleepColor.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.bedtime_rounded, color: _sleepColor, size: sw * 0.08),
              ),
              SizedBox(height: sh * 0.02),
              Text(
                AppLocalizations.of(context)!.automaticSleepTracking,
                style: TextStyle(
                  fontSize: sw * 0.05,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              SizedBox(height: sh * 0.01),
              Text(
                AppLocalizations.of(context)!.noSmartwatchNeeded,
                style: TextStyle(
                  fontSize: sw * 0.035,
                  color: subTextColor,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: sh * 0.03),
              Container(
                padding: EdgeInsets.all(sw * 0.04),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(sw * 0.04),
                  boxShadow: [
                    BoxShadow(
                      color: textColor.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.whenDoYouUsuallySleep,
                      style: TextStyle(
                        fontSize: sw * 0.038,
                        fontWeight: FontWeight.w600,
                        color: textColor,
                      ),
                    ),
                    SizedBox(height: sh * 0.02),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTimePicker(
                            'Sleep Time',
                            _sleepStart,
                                (time) => setState(() => _sleepStart = time),
                          ),
                        ),
                        SizedBox(width: sw * 0.04),
                        Expanded(
                          child: _buildTimePicker(
                            'Wake Time',
                            _sleepEnd,
                                (time) => setState(() => _sleepEnd = time),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: sh * 0.025),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () async {
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.setBool('sleep_setup_done', true);

                        // DÜZELTME BURADA: context.mounted kontrolü
                        if (!context.mounted) return;
                        Navigator.pop(context);
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: sh * 0.02),
                      ),
                      child: Text(
                        'Skip',
                        style: TextStyle(
                          fontSize: sw * 0.04,
                          color: subTextColor,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: sw * 0.03),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        // 1. Asenkron işlemler
                        await _sleepService.startTracking(_sleepStart, _sleepEnd);
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.setBool('sleep_setup_done', true);

                        // 2. DÜZELTME BURADA: context.mounted kontrolü
                        if (!context.mounted) return;

                        // 3. Context kullanımı güvenli
                        Navigator.pop(context);
                        context.read<IntrovertNotificationService>().showNotification(
                          message: 'Automatic tracking enabled',
                          type: NotificationType.success,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _sleepColor,
                        padding: EdgeInsets.symmetric(vertical: sh * 0.02),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(sw * 0.03),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        AppLocalizations.of(context)!.startTracking,
                        style: TextStyle(
                          fontSize: sw * 0.04,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimePicker(String label, TimeOfDay time, Function(TimeOfDay) onChanged) {
    // Dynamic Dimensions
    final sw = MediaQuery.of(context).size.width;
    final backgroundColor = AppColors.background;
    final subTextColor = AppColors.tertiaryColor;

    return GestureDetector(
      onTap: () async {
        final picked = await showTimePicker(
          context: context,
          initialTime: time,
        );
        if (picked != null) {
          onChanged(picked);
        }
      },
      child: Container(
        padding: EdgeInsets.all(sw * 0.03),
        decoration: BoxDecoration(
          color: backgroundColor.withValues(alpha: 0.5), // Slight difference from card
          borderRadius: BorderRadius.circular(sw * 0.03),
          border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: sw * 0.03,
                color: subTextColor,
              ),
            ),
            SizedBox(height: sw * 0.01),
            Text(
              '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}',
              style: TextStyle(
                fontSize: sw * 0.05,
                fontWeight: FontWeight.bold,
                color: _sleepColor,
              ),
            ),
          ],
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

    // Spacing
    final paddingH = sw * 0.05;
    final paddingV = sh * 0.025;

    // Theme Colors
    final backgroundColor = AppColors.background;
    final textColor = AppColors.primaryColor.inverted;

    final healthProvider = Provider.of<HealthProvider>(context);
    final healthData = healthProvider.healthData;
    final hoursSlept = healthData.sleepHours;
    final goalHours = 8.0;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.chevron_left_rounded, color: textColor, size: sw * 0.08),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(AppLocalizations.of(context)!.sleep, style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: paddingH, vertical: paddingV),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Hero(
                  tag: 'sleep_card',
                  child: Material(
                    color: Colors.transparent,
                    child: Container(
                      padding: EdgeInsets.all(sw * 0.06),
                      decoration: BoxDecoration(
                        color: _sleepColor,
                        borderRadius: BorderRadius.circular(sw * 0.06),
                        boxShadow: [
                          BoxShadow(
                              color: _sleepColor.withValues(alpha: 0.3),
                              blurRadius: 20,
                              offset: const Offset(0, 10)
                          )
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.sleepDuration,
                            style: TextStyle(
                              fontSize: sw * 0.04,
                              color: Colors.white70,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: sh * 0.015),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(sw * 0.03),
                            child: LinearProgressIndicator(
                              value: hoursSlept / goalHours,
                              minHeight: sh * 0.015,
                              backgroundColor: Colors.white70,
                              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          ),
                          SizedBox(height: sh * 0.02),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                hoursSlept.toStringAsFixed(1),
                                style: TextStyle(
                                  fontSize: sw * 0.16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  height: 1,
                                ),
                              ),
                              SizedBox(width: sw * 0.03),
                              Padding(
                                padding: EdgeInsets.only(bottom: sh * 0.01),
                                child: Text(
                                  AppLocalizations.of(context)!.ofHoursGoal(goalHours.toStringAsFixed(0)),
                                  style: TextStyle(
                                    fontSize: sw * 0.06,
                                    color: Colors.white70,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: sh * 0.03),
                _buildSleepStats(),
                SizedBox(height: sh * 0.03),
                Text(
                  AppLocalizations.of(context)!.sleepSegments,
                  style: TextStyle(fontSize: sw * 0.045, fontWeight: FontWeight.bold, color: textColor),
                ),
                SizedBox(height: sh * 0.02),
                _buildSleepSegmentsList(),
                SizedBox(height: sh * 0.1),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSleepStats() {
    // Dynamic Dimensions
    final sw = MediaQuery.of(context).size.width;
    final sh = MediaQuery.of(context).size.height;
    final cardColor = AppColors.secondaryColor;
    final textColor = AppColors.primaryColor.inverted;
    final subTextColor = AppColors.tertiaryColor;

    return FutureBuilder<List<dynamic>>(
      future: Future.wait([
        _sleepService.getTodaySegments(),
        _sleepService.getWakeUpCount(),
      ]),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return SizedBox(height: sh * 0.1);
        }

        final segments = snapshot.data![0] as List;
        final wakeUpCount = snapshot.data![1] as int;

        return Row(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.all(sw * 0.05),
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
                child: Column(
                  children: [
                    Icon(
                      Icons.nightlight_round,
                      color: _sleepColor,
                      size: sw * 0.08,
                    ),
                    SizedBox(height: sh * 0.015),
                    Text(
                      '${segments.length}',
                      style: TextStyle(
                        fontSize: sw * 0.08,
                        fontWeight: FontWeight.bold,
                        color: _sleepColor,
                      ),
                    ),
                    SizedBox(height: sh * 0.005),
                    Text(
                      AppLocalizations.of(context)!.sleepCycles,
                      style: TextStyle(
                        fontSize: sw * 0.035,
                        color: subTextColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: sw * 0.04),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(sw * 0.05),
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
                child: Column(
                  children: [
                    Icon(
                      Icons.wb_sunny_outlined,
                      color: const Color(0xFFFFB74D), // Sun color
                      size: sw * 0.08,
                    ),
                    SizedBox(height: sh * 0.015),
                    Text(
                      '$wakeUpCount',
                      style: TextStyle(
                        fontSize: sw * 0.08,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFFFFB74D),
                      ),
                    ),
                    SizedBox(height: sh * 0.005),
                    Text(
                      AppLocalizations.of(context)!.wakeUps,
                      style: TextStyle(
                        fontSize: sw * 0.035,
                        color: subTextColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSleepSegmentsList() {
    // Dynamic Dimensions
    final sw = MediaQuery.of(context).size.width;
    final sh = MediaQuery.of(context).size.height;
    final cardColor = AppColors.secondaryColor;
    final textColor = AppColors.primaryColor.inverted;
    final subTextColor = AppColors.tertiaryColor;
    final backgroundColor = AppColors.background;

    return FutureBuilder<List<dynamic>>(
      future: _sleepService.getTodaySegments(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return SizedBox(height: sh * 0.1);
        }

        final segments = snapshot.data!;

        if (segments.isEmpty) {
          return Container(
            width: double.infinity,
            padding: EdgeInsets.all(sw * 0.1),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(sw * 0.05),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.bedtime_outlined,
                  size: sw * 0.2,
                  color: subTextColor.withValues(alpha: 0.3),
                ),
                SizedBox(height: sh * 0.02),
                Text(
                  AppLocalizations.of(context)!.noSleepDataYet,
                  style: TextStyle(
                    fontSize: sw * 0.045,
                    fontWeight: FontWeight.w600,
                    color: subTextColor,
                  ),
                ),
                SizedBox(height: sh * 0.01),
                Text(
                  AppLocalizations.of(context)!.sleepTrackingWillStartTonight,
                  style: TextStyle(
                    fontSize: sw * 0.035,
                    color: subTextColor,
                  ),
                ),
              ],
            ),
          );
        }

        return Container(
          padding: EdgeInsets.all(sw * 0.05),
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
          child: Column(
            children: segments.asMap().entries.map((entry) {
              final index = entry.key;
              final segment = entry.value;
              final isActive = segment.endTime == null;
              final duration = segment.durationInMinutes;
              final hours = duration ~/ 60;
              final minutes = duration % 60;

              return Container(
                margin: EdgeInsets.only(bottom: index < segments.length - 1 ? sh * 0.015 : 0),
                padding: EdgeInsets.all(sw * 0.04),
                decoration: BoxDecoration(
                  color: isActive
                      ? _sleepColor.withValues(alpha: 0.1)
                      : backgroundColor,
                  borderRadius: BorderRadius.circular(sw * 0.04),
                  border: Border.all(
                    color: isActive
                        ? _sleepColor
                        : Colors.transparent,
                    width: 2,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(sw * 0.03),
                      decoration: BoxDecoration(
                        color: isActive
                            ? _sleepColor
                            : subTextColor.withValues(alpha: 0.5),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isActive ? Icons.bedtime : Icons.check,
                        color: Colors.white,
                        size: sw * 0.05,
                      ),
                    ),
                    SizedBox(width: sw * 0.04),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isActive ? 'Currently Sleeping' : 'Sleep Segment ${index + 1}',
                            style: TextStyle(
                              fontSize: sw * 0.04,
                              fontWeight: FontWeight.bold,
                              color: isActive
                                  ? _sleepColor
                                  : textColor,
                            ),
                          ),
                          SizedBox(height: sh * 0.005),
                          Text(
                            '${_formatTime(segment.startTime)} - ${segment.endTime != null ? _formatTime(segment.endTime!) : AppLocalizations.of(context)!.nowLabel}',
                            style: TextStyle(
                              fontSize: sw * 0.035,
                              color: subTextColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      AppLocalizations.of(context)!.hoursMinutes(hours, minutes),
                      style: TextStyle(
                        fontSize: sw * 0.045,
                        fontWeight: FontWeight.bold,
                        color: isActive
                            ? _sleepColor
                            : subTextColor,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}