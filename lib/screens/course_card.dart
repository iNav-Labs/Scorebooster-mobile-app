import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scorebooster/screens/billing_screen.dart';
import 'package:scorebooster/screens/bundle_detail_screen.dart';
import 'package:scorebooster/screens/home_screen.dart';

class CourseCard extends StatelessWidget {
  final Course course;

  const CourseCard({
    required this.course,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(12), // Slightly more rounded corners
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08), // More subtle shadow
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      margin: EdgeInsets.only(bottom: 16),
      child: InkWell(
        // Use InkWell for ripple effect on the entire card
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BundleScreen(course: course),
            ),
          );
        },
        borderRadius:
            BorderRadius.circular(12), // Match borderRadius of Container
        child: Padding(
          padding: EdgeInsets.all(20), // Increased padding for more spacing
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                course.title,
                style: TextStyle(
                  // Use Poppins for the title
                  fontSize: 18, // Slightly larger title
                  fontWeight: FontWeight.w600, // Semi-bold
                  color: Colors.grey[800],
                ),
              ),
              SizedBox(height: 12), // Increased spacing
              Text(
                course.description,
                style: TextStyle(
                  // Use Poppins for description
                  fontSize: 12,
                  color: Colors.grey[600],
                  height: 1.4, // Increased line height for better readability
                ),
              ),
              SizedBox(
                  height: 10), // Further spacing before the price and button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Rs. ${course.price}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.orange,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BillingScreen(course: course),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding: EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12), // Adjusted padding
                      textStyle: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      shape: RoundedRectangleBorder(
                        // Add rounded corners to button
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Buy Now',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
