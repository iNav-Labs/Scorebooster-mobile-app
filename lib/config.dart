// config.dart

class Config {
  // Base URL for the Flask backend
  // static const String baseUrl = 'http://127.0.0.1:3000/';
  static const String baseUrl = 'https://scorebooster-mobile-app.onrender.com/';
  // static const String baseUrl = 'https://scorebooster-backend.onrender.com/';
  // static const String baseUrl = 'https://scorebooster-mobile-app.onrender.com/';

  static const String apiKey = 'AIzaSyDNs0SGaEHb7nKA0MHuzktLLyLNh1rwNhA';
  static const String appId = '1:1058873364957:web:556bbe54cc333229c62634';
  static const String clientId =
      '1058873364957-6kn5eqvb4u63ajogogej22csk077va1h.apps.googleusercontent.com';
  static const String messagingSenderId = '1058873364957';
  static const String projectId = 'scorecheck-93b26';
  static const String authDomain = 'scorecheck-93b26.firebaseapp.com';
  static const String storageBucket = 'scorecheck-93b26.firebasestorage.app';
  static const String measurementId = 'G-E4EXQ2Z485';

  // Timeout duration for HTTP requests
  static const Duration timeoutDuration = Duration(seconds: 30);

  // Other configurations can be added here
}
