# Pair

A production-quality Flutter app for spouses to share live location, chat in real time, and stay connected.

## Features

- Google Sign In with Firebase Authentication
- Spouse pairing via secure single-use codes (10-minute expiration)
- Real-time location sharing on Google Maps
- Real-time chat with read receipts, typing indicators, and pagination
- Online/offline presence tracking
- Push notifications via Firebase Cloud Messaging

## Tech Stack

- Flutter (stable)
- Firebase Auth, Firestore, FCM
- Google Maps Flutter
- Riverpod (state management)
- GoRouter (navigation)
- Freezed + Json Serializable
- Clean Architecture (feature-first)

## Project Structure

```
lib/
├── core/           # Shared utilities, theme, errors
├── features/
│   ├── auth/
│   ├── pairing/
│   ├── location/
│   ├── chat/
│   ├── presence/
│   ├── notifications/
│   └── profile/
├── router/
├── app.dart
└── main.dart
```

## Firebase Setup

### 1. Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Create a new project named `pair`
3. Enable **Authentication** → Sign-in method → **Google**
4. Create a **Firestore** database (production mode)
5. Enable **Cloud Messaging**

### 2. Register Apps

Register Android (`com.redpanda.pair`) and iOS apps in Firebase Console.

### 3. FlutterFire CLI

```bash
dart pub global activate flutterfire_cli
flutterfire configure
```

This generates `lib/firebase_options.dart` with your project credentials.

### 4. Google Sign In

**Android:** Add SHA-1 fingerprint in Firebase Console → Project Settings → Your apps.

```bash
cd android && ./gradlew signingReport
```

**iOS:** Download `GoogleService-Info.plist` and add to `ios/Runner/` via Xcode.

### 5. Google Maps API Key

1. Enable **Maps SDK for Android** and **Maps SDK for iOS** in Google Cloud Console
2. Create an API key with appropriate restrictions
3. Replace `YOUR_GOOGLE_MAPS_API_KEY` in:
   - `android/app/src/main/AndroidManifest.xml`
   - `ios/Runner/Info.plist`

### 6. Deploy Firestore Rules & Indexes

```bash
firebase init firestore
# Select existing firestore.rules and firestore.indexes.json

firebase deploy --only firestore:rules,firestore:indexes
```

### 7. Push Notifications (Server-Side)

FCM tokens are stored on `users/{uid}.fcmToken`. For production push delivery, implement a Cloud Function:

```javascript
// Example: send notification when new message is created
exports.onNewMessage = functions.firestore
  .document('pairs/{pairId}/messages/{messageId}')
  .onCreate(async (snap, context) => {
    // Look up recipient FCM token and send via admin.messaging()
  });
```

The client-side `NotificationService` handles foreground notifications and token management.

## Getting Started

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run
```

## Running Tests

```bash
flutter test
```

## Architecture

Each feature follows Clean Architecture:

```
feature/
├── data/        # Models, datasources, repository implementations
├── domain/      # Entities, repository contracts, use cases
└── presentation/ # Screens, widgets, Riverpod providers
```

## Location Sharing

- **Foreground:** Updates every 30 seconds via `LocationService`
- **Background:** Architecture hooks provided in `LocationService.onBackgroundLocationTick()` for Workmanager or native background service integration

## Security

Firestore security rules enforce:

- Users can only read/write their own profile
- Only pair members can access pair subcollections
- Location/presence writes restricted to the authenticated user's own document

## Color Palette

| Token     | Value     |
|-----------|-----------|
| Primary   | `#E91E63` |
| Secondary | `#FF80AB` |

## License

Private project — not for public distribution.
