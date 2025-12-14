import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import '../models/workout_program.dart';
import '../models/exercise.dart';
import '../providers/health_provider.dart';
import '../utils/notification_helper.dart';
import '../l10n/app_localizations.dart';

class ActiveWorkoutScreen extends StatefulWidget {
  final WorkoutProgram program;

  const ActiveWorkoutScreen({
    super.key,
    required this.program,
  });

  @override
  State<ActiveWorkoutScreen> createState() => _ActiveWorkoutScreenState();
}

class _ActiveWorkoutScreenState extends State<ActiveWorkoutScreen> {
  int currentExerciseIndex = 0;
  Map<String, List<bool>> completedSets = {};
  Map<String, List<Map<String, dynamic>>> modifiedSets = {};
  bool isResting = false;
  int restSecondsRemaining = 0;
  Timer? restTimer;

  @override
  void initState() {
    super.initState();
    // Initialize all sets as not completed and copy original set data
    for (var exercise in widget.program.exercises) {
      completedSets[exercise.exerciseId] = List.filled(exercise.sets.length, false);
      modifiedSets[exercise.exerciseId] = exercise.sets.map((set) => {
        'reps': set.reps,
        'weight': set.weight,
        'restSeconds': set.restSeconds,
      }).toList();
    }
  }

  @override
  void dispose() {
    restTimer?.cancel();
    super.dispose();
  }

  void _startRestTimer(int seconds) {
    setState(() {
      isResting = true;
      restSecondsRemaining = seconds;
    });

    restTimer?.cancel();
    restTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (restSecondsRemaining > 0) {
          restSecondsRemaining--;
        } else {
          isResting = false;
          timer.cancel();
        }
      });
    });
  }

  void _skipRest() {
    restTimer?.cancel();
    setState(() {
      isResting = false;
      restSecondsRemaining = 0;
    });
  }

  void _editSet(String exerciseId, int setIndex) {
    final setData = modifiedSets[exerciseId]![setIndex];
    final repsController = TextEditingController(text: setData['reps'].toString());
    final weightController = TextEditingController(text: setData['weight'].toStringAsFixed(1));

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext dialogContext) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(dialogContext).viewInsets.bottom,
        ),
        child: Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFE57373).withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.edit, color: Color(0xFFE57373), size: 32),
              ),
              const SizedBox(height: 16),
              Text(
                AppLocalizations.of(dialogContext)!.editSetNumber(setIndex + 1),
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(dialogContext)!.reps,
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: repsController,
                          keyboardType: TextInputType.number,
                          autofocus: true,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Theme.of(context).cardColor,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(dialogContext)!.weightWithUnit(
                            Provider.of<HealthProvider>(context, listen: false).healthData.units == 'imperial' ? 'lbs' : 'kg'
                          ),
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: weightController,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Theme.of(context).cardColor,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Navigator.pop(dialogContext),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: const Text(
                          'Cancel',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        final newReps = int.tryParse(repsController.text);
                        final newWeight = double.tryParse(weightController.text);

                        if (newReps != null && newWeight != null) {
                          setState(() {
                            modifiedSets[exerciseId]![setIndex]['reps'] = newReps;
                            modifiedSets[exerciseId]![setIndex]['weight'] = newWeight;
                          });
                          Navigator.pop(dialogContext);
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE57373),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          AppLocalizations.of(dialogContext)!.save,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
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

  void _toggleSetCompletion(String exerciseId, int setIndex, int restSeconds) {
    setState(() {
      final currentValue = completedSets[exerciseId]![setIndex];
      completedSets[exerciseId]![setIndex] = !currentValue;

      // Start rest timer if set is now completed and not the last set
      if (!currentValue && restSeconds > 0) {
        _startRestTimer(restSeconds);
      }
    });
  }

  bool _isExerciseComplete(String exerciseId) {
    return completedSets[exerciseId]?.every((completed) => completed) ?? false;
  }

  bool _isWorkoutComplete() {
    return completedSets.values.every((sets) => sets.every((completed) => completed));
  }

  void _moveToNextExercise() {
    if (currentExerciseIndex < widget.program.exercises.length - 1) {
      setState(() {
        currentExerciseIndex++;
      });
    }
  }

  void _moveToPreviousExercise() {
    if (currentExerciseIndex > 0) {
      setState(() {
        currentExerciseIndex--;
      });
    }
  }

  void _showFinishConfirmation() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext dialogContext) => Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFE57373).withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.warning_rounded, color: Color(0xFFE57373), size: 32),
            ),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(dialogContext)!.workoutNotComplete,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              AppLocalizations.of(dialogContext)!.workoutNotCompleteMessage,
              style: TextStyle(fontSize: 14, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => Navigator.pop(dialogContext),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: Text(
                        AppLocalizations.of(dialogContext)!.cancel,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(dialogContext);
                      _finishWorkout();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE57373),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        AppLocalizations.of(dialogContext)!.finishAnyway,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _finishWorkout() async {
    final healthProvider = Provider.of<HealthProvider>(context, listen: false);
    final now = DateTime.now();
    final lastDate = healthProvider.healthData.lastExerciseDate;

    // Update exercise streak
    if (lastDate == null ||
        lastDate.year != now.year ||
        lastDate.month != now.month ||
        lastDate.day != now.day) {
      healthProvider.updateExerciseStreak(healthProvider.healthData.exerciseStreak + 1);
    }

    // Log the workout program with full details (only completed sets)
    final exercisesData = <Map<String, dynamic>>[];
    for (var programExercise in widget.program.exercises) {
      final exercise = ExerciseLibrary.getExerciseById(programExercise.exerciseId);
      if (exercise != null) {
        final allSets = modifiedSets[programExercise.exerciseId];
        final completedSetsList = completedSets[programExercise.exerciseId];

        // Only include completed sets
        final completedSetsData = <Map<String, dynamic>>[];
        for (int i = 0; i < allSets!.length; i++) {
          if (completedSetsList![i]) {
            completedSetsData.add(allSets[i]);
          }
        }

        // Only add exercise if it has at least one completed set
        if (completedSetsData.isNotEmpty) {
          exercisesData.add({
            'id': exercise.id,
            'name': exercise.name,
            'iconCodePoint': exercise.icon.codePoint,
            'sets': completedSetsData,
          });
        }
      }
    }

    healthProvider.addWorkoutProgramToLog(widget.program.name, exercisesData);

    if (mounted) {
      Navigator.pop(context);
      NotificationHelper.showSuccess(
        context,
        AppLocalizations.of(context)!.workoutCompleted,
        widget.program.name,
        backgroundColor: const Color(0xFFE57373),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentProgramExercise = widget.program.exercises[currentExerciseIndex];
    final currentExercise = ExerciseLibrary.getExerciseById(currentProgramExercise.exerciseId);

    if (currentExercise == null) {
      return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Center(
          child: Text(AppLocalizations.of(context)!.exerciseNotFound),
        ),
      );
    }

    final isCurrentExerciseComplete = _isExerciseComplete(currentProgramExercise.exerciseId);
    final isLastExercise = currentExerciseIndex == widget.program.exercises.length - 1;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, color: Colors.black, size: 32),
          onPressed: () {
            showModalBottomSheet(
              context: context,
              backgroundColor: Colors.transparent,
              builder: (BuildContext dialogContext) => Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEF5350).withOpacity(0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.exit_to_app_rounded, color: Color(0xFFEF5350), size: 32),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      AppLocalizations.of(dialogContext)!.exitWorkout,
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      AppLocalizations.of(dialogContext)!.progressNotSaved,
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => Navigator.pop(dialogContext),
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Theme.of(context).cardColor,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: Colors.grey[300]!),
                              ),
                              child: Text(
                                AppLocalizations.of(dialogContext)!.cancel,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(dialogContext);
                              Navigator.pop(context);
                            },
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEF5350),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                AppLocalizations.of(dialogContext)!.exit,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
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
        title: Text(
          widget.program.name,
          style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color, fontWeight: FontWeight.bold),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              if (_isWorkoutComplete()) {
                _finishWorkout();
              } else {
                _showFinishConfirmation();
              }
            },
            child: Container(
              margin: const EdgeInsets.only(right: 16),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFE57373),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(AppLocalizations.of(context)!.finish, style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Progress indicator
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.exerciseProgress(currentExerciseIndex + 1, widget.program.exercises.length),
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        AppLocalizations.of(context)!.percentComplete(_calculateProgress()),
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF81C784),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: _calculateProgress() / 100,
                      backgroundColor: Colors.grey[300],
                      valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF81C784)),
                      minHeight: 8,
                    ),
                  ),
                ],
              ),
            ),

            // Rest Timer Overlay
            if (isResting)
              Container(
                margin: const EdgeInsets.all(20),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFF64B5F6),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF64B5F6).withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white70,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(Icons.timer, color: Colors.white),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.restTime,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white70,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _formatTime(restSecondsRemaining),
                            style: const TextStyle(
                              fontSize: 32,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: _skipRest,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          AppLocalizations.of(context)!.skip,
                          style: TextStyle(
                            color: Color(0xFF64B5F6),
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            // Exercise Card
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Exercise Header
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE57373),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFE57373).withOpacity(0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white70,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  currentExercise.icon, color: Colors.white,
                                  size: 32,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      currentExercise.name,
                                      style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    if (currentExercise.equipment != null)
                                      Text(
                                        currentExercise.equipment!,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.white70,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              if (isCurrentExerciseComplete)
                                Icon(
                                  Icons.check_circle, color: Colors.white),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Sets List
                    Text(
                      AppLocalizations.of(context)!.sets,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),

                    ...List.generate(currentProgramExercise.sets.length, (setIndex) {
                      final setData = modifiedSets[currentProgramExercise.exerciseId]![setIndex];
                      final isCompleted = completedSets[currentProgramExercise.exerciseId]![setIndex];

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: GestureDetector(
                          onTap: () => _toggleSetCompletion(
                            currentProgramExercise.exerciseId,
                            setIndex,
                            setData['restSeconds'] as int,
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: isCompleted ? const Color(0xFF81C784) : Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isCompleted ? const Color(0xFF81C784) : (Theme.of(context).brightness == Brightness.dark ? Colors.grey[700]! : Colors.grey[300]!),
                                width: 2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    color: isCompleted
                                        ? Colors.white
                                        : const Color(0xFFE57373).withOpacity(0.15),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Text(
                                      '${setIndex + 1}',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: isCompleted ? const Color(0xFF81C784) : const Color(0xFFE57373),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Row(
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${setData['reps']} ${AppLocalizations.of(context)!.repsLowercase}',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: isCompleted ? Colors.white : Theme.of(context).textTheme.bodyLarge?.color,
                                            ),
                                          ),
                                          if ((setData['weight'] as double) > 0)
                                            Text(
                                              '${setData['weight']} ${AppLocalizations.of(context)!.kgUnit}',
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: isCompleted ? Colors.white70 : Colors.grey[600],
                                              ),
                                            ),
                                        ],
                                      ),
                                      const Spacer(),
                                      if ((setData['restSeconds'] as int) > 0)
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                          decoration: BoxDecoration(
                                            color: isCompleted
                                                ? Colors.white70
                                                : const Color(0xFF64B5F6).withOpacity(0.15),
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.timer,
                                                size: 16,
                                                color: isCompleted ? Colors.white : const Color(0xFF64B5F6),
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                AppLocalizations.of(context)!.restSeconds(setData['restSeconds']),
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600,
                                                  color: isCompleted ? Colors.white : const Color(0xFF64B5F6),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 12),
                                if (!isCompleted)
                                  GestureDetector(
                                    onTap: () => _editSet(currentProgramExercise.exerciseId, setIndex),
                                    child: Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFE57373).withOpacity(0.15),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Icon(
                                        Icons.edit,
                                        color: Color(0xFFE57373),
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                const SizedBox(width: 8),
                                Icon(
                                  isCompleted ? Icons.check_circle : Icons.circle_outlined,
                                  color: isCompleted ? Colors.white : Colors.grey[400],
                                  size: 28,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),

                    const SizedBox(height: 24),

                    // Navigation buttons
                    Row(
                      children: [
                        if (currentExerciseIndex > 0)
                          Expanded(
                            child: GestureDetector(
                              onTap: _moveToPreviousExercise,
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).cardColor,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: Colors.grey[300]!),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.arrow_back, color: Colors.black),
                                    SizedBox(width: 8),
                                    Text(
                                      AppLocalizations.of(context)!.previous,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        if (currentExerciseIndex > 0 && !isLastExercise)
                          const SizedBox(width: 12),
                        if (!isLastExercise)
                          Expanded(
                            child: GestureDetector(
                              onTap: _moveToNextExercise,
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE57373),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      AppLocalizations.of(context)!.next,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Icon(Icons.arrow_forward, color: Colors.white),
                                  ],
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
          ],
        ),
      ),
    );
  }

  int _calculateProgress() {
    int totalSets = 0;
    int completedSetsCount = 0;

    completedSets.forEach((exerciseId, sets) {
      totalSets += sets.length;
      completedSetsCount += sets.where((completed) => completed).length;
    });

    if (totalSets == 0) return 0;
    return ((completedSetsCount / totalSets) * 100).round();
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}
