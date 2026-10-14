# Ally

Always your ally.

## Description

Ally is a Flutter-based health companion app designed for iOS and Android platforms.


## Getting Started

### Prerequisites

- Flutter SDK (latest stable version)
- Firebase account and project setup
- iOS/Android development environment

### Installation

1. Clone the repository
```bash
git clone https://github.com/VertexCorporation/Ally.git
```

2. Install dependencies
```bash
flutter pub get
```

3. Configure Firebase
- Add your `google-services.json` for Android in `android/app/`
- Add your `GoogleService-Info.plist` for iOS in `ios/Runner/`
- In Firebase Console > Authentication > Sign-in method, enable Email/Password,
  Google, Apple, and Anonymous for the methods you want to offer.
- The `configuration-not-found` error means Firebase Authentication is not
  configured for the project. Open Authentication in the Firebase Console,
  complete its initial setup, and enable Anonymous for guest sign-in.
- For Android Google sign-in, register the app's SHA-1 and SHA-256 fingerprints
  in Firebase Project Settings, then download a fresh `google-services.json`.
  It must include the Google OAuth client configuration for this app.
- For iOS Google sign-in, add the reversed client ID from
  `GoogleService-Info.plist` to the Runner URL Types in Xcode.
- For Apple sign-in, enable the Sign in with Apple capability for the iOS app
  identifier and configure Apple as a provider in Firebase Authentication.

4. Run the app
```bash
flutter run
```

## License

This project is open-source and available under the Apache 2.0 License.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.
