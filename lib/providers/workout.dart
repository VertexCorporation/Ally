import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/program.dart';

class WorkoutProvider extends ChangeNotifier {
  List<WorkoutProgram> _programs = [];

  List<WorkoutProgram> get programs => _programs;

  Future<void> loadPrograms() async {
    final prefs = await SharedPreferences.getInstance();
    final programsJson = prefs.getString('workout_programs');

    if (programsJson != null) {
      try {
        final List<dynamic> decoded = jsonDecode(programsJson);
        _programs = decoded.map((p) => WorkoutProgram.fromJson(p)).toList();
        notifyListeners();
      } catch (e) {
        debugPrint('Error loading workout programs: $e');
      }
    }
  }

  Future<void> saveProgram(WorkoutProgram program) async {
    // Check if program exists (edit mode)
    final existingIndex = _programs.indexWhere((p) => p.id == program.id);

    if (existingIndex != -1) {
      // Update existing program
      _programs[existingIndex] = program;
    } else {
      // Add new program
      _programs.add(program);
    }

    await _saveToStorage();
    notifyListeners();
  }

  Future<void> deleteProgram(String programId) async {
    _programs.removeWhere((p) => p.id == programId);
    await _saveToStorage();
    notifyListeners();
  }

  Future<void> _saveToStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final programsJson = jsonEncode(_programs.map((p) => p.toJson()).toList());
    await prefs.setString('workout_programs', programsJson);
  }

  WorkoutProgram? getProgramById(String id) {
    try {
      return _programs.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }
}
