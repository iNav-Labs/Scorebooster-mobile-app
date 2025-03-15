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
        return macos;
      case TargetPlatform.windows:
        return windows;
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
    apiKey: 'AIzaSyA6g89WyxaWUBn7uZLzv_3bkNFTh8CY6YM',
    appId: '1:744693697638:web:00a51c6eb83c4646df31a7',
    messagingSenderId: '744693697638',
    projectId: 'scorebooster-d4dba',
    authDomain: 'scorebooster-d4dba.firebaseapp.com',
    storageBucket: 'scorebooster-d4dba.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyADdrYw_A3Kjw8L_fjiqSZ_RtNyl8A5pAw',
    appId: '1:744693697638:android:7766ca0865102088df31a7',
    messagingSenderId: '744693697638',
    projectId: 'scorebooster-d4dba',
    storageBucket: 'scorebooster-d4dba.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCholj9dT6ZNmcMKUSCm-dDLVaYDckBWy0',
    appId: '1:744693697638:ios:d1b95473ca1a9d38df31a7',
    messagingSenderId: '744693697638',
    projectId: 'scorebooster-d4dba',
    storageBucket: 'scorebooster-d4dba.firebasestorage.app',
    iosBundleId: 'com.example.scorebooster',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCholj9dT6ZNmcMKUSCm-dDLVaYDckBWy0',
    appId: '1:744693697638:ios:d1b95473ca1a9d38df31a7',
    messagingSenderId: '744693697638',
    projectId: 'scorebooster-d4dba',
    storageBucket: 'scorebooster-d4dba.firebasestorage.app',
    iosBundleId: 'com.example.scorebooster',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyA6g89WyxaWUBn7uZLzv_3bkNFTh8CY6YM',
    appId: '1:744693697638:web:00a51c6eb83c4646df31a7',
    messagingSenderId: '744693697638',
    projectId: 'scorebooster-d4dba',
    authDomain: 'scorebooster-d4dba.firebaseapp.com',
    storageBucket: 'scorebooster-d4dba.firebasestorage.app',
  );
}
