# Ally mobile integration for AI-lly

This document describes the mobile-side contract for the private AI-lly Firebase callable function.

## Client service

Open the chat from the new **Ally AI** card on the home screen. The screen is implemented in `lib/screens/ally_ai_chat.dart` and calls `AllyAiService` from `lib/services/ally_ai_service.dart`.

```dart
final ai = AllyAiService();
final response = await ai.generateResponse(message);

print(response.answer);
// response.remainingToday is the backend-reported daily request balance.
```

The service targets `europe-west1`, matching the Vertex Firebase Functions convention and AI-lly's `generateAIResponse` callable.

## Authentication and authorization

- The caller must already have a Firebase Auth session. If guest access is intended, the app's existing guest flow must establish an anonymous Firebase session first.
- The client does not send a UID, subscription tier, or model ID. The callable derives identity from the Firebase Auth token and resolves access server-side.
- The service deliberately does not sign users in automatically, because authentication transitions belong to Ally's existing auth flow.
- Provider API keys must never be included in Flutter code or app configuration.

## Backend prerequisite

The AI-lly backend has been merged, but the client will only work after that backend is deployed to the correct Firebase project, `OPENROUTER_API_KEY` is set as a Firebase secret, and both required model parameters (`AI_GUEST_MODEL` and `AI_REGISTERED_MODEL`) are configured.

Do not point production users at an unconfigured backend. Model selection and data handling must be reviewed before sending personal or health-related information.

## Error handling

`AllyAiException` exposes a stable code and safe, user-presentable message. UI code should show the message, retain the user's draft on failure, and avoid logging message content or provider responses. The chat screen currently provides Turkish and English UI copy, with English fallback for other locales. Chat messages are kept in memory only for the current screen and are not saved as conversation history by this client.
