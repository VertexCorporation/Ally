class HealthData {
  // Water
  int waterGlasses;
  int waterGoal;
  
  // Exercises
  int exerciseStreak;
  int exerciseGoal;
  DateTime? lastExerciseDate;
  
  // Sleep
  double sleepHours;
  double sleepGoal;
  
  // Weight
  double currentWeight;
  double goalWeight;
  double height; // in cm
  
  // Heartbeat
  int currentBpm;
  int goalBpm;
  
  // Nutrition
  int caloriesConsumed;
  int caloriesGoal;
  
  // Steps (Pedometer)
  int currentSteps;
  int stepsGoal;
  
  // Units
  String units; // 'metric' or 'imperial'
  
  // Logs
  List<Map<String, dynamic>> mealLog;
  List<Map<String, dynamic>> exerciseLog;
  List<Map<String, dynamic>> weightHistory;
  
  // BMI calculation
  double get bmi {
    if (height <= 0 || currentWeight <= 0) return 0.0;
    final heightInMeters = height / 100;
    return currentWeight / (heightInMeters * heightInMeters);
  }

  // BMI category
  String get bmiCategory {
    final bmiValue = bmi;
    if (bmiValue == 0) return '';
    if (bmiValue < 18.5) return 'Underweight';
    if (bmiValue < 25.0) return 'Normal';
    if (bmiValue < 30.0) return 'Overweight';
    if (bmiValue < 35.0) return 'Obese I';
    if (bmiValue < 40.0) return 'Obese II';
    return 'Obese III';
  }

  // Health Score (auto-calculated)
  int get healthScore {
    int score = 0;

    // 1. Steps (25%) - Daily step goal
    if (stepsGoal > 0) {
      double stepsPercent = (currentSteps / stepsGoal).clamp(0.0, 1.0);
      score += (stepsPercent * 25).round();
    }

    // 2. Water (25%) - Hydration
    double waterPercent = (waterGlasses / waterGoal).clamp(0.0, 1.0);
    score += (waterPercent * 25).round();

    // 3. Sleep (25%) - Sleep quality
    double sleepPercent = (sleepHours / sleepGoal).clamp(0.0, 1.0);
    score += (sleepPercent * 25).round();

    // 4. Exercise Streak (25%) - Consistency over last 7 days
    double exercisePercent = (exerciseStreak / 7).clamp(0.0, 1.0);
    score += (exercisePercent * 25).round();

    return score.clamp(0, 100);
  }

  HealthData({
    this.waterGlasses = 0,
    this.waterGoal = 8,
    this.exerciseStreak = 0,
    this.exerciseGoal = 30,
    this.lastExerciseDate,
    this.sleepHours = 0,
    this.sleepGoal = 8.0,
    this.currentWeight = 0,
    this.goalWeight = 0,
    this.height = 0,
    this.currentBpm = 0,
    this.goalBpm = 60,
    this.caloriesConsumed = 0,
    this.caloriesGoal = 2000,
    this.currentSteps = 0,
    this.stepsGoal = 6000,
    this.units = 'metric',
    List<Map<String, dynamic>>? mealLog,
    List<Map<String, dynamic>>? exerciseLog,
    List<Map<String, dynamic>>? weightHistory,
  })  : mealLog = mealLog ?? [],
        exerciseLog = exerciseLog ?? [],
        weightHistory = weightHistory ?? [];

  Map<String, dynamic> toJson() {
    return {
      'waterGlasses': waterGlasses,
      'waterGoal': waterGoal,
      'exerciseStreak': exerciseStreak,
      'exerciseGoal': exerciseGoal,
      'lastExerciseDate': lastExerciseDate?.toIso8601String(),
      'sleepHours': sleepHours,
      'sleepGoal': sleepGoal,
      'currentWeight': currentWeight,
      'goalWeight': goalWeight,
      'height': height,
      'currentBpm': currentBpm,
      'goalBpm': goalBpm,
      'caloriesConsumed': caloriesConsumed,
      'caloriesGoal': caloriesGoal,
      'currentSteps': currentSteps,
      'stepsGoal': stepsGoal,
      'units': units,
      'mealLog': mealLog,
      'exerciseLog': exerciseLog,
      'weightHistory': weightHistory,
    };
  }

  factory HealthData.fromJson(Map<String, dynamic> json) {
    return HealthData(
      waterGlasses: json['waterGlasses'] ?? 0,
      waterGoal: json['waterGoal'] ?? 8,
      exerciseStreak: json['exerciseStreak'] ?? 0,
      exerciseGoal: json['exerciseGoal'] ?? 30,
      lastExerciseDate: json['lastExerciseDate'] != null ? DateTime.parse(json['lastExerciseDate']) : null,
      sleepHours: json['sleepHours'] ?? 0,
      sleepGoal: json['sleepGoal'] ?? 8.0,
      currentWeight: json['currentWeight'] ?? 0,
      goalWeight: json['goalWeight'] ?? 0,
      height: json['height'] ?? 0,
      currentBpm: json['currentBpm'] ?? 0,
      goalBpm: json['goalBpm'] ?? 60,
      caloriesConsumed: json['caloriesConsumed'] ?? 0,
      caloriesGoal: json['caloriesGoal'] ?? 2000,
      currentSteps: json['currentSteps'] ?? 0,
      stepsGoal: json['stepsGoal'] ?? 6000,
      units: json['units'] ?? 'metric',
      mealLog: json['mealLog'] != null ? List<Map<String, dynamic>>.from(json['mealLog']) : [],
      exerciseLog: json['exerciseLog'] != null ? List<Map<String, dynamic>>.from(json['exerciseLog']) : [],
      weightHistory: json['weightHistory'] != null ? List<Map<String, dynamic>>.from(json['weightHistory']) : [],
    );
  }
}
