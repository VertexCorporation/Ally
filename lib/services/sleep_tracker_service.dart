import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'sleep_foreground_handler.dart';

class SleepSegment {
  final DateTime startTime;
  DateTime? endTime;

  SleepSegment({required this.startTime, this.endTime});

  int get durationInMinutes {
    if (endTime == null) return 0;
    return endTime!.difference(startTime).inMinutes;
  }

  Map<String, dynamic> toJson() => {
    'start': startTime.toIso8601String(),
    'end': endTime?.toIso8601String(),
  };

  factory SleepSegment.fromJson(Map<String, dynamic> json) {
    return SleepSegment(
      startTime: DateTime.parse(json['start']),
      endTime: json['end'] != null ? DateTime.parse(json['end']) : null,
    );
  }
}

class SleepTrackerService {
  static final SleepTrackerService _instance = SleepTrackerService._internal();
  factory SleepTrackerService() => _instance;
  SleepTrackerService._internal();

  static const int inactivityThresholdMinutes = 30;
  static const int checkIntervalSeconds = 60;

  Timer? _checkTimer;
  bool _isTracking = false;

  TimeOfDay? _sleepStartSchedule;
  TimeOfDay? _sleepEndSchedule;

  DateTime _lastActivityTime = DateTime.now();
  bool _isCurrentlySleeping = false;

  List<SleepSegment> _todaySegments = [];
  SleepSegment? _currentSegment;

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final enabled = prefs.getBool('sleep_tracking_enabled') ?? false;

    if (enabled) {
      final startHour = prefs.getInt('sleep_start_hour') ?? 23;
      final startMinute = prefs.getInt('sleep_start_minute') ?? 0;
      final endHour = prefs.getInt('sleep_end_hour') ?? 7;
      final endMinute = prefs.getInt('sleep_end_minute') ?? 0;

      _sleepStartSchedule = TimeOfDay(hour: startHour, minute: startMinute);
      _sleepEndSchedule = TimeOfDay(hour: endHour, minute: endMinute);
      _isTracking = true;

      await _loadTodaySegments();
      await _startForegroundService();
      _startPeriodicCheck();

      print('🌙 Sleep tracking resumed from saved settings');
    }
  }

  Future<void> startTracking(TimeOfDay sleepStart, TimeOfDay sleepEnd) async {
    _sleepStartSchedule = sleepStart;
    _sleepEndSchedule = sleepEnd;
    _isTracking = true;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('sleep_start_hour', sleepStart.hour);
    await prefs.setInt('sleep_start_minute', sleepStart.minute);
    await prefs.setInt('sleep_end_hour', sleepEnd.hour);
    await prefs.setInt('sleep_end_minute', sleepEnd.minute);
    await prefs.setBool('sleep_tracking_enabled', true);

    await _startForegroundService();
    _startPeriodicCheck();
  }

  void _startPeriodicCheck() {
    _checkTimer?.cancel();
    _checkTimer = Timer.periodic(
      Duration(seconds: checkIntervalSeconds),
      (_) => _checkSleepStatus(),
    );
  }

  Future<void> _checkSleepStatus() async {
    if (!_isTracking) return;

    final now = DateTime.now();
    final isInSleepWindow = _isInSleepTimeWindow(now);

    if (!isInSleepWindow) {
      if (_isCurrentlySleeping) {
        await _endCurrentSleepSegment();
      }
      return;
    }

    final minutesSinceActivity = now.difference(_lastActivityTime).inMinutes;
    final shouldBeSleeping = minutesSinceActivity >= inactivityThresholdMinutes;

    if (shouldBeSleeping && !_isCurrentlySleeping) {
      await _startNewSleepSegment();
    } else if (!shouldBeSleeping && _isCurrentlySleeping) {
      await _endCurrentSleepSegment();
    }

    await _updateNotification();
  }

  Future<void> _startNewSleepSegment() async {
    final sleepStartTime = _lastActivityTime.add(Duration(minutes: inactivityThresholdMinutes));

    _currentSegment = SleepSegment(startTime: sleepStartTime);
    _todaySegments.add(_currentSegment!);
    _isCurrentlySleeping = true;

    await _saveSegments();
    await _updateHealthProvider();

    print('😴 Sleep segment started at ${sleepStartTime.hour}:${sleepStartTime.minute}');
  }

  Future<void> _endCurrentSleepSegment() async {
    if (_currentSegment == null) return;

    _currentSegment!.endTime = DateTime.now();
    _isCurrentlySleeping = false;

    await _saveSegments();
    await _updateHealthProvider();

    print('⏰ Sleep segment ended. Duration: ${_currentSegment!.durationInMinutes} minutes');
    _currentSegment = null;
  }

  bool _isInSleepTimeWindow(DateTime now) {
    if (_sleepStartSchedule == null || _sleepEndSchedule == null) return false;

    final currentMinutes = now.hour * 60 + now.minute;
    final startMinutes = _sleepStartSchedule!.hour * 60 + _sleepStartSchedule!.minute;
    final endMinutes = _sleepEndSchedule!.hour * 60 + _sleepEndSchedule!.minute;

    if (startMinutes < endMinutes) {
      return currentMinutes >= startMinutes && currentMinutes < endMinutes;
    } else {
      return currentMinutes >= startMinutes || currentMinutes < endMinutes;
    }
  }

  Future<void> _saveSegments() async {
    final prefs = await SharedPreferences.getInstance();
    final today = _getTodayDateString();

    final segmentsJson = _todaySegments.map((s) => s.toJson()).toList();
    final jsonString = jsonEncode(segmentsJson);
    await prefs.setString('sleep_segments_$today', jsonString);

    print('💾 Saved ${_todaySegments.length} segments');
  }

  Future<void> _loadTodaySegments() async {
    final prefs = await SharedPreferences.getInstance();
    final today = _getTodayDateString();
    final segmentsStr = prefs.getString('sleep_segments_$today');

    if (segmentsStr != null && segmentsStr.isNotEmpty) {
      try {
        final List<dynamic> jsonList = jsonDecode(segmentsStr);
        _todaySegments = jsonList.map((json) => SleepSegment.fromJson(json)).toList();

        final openSegment = _todaySegments.where((s) => s.endTime == null).firstOrNull;
        if (openSegment != null) {
          _currentSegment = openSegment;
          _isCurrentlySleeping = true;
        }

        print('📂 Loaded ${_todaySegments.length} segments');
      } catch (e) {
        print('Error loading segments: $e');
        _todaySegments = [];
      }
    } else {
      _todaySegments = [];
    }
  }

  String _getTodayDateString() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  int getTotalSleepMinutesToday() {
    return _todaySegments.fold(0, (sum, segment) => sum + segment.durationInMinutes);
  }

  Future<void> _updateHealthProvider() async {
    final totalMinutes = getTotalSleepMinutesToday();
    final totalHours = totalMinutes / 60.0;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('today_sleep_hours', totalHours);
  }

  Future<void> _updateNotification() async {
    if (!_isTracking) return;

    final totalMinutes = getTotalSleepMinutesToday();
    final hours = totalMinutes ~/ 60;
    final minutes = totalMinutes % 60;

    String notificationText;
    if (_isCurrentlySleeping) {
      notificationText = '😴 Sleeping now • Total: ${hours}h ${minutes}m';
    } else {
      final minutesSinceActivity = DateTime.now().difference(_lastActivityTime).inMinutes;
      notificationText = '👀 Awake ${minutesSinceActivity}m • Total: ${hours}h ${minutes}m';
    }

    await FlutterForegroundTask.updateService(
      notificationTitle: '🌙 Sleep Tracker',
      notificationText: notificationText,
    );
  }

  Future<void> _startForegroundService() async {
    FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        channelId: 'sleep_tracker_channel',
        channelName: 'Sleep Tracker',
        channelDescription: 'Tracks your sleep automatically in the background',
        channelImportance: NotificationChannelImportance.LOW,
        priority: NotificationPriority.LOW,
      ),
      iosNotificationOptions: const IOSNotificationOptions(
        showNotification: true,
        playSound: false,
      ),
      foregroundTaskOptions: ForegroundTaskOptions(
        eventAction: ForegroundTaskEventAction.repeat(60000),
        autoRunOnBoot: true,
        autoRunOnMyPackageReplaced: true,
        allowWakeLock: true,
        allowWifiLock: false,
      ),
    );

    final batteryOptStatus = await FlutterForegroundTask.isIgnoringBatteryOptimizations;
    if (batteryOptStatus != null && batteryOptStatus == false) {
      await FlutterForegroundTask.requestIgnoreBatteryOptimization();
    }

    final result = await FlutterForegroundTask.startService(
      serviceId: 256,
      notificationTitle: '🌙 Sleep Tracker Active',
      notificationText: 'Monitoring your sleep pattern',
      callback: startSleepCallback,
    );

    print('✅ Sleep tracker foreground service started: ${result.runtimeType}');
  }

  Future<void> stopTracking() async {
    _isTracking = false;
    _checkTimer?.cancel();

    if (_isCurrentlySleeping) {
      await _endCurrentSleepSegment();
    }

    await FlutterForegroundTask.stopService();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('sleep_tracking_enabled', false);

    print('🛑 Sleep tracking stopped');
  }

  void onScreenOn() {
    _lastActivityTime = DateTime.now();
    FlutterForegroundTask.sendDataToTask({'action': 'activity'});

    if (_isTracking) {
      _checkSleepStatus();
    }
  }

  void onScreenOff() {
    _lastActivityTime = DateTime.now();
    FlutterForegroundTask.sendDataToTask({'action': 'screen_off'});
  }

  Future<Map<String, dynamic>?> getLastSleepData() async {
    final prefs = await SharedPreferences.getInstance();
    final startStr = prefs.getString('last_sleep_start');
    final endStr = prefs.getString('last_sleep_end');
    final duration = prefs.getInt('last_sleep_duration');

    if (startStr == null || endStr == null || duration == null) return null;

    return {
      'start': DateTime.parse(startStr),
      'end': DateTime.parse(endStr),
      'duration': Duration(minutes: duration),
    };
  }

  Future<List<SleepSegment>> getTodaySegments() async {
    await _loadTodaySegments();
    return List.from(_todaySegments);
  }

  Future<int> getWakeUpCount() async {
    await _loadTodaySegments();
    return _todaySegments.length > 1 ? _todaySegments.length - 1 : 0;
  }

  Future<void> addTestSegment(DateTime start, DateTime end) async {
    final segment = SleepSegment(startTime: start, endTime: end);
    _todaySegments.add(segment);
    await _saveSegments();
    await _updateHealthProvider();
  }

  Future<List<Map<String, dynamic>>> getSleepHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final history = prefs.getStringList('sleep_history') ?? [];

    return history.map((entry) {
      final parts = entry.split('|');
      return {
        'start': DateTime.parse(parts[0]),
        'end': DateTime.parse(parts[1]),
        'duration': Duration(minutes: int.parse(parts[2])),
      };
    }).toList();
  }

  void dispose() {
    _checkTimer?.cancel();
  }
}
