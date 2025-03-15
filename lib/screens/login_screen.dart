// login_screen.dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scorebooster/backend_apis/google_signin.dart';
import 'package:scorebooster/config.dart';
import 'package:scorebooster/screens/admin_login.dart';
import 'package:scorebooster/screens/home_screen.dart';
import 'package:scorebooster/users/widgets/divider.dart';
import 'package:scorebooster/widgets/general/loader.dart';
import 'package:scorebooster/widgets/login/login_container.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key}); // Corrected super.key

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _authService = AuthService();
  bool showLoginFields = false; // Controls visibility of name/phone fields
  bool _isLoadingSubmit = false; // Loading state for submit button
  bool _isLoadingGoogle = false; // Loading state for Google sign-in

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  double _googleButtonScale = 1.0; // Scale for button tap animation
  double _submitButtonScale = 1.0; // Scale for button tap animation

  @override
  void initState() {
    super.initState();
    _checkExistingLogin();
  }

  Future<void> _registerUser() async {
    // Register user with name and phone number
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('phone', _phoneController.text);
    await prefs.setString('name', _nameController.text);
    if (kDebugMode) {
      print(prefs.get('email'));
    }

    final response = await http.post(
      Uri.parse('${Config.baseUrl}/api/create-customer'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${prefs.getString('access_token')}',
      },
      body: jsonEncode({
        'phone': _phoneController.text,
        'name': _nameController.text,
        'email': prefs.getString('email') ?? '',
      }),
    );
    if (kDebugMode) {
      print(response.body);
    }

    if (kDebugMode) {
      print('User data saved successfully.');
      print('Name: ${_nameController.text}');
      print('Phone: ${_phoneController.text}');
      print(prefs.get('phone'));
      print(prefs.get('name'));
    }
  }

  // Checks if a user name is stored and pre-fills the name field.  Does NOT automatically log in.
  Future<void> _checkExistingLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final userName = prefs.getString('name');
    if (userName != null) {
      _nameController.text = userName;
      setState(() {
        showLoginFields = true; // Only show the fields, do not log in
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
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
                  const CustomDivider(text: "Log in Or Sign up"),
                  const SizedBox(height: 30),
                  // Conditionally render Google Sign-in or name/phone fields
                  if (!showLoginFields) ...[
                    _buildGoogleSignInButton(),
                  ] else ...[
                    _buildLoginFields(),
                  ],
                  const SizedBox(height: 30),
                  Text(
                    'By Signing in you are agreeing to our Terms and Conditions and Policies.',
                    style: GoogleFonts.poppins(
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
            bottom: 250,
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
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Positioned(
            bottom: 10, // Footer at the very bottom
            left: 0,
            right: 0,
            child: _buildFooter(),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Made with ',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Icon(Icons.favorite, color: Colors.red, size: 14),
              Text(
                ' by RebelMinds',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.black, // Brand color
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Builds the name and phone number input fields
  Widget _buildLoginFields() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Column(
        children: [
          _buildTextField(
            controller: _nameController,
            hintText: 'Enter Name',
            keyboardType: TextInputType.name,
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                decoration: BoxDecoration(
                  border: Border.all(
                    // ignore: deprecated_member_use
                    color: Colors.black.withOpacity(0.5),
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '+91',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildTextField(
                  controller: _phoneController,
                  hintText: 'Enter Mobile Number',
                  keyboardType: TextInputType.number,
                  maxLength: 10,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildSubmitButton(context),
        ],
      ),
    );
  }

  // Builds a reusable text field
  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required TextInputType keyboardType,
    int? maxLength,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLength: maxLength,
      maxLines: 1,
      inputFormatters: keyboardType == TextInputType.number
          ? [FilteringTextInputFormatter.digitsOnly]
          : null,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: GoogleFonts.poppins(color: Colors.grey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide:
              // ignore: deprecated_member_use
              BorderSide(color: Colors.black.withOpacity(0.5), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.black, width: 2),
        ),
        counterText: '',
      ),
      style: GoogleFonts.poppins(
        fontWeight: FontWeight.w500,
        color: Colors.black,
        fontSize: 16,
      ),
      cursorColor: Colors.black,
    );
  }

  // Builds the Google Sign-in button
  Widget _buildGoogleSignInButton() {
    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          _googleButtonScale = 0.95; // Scale down on tap
        });
      },
      onTapUp: (_) async {
        setState(() {
          _googleButtonScale = 1.0; // Reset scale
          _isLoadingGoogle = true; // Show loading state
        });

        // Sign in with Google
        final userCredential = await _authService.signInWithGoogle(context);

        setState(() {
          _isLoadingGoogle = false; // Hide loading state
        });

        // If sign-in is successful, show the name/phone fields
        if (userCredential != null) {
          setState(() {
            showLoginFields = true; // Show login fields upon successful sign-in
          });
        }
      },
      onTapCancel: () {
        setState(() {
          _googleButtonScale = 1.0; // Reset scale on cancel
        });
      },
      child: Transform.scale(
        scale: _googleButtonScale,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              // ignore: deprecated_member_use
              color: Colors.black.withOpacity(0.5),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_isLoadingGoogle)
                CustomLoader() // Show loader when loading
              else
                Image.asset(
                  'assets/google_icon.png',
                  height: 24,
                ),
              const SizedBox(width: 10),
              Text(
                _isLoadingGoogle ? '' : 'Sign in with Google',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _submitButtonScale = 0.95),
      onTapUp: (_) async {
        setState(() => _submitButtonScale = 1.0);

        // Validate name and phone number
        if (_nameController.text.isEmpty ||
            _phoneController.text.length != 10) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Validation Error'),
              content: const Text(
                  'Please enter a valid name and 10-digit phone number.'),
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

        // Show loading indicator
        setState(() => _isLoadingSubmit = true);

        try {
          // Save user data
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('name', _nameController.text);
          await prefs.setString('phone', _phoneController.text);

          // Register user (if async, ensure it completes)
          await _registerUser();

          if (kDebugMode) {
            print('User data saved successfully.');
            print('Name: ${_nameController.text}');
            print('Phone: ${_phoneController.text}');
            print('Saved Name: ${prefs.getString('name')}');
            print('Saved Phone: ${prefs.getString('phone')}');
          }

          // Navigate to HomeScreen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MainScreen()),
          );
        } catch (error) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Error'),
              content: Text('Failed to save customer data. Error: $error'),
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
              ? CustomLoader() // Show loader
              : Text(
                  'Submit',
                  style: GoogleFonts.poppins(
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
}
