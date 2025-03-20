// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
    apiKey: 'AIzaSyDurg5E4KCobDkRzegYYZgosn5TxoDDOds',
    appId: '1:745532963178:web:068be1df0e023b83538d13',
    messagingSenderId: '745532963178',
    projectId: 'scorebooster-c9659',
    authDomain: 'scorebooster-c9659.firebaseapp.com',
    storageBucket: 'scorebooster-c9659.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDydqGI-8Xm1yhD32kJ509AXwZRLgVtA7E',
    appId: '1:745532963178:android:2ed0b2e8a1fe26f5538d13',
    messagingSenderId: '745532963178',
    projectId: 'scorebooster-c9659',
    storageBucket: 'scorebooster-c9659.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAB3-z3oRBe0yJbzmlo7ZH8NhAjB7Wd-eE',
    appId: '1:745532963178:ios:df25e9a45ec276f9538d13',
    messagingSenderId: '745532963178',
    projectId: 'scorebooster-c9659',
    storageBucket: 'scorebooster-c9659.firebasestorage.app',
    iosBundleId: 'com.example.scorebooster',
  );
}
