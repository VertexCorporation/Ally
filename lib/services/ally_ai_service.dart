// ally_ai_service.dart
//
// © 2026 Vertex Corporation
// ─────────────────────────────────────────────────────────────────────────────
// Client for the private AI-lly Firebase callable function.
//
// Provider keys, model selection, subscription checks, and usage limits stay
// on the server. Never send a UID, tier, or model choice as client authority.
//
// The service is resilient to a missing Firebase app (offline / local dev
// sessions): construction never throws, and requests fail with a typed
// [AllyAiException] instead of a platform error.

import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

/// A validated response from the AI-lly backend.
class AllyAiResponse {
  const AllyAiResponse({
    required this.answer,
    required this.model,
    required this.remainingToday,
  });

  final String answer;

  /// Model identifier returned by the trusted backend for diagnostics/UI.
  final String model;

  /// Remaining requests for the current UTC day, according to the backend.
  final int remainingToday;

  factory AllyAiResponse.fromMap(Map<Object?, Object?> data) {
    final answer = data['answer'];
    final model = data['model'];
    final usage = data['usage'];

    if (answer is! String || answer.trim().isEmpty || model is! String) {
      throw const AllyAiException(
        code: 'invalid-response',
        message: 'Ally AI returned an invalid response. Please try again.',
      );
    }

    var remainingToday = 0;
    if (usage is Map) {
      final value = usage['remainingToday'];
      if (value is num && value.isFinite) {
        remainingToday = value.toInt().clamp(0, 1000000).toInt();
      }
    }

    return AllyAiResponse(
      answer: answer.trim(),
      model: model,
      remainingToday: remainingToday,
    );
  }
}

/// A safe, user-presentable error from the AI service.
class AllyAiException implements Exception {
  const AllyAiException({required this.code, required this.message});

  final String code;
  final String message;

  @override
  String toString() => 'AllyAiException($code): $message';
}

class AllyAiService {
  AllyAiService({FirebaseFunctions? functions, FirebaseAuth? auth})
    : _functions = functions,
      _auth = auth;

  FirebaseFunctions? _functions;
  FirebaseAuth? _auth;

  bool get _backendReady => _functions != null && _auth != null;

  /// Lazily resolves the Firebase handles so construction stays side-effect
  /// free (important for tests and Firebase-less sessions).
  void _ensureBackend() {
    if (_backendReady) return;
    try {
      _functions ??= FirebaseFunctions.instanceFor(region: 'europe-west1');
      _auth ??= FirebaseAuth.instance;
    } catch (e) {
      debugPrint('[AllyAiService] Firebase unavailable: $e');
    }
  }

  Future<AllyAiResponse> generateResponse(String message) async {
    _ensureBackend();

    final normalizedMessage = message.trim();

    if (normalizedMessage.isEmpty) {
      throw const AllyAiException(
        code: 'invalid-argument',
        message: 'Write a message before sending it.',
      );
    }

    if (normalizedMessage.length > 8000) {
      throw const AllyAiException(
        code: 'invalid-argument',
        message: 'Your message is too long. Please shorten it and try again.',
      );
    }

    // The callable function derives the user identity from Firebase Auth.
    // Do not silently sign users in here, because that would alter app auth flow.
    if (!_backendReady || _auth!.currentUser == null) {
      throw const AllyAiException(
        code: 'unauthenticated',
        message: 'Sign in or continue as a guest to use Ally AI.',
      );
    }

    try {
      final callable = _functions!.httpsCallable(
        'generateAIResponse',
        options: HttpsCallableOptions(timeout: const Duration(seconds: 55)),
      );
      final result = await callable.call<Map<String, dynamic>>({
        'message': normalizedMessage,
      });

      return AllyAiResponse.fromMap(result.data);
    } on FirebaseFunctionsException catch (error) {
      throw AllyAiException(
        code: error.code,
        message: _messageForCode(error.code),
      );
    } on AllyAiException {
      rethrow;
    } catch (_) {
      throw const AllyAiException(
        code: 'unavailable',
        message: 'Ally AI is temporarily unavailable. Please try again.',
      );
    }
  }

  String _messageForCode(String code) {
    switch (code) {
      case 'unauthenticated':
        return 'Sign in or continue as a guest to use Ally AI.';
      case 'invalid-argument':
        return 'Please check your message and try again.';
      case 'resource-exhausted':
        return 'You have reached today’s AI request limit. Please try again later.';
      case 'failed-precondition':
        // Server model policy (designated "Caveman" model) is not unblocked
        // yet — surfaced honestly instead of pretending the AI works.
        return 'AI insights are not available in this build yet.';
      case 'deadline-exceeded':
      case 'unavailable':
        return 'Ally AI is temporarily unavailable. Please try again.';
      default:
        return 'Something went wrong while contacting Ally AI. Please try again.';
    }
  }
}

/// Kinds of structured insight the insights surface can request.
enum AllyInsightKind { activity, sleep, overview }

/// Request templates enforcing the non-conversational product policy
/// (docs/AI_INTEGRATION.md). The model is instructed to never greet, never
/// ask questions, and never give medical advice — outputs stay terse bullets.
abstract final class AllyAiPrompts {
  static const String _contract =
      'You are a health-data summarizer inside the Ally app. Output 2-4 short '
      'bullet lines starting with "• ". Be factual and terse. Never greet, '
      'never ask questions, never address the user directly. No diagnoses, no '
      'medical advice; if data is missing or zero, say so plainly.';

  /// Builds the full callable payload for an insight request.
  static String buildInsightRequest(
    AllyInsightKind kind,
    Map<String, Object?> data,
  ) {
    final flat = data.entries.map((e) => '${e.key}=${e.value}').join('; ');
    final task = switch (kind) {
      AllyInsightKind.activity =>
        "Task: summarize today's activity versus the user's own goals.",
      AllyInsightKind.sleep =>
        'Task: summarize the most recent recorded sleep.',
      AllyInsightKind.overview =>
        'Task: give a compact daily overview across all metrics.',
    };
    return '$_contract\n$task\nData: $flat';
  }

  /// Wraps a user-initiated custom query with the same contract so free-form
  /// requests also produce terse, non-conversational output.
  static String buildCustomRequest(String userQuery) =>
      '$_contract\nTask: answer the question about the logged data.\nQuestion: ${userQuery.trim()}';
}
