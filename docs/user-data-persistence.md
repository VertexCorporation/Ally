# Ally user data persistence

## Implemented foundation

- Firebase Authentication owns credentials and session persistence. Ally must not
  store raw passwords in SharedPreferences, Firestore, or secure storage.
- `UserRecordsService` stores a health snapshot at
  `users/{auth.uid}/health/current`.
- Workout programs are stored at
  `users/{auth.uid}/workout_programs/{programId}`.
- Each cloud record includes a schema version and server-side update timestamp.
- Firestore rules in `firestore.rules` are a deployment template. They must be
  reviewed against the existing profile document shape and deployed in Firebase
  Console or through the project's Firebase CLI configuration before release.

## Important rollout notes

1. Existing health data and workout programs currently stored in unscoped
   SharedPreferences are not automatically uploaded. They may belong to a prior
   account on a shared device, so migration must be an explicit, UID-aware step.
2. The service is an initial persistence layer. Providers must be connected to it
   and account-switch / sign-out behavior tested before treating cloud sync as
   complete.
3. Daily health history, sleep records, meal logs, exercise logs, and completed
   workout sessions need dedicated record models and retention/deletion behavior.
4. Firebase rules do not protect data accessed through Admin SDK. The future AI
   backend must verify Firebase ID tokens and enforce the same UID ownership.
5. Do not store AI provider secrets in the Flutter app.
