// sleep.dart
//
// © 2026 Vertex Corporation
// ─────────────────────────────────────────────────────────────────────────────
// Sleep dashboard. Tracking, setup persistence and segment data are handled by
// [SleepTrackerService] — untouched. Presentation uses the shared design
// system with the restrained sleep-purple accent.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../design_system/design_system.dart';
import '../l10n/app_localizations.dart';
import '../notifications/introvert.dart';
import '../providers/health.dart';
import '../services/sleep.dart';

class SleepScreen extends StatefulWidget {
  const SleepScreen({super.key});

  @override
  State<SleepScreen> createState() => _SleepScreenState();
}

class _SleepScreenState extends State<SleepScreen> {
  final _sleepService = SleepTrackerService();
  TimeOfDay _sleepStart = const TimeOfDay(hour: 22, minute: 0);
  TimeOfDay _sleepEnd = const TimeOfDay(hour: 7, minute: 0);
  TimeOfDay _alarmTime = const TimeOfDay(hour: 7, minute: 0);
  bool _smartAlarmEnabled = false;
  int _smartAlarmDuration = 30;

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

          final alarmHour = prefs.getInt('alarm_hour') ?? endHour;
          final alarmMinute = prefs.getInt('alarm_minute') ?? endMinute;
          _alarmTime = TimeOfDay(hour: alarmHour, minute: alarmMinute);

          _smartAlarmEnabled = prefs.getBool('alarm_enabled') ?? false;
          _smartAlarmDuration = prefs.getInt('alarm_minutes_before') ?? 30;
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
    final l10n = AppLocalizations.of(context)!;
    bool isLoading = false;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      isDismissible: false,
      builder: (sheetContext) => StatefulBuilder(
        builder: (sheetContext, setStateModal) {
          final ThemeData theme = Theme.of(sheetContext);
          final ColorScheme scheme = theme.colorScheme;
          final AllySemanticPalette semantics = sheetContext.allySemantics;
          final sleepColor = semantics.sleep;

          return PopScope(
            canPop: false,
            child: Container(
              margin: const EdgeInsets.all(AllySpacing.lg),
              padding: const EdgeInsets.all(AllySpacing.xxl),
              decoration: BoxDecoration(
                color: scheme.surface,
                borderRadius: AllyRadius.lgAll,
                border: Border.all(color: scheme.outlineVariant),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(AllySpacing.lg),
                    decoration: BoxDecoration(
                      color: sleepColor.withValues(alpha: 0.14),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.bedtime_rounded,
                      color: sleepColor,
                      size: AllyDimensions.iconXl,
                    ),
                  ),
                  const SizedBox(height: AllySpacing.lg),
                  Text(
                    l10n.automaticSleepTracking,
                    style: AllyTypography.headline(
                      size: 20,
                      color: scheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: AllySpacing.sm),
                  Text(
                    l10n.noSmartwatchNeeded,
                    style: AllyTypography.body(
                      size: 14,
                      color: scheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AllySpacing.xl),
                  Container(
                    padding: const EdgeInsets.all(AllySpacing.lg),
                    decoration: BoxDecoration(
                      color: theme.cardColor,
                      borderRadius: AllyRadius.mdAll,
                      border: Border.all(color: scheme.outlineVariant),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.whenDoYouUsuallySleep,
                          style: AllyTypography.label(
                            size: 14,
                            color: scheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: AllySpacing.lg),
                        Row(
                          children: [
                            Expanded(
                              child: _buildTimePicker(
                                sheetContext,
                                l10n.sleepTime,
                                _sleepStart,
                                (time) => setState(() => _sleepStart = time),
                              ),
                            ),
                            const SizedBox(width: AllySpacing.md),
                            Expanded(
                              child: _buildTimePicker(
                                sheetContext,
                                l10n.wakeTime,
                                _sleepEnd,
                                (time) => setState(() => _sleepEnd = time),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AllySpacing.md),
                  SwitchListTile(
                    title: Text(
                      l10n.enableAlarm,
                      style: AllyTypography.label(
                        size: 15,
                        color: scheme.onSurface,
                      ),
                    ),
                    subtitle: Text(
                      l10n.smartAlarmDesc,
                      style: AllyTypography.caption(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                    value: _smartAlarmEnabled,
                    onChanged: (val) {
                      setState(() => _smartAlarmEnabled = val);
                      setStateModal(() {});
                    },
                    contentPadding: EdgeInsets.zero,
                  ),
                  if (_smartAlarmEnabled) ...[
                    const SizedBox(height: AllySpacing.sm),
                    Container(
                      padding: const EdgeInsets.all(AllySpacing.lg),
                      decoration: BoxDecoration(
                        color: theme.cardColor,
                        borderRadius: AllyRadius.mdAll,
                        border: Border.all(color: scheme.outlineVariant),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              l10n.alarmTime,
                              style: AllyTypography.label(
                                size: 14,
                                color: scheme.onSurface,
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: AllyRadius.smAll,
                              border: Border.all(color: scheme.outlineVariant),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: AllySpacing.md,
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<TimeOfDay>(
                                value: _alarmTime,
                                borderRadius: AllyRadius.smAll,
                                style: AllyTypography.label(
                                  size: 14,
                                  color: scheme.onSurface,
                                ),
                                items: List.generate(24, (h) {
                                  return DropdownMenuItem<TimeOfDay>(
                                    value: TimeOfDay(hour: h, minute: 0),
                                    child: Text(
                                      '${h.toString().padLeft(2, '0')}:00',
                                    ),
                                  );
                                }).toList(),
                                onChanged: (val) {
                                  if (val != null) {
                                    setState(() => _alarmTime = val);
                                    setStateModal(() {});
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AllySpacing.sm),
                    Container(
                      padding: const EdgeInsets.all(AllySpacing.lg),
                      decoration: BoxDecoration(
                        color: theme.cardColor,
                        borderRadius: AllyRadius.mdAll,
                        border: Border.all(color: scheme.outlineVariant),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              l10n.alarmBefore,
                              style: AllyTypography.label(
                                size: 14,
                                color: scheme.onSurface,
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: AllyRadius.smAll,
                              border: Border.all(color: scheme.outlineVariant),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: AllySpacing.md,
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<int>(
                                value: _smartAlarmDuration,
                                borderRadius: AllyRadius.smAll,
                                style: AllyTypography.label(
                                  size: 14,
                                  color: scheme.onSurface,
                                ),
                                items: [5, 10, 15, 20, 30, 45, 60]
                                    .map(
                                      (val) => DropdownMenuItem<int>(
                                        value: val,
                                        child: Text(l10n.minutesShort('$val')),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (val) {
                                  if (val != null) {
                                    setState(() => _smartAlarmDuration = val);
                                    setStateModal(() {});
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: AllySpacing.lg),
                  Row(
                    children: [
                      Expanded(
                        child: AllyButton(
                          label: l10n.skip,
                          kind: AllyButtonKind.ghost,
                          small: true,
                          onPressed: () async {
                            final prefs = await SharedPreferences.getInstance();
                            await prefs.setBool('sleep_setup_done', true);

                            if (!sheetContext.mounted) return;
                            Navigator.pop(sheetContext);
                          },
                        ),
                      ),
                      const SizedBox(width: AllySpacing.md),
                      Expanded(
                        child: AllyButton(
                          label: l10n.startTracking,
                          isLoading: isLoading,
                          small: true,
                          onPressed: isLoading
                              ? null
                              : () async {
                                  final service = context
                                      .read<IntrovertNotificationService>();
                                  setStateModal(() {
                                    isLoading = true;
                                  });
                                  final prefs =
                                      await SharedPreferences.getInstance();
                                  await prefs.setBool('sleep_setup_done', true);
                                  await prefs.setBool(
                                    'alarm_enabled',
                                    _smartAlarmEnabled,
                                  );
                                  await prefs.setInt(
                                    'alarm_hour',
                                    _alarmTime.hour,
                                  );
                                  await prefs.setInt(
                                    'alarm_minute',
                                    _alarmTime.minute,
                                  );
                                  await prefs.setInt(
                                    'alarm_minutes_before',
                                    _smartAlarmDuration,
                                  );
                                  await _sleepService.startTracking(
                                    _sleepStart,
                                    _sleepEnd,
                                  );

                                  if (!sheetContext.mounted) return;
                                  Navigator.pop(sheetContext);
                                  service.showNotification(
                                    message: l10n.trackingEnabled,
                                    type: NotificationType.success,
                                  );
                                },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTimePicker(
    BuildContext sheetContext,
    String label,
    TimeOfDay time,
    Function(TimeOfDay) onChanged,
  ) {
    final ThemeData theme = Theme.of(sheetContext);
    final ColorScheme scheme = theme.colorScheme;

    return GestureDetector(
      onTap: () async {
        final picked = await showTimePicker(
          context: sheetContext,
          initialTime: time,
        );
        if (picked != null) {
          onChanged(picked);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(AllySpacing.md),
        decoration: BoxDecoration(
          color: scheme.surface,
          borderRadius: AllyRadius.smAll,
          border: Border.all(color: scheme.outlineVariant),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: AllyTypography.caption(color: scheme.onSurfaceVariant),
            ),
            const SizedBox(height: 2),
            Text(
              '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}',
              style: AllyTypography.metric(size: 24, color: scheme.onSurface),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;
    final AllySemanticPalette semantics = context.allySemantics;
    final sleepColor = semantics.sleep;

    final healthProvider = Provider.of<HealthProvider>(context);
    final healthData = healthProvider.healthData;
    final hoursSlept = healthData.sleepHours;
    final goalHours = healthData.sleepGoal > 0 ? healthData.sleepGoal : 8.0;

    return Scaffold(
      appBar: AllyAppBar(
        title: l10n.sleep,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_rounded),
            onPressed: _showSleepSetupDialog,
            tooltip: l10n.automaticSleepTracking,
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AllySpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Duration overview ───────────────────────────────────────
              AllyCard(
                padding: const EdgeInsets.all(AllySpacing.xxl),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: AllyDimensions.iconChip,
                          height: AllyDimensions.iconChip,
                          decoration: BoxDecoration(
                            color: sleepColor.withValues(alpha: 0.14),
                            borderRadius: AllyRadius.smAll,
                          ),
                          child: Icon(
                            Icons.bedtime_rounded,
                            color: sleepColor,
                            size: AllyDimensions.iconSm,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AllySpacing.xl),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          hoursSlept.toStringAsFixed(1),
                          style: AllyTypography.metric(
                            size: 56,
                            color: scheme.onSurface,
                            weight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(width: AllySpacing.md),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Text(
                            l10n.ofHoursGoal(goalHours.toStringAsFixed(0)),
                            style: AllyTypography.body(
                              size: 16,
                              color: scheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AllySpacing.xl),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(2),
                      child: LinearProgressIndicator(
                        value: (hoursSlept / goalHours).clamp(0.0, 1.0),
                        minHeight: 6,
                        backgroundColor: scheme.outlineVariant,
                        valueColor: AlwaysStoppedAnimation<Color>(sleepColor),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AllySpacing.section),
              _buildSleepStats(),
              const SizedBox(height: AllySpacing.section),
              AllySectionHeader(title: l10n.sleepSegments),
              const SizedBox(height: AllySpacing.lg),
              _buildSleepSegmentsList(),
              const SizedBox(height: AllySpacing.huge),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSleepStats() {
    final l10n = AppLocalizations.of(context)!;
    final AllySemanticPalette semantics = context.allySemantics;

    return FutureBuilder<List<dynamic>>(
      future: Future.wait([
        _sleepService.getTodaySegments(),
        _sleepService.getWakeUpCount(),
      ]),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox(height: 72);
        }

        final segments = snapshot.data![0] as List;
        final wakeUpCount = snapshot.data![1] as int;

        return Row(
          children: [
            Expanded(
              child: _SleepStatCard(
                icon: Icons.nightlight_round,
                iconColor: semantics.sleep,
                value: '${segments.length}',
                label: l10n.sleepCycles,
              ),
            ),
            const SizedBox(width: AllySpacing.md),
            Expanded(
              child: _SleepStatCard(
                icon: Icons.wb_sunny_outlined,
                iconColor: semantics.nutrition,
                value: '$wakeUpCount',
                label: l10n.wakeUps,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSleepSegmentsList() {
    final l10n = AppLocalizations.of(context)!;
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;
    final AllySemanticPalette semantics = context.allySemantics;
    final sleepColor = semantics.sleep;

    return FutureBuilder<List<dynamic>>(
      future: _sleepService.getTodaySegments(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox(height: 72);
        }

        final segments = snapshot.data!;

        if (segments.isEmpty) {
          return AllyEmptyState(
            icon: Icons.bedtime_outlined,
            title: l10n.noSleepDataYet,
            message: l10n.sleepTrackingWillStartTonight,
            compact: true,
          );
        }

        return Column(
          children: List.generate(segments.length, (index) {
            final segment = segments[index];
            final isActive = segment.endTime == null;
            final duration = segment.durationInMinutes;
            final hours = duration ~/ 60;
            final minutes = duration % 60;

            return Container(
              margin: EdgeInsets.only(
                bottom: index < segments.length - 1 ? AllySpacing.md : 0,
              ),
              child: AllyCard(
                elevated: isActive,
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(AllySpacing.md),
                      decoration: BoxDecoration(
                        color: isActive
                            ? sleepColor.withValues(alpha: 0.14)
                            : scheme.onSurface.withValues(alpha: 0.06),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isActive ? Icons.bedtime : Icons.check,
                        color: isActive ? sleepColor : scheme.onSurfaceVariant,
                        size: AllyDimensions.iconSm,
                      ),
                    ),
                    const SizedBox(width: AllySpacing.lg),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isActive
                                ? l10n.currentlySleeping
                                : l10n.sleepSegmentNumber(index + 1),
                            style: AllyTypography.label(
                              size: 15,
                              color: isActive ? sleepColor : scheme.onSurface,
                            ),
                          ),
                          Text(
                            '${_formatTime(segment.startTime)} - ${segment.endTime != null ? _formatTime(segment.endTime!) : l10n.nowLabel}',
                            style: AllyTypography.caption(
                              color: scheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      l10n.hoursMinutes(hours, minutes),
                      style: AllyTypography.label(
                        size: 15,
                        color: isActive ? sleepColor : scheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        );
      },
    );
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}

class _SleepStatCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String value;
  final String label;

  const _SleepStatCard({
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;

    return AllyCard(
      child: Column(
        children: [
          Icon(icon, color: iconColor, size: AllyDimensions.iconXl),
          const SizedBox(height: AllySpacing.md),
          Text(
            value,
            style: AllyTypography.metric(size: 30, color: scheme.onSurface),
          ),
          Text(
            label,
            textAlign: TextAlign.center,
            style: AllyTypography.caption(color: scheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}
