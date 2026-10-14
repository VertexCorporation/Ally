# Ally user data persistence

## Implemented in this branch

- Firebase Authentication owns credentials and session persistence. Ally must not
  store raw passwords in SharedPreferences, Firestore, or secure storage.
- `UserRecordsService` stores a current health snapshot at
  `users/{auth.uid}/health/current`.
- When a daily reset occurs, the previous day's final health snapshot is archived
  at `users/{auth.uid}/daily_health/{yyyy-MM-dd}` when a prior reset date exists.
- Workout programs are stored at
  `users/{auth.uid}/workout_programs/{programId}`.
- Health cache, units, reset date, profile cache and workout cache are scoped to
  the current Firebase UID after authentication state is observed.
- Local writes remain usable when Firestore is temporarily unavailable; failed
  cloud writes are logged and can be retried by the user through a later save.
- Each cloud record includes a schema version and server-side update timestamp.
- `firestore.rules` is a starter template that limits access to the owner's UID
  and prevents clients from changing subscription/admin fields. It is **not
  deployed by this code change** and must be reviewed against every existing
  collection and Cloud Function before deployment.

## Known gaps before production

1. Existing health/workout data under legacy, unscoped SharedPreferences keys is
   intentionally not uploaded automatically. On a shared device it may belong to
   a different account. Add a clear, user-confirmed migration flow before moving
   legacy data into a cloud account.
2. The daily archive currently captures a final health snapshot at reset time;
   it is not a complete timestamped history of every change during the day.
3. Meal logs, exercise logs, weight history and sleep records are still embedded
   in or managed by existing local models/services. They need dedicated cloud
   record operations and explicit sync/deletion behavior.
4. Workout cloud records are loaded when `loadPrograms()` runs. Ensure screens
   call it after authentication changes and add a proper retry queue for offline
   edits before release.
5. Account deletion must remove the user's Firestore subcollections as well as
   the Firebase Authentication account. Deleting a Firestore parent document
   alone does not delete its subcollections.
6. Firebase rules do not protect data accessed through Admin SDK. The future AI
   backend must verify Firebase ID tokens and enforce UID ownership itself.
7. Do not store AI provider secrets in the Flutter app.
