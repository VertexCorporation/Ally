import 'dart:async';
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
  bool _isScreenActive = true;
  int _checkCount = 0;

  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {
    print('🌙 Sleep tracker foreground service started');
    
    // Load settings
    final prefs = await SharedPreferences.getInstance();
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
      print('🌙 Entered sleep window at ${now.hour}:${now.minute}');
      
      // Wait 2 minutes, then start checking for inactivity
      await Future.delayed(const Duration(minutes: 2));
      _checkInactivity();
    } else if (!isInWindow && _isInSleepWindow) {
      // Exited sleep window
      _isInSleepWindow = false;
      _sleepStartTime = null;
      print('☀️ Exited sleep window');
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
      print('📱 Phone still active, checking again in 10 min');
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
    print('😴 Sleep detected at ${_sleepStartTime!.hour}:${_sleepStartTime!.minute}');

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
    
    print('☀️ Wake up detected at ${wakeTime.hour}:${wakeTime.minute}');
    print('💤 Sleep duration: ${sleepDuration.inHours}h ${sleepDuration.inMinutes % 60}m');

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
    print('🌙 Sleep tracker service stopped');
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
        _isScreenActive = true;
      } else if (data['action'] == 'screen_off') {
        _isScreenActive = false;
      }
    }
  }
}
