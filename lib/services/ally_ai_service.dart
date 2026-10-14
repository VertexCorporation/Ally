import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
  const AllyAiException({
    required this.code,
    required this.message,
  });

  final String code;
  final String message;

  @override
  String toString() => 'AllyAiException($code): $message';
}

/// Client for the private AI-lly Firebase callable function.
///
/// Provider keys, model selection, subscription checks, and usage limits stay
/// on the server. Never send a UID, tier, or model choice as client authority.
class AllyAiService {
  AllyAiService({
    FirebaseFunctions? functions,
    FirebaseAuth? auth,
  }) : _functions = functions ??
            FirebaseFunctions.instanceFor(region: 'europe-west1'),
       _auth = auth ?? FirebaseAuth.instance;

  final FirebaseFunctions _functions;
  final FirebaseAuth _auth;

  Future<AllyAiResponse> generateResponse(String message) async {
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
    if (_auth.currentUser == null) {
      throw const AllyAiException(
        code: 'unauthenticated',
        message: 'Sign in or continue as a guest to use Ally AI.',
      );
    }

    try {
      final callable = _functions.httpsCallable(
        'generateAIResponse',
        options: HttpsCallableOptions(
          timeout: const Duration(seconds: 55),
        ),
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
        return 'Ally AI is not configured yet.';
      case 'deadline-exceeded':
      case 'unavailable':
        return 'Ally AI is temporarily unavailable. Please try again.';
      default:
        return 'Something went wrong while contacting Ally AI. Please try again.';
    }
  }
}
