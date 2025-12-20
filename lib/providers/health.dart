import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/health.dart';

class HealthProvider extends ChangeNotifier {
  HealthData _healthData = HealthData();
  Timer? _sleepUpdateTimer;
  Timer? _midnightResetTimer;

  HealthData get healthData => _healthData;

  Future<void> loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final String? healthDataJson = prefs.getString('health_data');
    _units = prefs.getString('units') ?? 'metric';

    if (healthDataJson != null) {
      try {
        final Map<String, dynamic> json = jsonDecode(healthDataJson);
        _healthData = HealthData.fromJson(json);
      } catch (e) {
        debugPrint('Error loading health data: $e');
      }
    }

    await _checkAndResetDailyData();
    await _loadSleepDataFromTracker();
    notifyListeners();

    _startPeriodicSleepUpdate();
    _startMidnightResetTimer();
  }

  Future<void> _checkAndResetDailyData() async {
    final prefs = await SharedPreferences.getInstance();
    final today = _getTodayDateString();
    final lastResetDate = prefs.getString('last_reset_date');

    if (lastResetDate != today) {
      _healthData.currentSteps = 0;
      _healthData.waterGlasses = 0;
      _healthData.caloriesConsumed = 0;

      await prefs.setString('last_reset_date', today);
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
    _sleepUpdateTimer?.cancel();
    _midnightResetTimer?.cancel();
    super.dispose();
  }
  
  // Save data to storage
  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    final String healthDataJson = jsonEncode(_healthData.toJson());
    await prefs.setString('health_data', healthDataJson);
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
    await prefs.setString('user_profile', profileJson);
  }
  
  Future<Map<String, dynamic>?> loadUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final String? profileJson = prefs.getString('user_profile');
    
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
    await prefs.setString('units', units);
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
