import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:scorebooster/config.dart';
import 'package:scorebooster/screens/home_screen.dart';
import 'package:scorebooster/screens/payment_splash.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BillingScreen extends StatefulWidget {
  final Course course;

  const BillingScreen({required this.course});

  @override
  State<BillingScreen> createState() => _BillingScreenState();
}

class _BillingScreenState extends State<BillingScreen> {
  // Add a function to handle the bundle purchase
  Future<void> purchaseBundle(String bundleId) async {
    final prefs = await SharedPreferences.getInstance();
    try {
      final response = await http.post(
        Uri.parse('${Config.baseUrl}api/purchase-bundle'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${prefs.getString('access_token')}',
        },
        body: jsonEncode({
          'bundleId': bundleId,
        }),
      );

      if (response.statusCode == 200) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Bundle purchased successfully!')),
        );
        // Optionally navigate to success screen
      } else {
        final errorData = jsonDecode(response.body);
        // ignore: use_build_context_synchronously
        if (kDebugMode) {
          print(errorData);
        }
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorData['error'] ?? 'Purchase failed')),
        );
      }
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Billing Details',
          style: TextStyle(color: Colors.black),
        ),
      ),
      backgroundColor:
          Colors.grey[100], // A light background for the whole screen
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          padding: EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Order Summary',
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Course:',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  Text(
                    widget.course.title,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Price:',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  Text(
                    'Rs. ${widget.course.price}',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.orange,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24),
              Divider(color: Colors.grey[300], thickness: 1),
              SizedBox(height: 24),
              Text(
                'Payment Method Accepted',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
              ),
              SizedBox(height: 16),
              // Add your payment method selection UI here (e.g., radio buttons for different payment options)
              // For now, let's just add a placeholder:
              ListTile(
                leading: Icon(Icons.payment, color: Colors.orange),
                title: Text(
                  'Credit/Debit Card',
                  style: GoogleFonts.poppins(fontSize: 16),
                ),
                // You can add onTap functionality to handle payment method selection
              ),
              ListTile(
                leading:
                    Icon(Icons.account_balance_wallet, color: Colors.orange),
                title: Text(
                  'UPI',
                  style: GoogleFonts.poppins(fontSize: 16),
                ),
                // You can add onTap functionality to handle payment method selection
              ),
              ListTile(
                leading:
                    Icon(Icons.account_balance_wallet, color: Colors.orange),
                title: Text(
                  'Net Banking',
                  style: GoogleFonts.poppins(fontSize: 16),
                ),
                // You can add onTap functionality to handle payment method selection
              ),
              SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    purchaseBundle(widget.course.id);
                    if (kDebugMode) {
                      print('Purchased');
                    }
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PaymentSplashScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    textStyle: GoogleFonts.poppins(
                        fontSize: 18, fontWeight: FontWeight.w600),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Submit Payment',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
