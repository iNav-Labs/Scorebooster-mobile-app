import 'package:flutter/material.dart';
import 'package:scorebooster/screens/home_screen.dart';

class PaymentSplashScreen extends StatefulWidget {
  const PaymentSplashScreen({super.key});

  @override
  _PaymentSplashScreenState createState() => _PaymentSplashScreenState();
}

class _PaymentSplashScreenState extends State<PaymentSplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange,
      body: Center(
        child: Text(
          'Success Payment',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
