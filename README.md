# Ally

**Your health's closest ally.**

Ally is a Flutter mobile application for iOS and Android that brings everyday health and wellness tools into one place. The project combines a cross-platform interface with Firebase-backed authentication and cloud services, with a separate private AI Support backend responsible for AI capabilities.

> **Project status:** Active development. Some features and data flows may change as the application evolves.

## Overview

Ally is being built to help users keep health and wellness routines organized through a single mobile experience.

### Core capabilities

- **Health tracking:** Health-related summaries and daily activity views.
- **Workouts:** Workout-related screens and progress visualization.
- **Sleep and alarms:** Sleep-related tools and alarm functionality.
- **AI support:** A client-side experience designed to work with the separate AI Support service.
- **Accounts and access:** Guest access and account-based sign-in, with supported providers configured through Firebase Authentication.
- **Personalization:** Profile, theme, language, and notification preferences.
- **Cloud services:** Firebase integrations for authentication and selected application data and services.
- **Mobile experience:** Native iOS and Android integrations, local notifications, and background-task support where required.

Feature availability and data persistence can vary while development continues. The repository should be treated as an actively developed application, not a statement that every feature is production-ready.

## Technology stack

| Area | Technologies |
| --- | --- |
| Application | Flutter, Dart |
| State management | Provider |
| Authentication | Firebase Authentication, Google Sign-In, Sign in with Apple |
| Cloud data and functions | Cloud Firestore, Cloud Functions |
| Analytics and configuration | Firebase Analytics, Firebase Remote Config |
| Reliability and messaging | Firebase Crashlytics, Firebase Cloud Messaging |
| UI and visualization | Material, Google Fonts, SVG, fl_chart, shimmer effects |
| Local capabilities | Secure Storage, Shared Preferences, local notifications, foreground tasks |

The exact dependency versions are maintained in [pubspec.yaml](pubspec.yaml).

## Architecture

Ally is the **mobile client**. It owns the application interface, mobile-specific behavior, user preferences, and integration with configured Firebase services.

AI processing is handled by a **separate, private AI Support backend**. Backend implementation details and private credentials do not belong in this repository. Any AI access restrictions, including differences between guest and registered users, should be enforced by trusted backend services rather than by relying on the mobile UI alone.

## Getting started

### Prerequisites

Install and configure the following before running the application:

- Flutter SDK compatible with the Dart constraint in pubspec.yaml (Dart ^3.8.1).
- The Flutter platform tooling for your target: Android Studio/Android SDK and/or Xcode on macOS for iOS.
- A Firebase project with the required application registrations and services.
- Git.

Verify your Flutter installation:

```bash
flutter doctor
```

### 1. Clone the repository

```bash
git clone https://github.com/VertexCorporation/Ally.git
cd Ally
```

### 2. Install dependencies

```bash
flutter pub get
```

### 3. Configure Firebase

Register the Android and iOS applications in your Firebase project using the exact application identifiers configured in the repository.

- **Android:** Place the downloaded google-services.json in android/app/.
- **iOS:** Add GoogleService-Info.plist to the iOS Runner project in Xcode and ensure it is included in the Runner target.

In the Firebase Console, enable only the authentication providers the application is intended to offer. Depending on the sign-in flow being used, these may include Email/Password, Google, Apple, and Anonymous.

Additional provider-specific setup may be required:

**Google Sign-In on Android**
1. Register the app's SHA-1 and SHA-256 signing certificate fingerprints in Firebase Project Settings.
2. Confirm Google is enabled under Firebase Authentication providers.
3. Download a fresh google-services.json after changing the Firebase configuration.

**Google Sign-In on iOS**
1. Confirm Google is enabled in Firebase Authentication.
2. Configure the reversed client ID as a URL scheme for the Runner target in Xcode.
3. Verify that the iOS Firebase configuration belongs to the correct Firebase app.

**Sign in with Apple**
1. Enable Sign in with Apple for the relevant Apple App ID and Xcode target capability.
2. Enable the Apple provider in Firebase Authentication.
3. Complete any required Apple and Firebase provider configuration.

**Guest access**
Enable Anonymous authentication in Firebase if guest sign-in is part of the intended configuration. Guest access should not be assumed to provide the same permissions as an authenticated account.

**Email verification**
If email verification is required by the current sign-in flow, configure and test the verification process in Firebase Authentication. A successful account-creation request does not necessarily mean the email address has been verified.

> **Security:** Never commit service-account keys, private backend credentials, signing keys, or production secrets. Firebase client configuration files are ignored by this repository's .gitignore; follow your team's secret-management policy for local development and deployment.

### 4. Run the application

Connect a device or start an emulator/simulator, then run:

```bash
flutter run
```

To list available targets:

```bash
flutter devices
```

## Development checks

Before submitting changes, run the checks relevant to the code you changed:

```bash
flutter analyze
flutter test
```

If a test suite or platform-specific integration is not yet configured, document that limitation in the pull request rather than treating an unrun check as a pass.

For authentication changes, test each enabled provider on its target platform, including cancellation, invalid configuration, network failures, and sign-out. Test guest and verified-account flows separately.

## Project structure

This is a Flutter application. The main platform and application directories include:

- lib/ — Dart application code.
- android/ — Android platform project.
- ios/ — iOS platform project.
- assets/ — bundled images and audio resources.
- test/ — Flutter tests.
- pubspec.yaml — SDK constraints, dependencies, assets, and application metadata.

Individual files and feature organization may evolve during development.

## Contributing

Contributions, fixes, and focused improvements are welcome.

1. Create a branch for your change.
2. Keep changes scoped and consistent with the existing architecture.
3. Run flutter analyze and relevant tests.
4. Describe the motivation, implementation, and verification performed in your pull request.
5. Never include secrets, personal user data, or real production credentials in commits, screenshots, or logs.

For significant changes to authentication, data storage, or the AI service boundary, explain the security and migration implications in the pull request.

## License

Ally is distributed under the [Apache License 2.0](LICENSE).
