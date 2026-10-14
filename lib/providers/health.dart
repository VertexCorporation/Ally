import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/user_records.dart';
import 'dart:convert';
import '../models/health.dart';

class HealthProvider extends ChangeNotifier {
  HealthData _healthData = HealthData();
  Timer? _sleepUpdateTimer;
  Timer? _midnightResetTimer;
  Timer? _stepUpdateTimer;
  StreamSubscription<User?>? _authSubscription;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final UserRecordsService _recordsService = UserRecordsService();
  String? _currentUid;
  bool _hasObservedAuthState = false;

  HealthProvider() {
    _currentUid = _auth.currentUser?.uid;
    loadData();
    _authSubscription = _auth.authStateChanges().listen((user) {
      final nextUid = user?.uid;
      if (nextUid == _currentUid && _hasObservedAuthState) return;

      final previousUid = _currentUid;
      _hasObservedAuthState = true;
      if (nextUid != previousUid) {
        _currentUid = nextUid;
        _healthData = HealthData();
        _units = 'metric';
        loadData();
      }
    });
  }

  HealthData get healthData => _healthData;

  Future<void> loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final uid = _auth.currentUser?.uid;
    if (uid != _currentUid) return;

    // Legacy global keys are read only before auth state has been observed.
    // Once accounts are in use, each account gets an isolated local cache.
    final localKey = uid != null
        ? 'health_data_$uid'
        : (_hasObservedAuthState ? null : 'health_data');
    final unitsKey = uid != null
        ? 'units_$uid'
        : (_hasObservedAuthState ? null : 'units');
    final String? healthDataJson =
        localKey == null ? null : prefs.getString(localKey);
    _units = unitsKey == null ? 'metric' : (prefs.getString(unitsKey) ?? 'metric');

    if (healthDataJson != null) {
      try {
        final Map<String, dynamic> json = jsonDecode(healthDataJson);
        _healthData = HealthData.fromJson(json);
      } catch (e) {
        debugPrint('Error loading health data: $e');
      }
    }

    // Cloud data is authoritative when available. Local state remains available
    // if the device is offline or the cloud read fails.
    if (uid != null) {
      try {
        final cloudData = await _recordsService.loadHealthSnapshot();
        if (_auth.currentUser?.uid != uid || _currentUid != uid) return;
        if (cloudData != null) {
          _healthData = HealthData.fromJson(cloudData);
        }
      } catch (e) {
        debugPrint('Unable to load health snapshot from cloud; using local cache: $e');
      }
    }

    await _checkAndResetDailyData();
    await _loadSleepDataFromTracker();
    notifyListeners();

    _startPeriodicSleepUpdate();
    _startPeriodicStepUpdate();
    _startMidnightResetTimer();
  }

  Future<void> _checkAndResetDailyData() async {
    final prefs = await SharedPreferences.getInstance();
    final today = _getTodayDateString();
    final uid = _auth.currentUser?.uid;
    final resetKey = uid != null
        ? 'last_reset_date_$uid'
        : (_hasObservedAuthState ? null : 'last_reset_date');
    final lastResetDate = resetKey == null ? null : prefs.getString(resetKey);

    if (lastResetDate != today) {
      // Archive the previous day's final snapshot before resetting counters.
      // Failure to reach Firestore must never block the local daily reset.
      if (uid != null && lastResetDate != null) {
        try {
          await _recordsService.saveDailyHealthRecord(
            lastResetDate,
            _healthData.toJson(),
          );
        } catch (e) {
          debugPrint('Unable to archive previous health day: $e');
        }
      }

      _healthData.currentSteps = 0;
      _healthData.waterGlasses = 0;
      _healthData.caloriesConsumed = 0;

      if (resetKey != null) await prefs.setString(resetKey, today);
      await _saveData();

      debugPrint('🔄 Daily data reset for $today');
    }
  }

  String _getTodayDateString() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  void _startPeriodicSleepUpdate() {
    _sleepUpdateTimer?.cancel();
    _sleepUpdateTimer = Timer.periodic(const Duration(minutes: 1), (_) async {
      await _loadSleepDataFromTracker();
      notifyListeners();
    });
  }

  void _startPeriodicStepUpdate() {
    _stepUpdateTimer?.cancel();
    _stepUpdateTimer = Timer.periodic(const Duration(seconds: 3), (_) async {
      await _loadStepsFromNative();
    });
  }

  Future<void> _loadStepsFromNative() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.reload(); // IMPORTANT: fetch fresh data modified by Native Service
    
    final now = DateTime.now();
    final key = 'steps_${now.day}/${now.month}/${now.year}';
    final steps = prefs.getInt(key);
    
    if (steps != null && _healthData.currentSteps != steps) {
      _healthData.currentSteps = steps;
      notifyListeners();
      _saveData();
    }
  }

  void _startMidnightResetTimer() {
    _midnightResetTimer?.cancel();

    // Calculate time until next midnight
    final now = DateTime.now();
    final nextMidnight = DateTime(now.year, now.month, now.day + 1, 0, 0, 0);
    final durationUntilMidnight = nextMidnight.difference(now);

    // Schedule reset at midnight
    _midnightResetTimer = Timer(durationUntilMidnight, () async {
      await _checkAndResetDailyData();
      notifyListeners();

      // Reschedule for next day
      _startMidnightResetTimer();
    });
  }

  Future<void> _loadSleepDataFromTracker() async {
    final prefs = await SharedPreferences.getInstance();
    final sleepHours = prefs.getDouble('today_sleep_hours') ?? 0.0;
    _healthData.sleepHours = sleepHours;
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    _sleepUpdateTimer?.cancel();
    _midnightResetTimer?.cancel();
    _stepUpdateTimer?.cancel();
    super.dispose();
  }
  
  // Save data to storage
  Future<void> _saveData() async {
    final uid = _auth.currentUser?.uid;
    if (uid != _currentUid) return;

    final prefs = await SharedPreferences.getInstance();
    final data = _healthData.toJson();
    final String healthDataJson = jsonEncode(data);
    final localKey = uid != null
        ? 'health_data_$uid'
        : (_hasObservedAuthState ? null : 'health_data');
    if (localKey != null) {
      await prefs.setString(localKey, healthDataJson);
    }

    if (uid != null && _auth.currentUser?.uid == uid) {
      try {
        await _recordsService.saveHealthSnapshot(data);
      } catch (e) {
        debugPrint('Health data saved locally; cloud sync failed: $e');
      }
    }
  }
  
  // Water methods
  void updateWaterGlasses(int glasses) {
    _healthData.waterGlasses = glasses;
    notifyListeners();
    _saveData();
  }
  
  void incrementWater() {
    if (_healthData.waterGlasses < _healthData.waterGoal) {
      _healthData.waterGlasses++;
      notifyListeners();
      _saveData();
    }
  }
  
  void decrementWater() {
    if (_healthData.waterGlasses > 0) {
      _healthData.waterGlasses--;
      notifyListeners();
      _saveData();
    }
  }
  
  // Exercise methods
  void updateExerciseStreak(int streak) {
    _healthData.exerciseStreak = streak;
    _healthData.lastExerciseDate = DateTime.now();
    notifyListeners();
    _saveData();
  }
  
  // Sleep methods
  void updateSleepHours(double hours) {
    _healthData.sleepHours = hours;
    notifyListeners();
    _saveData();
  }
  
  // Weight methods
  void updateWeight(double weight) {
    _healthData.currentWeight = weight;
    // Add to weight history
    _healthData.weightHistory.insert(0, {
      'weight': weight,
      'date': DateTime.now().toIso8601String(),
    });
    notifyListeners();
    _saveData();
  }
  
  void updateGoalWeight(double weight) {
    _healthData.goalWeight = weight;
    notifyListeners();
    _saveData();
  }
  
  // Heartbeat methods
  void updateBpm(int bpm) {
    _healthData.currentBpm = bpm;
    notifyListeners();
    _saveData();
  }
  
  // Nutrition methods
  void updateCalories(int calories) {
    _healthData.caloriesConsumed = calories;
    notifyListeners();
    _saveData();
  }
  
  void addCalories(int calories) {
    _healthData.caloriesConsumed += calories;
    notifyListeners();
    _saveData();
  }
  
  void updateCaloriesGoal(int goal) {
    _healthData.caloriesGoal = goal;
    notifyListeners();
    _saveData();
  }
  
  // Steps methods
  void updateSteps(int steps) {
    _healthData.currentSteps = steps;
    notifyListeners();
    _saveData();
  }
  
  void incrementSteps(int amount) {
    _healthData.currentSteps += amount;
    notifyListeners();
    _saveData();
  }
  
  // Update steps from sensor
  void updateStepsFromSensor(int steps) {
    _healthData.currentSteps = steps;
    notifyListeners();
    _saveData();
  }
  
  void updateStepsGoal(int goal) {
    _healthData.stepsGoal = goal;
    notifyListeners();
    _saveData();
  }
  
  void updateWaterGoal(int goal) {
    _healthData.waterGoal = goal;
    notifyListeners();
    _saveData();
  }

  void addWaterMl(int ml) {
    final glasses = (ml / 250).round();
    _healthData.waterGlasses += glasses;
    notifyListeners();
    _saveData();
  }

  void updateWaterMl(int ml) {
    _healthData.waterGlasses = (ml / 250).round();
    notifyListeners();
    _saveData();
  }

  void updateWaterGoalMl(int ml) {
    _healthData.waterGoal = (ml / 250).round();
    notifyListeners();
    _saveData();
  }
  
  void updateTargetWeight(double weight) {
    _healthData.goalWeight = weight;
    notifyListeners();
    _saveData();
  }

  void updateHeight(double height) {
    _healthData.height = height;
    notifyListeners();
    _saveData();
  }
  
  // User profile methods
  Future<void> saveUserProfile(Map<String, dynamic> profile) async {
    final prefs = await SharedPreferences.getInstance();
    final String profileJson = jsonEncode(profile);
    final uid = _auth.currentUser?.uid;
    final key = uid != null
        ? 'user_profile_$uid'
        : (_hasObservedAuthState ? null : 'user_profile');
    if (key != null) await prefs.setString(key, profileJson);
  }
  
  Future<Map<String, dynamic>?> loadUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final uid = _auth.currentUser?.uid;
    final key = uid != null
        ? 'user_profile_$uid'
        : (_hasObservedAuthState ? null : 'user_profile');
    final String? profileJson = key == null ? null : prefs.getString(key);
    
    if (profileJson != null) {
      try {
        return jsonDecode(profileJson) as Map<String, dynamic>;
      } catch (e) {
        debugPrint('Error loading user profile: $e');
      }
    }
    return null;
  }
  
  Future<bool> isOnboardingCompleted() async {
    final profile = await loadUserProfile();
    return profile?['onboardingCompleted'] == true;
  }
  
  // Units
  String _units = 'metric';
  String get units => _units;

  Future<void> setUnits(String units) async {
    _units = units;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    final uid = _auth.currentUser?.uid;
    final key = uid != null
        ? 'units_$uid'
        : (_hasObservedAuthState ? null : 'units');
    if (key != null) await prefs.setString(key, units);
  }

// Meal log methods
  void addMealToLog(String nameKey, String displayName, int calories, int grams, Color color) {
    _healthData.mealLog.insert(0, {
      'nameKey': nameKey,
      'name': displayName,
      'calories': calories,
      'grams': grams,
      'color': color.toARGB32(),
      'time': DateTime.now().toIso8601String(),
    });
    notifyListeners();
    _saveData();
  }

  // Exercise log methods
  void addExerciseToLog(String nameKey, String displayName, IconData icon, Color color) {
    _healthData.exerciseLog.insert(0, {
      'nameKey': nameKey,
      'name': displayName,
      'iconCodePoint': icon.codePoint,
      'color': color.toARGB32(),
      'time': DateTime.now().toIso8601String(),
    });
    notifyListeners();
    _saveData();
  }

  void addWorkoutProgramToLog(String programName, List<Map<String, dynamic>> exercises) {
    _healthData.exerciseLog.insert(0, {
      'type': 'program',
      'name': programName,
      'exercises': exercises,
      'time': DateTime.now().toIso8601String(),
    });
    notifyListeners();
    _saveData();
  }
}
