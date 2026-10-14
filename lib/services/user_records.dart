import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// User-scoped cloud persistence for Ally records.
///
/// All paths are derived from the Firebase Auth UID. Callers must never pass
/// a UID supplied by the UI or user input.
class UserRecordsService {
  UserRecordsService({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  String? get _uid => _auth.currentUser?.uid;

  DocumentReference<Map<String, dynamic>>? get _userDocument {
    final uid = _uid;
    if (uid == null) return null;
    return _firestore.collection('users').doc(uid);
  }

  /// Loads the latest health snapshot for the signed-in user.
  Future<Map<String, dynamic>?> loadHealthSnapshot() async {
    final user = _userDocument;
    if (user == null) return null;

    final snapshot = await user.collection('health').doc('current').get();
    if (!snapshot.exists) return null;

    final data = snapshot.data();
    final health = data?['data'];
    if (health is! Map) return null;
    return Map<String, dynamic>.from(health);
  }

  /// Saves the current health snapshot without storing credentials.
  Future<void> saveHealthSnapshot(Map<String, dynamic> data) async {
    final user = _userDocument;
    if (user == null) return;

    await user.collection('health').doc('current').set({
      'data': data,
      'updatedAt': FieldValue.serverTimestamp(),
      'schemaVersion': 1,
    }, SetOptions(merge: true));
  }

  /// Archives one day's health summary under a stable local-date key.
  Future<void> saveDailyHealthRecord(
    String date,
    Map<String, dynamic> data,
  ) async {
    final user = _userDocument;
    if (user == null) return;

    await user.collection('daily_health').doc(date).set({
      'data': data,
      'date': date,
      'updatedAt': FieldValue.serverTimestamp(),
      'schemaVersion': 1,
    }, SetOptions(merge: true));
  }

  /// Loads all saved workout programs for the current user.
  Future<List<Map<String, dynamic>>> loadWorkoutPrograms() async {
    final user = _userDocument;
    if (user == null) return const [];

    final snapshot = await user.collection('workout_programs').get();
    return snapshot.docs.map((doc) {
      final data = doc.data();
      return <String, dynamic>{...data, 'id': doc.id};
    }).toList();
  }

  /// Creates or updates a workout program using its stable program ID.
  Future<void> saveWorkoutProgram(
    String programId,
    Map<String, dynamic> data,
  ) async {
    final user = _userDocument;
    if (user == null) return;

    await user.collection('workout_programs').doc(programId).set({
      ...data,
      'updatedAt': FieldValue.serverTimestamp(),
      'schemaVersion': 1,
    }, SetOptions(merge: true));
  }

  Future<void> deleteWorkoutProgram(String programId) async {
    final user = _userDocument;
    if (user == null) return;

    await user.collection('workout_programs').doc(programId).delete();
  }
}
