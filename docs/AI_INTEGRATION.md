# Ally mobile integration for AI-lly

This document describes the mobile-side contract for the private AI-lly Firebase callable function.

## Designated model — "Caveman"

**Verification result (integration blocker).** The backend provider is OpenRouter. On 2026-10-31 the complete live OpenRouter catalog (`https://openrouter.ai/api/v1/models`, 805,539-byte snapshot) was searched: **no model id or name matching "caveman" exists** on the provider. Consequences:

- The client **must not** hardcode or display any model identifier as "Caveman"; the client never sends model ids (identity and model selection stay server-side).
- The server enforces this with a fail-closed allowlist (`AI-lly/functions/src/policy.js`): until a verified Caveman identifier is added there and configured in `AI_GUEST_MODEL` / `AI_REGISTERED_MODEL`, every callable request returns `failed-precondition` rather than silently running on another model.
- Unblock path is documented in `AI-lly/README.md`. The mobile app is ready and requires **no client change** once the server policy is unblocked.

## Client service

Use `AllyAiService` from `lib/services/ally_ai_service.dart`:

```dart
final ai = AllyAiService();
final response = await ai.generateResponse(message);

print(response.answer);
// response.remainingToday is the backend-reported daily request balance.
```

The service targets `europe-west1`, matching the Vertex Firebase Functions convention and AI-lly's `generateAIResponse` callable.

## Non-conversational product policy

Ally's AI surface is **not a chatbot**. The AI must never initiate contact, greet, ask questions, or make small talk. The in-app "Ally AI" screen is an insights surface:

- Insights are generated **only on explicit user action** ("Generate" buttons or a user-submitted query).
- Requests are wrapped in a terse, non-conversational instruction template (see `AllyAiService.buildInsightRequest`) so outputs stay structured, and the template explicitly forbids greetings and questions.
- Outputs are presented as structured insight cards with a type label, timestamp and model metadata — no chat bubbles, no assistant persona, no unsolicited pushes.

## Consent and data boundaries

Health-related requests include a compact local summary (today's steps, water, sleep hours, calories, weight entries). Because this is sensitive data:

- The insights surface shows a one-time, explicit consent screen before the first request (persisted as `ai_consent_v1` in `SharedPreferences`).
- The consent screen states exactly what is sent (the local summary above), where it is processed (Vertex's AI-lly backend on Firebase, which forwards to the configured provider), and that outputs are not medical advice.
- Declining keeps every other feature fully functional; AI insights simply stay locked.

## Authentication and authorization

- The caller must already have a Firebase Auth session. If guest access is intended, the app's existing guest flow must establish an anonymous Firebase session first.
- The client does not send a UID, subscription tier, or model ID. The callable derives identity from the Firebase Auth token and resolves access server-side.
- The service deliberately does not sign users in automatically, because authentication transitions belong to Ally's existing auth flow.
- Provider API keys must never be included in Flutter code or app configuration.

## Error handling

`AllyAiException` exposes a stable code and safe, user-presentable message. UI code should show the message, retain the user's draft on failure, and avoid logging message content or provider responses. Localized UI strings should be added when the chat interface is implemented.
