class WorkoutProgram {
  final String id;
  final String name;
  final List<ProgramExercise> exercises;
  final DateTime createdAt;

  WorkoutProgram({
    required this.id,
    required this.name,
    required this.exercises,
    required this.createdAt,
  });

  int get totalExercises => exercises.length;

  int get totalSets => exercises.fold(0, (sum, ex) => sum + ex.sets.length);

  int get estimatedDuration {
    // Rough estimate: 3 min per set + rest
    return totalSets * 3;
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'exercises': exercises.map((e) => e.toJson()).toList(),
    'createdAt': createdAt.toIso8601String(),
  };

  factory WorkoutProgram.fromJson(Map<String, dynamic> json) {
    return WorkoutProgram(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      exercises: (json['exercises'] as List?)
          ?.map((e) => ProgramExercise.fromJson(e))
          .toList() ?? [],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }
}

class ProgramExercise {
  final String exerciseId;
  final List<ProgramSet> sets;

  ProgramExercise({
    required this.exerciseId,
    required this.sets,
  });

  Map<String, dynamic> toJson() => {
    'exerciseId': exerciseId,
    'sets': sets.map((s) => s.toJson()).toList(),
  };

  factory ProgramExercise.fromJson(Map<String, dynamic> json) {
    return ProgramExercise(
      exerciseId: json['exerciseId'] ?? '',
      sets: (json['sets'] as List?)
          ?.map((s) => ProgramSet.fromJson(s))
          .toList() ?? [],
    );
  }
}

class ProgramSet {
  final int reps;
  final double weight;
  final int restSeconds;

  ProgramSet({
    required this.reps,
    required this.weight,
    required this.restSeconds,
  });

  Map<String, dynamic> toJson() => {
    'reps': reps,
    'weight': weight,
    'restSeconds': restSeconds,
  };

  factory ProgramSet.fromJson(Map<String, dynamic> json) {
    return ProgramSet(
      reps: json['reps'] ?? 0,
      weight: (json['weight'] ?? 0).toDouble(),
      restSeconds: json['restSeconds'] ?? 60,
    );
  }
}
