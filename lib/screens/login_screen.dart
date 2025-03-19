import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:scorebooster/config.dart';
import 'dart:convert';
import 'package:scorebooster/screens/admin_login.dart';
import 'package:scorebooster/screens/home_screen.dart';
import 'package:scorebooster/users/widgets/divider.dart';
import 'package:scorebooster/widgets/general/loader.dart';
import 'package:scorebooster/widgets/login/login_container.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoadingSubmit = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  double _submitButtonScale = 1.0;
  double _signupButtonScale = 1.0;
  bool _isSignUp = false;

  @override
  void initState() {
    super.initState();
    // Check if user is already logged in
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      // User is already logged in, redirect to main screen
      if (kDebugMode) {
        print('User already logged in: ${currentUser.email}');
      }

      final prefs = await SharedPreferences.getInstance();
      if (prefs.getString('email') == null) {
        await prefs.setString('email', currentUser.email ?? '');
      }

      // Using Future.delayed to avoid calling setState during build
      Future.delayed(Duration.zero, () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MainScreen()),
        );
      });
    }
  }

  Future<void> _resetPassword() async {
    if (_emailController.text.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Email Required'),
          content: const Text(
              'Please enter your email address to reset your password.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: _emailController.text,
      );

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Password Reset Email Sent'),
          content:
              const Text('Please check your email to reset your password.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } on FirebaseAuthException catch (e) {
      String errorMessage = "Failed to send password reset email";
      if (e.code == 'user-not-found') {
        errorMessage = "No user found with this email address.";
      } else if (e.code == 'invalid-email') {
        errorMessage = "Please enter a valid email address.";
      }

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: Text(errorMessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: Text(e.toString()),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _signupUser() async {
    setState(() => _isLoadingSubmit = true);

    try {
      // Step 1: Firebase Authentication
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      final User? user = userCredential.user;

      if (user != null) {
        // Get the Firebase ID token
        String? idToken = await user.getIdToken();

        // Step 2: Create customer in the backend
        final response = await http.post(
          Uri.parse('${Config.baseUrl}api/create-customer'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $idToken',
          },
          body: json.encode({
            'name': _nameController.text,
            'phone': _phoneController.text,
          }),
        );

        if (response.statusCode == 200) {
          // Customer created successfully
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('email', user.email ?? '');
          await prefs.setString('name', _nameController.text);
          await prefs.setString('phone', _phoneController.text);

          if (kDebugMode) {
            print('User Registered: ${user.email}');
          }

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MainScreen()),
          );
        } else {
          // Backend API error
          final errorData = json.decode(response.body);
          throw Exception(errorData['error'] ?? 'Failed to create customer');
        }
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage = "An error occurred";
      if (e.code == 'email-already-in-use') {
        errorMessage = "This email is already registered. Please log in.";
      } else if (e.code == 'weak-password') {
        errorMessage = "Password should be at least 6 characters.";
      } else if (e.code == 'invalid-email') {
        errorMessage = "Please enter a valid email address.";
      }

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Signup Error'),
          content: Text(errorMessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } catch (e) {
      // Handle other errors like API errors
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Registration Error'),
          content: Text(e.toString()),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } finally {
      setState(() => _isLoadingSubmit = false);
    }
  }

  Future<void> _loginUser() async {
    setState(() => _isLoadingSubmit = true);

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      final User? user = userCredential.user;

      if (user != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('email', user.email ?? '');

        if (kDebugMode) {
          print('User Logged In: ${user.email}');
        }

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MainScreen()),
        );
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage = "An error occurred";
      if (e.code == 'user-not-found') {
        errorMessage = "No user found with this email. Please sign up.";
      } else if (e.code == 'wrong-password') {
        errorMessage = "Wrong password. Please try again.";
      } else if (e.code == 'invalid-email') {
        errorMessage = "Please enter a valid email address.";
      }

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Login Error'),
          content: Text(errorMessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } finally {
      setState(() => _isLoadingSubmit = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Center(
            child: LoginContainer(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 20),
                  Image.asset(
                    'assets/sb_logo.png',
                    height: 50,
                  ),
                  const SizedBox(height: 35),
                  CustomDivider(text: _isSignUp ? "Sign Up" : "Log in"),
                  const SizedBox(height: 30),
                  _buildLoginFields(),
                  const SizedBox(height: 30),
                  Text(
                    'By Signing in you are agreeing to our Terms and Conditions and Policies.',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.black.withOpacity(0.5),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AdminLoginScreen()),
                );
              },
              child: Text(
                'Admin Login',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginFields() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Column(
        children: [
          if (_isSignUp) ...[
            _buildTextField(
              controller: _nameController,
              hintText: 'Enter Full Name',
              keyboardType: TextInputType.name,
            ),
            const SizedBox(height: 15),
            _buildTextField(
              controller: _phoneController,
              hintText: 'Enter Phone Number',
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 15),
          ],
          _buildTextField(
            controller: _emailController,
            hintText: 'Enter Email',
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 15),
          _buildTextField(
            controller: _passwordController,
            hintText: 'Enter Password',
            keyboardType: TextInputType.text,
            obscureText: true,
          ),
          if (!_isSignUp) ...[
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: _resetPassword,
                child: Text(
                  'Forgot Password?',
                  style: TextStyle(
                    color: const Color(0xFF6552FF),
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ],
          const SizedBox(height: 10),
          _isSignUp ? _buildSignupButton(context) : _buildLoginButton(context),
          const SizedBox(height: 15),
          _buildToggleButton(),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required TextInputType keyboardType,
    bool obscureText = false,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide:
              BorderSide(color: Colors.black.withOpacity(0.5), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.black, width: 2),
        ),
      ),
      style: TextStyle(
        fontWeight: FontWeight.w500,
        color: Colors.black,
        fontSize: 16,
      ),
      cursorColor: Colors.black,
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _submitButtonScale = 0.95),
      onTapUp: (_) async {
        setState(() => _submitButtonScale = 1.0);

        if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Validation Error'),
              content: const Text('Please enter a valid email and password.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
          return;
        }

        await _loginUser();
      },
      onTapCancel: () => setState(() => _submitButtonScale = 1.0),
      child: Transform.scale(
        scale: _submitButtonScale,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 15),
          decoration: BoxDecoration(
            color: const Color(0xFF6552FF),
            borderRadius: BorderRadius.circular(10),
          ),
          child: _isLoadingSubmit
              ? CustomLoader()
              : Text(
                  'Login',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
        ),
      ),
    );
  }

  Widget _buildSignupButton(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _signupButtonScale = 0.95),
      onTapUp: (_) async {
        setState(() => _signupButtonScale = 1.0);

        if (_emailController.text.isEmpty ||
            _passwordController.text.isEmpty ||
            _nameController.text.isEmpty ||
            _phoneController.text.isEmpty) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Validation Error'),
              content: const Text('Please fill all the fields.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
          return;
        }

        await _signupUser();
      },
      onTapCancel: () => setState(() => _signupButtonScale = 1.0),
      child: Transform.scale(
        scale: _signupButtonScale,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 15),
          decoration: BoxDecoration(
            color: const Color(0xFF6552FF),
            borderRadius: BorderRadius.circular(10),
          ),
          child: _isLoadingSubmit
              ? CustomLoader()
              : Text(
                  'Sign Up',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
        ),
      ),
    );
  }

  Widget _buildToggleButton() {
    return TextButton(
      onPressed: () {
        setState(() {
          _isSignUp = !_isSignUp;
          _emailController.clear();
          _passwordController.clear();
          _nameController.clear();
          _phoneController.clear();
        });
      },
      child: Text(
        _isSignUp
            ? 'Already have an account? Log in'
            : 'Don\'t have an account? Sign Up',
        style: TextStyle(
          color: const Color(0xFF6552FF),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
