import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/exercise.dart';
import '../models/program.dart';
import '../providers/workout.dart';
import '../providers/health.dart';
import '../l10n/app_localizations.dart';
import '../widgets/notification.dart';

class WorkoutBuilderScreen extends StatefulWidget {
  final WorkoutProgram? program;

  const WorkoutBuilderScreen({super.key, this.program});

  @override
  State<WorkoutBuilderScreen> createState() => _WorkoutBuilderScreenState();
}

class _WorkoutBuilderScreenState extends State<WorkoutBuilderScreen> {
  final List<Map<String, dynamic>> _selectedExercises = [];
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();

    // If editing existing program, load its data
    if (widget.program != null) {
      _nameController.text = widget.program!.name;
      for (var programExercise in widget.program!.exercises) {
        final exercise = ExerciseLibrary.getExerciseById(programExercise.exerciseId);
        if (exercise != null) {
          _selectedExercises.add({
            'exercise': exercise,
            'sets': programExercise.sets.map((set) => {
              'reps': set.reps,
              'weight': set.weight,
              'rest': set.restSeconds,
            }).toList(),
          });
        }
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _showExercisePicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext dialogContext) {
        final l10n = AppLocalizations.of(dialogContext)!;
        return Container(
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
                  color: const Color(0xFFE57373).withValues(alpha:0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.search, color: Color(0xFFE57373), size: 32),
              ),
              const SizedBox(height: 16),
              Text(
                l10n.selectExercise,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),

              Expanded(
                child: ListView(
                  children: ExerciseLibrary.exercises
                      .map((exercise) => _buildExerciseOption(dialogContext, exercise))
                      .toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildExerciseOption(BuildContext dialogContext, Exercise exercise) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(dialogContext);
        _addExercise(exercise);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 5, offset: Offset(0, 1)),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFE57373).withValues(alpha:0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(exercise.icon, color: const Color(0xFFE57373), size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    exercise.name,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  if (exercise.equipment != null)
                    Row(
                      children: [
                        const Icon(Icons.fitness_center, size: 12, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(
                          exercise.equipment!,
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                ],
              ),
            ),
            const Icon(Icons.add_circle, color: Color(0xFFE57373), size: 24),
          ],
        ),
      ),
    );
  }

  void _addExercise(Exercise exercise) {
    setState(() {
      _selectedExercises.add({
        'exercise': exercise,
        'sets': [
          {'reps': 10, 'weight': 0.0, 'rest': 60},
        ],
      });
    });
  }

  void _addSet(int exerciseIndex) {
    setState(() {
      final sets = _selectedExercises[exerciseIndex]['sets'] as List;
      final lastSet = sets.last as Map<String, dynamic>;
      sets.add({
        'reps': lastSet['reps'] as int,
        'weight': lastSet['weight'] as double,
        'rest': lastSet['rest'] as int,
      });
    });
  }

  void _removeSet(int exerciseIndex, int setIndex) {
    setState(() {
      if (_selectedExercises[exerciseIndex]['sets'].length > 1) {
        _selectedExercises[exerciseIndex]['sets'].removeAt(setIndex);
      }
    });
  }

  void _updateSet(int exerciseIndex, int setIndex, String field, dynamic value) {
    setState(() {
      _selectedExercises[exerciseIndex]['sets'][setIndex][field] = value;
    });
  }

  void _saveProgram() {
    if (_selectedExercises.isEmpty) return;

    final controller = TextEditingController(text: _nameController.text);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext dialogContext) {
        final l10n = AppLocalizations.of(dialogContext)!;
        return Padding(
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
                    color: const Color(0xFFE57373).withValues(alpha:0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.save_rounded, color: Color(0xFFE57373), size: 32),
                ),
                const SizedBox(height: 16),
                Text(
                  widget.program != null ? 'Update Program' : 'Save Program',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: controller,
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)!.programNameHint,
                    filled: true,
                    fillColor: Theme.of(context).cardColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  ),
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
                        onTap: () async {
                          final name = controller.text.trim();
                          if (name.isEmpty) return;

                          final program = WorkoutProgram(
                            id: widget.program?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
                            name: name,
                            exercises: _selectedExercises.map((ex) {
                              return ProgramExercise(
                                exerciseId: (ex['exercise'] as Exercise).id,
                                sets: (ex['sets'] as List).map((s) {
                                  return ProgramSet(
                                    reps: s['reps'] as int,
                                    weight: s['weight'] as double,
                                    restSeconds: s['rest'] as int,
                                  );
                                }).toList(),
                              );
                            }).toList(),
                            createdAt: widget.program?.createdAt ?? DateTime.now(),
                          );

                          final workoutProvider = Provider.of<WorkoutProvider>(context, listen: false);

                          if (mounted) {
                            Navigator.pop(dialogContext); // Close dialog
                            Navigator.pop(context); // Close builder
                            CustomNotification.show(
                              context,
                              message: widget.program != null ? l10n.programUpdated(name) : l10n.programSaved(name),
                              backgroundColor: const Color(0xFF4CAF50),
                              icon: Icons.check_circle,
                            );

                            await workoutProvider.saveProgram(program);
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE57373),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            l10n.save,
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
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final totalSets = _selectedExercises.fold<int>(
      0,
          (sum, ex) => sum + (ex['sets'] as List).length,
    );

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, color: Colors.black, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.program != null ? AppLocalizations.of(context)!.editProgram : AppLocalizations.of(context)!.workoutBuilder,
          style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color, fontWeight: FontWeight.bold),
        ),
        actions: [
          if (_selectedExercises.isNotEmpty)
            TextButton(
              onPressed: _saveProgram,
              child: Text(
                l10n.save,
                style: const TextStyle(
                  color: Color(0xFFE57373),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            if (_selectedExercises.isEmpty)
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.fitness_center_rounded,
                        size: 100,
                        color: Colors.grey[300],
                      ),
                      const SizedBox(height: 24),
                      Text(
                        l10n.addExercisesToStart,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[400],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.tapPlusButton,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[400],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: _selectedExercises.length,
                  itemBuilder: (context, exerciseIndex) {
                    final exerciseData = _selectedExercises[exerciseIndex];
                    final exercise = exerciseData['exercise'] as Exercise;
                    final sets = exerciseData['sets'] as List;

                    return Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha:0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Exercise Header
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE57373).withValues(alpha:0.15),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(exercise.icon, color: const Color(0xFFE57373), size: 24),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        exercise.name,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      if (exercise.equipment != null)
                                        Text(
                                          exercise.equipment!,
                                          style: const TextStyle(
                                            fontSize: 13,
                                            color: Colors.grey,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                                  onPressed: () {
                                    setState(() {
                                      _selectedExercises.removeAt(exerciseIndex);
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),

                          const Divider(height: 1),

                          // Sets Header
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            child: Row(
                              children: [
                                const SizedBox(width: 40),
                                Expanded(
                                  child: Text(l10n.reps, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
                                ),
                                Expanded(
                                  child: Consumer<HealthProvider>(
                                    builder: (context, healthProvider, _) {
                                      return Text(
                                        exercise.isUnilateral
                                            ? '${l10n.weight} (2x)'
                                            : '${l10n.weight} (${healthProvider.units == 'imperial' ? 'lbs' : 'kg'})',
                                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey),
                                      );
                                    },
                                  ),
                                ),
                                Expanded(
                                  child: Text(l10n.rest, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
                                ),
                                const SizedBox(width: 40),
                              ],
                            ),
                          ),

                          // Sets List
                          ...List.generate(sets.length, (setIndex) {
                            final set = sets[setIndex];
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              child: Row(
                                children: [
                                  Container(
                                    width: 32,
                                    height: 32,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFE57373).withValues(alpha:0.15),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Center(
                                      child: Text(
                                        '${setIndex + 1}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFFE57373),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: _buildNumberInput(
                                      value: set['reps'],
                                      onChanged: (val) => _updateSet(exerciseIndex, setIndex, 'reps', val),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: _buildNumberInput(
                                      value: set['weight'],
                                      isDecimal: true,
                                      onChanged: (val) => _updateSet(exerciseIndex, setIndex, 'weight', val),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: _buildNumberInput(
                                      value: set['rest'],
                                      onChanged: (val) => _updateSet(exerciseIndex, setIndex, 'rest', val),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  IconButton(
                                    icon: const Icon(Icons.remove_circle_outline, size: 20),
                                    color: Colors.red,
                                    onPressed: () => _removeSet(exerciseIndex, setIndex),
                                  ),
                                ],
                              ),
                            );
                          }),

                          // Add Set Button
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: SizedBox(
                              width: double.infinity,
                              child: OutlinedButton.icon(
                                onPressed: () => _addSet(exerciseIndex),
                                icon: const Icon(Icons.add, size: 20),
                                label: Text(l10n.addSet),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: const Color(0xFFE57373),
                                  side: const BorderSide(color: Color(0xFFE57373)),
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

            // Bottom Add Exercise Button
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha:0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_selectedExercises.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              Text(
                                '${_selectedExercises.length}',
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFE57373),
                                ),
                              ),
                              const Text(
                                'Exercises',
                                style: TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                '$totalSets',
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF64B5F6),
                                ),
                              ),
                              const Text(
                                'Sets',
                                style: TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _showExercisePicker,
                      icon: const Icon(Icons.add, size: 24),
                      label: Text(l10n.addExercise, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE57373),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNumberInput({
    required dynamic value,
    required Function(dynamic) onChanged,
    bool isDecimal = false,
  }) {
    final controller = TextEditingController(
      text: isDecimal ? value.toStringAsFixed(1) : value.toString(),
    );

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.grey[800]
            : const Color(0xFFF5F1EB),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        decoration: const InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          isDense: true,
        ),
        onChanged: (text) {
          if (text.isEmpty) return;
          if (isDecimal) {
            final val = double.tryParse(text);
            if (val != null) onChanged(val);
          } else {
            final val = int.tryParse(text);
            if (val != null) onChanged(val);
          }
        },
      ),
    );
  }
}