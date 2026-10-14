import 'dart:convert';

import 'package:ally/services/user_records.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/program.dart';

class WorkoutProvider extends ChangeNotifier {
  WorkoutProvider({
    UserRecordsService? recordsService,
    FirebaseAuth? auth,
  })  : _recordsService = recordsService ?? UserRecordsService(),
        _auth = auth ?? FirebaseAuth.instance;

  final UserRecordsService _recordsService;
  final FirebaseAuth _auth;
  List<WorkoutProgram> _programs = [];

  List<WorkoutProgram> get programs => _programs;

  String get _storageKey {
    final uid = _auth.currentUser?.uid;
    return uid == null ? 'workout_programs' : 'workout_programs_$uid';
  }

  Future<void> loadPrograms() async {
    final prefs = await SharedPreferences.getInstance();
    final programsJson = prefs.getString(_storageKey);

    if (programsJson != null) {
      try {
        final List<dynamic> decoded = jsonDecode(programsJson);
        _programs = decoded
            .map((p) => WorkoutProgram.fromJson(Map<String, dynamic>.from(p)))
            .toList();
      } catch (e) {
        debugPrint('Error loading local workout programs: $e');
      }
    } else {
      _programs = [];
    }

    // Keep local data usable offline; when authenticated, merge in the cloud
    // copy and prefer the cloud version for matching program IDs.
    if (_auth.currentUser != null) {
      try {
        final cloudPrograms = await _recordsService.loadWorkoutPrograms();
        final merged = <String, WorkoutProgram>{
          for (final program in _programs) program.id: program,
          for (final data in cloudPrograms)
            WorkoutProgram.fromJson(data).id: WorkoutProgram.fromJson(data),
        };
        _programs = merged.values.toList();
        await _saveLocal();
      } catch (e) {
        debugPrint('Unable to load workout programs from cloud; using local cache: $e');
      }
    }

    notifyListeners();
  }

  Future<void> saveProgram(WorkoutProgram program) async {
    final existingIndex = _programs.indexWhere((p) => p.id == program.id);

    if (existingIndex != -1) {
      _programs[existingIndex] = program;
    } else {
      _programs.add(program);
    }

    await _saveLocal();

    if (_auth.currentUser != null) {
      try {
        await _recordsService.saveWorkoutProgram(program.id, program.toJson());
      } catch (e) {
        debugPrint('Workout program saved locally; cloud sync failed: $e');
      }
    }

    notifyListeners();
  }

  Future<void> deleteProgram(String programId) async {
    _programs.removeWhere((p) => p.id == programId);
    await _saveLocal();

    if (_auth.currentUser != null) {
      try {
        await _recordsService.deleteWorkoutProgram(programId);
      } catch (e) {
        debugPrint('Workout program deleted locally; cloud delete failed: $e');
      }
    }

    notifyListeners();
  }

  Future<void> _saveLocal() async {
    final prefs = await SharedPreferences.getInstance();
    final programsJson = jsonEncode(_programs.map((p) => p.toJson()).toList());
    await prefs.setString(_storageKey, programsJson);
  }

  WorkoutProgram? getProgramById(String id) {
    try {
      return _programs.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }
}
