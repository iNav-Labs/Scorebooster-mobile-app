import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:scorebooster/backend_apis/google_signin.dart';
import 'package:scorebooster/screens/login_screen.dart'; // Ensure this is your login screen
import 'package:scorebooster/widgets/general/loader.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    print("Error initializing Firebase: $e");
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
      home: FutureBuilder<bool>(
        future: AuthService().isUserRegistered(),
        builder: (context, snapshot) {
          print("FutureBuilder state: ${snapshot.connectionState}");
          print("FutureBuilder data: ${snapshot.data}");

          if (snapshot.connectionState == ConnectionState.waiting) {
            print("FutureBuilder is waiting...");
            return Scaffold(
              body: Center(child: CustomLoader()),
            );
          }

          // Always navigate to LoginScreen first
          print("Navigating to LoginScreen");
          return const LoginScreen();
        },
      ),
    );
  }
}
