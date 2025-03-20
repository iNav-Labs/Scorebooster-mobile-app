import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:scorebooster/screens/login_screen.dart'; // Ensure this is your login screen
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    if (kDebugMode) {
      print("Error initializing Firebase: $e");
    }
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Score Booster',
      // home: FutureBuilder<bool>(
      //   future: AuthService().isUserRegistered(),
      //   builder: (context, snapshot) {
      //     if (kDebugMode) {
      //       print("FutureBuilder state: ${snapshot.connectionState}");
      //     }
      //     if (kDebugMode) {
      //       print("FutureBuilder data: ${snapshot.data}");
      //     }

      //     if (snapshot.connectionState == ConnectionState.waiting) {
      //       if (kDebugMode) {
      //         print("FutureBuilder is waiting...");
      //       }
      //       return Scaffold(
      //         body: Center(child: CustomLoader()),
      //       );
      //     }

      //     // Always navigate to LoginScreen first
      //     if (kDebugMode) {
      //       print("Navigating to LoginScreen");
      //     }
      //     return const LoginScreen();
      //   },
      home: const LoginScreen(),
    );
  }
}
