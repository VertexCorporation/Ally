# Authentication readiness checklist

Use this checklist before calling the current authentication flows production-ready. It is a manual integration checklist; CI runs static analysis and automated Flutter tests, but does not authenticate against the live Firebase project.

## Firebase project configuration

- [ ] Confirm the intended Firebase project ID is used by Android, iOS, and web builds.
- [ ] Enable only the sign-in providers that the app currently supports and that have been configured in each platform.
- [ ] Configure authorized domains for web sign-in.
- [ ] Verify Android package name and SHA fingerprints for Google Sign-In.
- [ ] Verify iOS bundle ID, URL schemes, and Sign in with Apple capability where applicable.
- [ ] Confirm Cloud Functions are deployed to the region used by the app (`europe-west1`).
- [ ] Review Firestore rules for `users`, `usernameSuggestions`, and all user-owned documents. Client-side checks are not authorization controls.

## Email and password

- [ ] Valid credentials sign in and restore the authenticated session after app restart.
- [ ] Invalid credentials show a useful, non-sensitive message.
- [ ] Disabled accounts are handled without a crash.
- [ ] Registration handles email-already-in-use and weak-password responses.
- [ ] Username availability failures are distinguishable from a username that is already taken.
- [ ] Verification email can be resent within the configured limit.
- [ ] Verify the product decision for continuing before email verification. If unverified accounts may continue, make sure privileged actions are still protected by backend rules.
- [ ] Password reset flow is available and tested before public release.

## Google, Apple, and anonymous sign-in

- [ ] Google sign-in works on each supported platform and cancellation does not show a misleading error.
- [ ] Apple sign-in is tested on a supported Apple device and with the configured Firebase provider.
- [ ] Anonymous users receive only the intended guest permissions.
- [ ] Linking an anonymous account to email/password preserves the same UID and user-owned data.
- [ ] Provider failures and offline conditions recover cleanly.

## Session and local data

- [ ] Firebase Auth, rather than a stored password, is responsible for restoring the signed-in session.
- [ ] Older saved password values are removed on a successful login or verification flow.
- [ ] Signing out cancels user-data listeners and clears user-specific cached data.
- [ ] Signing in as a different account never displays the previous account's cached profile.
- [ ] Token synchronization is retried or reports a recoverable error if the initial attempt fails.

## AI integration later

The mobile app should send an authenticated Firebase ID token to the separate AI Support API. Never ship a model provider key or private backend secret in the Flutter app. The API must verify the token and authorize access to any health context server-side.
