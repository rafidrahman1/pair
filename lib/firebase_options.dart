// Generated from android/app/google-services.json
// Re-run `flutterfire configure` to regenerate for all platforms.
//
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyD5f6RVewfeN7pLccNIDGzuv6-_nvmjwQY',
    appId: '1:474066158822:android:4b8466d08c51e28f346727',
    messagingSenderId: '474066158822',
    projectId: 'pair-d7dd3',
    authDomain: 'pair-d7dd3.firebaseapp.com',
    storageBucket: 'pair-d7dd3.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD5f6RVewfeN7pLccNIDGzuv6-_nvmjwQY',
    appId: '1:474066158822:android:4b8466d08c51e28f346727',
    messagingSenderId: '474066158822',
    projectId: 'pair-d7dd3',
    storageBucket: 'pair-d7dd3.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD5f6RVewfeN7pLccNIDGzuv6-_nvmjwQY',
    appId: '1:474066158822:android:4b8466d08c51e28f346727',
    messagingSenderId: '474066158822',
    projectId: 'pair-d7dd3',
    storageBucket: 'pair-d7dd3.firebasestorage.app',
    iosBundleId: 'com.redpanda.pair',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyD5f6RVewfeN7pLccNIDGzuv6-_nvmjwQY',
    appId: '1:474066158822:android:4b8466d08c51e28f346727',
    messagingSenderId: '474066158822',
    projectId: 'pair-d7dd3',
    storageBucket: 'pair-d7dd3.firebasestorage.app',
    iosBundleId: 'com.redpanda.pair',
  );
}
