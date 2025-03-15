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
    apiKey: "AIzaSyA6g89WyxaWUBn7uZLzv_3bkNFTh8CY6YM",
    authDomain: "scorebooster-d4dba.firebaseapp.com",
    projectId: "scorebooster-d4dba",
    storageBucket: "scorebooster-d4dba.firebasestorage.app",
    messagingSenderId: "744693697638",
    appId: "1:744693697638:web:772999edcd561c8adf31a7",
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCS5AEn4uSjMSexmFDcQwyK6S4Rdw4rkhs',
    appId: '1:744693697638:android:7766ca0865102088df31a7',
    messagingSenderId: '1058873364957',
    projectId: 'scorebooster-d4dba',
    storageBucket: 'scorecheck-93b26.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAlrTK53QAM2rP-kWsWVvzD1_ZM4IMg_pk',
    appId: '1:1058873364957:ios:fe54595cf7bf4d17c62634',
    messagingSenderId: '1058873364957',
    projectId: 'scorecheck-93b26',
    storageBucket: 'scorecheck-93b26.firebasestorage.app',
    androidClientId:
        '1058873364957-7ttpj4plmamslaotekms50t3sjqfanth.apps.googleusercontent.com',
    iosClientId:
        '1058873364957-ieuku5nucj4jhaors0rrnogf0mheenr5.apps.googleusercontent.com',
    iosBundleId: 'com.example.scorebooster',
  );
}
