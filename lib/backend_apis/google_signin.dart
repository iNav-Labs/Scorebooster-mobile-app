import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:scorebooster/config.dart';
import 'package:scorebooster/screens/home_screen.dart';
import 'package:scorebooster/screens/login_screen.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
    clientId: Config.clientId,
  );

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final String baseUrl = Config.baseUrl;

  Future<UserCredential?> signInWithGoogle(BuildContext context) async {
    try {
      UserCredential? userCredential;

      if (Theme.of(context).platform == TargetPlatform.android ||
          Theme.of(context).platform == TargetPlatform.iOS) {
        // Mobile sign in flow
        final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
        if (googleUser == null) return null;

        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        userCredential = await _auth.signInWithCredential(credential);
      } else {
        // Web sign in flow
        final provider = GoogleAuthProvider();
        userCredential = await _auth.signInWithPopup(provider);
      }

      if (userCredential.user != null) {
        // Store user data using SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('email', userCredential.user!.email ?? '');
        await prefs.setString('name', userCredential.user!.displayName ?? '');
        await prefs.setString(
            'user_photo', userCredential.user!.photoURL ?? '');

        if (kDebugMode) {
          print('Sign-in successful: ${userCredential.user!.displayName}');
        }

        // Check if user is registered
        bool isRegistered =
            await isExistRegistered(userCredential.user!.email!);
        // bool isRegistered = await isLoggedin();
        if (kDebugMode) {
          print(isRegistered);
        }

        if (isRegistered) {
          // Navigate to HomeScreen
          // ignore: use_build_context_synchronously
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => MainScreen()),
            (route) => false,
          );
        } else {
          // Navigate to LoginScreen instead of showing dialog
          // ignore: use_build_context_synchronously
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const LoginScreen()),
            (route) => false,
          );
        }
      }

      return userCredential;
    } catch (e) {
      if (kDebugMode) {
        print('Error during Google Sign-In: $e');
      }
      await showDialog(
        // ignore: use_build_context_synchronously
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Sign In Error'),
          content: Text('An error occurred during sign in: ${e.toString()}'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return null;
    }
  }

  // Future<UserCredential?> signInWithGoogle(BuildContext context) async {
  //   try {
  //     UserCredential? userCredential;

  //     if (Theme.of(context).platform == TargetPlatform.android ||
  //         Theme.of(context).platform == TargetPlatform.iOS) {
  //       // Mobile sign-in flow
  //       final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
  //       if (googleUser == null) return null;

  //       final GoogleSignInAuthentication googleAuth =
  //           await googleUser.authentication;
  //       final credential = GoogleAuthProvider.credential(
  //         accessToken: googleAuth.accessToken,
  //         idToken: googleAuth.idToken,
  //       );

  //       userCredential = await _auth.signInWithCredential(credential);
  //     } else {
  //       // Web sign-in flow
  //       final provider = GoogleAuthProvider();

  //       if (kIsWeb &&
  //           (defaultTargetPlatform == TargetPlatform.iOS ||
  //               defaultTargetPlatform == TargetPlatform.android)) {
  //         // Use redirect for mobile browsers
  //         await _auth.signInWithRedirect(provider);
  //         return null; // Return null as the result comes later via onAuthStateChanged
  //       } else {
  //         // Use popup for desktop browsers
  //         userCredential = await _auth.signInWithPopup(provider);
  //       }
  //     }

  //     if (userCredential != null && userCredential.user != null) {
  //       final prefs = await SharedPreferences.getInstance();
  //       await prefs.setString('email', userCredential.user!.email ?? '');
  //       await prefs.setString('name', userCredential.user!.displayName ?? '');
  //       await prefs.setString(
  //           'user_photo', userCredential.user!.photoURL ?? '');

  //       bool isRegistered =
  //           await isExistRegistered(userCredential.user!.email!);

  //       if (isRegistered) {
  //         if (context.mounted) {
  //           Navigator.of(context).pushAndRemoveUntil(
  //             MaterialPageRoute(builder: (context) => MainScreen()),
  //             (route) => false,
  //           );
  //         }
  //       } else {
  //         if (context.mounted) {
  //           Navigator.of(context).pushAndRemoveUntil(
  //             MaterialPageRoute(builder: (context) => const LoginScreen()),
  //             (route) => false,
  //           );
  //         }
  //       }
  //     }

  //     return userCredential;
  //   } catch (e) {
  //     if (kDebugMode) {
  //       print('Error during Google Sign-In: $e');
  //     }

  //     if (context.mounted) {
  //       await showDialog(
  //         context: context,
  //         builder: (context) => AlertDialog(
  //           title: const Text('Sign In Error'),
  //           content: Text('An error occurred during sign-in: ${e.toString()}'),
  //           actions: [
  //             TextButton(
  //               onPressed: () => Navigator.pop(context),
  //               child: const Text('OK'),
  //             ),
  //           ],
  //         ),
  //       );
  //     }
  //     return null;
  //   }
  // }

  Future<bool> isExistRegistered(String email) async {
    try {
      final customerExists = await fetchAllCustomers(email);
      if (customerExists) {
        final user = FirebaseAuth.instance.currentUser;
        final prefs = await SharedPreferences.getInstance();
        prefs.setString('email', user!.email!);
        prefs.setString('name', user.displayName!);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      if (kDebugMode) {
        print('An error occurred while checking registration: $e');
      }
      return false; // Optionally, return false or rethrow the error based on your use case
    }
  }

  Future<bool> isLoggedin() async {
    final prefs = await SharedPreferences.getInstance();
    final phone = prefs.getString('phone');
    final name = prefs.getString('name');
    if (kDebugMode) {
      print(phone);
    }
    if (kDebugMode) {
      print(name);
    }
    if (phone != null && name != null) {
      return true;
    }
    return false;
  }

  Future<bool> isUserRegistered() async {
    final user = FirebaseAuth.instance.currentUser;
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('email', user!.email!);

    // Check if user is authenticated
    if (user == null) {
      if (kDebugMode) {
        print('No user is currently logged in.');
      }
      return false; // User is not logged in
    }

    if (kDebugMode) {
      print('CURRENT USER: ${user.email}');
    }

    try {
      final customers = await fetchAllCustomers(user.email!);

      // Check if the customer exists in the database
      if (customers) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      // Handle exceptions that may occur during fetching customers
      if (kDebugMode) {
        print('An error occurred while checking registration: $e');
      }
      return false; // Optionally, return false or rethrow the error based on your use case
    }
  }

  Future<bool> fetchAllCustomers(String email) async {
    try {
      final uid = await FirebaseAuth.instance.currentUser!.getIdToken();

      final prefs = await SharedPreferences.getInstance();
      prefs.setString("access_token", uid.toString());
      final response = await http.get(
        Uri.parse('${baseUrl}api/customer-exists'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $uid',
        },
        // body: jsonEncode({'email': email}),
      );
      if (kDebugMode) {
        print(response.body);
      }
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (kDebugMode) {
          print(data['exists']);
        }
        return data['exists'];
      }
      throw Exception('Failed to check customer existence');
    } catch (e) {
      if (kDebugMode) {
        print('Error checking customer existence: $e');
      }
      return false;
    }
  }

  Future<String> fetchCustomerPhone(String email) async {
    try {
      final response = await http
          .get(Uri.parse('${baseUrl}api/get-customer-phone'), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization':
            'Bearer ${await FirebaseAuth.instance.currentUser!.getIdToken()}',
      });
      if (kDebugMode) {
        print(response.body);
      }
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (kDebugMode) {
          print(data);
        }
        return data['phone'];
      }
      throw Exception('Failed to check customer existence');
    } catch (e) {
      if (kDebugMode) {
        print('Error checking customer existence: $e');
      }
      return '';
    }
  }

  Future<void> signOut() async {
    try {
      await Future.wait([
        _auth.signOut(),
        _googleSignIn.signOut(),
      ]);

      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
    } catch (e) {
      if (kDebugMode) {
        print('Error signing out: $e');
      }
    }
  }

  Future<void> logout(BuildContext context) async {
    try {
      await _auth.signOut();
      await _googleSignIn.signOut();

      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      // ignore: use_build_context_synchronously
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false,
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error during logout: $e');
      }
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error logging out. Please try again.')),
      );
    }
  }
}
