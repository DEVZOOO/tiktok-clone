// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDJgC_gsZ-DOjN91Bh402Z2qpiedDX_hGA',
    appId: '1:607241127530:web:a28ed70d422489043dec13',
    messagingSenderId: '607241127530',
    projectId: 'judy-tiktok-clone',
    authDomain: 'judy-tiktok-clone.firebaseapp.com',
    storageBucket: 'judy-tiktok-clone.appspot.com',
    measurementId: 'G-PCJNCT1V55',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAIjgvifVvnKN2SUesK3OsXLqwcDN-EEhY',
    appId: '1:607241127530:android:c7f4eeb291368a773dec13',
    messagingSenderId: '607241127530',
    projectId: 'judy-tiktok-clone',
    storageBucket: 'judy-tiktok-clone.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAMPyYKWpGek2p3eqEHQvwY03Hs91mD96c',
    appId: '1:607241127530:ios:3c37a2dae3cf7c7f3dec13',
    messagingSenderId: '607241127530',
    projectId: 'judy-tiktok-clone',
    storageBucket: 'judy-tiktok-clone.appspot.com',
    iosBundleId: 'com.example.tiktokClone',
  );
}
