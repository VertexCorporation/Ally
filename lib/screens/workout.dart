import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';

import '../models/program.dart';
import '../models/exercise.dart'; // Assuming ExerciseLibrary is here
import '../providers/health.dart';
import '../notifications/introvert.dart'; // The Notification Service
import '../l10n/app_localizations.dart';
import '../theme.dart';
import '../app.dart'; // For InvertedColor extension

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

  // Semantic Colors
  final Color _workoutColor = const Color(0xFFE57373);
  final Color _restColor = const Color(0xFF64B5F6);
  final Color _completedColor = const Color(0xFF81C784);

  @override
  void initState() {
    super.initState();
    // Initialize sets
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

    // Dynamic Dimensions
    final sw = MediaQuery.of(context).size.width;
    final sh = MediaQuery.of(context).size.height;
    final backgroundColor = AppColors.background;
    final cardColor = AppColors.secondaryColor;
    final textColor = AppColors.primaryColor.inverted;
    final hintColor = AppColors.tertiaryColor;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext dialogContext) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(dialogContext).viewInsets.bottom,
        ),
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
                  color: _workoutColor.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.edit, color: _workoutColor, size: sw * 0.08),
              ),
              SizedBox(height: sh * 0.02),
              Text(
                AppLocalizations.of(dialogContext)!.editSetNumber(setIndex + 1),
                style: TextStyle(
                    fontSize: sw * 0.05,
                    fontWeight: FontWeight.bold,
                    color: textColor
                ),
              ),
              SizedBox(height: sh * 0.03),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(dialogContext)!.reps,
                          style: TextStyle(fontSize: sw * 0.035, fontWeight: FontWeight.bold, color: hintColor),
                        ),
                        SizedBox(height: sh * 0.01),
                        TextField(
                          controller: repsController,
                          keyboardType: TextInputType.number,
                          autofocus: true,
                          style: TextStyle(color: textColor),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: cardColor,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(sw * 0.04),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: EdgeInsets.symmetric(horizontal: sw * 0.05, vertical: sh * 0.02),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: sw * 0.04),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(dialogContext)!.weightWithUnit(
                              Provider.of<HealthProvider>(context, listen: false).units == 'imperial' ? 'lbs' : 'kg'
                          ),
                          style: TextStyle(fontSize: sw * 0.035, fontWeight: FontWeight.bold, color: hintColor),
                        ),
                        SizedBox(height: sh * 0.01),
                        TextField(
                          controller: weightController,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          style: TextStyle(color: textColor),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: cardColor,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(sw * 0.04),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: EdgeInsets.symmetric(horizontal: sw * 0.05, vertical: sh * 0.02),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: sh * 0.03),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Navigator.pop(dialogContext),
                      child: Container(
                        padding: EdgeInsets.all(sw * 0.04),
                        decoration: BoxDecoration(
                          color: cardColor,
                          borderRadius: BorderRadius.circular(sw * 0.04),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Text(
                          AppLocalizations.of(dialogContext)!.cancel,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: sw * 0.04,
                            fontWeight: FontWeight.bold,
                            color: hintColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: sw * 0.03),
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
                        padding: EdgeInsets.all(sw * 0.04),
                        decoration: BoxDecoration(
                          color: _workoutColor,
                          borderRadius: BorderRadius.circular(sw * 0.04),
                        ),
                        child: Text(
                          AppLocalizations.of(dialogContext)!.save,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: sw * 0.04,
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
    // Dynamic Dimensions
    final sw = MediaQuery.of(context).size.width;
    final sh = MediaQuery.of(context).size.height;
    final backgroundColor = AppColors.background;
    final cardColor = AppColors.secondaryColor;
    final textColor = AppColors.primaryColor.inverted;
    final hintColor = AppColors.tertiaryColor;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext dialogContext) => Container(
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
                color: _workoutColor.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.warning_rounded, color: _workoutColor, size: sw * 0.08),
            ),
            SizedBox(height: sh * 0.02),
            Text(
              AppLocalizations.of(dialogContext)!.workoutNotComplete,
              style: TextStyle(fontSize: sw * 0.05, fontWeight: FontWeight.bold, color: textColor),
            ),
            SizedBox(height: sh * 0.015),
            Text(
              AppLocalizations.of(dialogContext)!.workoutNotCompleteMessage,
              style: TextStyle(fontSize: sw * 0.035, color: hintColor),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: sh * 0.03),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => Navigator.pop(dialogContext),
                    child: Container(
                      padding: EdgeInsets.all(sw * 0.04),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(sw * 0.04),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Text(
                        AppLocalizations.of(dialogContext)!.cancel,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: sw * 0.04,
                          fontWeight: FontWeight.bold,
                          color: hintColor,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: sw * 0.03),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(dialogContext);
                      _finishWorkout();
                    },
                    child: Container(
                      padding: EdgeInsets.all(sw * 0.04),
                      decoration: BoxDecoration(
                        color: _workoutColor,
                        borderRadius: BorderRadius.circular(sw * 0.04),
                      ),
                      child: Text(
                        AppLocalizations.of(dialogContext)!.finishAnyway,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: sw * 0.04,
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

    // Log the workout program
    final exercisesData = <Map<String, dynamic>>[];
    for (var programExercise in widget.program.exercises) {
      final exercise = ExerciseLibrary.getExerciseById(programExercise.exerciseId);
      if (exercise != null) {
        final allSets = modifiedSets[programExercise.exerciseId];
        final completedSetsList = completedSets[programExercise.exerciseId];

        final completedSetsData = <Map<String, dynamic>>[];
        for (int i = 0; i < allSets!.length; i++) {
          if (completedSetsList![i]) {
            completedSetsData.add(allSets[i]);
          }
        }

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
      // Use IntrovertNotificationService
      context.read<IntrovertNotificationService>().showNotification(
        message: widget.program.name, // "Workout Completed" is implied or can be prefixed
        type: NotificationType.success,
      );
    }
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
    final paddingV = sh * 0.015;

    // Theme Colors
    final backgroundColor = AppColors.background;
    final cardColor = AppColors.secondaryColor;
    final textColor = AppColors.primaryColor.inverted;
    final subTextColor = AppColors.tertiaryColor;

    final currentProgramExercise = widget.program.exercises[currentExerciseIndex];
    final currentExercise = ExerciseLibrary.getExerciseById(currentProgramExercise.exerciseId);

    if (currentExercise == null) {
      return Scaffold(
        backgroundColor: backgroundColor,
        body: Center(
          child: Text(AppLocalizations.of(context)!.exerciseNotFound, style: TextStyle(color: textColor)),
        ),
      );
    }

    final isCurrentExerciseComplete = _isExerciseComplete(currentProgramExercise.exerciseId);
    final isLastExercise = currentExerciseIndex == widget.program.exercises.length - 1;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close_rounded, color: textColor, size: sw * 0.08),
          onPressed: () {
            // Exit confirmation dialog
            showModalBottomSheet(
              context: context,
              backgroundColor: Colors.transparent,
              builder: (BuildContext dialogContext) => Container(
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
                        color: Colors.red.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.exit_to_app_rounded, color: Colors.red, size: sw * 0.08),
                    ),
                    SizedBox(height: sh * 0.02),
                    Text(
                      AppLocalizations.of(dialogContext)!.exitWorkout,
                      style: TextStyle(fontSize: sw * 0.05, fontWeight: FontWeight.bold, color: textColor),
                    ),
                    SizedBox(height: sh * 0.015),
                    Text(
                      AppLocalizations.of(dialogContext)!.progressNotSaved,
                      style: TextStyle(fontSize: sw * 0.035, color: subTextColor),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: sh * 0.03),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => Navigator.pop(dialogContext),
                            child: Container(
                              padding: EdgeInsets.all(sw * 0.04),
                              decoration: BoxDecoration(
                                color: cardColor,
                                borderRadius: BorderRadius.circular(sw * 0.04),
                                border: Border.all(color: AppColors.border),
                              ),
                              child: Text(
                                AppLocalizations.of(dialogContext)!.cancel,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: sw * 0.04,
                                  fontWeight: FontWeight.bold,
                                  color: subTextColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: sw * 0.03),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(dialogContext);
                              Navigator.pop(context);
                            },
                            child: Container(
                              padding: EdgeInsets.all(sw * 0.04),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(sw * 0.04),
                              ),
                              child: Text(
                                AppLocalizations.of(dialogContext)!.exit,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: sw * 0.04,
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
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
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
              margin: EdgeInsets.only(right: sw * 0.04),
              padding: EdgeInsets.symmetric(horizontal: sw * 0.04, vertical: sh * 0.01),
              decoration: BoxDecoration(
                color: _workoutColor,
                borderRadius: BorderRadius.circular(sw * 0.05),
              ),
              child: Text(AppLocalizations.of(context)!.finish, style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: sw * 0.035,
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
              margin: EdgeInsets.symmetric(horizontal: paddingH, vertical: paddingV),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.exerciseProgress(currentExerciseIndex + 1, widget.program.exercises.length),
                        style: TextStyle(
                          fontSize: sw * 0.035,
                          color: subTextColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        AppLocalizations.of(context)!.percentComplete(_calculateProgress()),
                        style: TextStyle(
                          fontSize: sw * 0.035,
                          color: _completedColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: sh * 0.01),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(sw * 0.025),
                    child: LinearProgressIndicator(
                      value: _calculateProgress() / 100,
                      backgroundColor: subTextColor.withValues(alpha: 0.2),
                      valueColor: AlwaysStoppedAnimation<Color>(_completedColor),
                      minHeight: sh * 0.01,
                    ),
                  ),
                ],
              ),
            ),

            // Rest Timer Overlay
            if (isResting)
              Container(
                margin: EdgeInsets.symmetric(horizontal: paddingH, vertical: paddingV),
                padding: EdgeInsets.all(sw * 0.06),
                decoration: BoxDecoration(
                  color: _restColor,
                  borderRadius: BorderRadius.circular(sw * 0.05),
                  boxShadow: [
                    BoxShadow(
                      color: _restColor.withValues(alpha: 0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(sw * 0.03),
                      decoration: BoxDecoration(
                        color: Colors.white70,
                        borderRadius: BorderRadius.circular(sw * 0.03),
                      ),
                      child: Icon(Icons.timer, color: Colors.white, size: sw * 0.06),
                    ),
                    SizedBox(width: sw * 0.04),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.restTime,
                            style: TextStyle(
                              fontSize: sw * 0.035,
                              color: Colors.white70,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: sh * 0.005),
                          Text(
                            _formatTime(restSecondsRemaining),
                            style: TextStyle(
                              fontSize: sw * 0.08,
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
                        padding: EdgeInsets.symmetric(horizontal: sw * 0.05, vertical: sh * 0.015),
                        decoration: BoxDecoration(
                          color: cardColor,
                          borderRadius: BorderRadius.circular(sw * 0.04),
                        ),
                        child: Text(
                          AppLocalizations.of(context)!.skip,
                          style: TextStyle(
                            color: _restColor,
                            fontWeight: FontWeight.bold,
                            fontSize: sw * 0.035,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            // Exercise Card & Sets
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.all(paddingH),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Exercise Header
                    Container(
                      padding: EdgeInsets.all(sw * 0.06),
                      decoration: BoxDecoration(
                        color: _workoutColor,
                        borderRadius: BorderRadius.circular(sw * 0.06),
                        boxShadow: [
                          BoxShadow(
                            color: _workoutColor.withValues(alpha: 0.3),
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
                                padding: EdgeInsets.all(sw * 0.03),
                                decoration: BoxDecoration(
                                  color: Colors.white70,
                                  borderRadius: BorderRadius.circular(sw * 0.03),
                                ),
                                child: Icon(
                                  currentExercise.icon, color: Colors.white,
                                  size: sw * 0.08,
                                ),
                              ),
                              SizedBox(width: sw * 0.04),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      currentExercise.name,
                                      style: TextStyle(
                                        fontSize: sw * 0.06,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    if (currentExercise.equipment != null)
                                      Text(
                                        currentExercise.equipment!,
                                        style: TextStyle(
                                          fontSize: sw * 0.035,
                                          color: Colors.white70,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              if (isCurrentExerciseComplete)
                                Icon(
                                    Icons.check_circle, color: Colors.white, size: sw * 0.08),
                            ],
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: sh * 0.03),

                    // Sets List
                    Text(
                      AppLocalizations.of(context)!.sets,
                      style: TextStyle(
                        fontSize: sw * 0.05,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    SizedBox(height: sh * 0.015),

                    ...List.generate(currentProgramExercise.sets.length, (setIndex) {
                      final setData = modifiedSets[currentProgramExercise.exerciseId]![setIndex];
                      final isCompleted = completedSets[currentProgramExercise.exerciseId]![setIndex];

                      return Container(
                        margin: EdgeInsets.only(bottom: sh * 0.015),
                        child: GestureDetector(
                          onTap: () => _toggleSetCompletion(
                            currentProgramExercise.exerciseId,
                            setIndex,
                            setData['restSeconds'] as int,
                          ),
                          child: Container(
                            padding: EdgeInsets.all(sw * 0.05),
                            decoration: BoxDecoration(
                              color: isCompleted ? _completedColor : cardColor,
                              borderRadius: BorderRadius.circular(sw * 0.04),
                              border: Border.all(
                                color: isCompleted ? _completedColor : AppColors.border,
                                width: 2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: textColor.withValues(alpha: 0.05),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: sw * 0.08,
                                  height: sw * 0.08,
                                  decoration: BoxDecoration(
                                    color: isCompleted
                                        ? Colors.white
                                        : _workoutColor.withValues(alpha: 0.15),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Text(
                                      '${setIndex + 1}',
                                      style: TextStyle(
                                        fontSize: sw * 0.04,
                                        fontWeight: FontWeight.bold,
                                        color: isCompleted ? _completedColor : _workoutColor,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: sw * 0.04),
                                Expanded(
                                  child: Row(
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${setData['reps']} ${AppLocalizations.of(context)!.repsLowercase}',
                                            style: TextStyle(
                                              fontSize: sw * 0.045,
                                              fontWeight: FontWeight.bold,
                                              color: isCompleted ? Colors.white : textColor,
                                            ),
                                          ),
                                          if ((setData['weight'] as double) > 0)
                                            Text(
                                              '${setData['weight']} ${AppLocalizations.of(context)!.kgUnit}',
                                              style: TextStyle(
                                                fontSize: sw * 0.035,
                                                color: isCompleted ? Colors.white70 : subTextColor,
                                              ),
                                            ),
                                        ],
                                      ),
                                      const Spacer(),
                                      if ((setData['restSeconds'] as int) > 0)
                                        Container(
                                          padding: EdgeInsets.symmetric(horizontal: sw * 0.03, vertical: sh * 0.008),
                                          decoration: BoxDecoration(
                                            color: isCompleted
                                                ? Colors.white70
                                                : _restColor.withValues(alpha: 0.15),
                                            borderRadius: BorderRadius.circular(sw * 0.03),
                                          ),
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.timer,
                                                size: sw * 0.04,
                                                color: isCompleted ? Colors.white : _restColor,
                                              ),
                                              SizedBox(width: sw * 0.01),
                                              Text(
                                                AppLocalizations.of(context)!.restSeconds(setData['restSeconds']),
                                                style: TextStyle(
                                                  fontSize: sw * 0.03,
                                                  fontWeight: FontWeight.w600,
                                                  color: isCompleted ? Colors.white : _restColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: sw * 0.03),
                                if (!isCompleted)
                                  GestureDetector(
                                    onTap: () => _editSet(currentProgramExercise.exerciseId, setIndex),
                                    child: Container(
                                      padding: EdgeInsets.all(sw * 0.015),
                                      decoration: BoxDecoration(
                                        color: _workoutColor.withValues(alpha: 0.15),
                                        borderRadius: BorderRadius.circular(sw * 0.02),
                                      ),
                                      child: Icon(
                                        Icons.edit,
                                        color: _workoutColor,
                                        size: sw * 0.05,
                                      ),
                                    ),
                                  ),
                                SizedBox(width: sw * 0.02),
                                Icon(
                                  isCompleted ? Icons.check_circle : Icons.circle_outlined,
                                  color: isCompleted ? Colors.white : subTextColor.withValues(alpha: 0.5),
                                  size: sw * 0.07,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),

                    SizedBox(height: sh * 0.03),

                    // Navigation buttons
                    Row(
                      children: [
                        if (currentExerciseIndex > 0)
                          Expanded(
                            child: GestureDetector(
                              onTap: _moveToPreviousExercise,
                              child: Container(
                                padding: EdgeInsets.all(sw * 0.04),
                                decoration: BoxDecoration(
                                  color: cardColor,
                                  borderRadius: BorderRadius.circular(sw * 0.04),
                                  border: Border.all(color: AppColors.border),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.arrow_back, color: textColor),
                                    SizedBox(width: sw * 0.02),
                                    Text(
                                      AppLocalizations.of(context)!.previous,
                                      style: TextStyle(
                                        fontSize: sw * 0.04,
                                        fontWeight: FontWeight.bold,
                                        color: textColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        if (currentExerciseIndex > 0 && !isLastExercise)
                          SizedBox(width: sw * 0.03),
                        if (!isLastExercise)
                          Expanded(
                            child: GestureDetector(
                              onTap: _moveToNextExercise,
                              child: Container(
                                padding: EdgeInsets.all(sw * 0.04),
                                decoration: BoxDecoration(
                                  color: _workoutColor,
                                  borderRadius: BorderRadius.circular(sw * 0.04),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      AppLocalizations.of(context)!.next,
                                      style: TextStyle(
                                        fontSize: sw * 0.04,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(width: sw * 0.02),
                                    Icon(Icons.arrow_forward, color: Colors.white),
                                  ],
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: sh * 0.1),
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