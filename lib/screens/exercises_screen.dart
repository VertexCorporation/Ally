import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/health_provider.dart';
import '../providers/workout_provider.dart';
import '../models/exercise.dart';
import '../models/workout_program.dart';
import '../l10n/app_localizations.dart';
import 'workout_builder_screen.dart';
import 'active_workout_screen.dart';

class ExercisesScreen extends StatefulWidget {
  const ExercisesScreen({super.key});

  @override
  State<ExercisesScreen> createState() => _ExercisesScreenState();
}

class _ExercisesScreenState extends State<ExercisesScreen> {

  void _showWorkoutDetails(Map<String, dynamic> workout) {
    final exercises = workout['exercises'] as List;
    final time = DateTime.parse(workout['time']);
    final timeStr = '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext dialogContext) => Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(24),
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
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
              child: const Icon(Icons.fitness_center, color: Color(0xFFE57373), size: 32),
            ),
            const SizedBox(height: 16),
            Text(
              workout['name'],
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              AppLocalizations.of(context)!.completedAt(timeStr),
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: exercises.length,
                itemBuilder: (context, index) {
                  final exercise = exercises[index];
                  final sets = exercise['sets'] as List;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [
                        BoxShadow(color: Colors.black12, blurRadius: 5, offset: Offset(0, 2)),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE57373).withOpacity(0.15),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                IconData(exercise['iconCodePoint'], fontFamily: 'MaterialIcons'),
                                color: const Color(0xFFE57373),
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                exercise['name'],
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const Divider(height: 1),
                        const SizedBox(height: 12),
                        ...List.generate(sets.length, (setIndex) {
                          final set = sets[setIndex];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              children: [
                                Container(
                                  width: 28,
                                  height: 28,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE57373).withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Center(
                                    child: Text(
                                      '${setIndex + 1}',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFFE57373),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  '${set['reps']} ${AppLocalizations.of(context)!.reps}',
                                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                                ),
                                if ((set['weight'] as double) > 0) ...[
                                  const SizedBox(width: 8),
                                  Text(
                                    '• ${set['weight']} ${AppLocalizations.of(context)!.kg}',
                                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                                  ),
                                ],
                                if ((set['restSeconds'] as int) > 0) ...[
                                  const SizedBox(width: 8),
                                  Text(
                                    '• ${set['restSeconds']}s ${AppLocalizations.of(context)!.rest}',
                                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                                  ),
                                ],
                              ],
                            ),
                          );
                        }),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: GestureDetector(
                onTap: () => Navigator.pop(dialogContext),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF81C784),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    AppLocalizations.of(dialogContext)!.close,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
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
      ),
    );
  }

  void _showCreateWorkoutDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
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
              child: const Icon(Icons.add_rounded, color: Color(0xFFE57373), size: 32),
            ),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(dialogContext)!.createWorkout,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),

            GestureDetector(
              onTap: () {
                Navigator.pop(dialogContext);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const WorkoutBuilderScreen(),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.withOpacity(0.2)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE57373).withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.fitness_center, color: Color(0xFFE57373), size: 24),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(dialogContext)!.customProgram,
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            AppLocalizations.of(dialogContext)!.buildYourOwnWorkout,
                            style: const TextStyle(fontSize: 13, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            GestureDetector(
              onTap: () {
                Navigator.pop(dialogContext);
                // Quick log single exercise
                _showQuickExerciseLog();
              },
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.withOpacity(0.2)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF64B5F6).withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.bolt, color: Color(0xFF64B5F6), size: 24),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(dialogContext)!.quickLog,
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            AppLocalizations.of(dialogContext)!.logASingleExercise,
                            style: const TextStyle(fontSize: 13, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showQuickExerciseLog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext dialogContext) => Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(24),
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.7,
        ),
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
                color: const Color(0xFF64B5F6).withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.bolt, color: Color(0xFF64B5F6), size: 32),
            ),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(dialogContext)!.quickLog,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView(
                children: ExerciseCategory.values.map((category) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          ExerciseLibrary.getCategoryName(category),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      ...ExerciseLibrary.getExercisesByCategory(category).take(3).map(
                        (exercise) => _buildQuickExerciseOption(dialogContext, exercise),
                      ),
                      const SizedBox(height: 12),
                    ],
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickExerciseOption(BuildContext dialogContext, Exercise exercise) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(dialogContext);
        final healthProvider = Provider.of<HealthProvider>(context, listen: false);
        final now = DateTime.now();
        final lastDate = healthProvider.healthData.lastExerciseDate;

        if (lastDate == null ||
            lastDate.year != now.year ||
            lastDate.month != now.month ||
            lastDate.day != now.day) {
          healthProvider.updateExerciseStreak(healthProvider.healthData.exerciseStreak + 1);
        }

        healthProvider.addExerciseToLog(
          exercise.id,
          exercise.name,
          exercise.icon,
          const Color(0xFFE57373),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 5, offset: Offset(0, 1)),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFE57373).withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(exercise.icon, color: const Color(0xFFE57373), size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    exercise.name,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  if (exercise.equipment != null)
                    Text(
                      exercise.equipment!,
                      style: const TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final healthProvider = Provider.of<HealthProvider>(context);
    final healthData = healthProvider.healthData;
    final currentStreak = healthData.exerciseStreak;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.chevron_left_rounded, color: Theme.of(context).iconTheme.color, size: 32),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          AppLocalizations.of(context)!.exercises,
          style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color, fontWeight: FontWeight.bold),
        ),
        actions: [
          GestureDetector(
            onTap: _showCreateWorkoutDialog,
            child: Container(
              margin: const EdgeInsets.only(right: 16),
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Color(0xFFE57373),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.add, color: Colors.white),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Streak Card
                Hero(
                  tag: 'exercises_card',
                  child: Material(
                    color: Colors.transparent,
                    child: Container(
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
                              Icon(Icons.local_fire_department, color: Colors.white),
                              const SizedBox(width: 12),
                              Text(
                                currentStreak == 0
                                  ? AppLocalizations.of(context)!.noStreakYet
                                  : '$currentStreak ${currentStreak == 1 ? AppLocalizations.of(context)!.day : AppLocalizations.of(context)!.days}',
                                style: const TextStyle(
                                  fontSize: 32,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            AppLocalizations.of(context)!.keepGoing,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // Quick Programs Section
                Text(
                  AppLocalizations.of(context)!.quickPrograms,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),

                Consumer<WorkoutProvider>(
                  builder: (context, workoutProvider, child) {
                    final programs = workoutProvider.programs;

                    if (programs.isEmpty) {
                      return Container(
                        height: 140,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.grey.withOpacity(0.2)),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add_circle_outline, size: 40, color: Colors.grey[300]),
                              const SizedBox(height: 12),
                              Text(
                                AppLocalizations.of(context)!.createProgramToQuicklyStart,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[500],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    return SizedBox(
                      height: 140,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: programs.length,
                        itemBuilder: (context, index) {
                          final program = programs[index];
                          final colors = [
                            const Color(0xFFE57373),
                            const Color(0xFF64B5F6),
                            const Color(0xFF81C784),
                            const Color(0xFFFFB74D),
                            const Color(0xFFBA68C8),
                          ];
                          final color = colors[index % colors.length];

                          return Container(
                            width: 180,
                            margin: const EdgeInsets.only(right: 12),
                            child: Stack(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ActiveWorkoutScreen(program: program),
                                      ),
                                    );
                                  },
                                  child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: color,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: color.withOpacity(0.3),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(Icons.fitness_center, color: Colors.white),
                                    const Spacer(),
                                    Text(
                                      program.name,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Icon(Icons.access_time, color: Colors.white),
                                        const SizedBox(width: 4),
                                        Text(
                                          '${program.estimatedDuration} ${AppLocalizations.of(context)!.min}',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.white70,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Icon(Icons.fitness_center, color: Colors.white),
                                        const SizedBox(width: 4),
                                        Flexible(
                                          child: Text(
                                            '${program.totalExercises} ${AppLocalizations.of(context)!.ex}',
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.white70,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                  ),
                                ),
                                // Edit icon positioned at top right
                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: GestureDetector(
                                    onTap: () {
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
                                                child: const Icon(Icons.edit, color: Color(0xFFE57373), size: 32),
                                              ),
                                              const SizedBox(height: 16),
                                              Text(
                                                program.name,
                                                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                              ),
                                              const SizedBox(height: 24),
                                              GestureDetector(
                                                onTap: () {
                                                  Navigator.pop(dialogContext);
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) => WorkoutBuilderScreen(program: program),
                                                    ),
                                                  );
                                                },
                                                child: Container(
                                                  padding: const EdgeInsets.all(20),
                                                  decoration: BoxDecoration(
                                                    color: Theme.of(context).cardColor,
                                                    borderRadius: BorderRadius.circular(16),
                                                    boxShadow: const [
                                                      BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 2)),
                                                    ],
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      const Icon(Icons.edit, color: Color(0xFFE57373), size: 24),
                                                      const SizedBox(width: 16),
                                                      Text(
                                                        AppLocalizations.of(dialogContext)!.editProgram,
                                                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                                      ),
                                                      const Spacer(),
                                                      const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 12),
                                              GestureDetector(
                                                onTap: () {
                                                  Navigator.pop(dialogContext);
                                                  showModalBottomSheet(
                                                    context: context,
                                                    backgroundColor: Colors.transparent,
                                                    builder: (BuildContext deleteContext) => Container(
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
                                                            child: const Icon(Icons.delete_outline, color: Color(0xFFEF5350), size: 32),
                                                          ),
                                                          const SizedBox(height: 16),
                                                          Text(
                                                            AppLocalizations.of(deleteContext)!.deleteProgramQuestion,
                                                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                                          ),
                                                          const SizedBox(height: 12),
                                                          Text(
                                                            AppLocalizations.of(deleteContext)!.areYouSureDeleteProgram(program.name),
                                                            style: const TextStyle(fontSize: 14, color: Colors.grey),
                                                            textAlign: TextAlign.center,
                                                          ),
                                                          const SizedBox(height: 24),
                                                          Row(
                                                            children: [
                                                              Expanded(
                                                                child: GestureDetector(
                                                                  onTap: () => Navigator.pop(deleteContext),
                                                                  child: Container(
                                                                    padding: const EdgeInsets.all(16),
                                                                    decoration: BoxDecoration(
                                                                      color: Theme.of(context).cardColor,
                                                                      borderRadius: BorderRadius.circular(16),
                                                                      border: Border.all(color: Colors.grey[300]!),
                                                                    ),
                                                                    child: Text(
                                                                      AppLocalizations.of(deleteContext)!.cancel,
                                                                      textAlign: TextAlign.center,
                                                                      style: const TextStyle(
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
                                                                  onTap: () async {
                                                                    await workoutProvider.deleteProgram(program.id);
                                                                    Navigator.pop(deleteContext);
                                                                  },
                                                                  child: Container(
                                                                    padding: const EdgeInsets.all(16),
                                                                    decoration: BoxDecoration(
                                                                      color: const Color(0xFFEF5350),
                                                                      borderRadius: BorderRadius.circular(16),
                                                                    ),
                                                                    child: Text(
                                                                      AppLocalizations.of(deleteContext)!.delete,
                                                                      textAlign: TextAlign.center,
                                                                      style: const TextStyle(
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
                                                child: Container(
                                                  padding: const EdgeInsets.all(20),
                                                  decoration: BoxDecoration(
                                                    color: Theme.of(context).cardColor,
                                                    borderRadius: BorderRadius.circular(16),
                                                    boxShadow: const [
                                                      BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 2)),
                                                    ],
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      const Icon(Icons.delete_outline, color: Color(0xFFEF5350), size: 24),
                                                      const SizedBox(width: 16),
                                                      Text(
                                                        AppLocalizations.of(dialogContext)!.deleteProgram,
                                                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                                      ),
                                                      const Spacer(),
                                                      const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color: Colors.white70,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Icon(
                                        Icons.edit, color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),

                const SizedBox(height: 32),

                // Today's Workouts
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.todaysPrograms,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    if (healthData.exerciseLog.isNotEmpty)
                      Text(
                        '${healthData.exerciseLog.length} ${AppLocalizations.of(context)!.logged}',
                        style: const TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                  ],
                ),
                const SizedBox(height: 16),

                healthData.exerciseLog.isEmpty
                    ? Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(40),
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.fitness_center_rounded,
                              size: 80,
                              color: Colors.grey[300],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              AppLocalizations.of(context)!.noWorkoutsLogged,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[400],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              AppLocalizations.of(context)!.startFitnessJourney,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[400],
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: healthData.exerciseLog.length,
                        itemBuilder: (context, index) {
                          final exercise = healthData.exerciseLog[index];
                          final time = DateTime.parse(exercise['time']);
                          final timeStr = '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
                          final name = exercise['name'] ?? exercise['nameKey'] ?? 'Exercise';
                          final isProgram = exercise['type'] == 'program';

                          return GestureDetector(
                            onTap: isProgram ? () => _showWorkoutDetails(exercise) : null,
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Theme.of(context).cardColor,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: const [
                                  BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 2)),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: isProgram
                                          ? const Color(0xFFE57373).withOpacity(0.15)
                                          : Color(exercise['color']).withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Icon(
                                      isProgram
                                          ? Icons.fitness_center
                                          : IconData(exercise['iconCodePoint'], fontFamily: 'MaterialIcons'),
                                      color: isProgram
                                          ? const Color(0xFFE57373)
                                          : Color(exercise['color']),
                                      size: 24,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          name,
                                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              timeStr,
                                              style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                                            ),
                                            if (isProgram) ...[
                                              const SizedBox(width: 8),
                                              Text(
                                                '• ${exercise['exercises'].length} ${AppLocalizations.of(context)!.exercises}',
                                                style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                                              ),
                                            ],
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Icon(
                                    isProgram ? Icons.arrow_forward_ios : Icons.check_circle,
                                    color: isProgram ? Colors.grey : const Color(0xFFE57373),
                                    size: isProgram ? 16 : 24,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
