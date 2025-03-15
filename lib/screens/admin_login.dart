import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scorebooster/screens/admin_main_screen.dart';

class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange, // Orange background
      appBar: AppBar(
        // Added AppBar
        backgroundColor: Colors.orange, // Match app bar color to background
        elevation: 0, // Remove shadow
        leading: IconButton(
          // Back button
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // Navigate back
          },
        ),
        title: const Text(''), // Empty title to remove default title
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          // Added SingleChildScrollView
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                padding: EdgeInsets.all(
                    8.0), // Optional: Add padding around the image
                child: Image.asset(
                  'assets/sb_logo.png', // Replace with your logo path
                  height: 60, // Adjust size as needed
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Admin Login',
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 40),
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  labelStyle: GoogleFonts.poppins(color: Colors.white70),
                  border: OutlineInputBorder(),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white70),
                  ),
                  prefixIcon: const Icon(Icons.person, color: Colors.white70),
                ),
                style: GoogleFonts.poppins(color: Colors.white),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: GoogleFonts.poppins(color: Colors.white70),
                  border: const OutlineInputBorder(),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white70),
                  ),
                  prefixIcon: const Icon(Icons.lock, color: Colors.white70),
                ),
                style: GoogleFonts.poppins(color: Colors.white),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.orange,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  textStyle: GoogleFonts.poppins(fontSize: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  // TODO: Implement admin authentication logic here
                  String username = _usernameController.text;
                  String password = _passwordController.text;

                  // For demonstration purposes (replace with actual authentication)
                  if (username == "admin" && password == "1234") {
                    // Navigate to admin area
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AdminMainScreen()),
                    );
                    if (kDebugMode) {
                      print('Login Successful');
                    } // Replace with navigation
                  } else {
                    // Show error message
                    if (kDebugMode) {
                      print('Login Failed');
                    } // Replace with error display
                  }
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
