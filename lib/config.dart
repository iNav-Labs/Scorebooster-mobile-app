// config.dart

class Config {
  // Base URL for the Flask backend
  static const String baseUrl = 'http://127.0.0.1:3000/';
  // static const String baseUrl = 'https://scorebooster-mobile-app.onrender.com/';
  // static const String baseUrl = 'https://scorebooster-backend.onrender.com/';
  // static const String baseUrl = 'https://scorebooster-mobile-app.onrender.com/';

  static const String apiKey = 'AIzaSyDurg5E4KCobDkRzegYYZgosn5TxoDDOds';
  static const String appId = '1:745532963178:web:068be1df0e023b83538d13';
  static const String clientId =
      '745532963178-neao83h47tksqas2u1hmr90742rj431d.apps.googleusercontent.com';
  static const String messagingSenderId = '745532963178';
  static const String projectId = 'scorebooster-c9659';
  static const String authDomain = 'scorebooster-c9659.firebaseapp.com';
  static const String storageBucket = 'scorebooster-c9659.firebasestorage.app';

  // Timeout duration for HTTP requests
  static const Duration timeoutDuration = Duration(seconds: 30);

  // Other configurations can be added here
}
