import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:shared_preferences/shared_preferences.dart';

@pragma('vm:entry-point')
void startSleepCallback() {
  FlutterForegroundTask.setTaskHandler(SleepForegroundHandler());
}

class SleepForegroundHandler extends TaskHandler {
  Timer? _checkTimer;
  DateTime? _sleepStartTime;
  DateTime? _lastActivityTime;
  bool _isInSleepWindow = false;
  int _checkCount = 0;

  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {
    debugPrint('🌙 Sleep tracker foreground service started');
    
    // Load settings
    _lastActivityTime = DateTime.now();
    
    // Check sleep window every minute
    _checkTimer = Timer.periodic(const Duration(minutes: 1), (timer) async {
      await _checkSleepWindow();
    });
  }

  @override
  void onRepeatEvent(DateTime timestamp) async {
    // This is called every minute by the foreground task
    _checkCount++;
    
    // Send data to UI if needed
    FlutterForegroundTask.sendDataToMain({
      'action': 'update',
      'timestamp': timestamp.toIso8601String(),
      'checkCount': _checkCount,
      'isInSleepWindow': _isInSleepWindow,
      'isSleeping': _sleepStartTime != null,
    });
  }

  Future<void> _checkSleepWindow() async {
    final prefs = await SharedPreferences.getInstance();
    final enabled = prefs.getBool('sleep_tracking_enabled') ?? false;
    
    if (!enabled) return;

    final startHour = prefs.getInt('sleep_start_hour') ?? 23;
    final startMinute = prefs.getInt('sleep_start_minute') ?? 0;
    final endHour = prefs.getInt('sleep_end_hour') ?? 7;
    final endMinute = prefs.getInt('sleep_end_minute') ?? 0;

    final now = DateTime.now();
    final currentMinutes = now.hour * 60 + now.minute;
    final startMinutes = startHour * 60 + startMinute;
    final endMinutes = endHour * 60 + endMinute;

    bool isInWindow;
    if (startMinutes > endMinutes) {
      // Sleep window crosses midnight (e.g., 23:00 - 07:00)
      isInWindow = currentMinutes >= startMinutes || currentMinutes <= endMinutes;
    } else {
      // Sleep window in same day
      isInWindow = currentMinutes >= startMinutes && currentMinutes <= endMinutes;
    }

    if (isInWindow && !_isInSleepWindow) {
      // Just entered sleep window
      _isInSleepWindow = true;
      debugPrint('🌙 Entered sleep window at ${now.hour}:${now.minute}');
      
      // Wait 2 minutes, then start checking for inactivity
      await Future.delayed(const Duration(minutes: 2));
      _checkInactivity();
    } else if (!isInWindow && _isInSleepWindow) {
      // Exited sleep window
      _isInSleepWindow = false;
      _sleepStartTime = null;
      debugPrint('☀️ Exited sleep window');
    }

    // If sleeping, check for wake up
    if (_sleepStartTime != null) {
      _checkWakeUp();
    }
  }

  void _checkInactivity() async {
    if (!_isInSleepWindow) return;

    // Check if phone is active
    final timeSinceActivity = DateTime.now().difference(_lastActivityTime!);
    final isActive = timeSinceActivity.inMinutes < 2;

    if (isActive) {
      // Still active, check again in 10 minutes
      debugPrint('📱 Phone still active, checking again in 10 min');
      await Future.delayed(const Duration(minutes: 10));
      _checkInactivity();
    } else {
      // Phone inactive - user likely sleeping
      _onSleepDetected();
    }
  }

  void _onSleepDetected() async {
    if (_sleepStartTime != null) return; // Already sleeping

    _sleepStartTime = DateTime.now();
    debugPrint('😴 Sleep detected at ${_sleepStartTime!.hour}:${_sleepStartTime!.minute}');

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('current_sleep_start', _sleepStartTime!.toIso8601String());

    // Update notification
    FlutterForegroundTask.updateService(
      notificationTitle: '😴 Sleep Tracking',
      notificationText: 'Sleeping since ${_sleepStartTime!.hour.toString().padLeft(2, '0')}:${_sleepStartTime!.minute.toString().padLeft(2, '0')}',
    );

    // Notify UI
    FlutterForegroundTask.sendDataToMain({
      'action': 'sleep_started',
      'time': _sleepStartTime!.toIso8601String(),
    });
  }

  void _checkWakeUp() {
    if (_sleepStartTime == null) return;

    // Check if phone became active (screen on, app opened, etc.)
    final timeSinceActivity = DateTime.now().difference(_lastActivityTime!);
    
    if (timeSinceActivity.inMinutes < 2) {
      // Phone is active - user woke up!
      _onWakeUpDetected();
    }
  }

  void _onWakeUpDetected() async {
    if (_sleepStartTime == null) return;

    final wakeTime = DateTime.now();
    final sleepDuration = wakeTime.difference(_sleepStartTime!);
    
    debugPrint('☀️ Wake up detected at ${wakeTime.hour}:${wakeTime.minute}');
    debugPrint('💤 Sleep duration: ${sleepDuration.inHours}h ${sleepDuration.inMinutes % 60}m');

    // Save sleep data
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('last_sleep_start', _sleepStartTime!.toIso8601String());
    await prefs.setString('last_sleep_end', wakeTime.toIso8601String());
    await prefs.setInt('last_sleep_duration', sleepDuration.inMinutes);
    await prefs.remove('current_sleep_start');

    // Add to history
    final history = prefs.getStringList('sleep_history') ?? [];
    history.add('${_sleepStartTime!.toIso8601String()}|${wakeTime.toIso8601String()}|${sleepDuration.inMinutes}');
    if (history.length > 30) {
      history.removeAt(0); // Keep only last 30 records
    }
    await prefs.setStringList('sleep_history', history);

    // Update notification
    FlutterForegroundTask.updateService(
      notificationTitle: '☀️ Good Morning!',
      notificationText: 'Slept ${sleepDuration.inHours}h ${sleepDuration.inMinutes % 60}m',
    );

    // Notify UI
    FlutterForegroundTask.sendDataToMain({
      'action': 'wake_up',
      'sleep_start': _sleepStartTime!.toIso8601String(),
      'wake_time': wakeTime.toIso8601String(),
      'duration': sleepDuration.inMinutes,
    });

    // Reset for next night
    _sleepStartTime = null;
  }

  @override
  void onNotificationPressed() {
    // Open app when notification is tapped
    FlutterForegroundTask.launchApp('/sleep');
  }

  @override
  Future<void> onDestroy(DateTime timestamp) async {
    debugPrint('🌙 Sleep tracker service stopped');
    _checkTimer?.cancel();
  }

  @override
  void onNotificationButtonPressed(String id) {
    // Handle notification button press if needed
  }

  @override
  void onReceiveData(Object data) {
    // Receive data from UI
    if (data is Map) {
      if (data['action'] == 'activity') {
        // User interacted with app - update activity time
        _lastActivityTime = DateTime.now();
      } else if (data['action'] == 'screen_off') {
      }
    }
  }
}

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

      debugPrint('🌙 Sleep tracking resumed from saved settings');
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

    debugPrint('😴 Sleep segment started at ${sleepStartTime.hour}:${sleepStartTime.minute}');
  }

  Future<void> _endCurrentSleepSegment() async {
    if (_currentSegment == null) return;

    _currentSegment!.endTime = DateTime.now();
    _isCurrentlySleeping = false;

    await _saveSegments();
    await _updateHealthProvider();

    debugPrint('⏰ Sleep segment ended. Duration: ${_currentSegment!.durationInMinutes} minutes');
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

    debugPrint('💾 Saved ${_todaySegments.length} segments');
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

        debugPrint('📂 Loaded ${_todaySegments.length} segments');
      } catch (e) {
        debugPrint('Error loading segments: $e');
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
    if (batteryOptStatus == false) {
      await FlutterForegroundTask.requestIgnoreBatteryOptimization();
    }

    final result = await FlutterForegroundTask.startService(
      serviceId: 256,
      notificationTitle: '🌙 Sleep Tracker Active',
      notificationText: 'Monitoring your sleep pattern',
      callback: startSleepCallback,
    );

    debugPrint('✅ Sleep tracker foreground service started: ${result.runtimeType}');
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

    debugPrint('🛑 Sleep tracking stopped');
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
