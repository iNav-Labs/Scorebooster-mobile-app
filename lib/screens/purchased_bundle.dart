// lib/screens/purchased_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scorebooster/screens/bundle_detail_screen.dart';
import 'package:scorebooster/screens/home_screen.dart';

class PurchasedScreen extends StatefulWidget {
  @override
  _PurchasedScreenState createState() => _PurchasedScreenState();
}

class _PurchasedScreenState extends State<PurchasedScreen> {
  // Sample purchased courses data
  final List<Course> _purchasedCourses = [
    Course(
      id: '1',
      title: 'JEE mains 2025',
      description:
          'Covering all the concepts of physics and maths and chemistry',
      imageUrl: 'assets/jee.png',
      price: 499,
      // You might want to add additional fields like purchaseDate, progress, etc.
    ),
    Course(
      id: '2',
      title: 'NEET exam 2025',
      description:
          'Covering all the concepts of physics and maths and chemistry',
      imageUrl: 'assets/neet.png',
      price: 499,
    ),
    Course(
      id: '3',
      title: 'CSE GATE exams 2025',
      description:
          'Covering all the concepts of physics and maths and chemistry',
      imageUrl: 'assets/gate.png',
      price: 499,
    ),
  ];

  List<Course> _filteredCourses = [];

  @override
  void initState() {
    super.initState();
    _filteredCourses = _purchasedCourses;
  }

  void _filterCourses(String query) {
    setState(() {
      _filteredCourses = _purchasedCourses
          .where((course) =>
              course.title.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Column(
          children: [
            // Header with logo and search
            Container(
              padding: EdgeInsets.all(16),
              color: Colors.white,
              child: Row(
                children: [
                  Image.asset(
                    'assets/sb_logo.png',
                    height: 40,
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: CustomSearchBar(
                      // Assuming you will update this
                      onChanged: _filterCourses,
                      hintText: 'Search your purchased courses',
                    ),
                  ),
                ],
              ),
            ),

            // Course count indicator
            Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  Text(
                    'Your Courses (${_filteredCourses.length})',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                    ),
                  ),
                ],
              ),
            ),

            // Purchased courses list
            Expanded(
              child: _filteredCourses.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.library_books,
                            size: 64,
                            color: Colors.grey[400], // Changed color
                          ),
                          SizedBox(height: 16),
                          Text(
                            'No purchased courses found',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      itemCount: _filteredCourses.length,
                      itemBuilder: (context, index) {
                        return PurchasedCourseCard(
                          course: _filteredCourses[index],
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BundleScreen(
                                  course: _filteredCourses[index],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// Add this new widget for purchased course cards
class PurchasedCourseCard extends StatelessWidget {
  final Course course;
  final VoidCallback onTap;

  const PurchasedCourseCard({
    required this.course,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      margin: EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    course.title,
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green[50],
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'Purchased',
                      style: GoogleFonts.poppins(
                        color: Colors.green[700],
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Text(
                course.description,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.grey[600],
                  height: 1.4,
                ),
              ),
              SizedBox(height: 16),
              // Progress indicator
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Progress',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[700],
                        ),
                      ),
                      Text(
                        '45%', // This would come from your course data
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: 0.45, // This would come from your course data
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
                    minHeight: 6,
                  ),
                ],
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.access_time,
                          size: 16, color: Colors.grey[600]),
                      SizedBox(width: 4),
                      Text(
                        'Last accessed: 2 days ago', // This would come from your course data
                        style: GoogleFonts.poppins(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: onTap,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      textStyle: GoogleFonts.poppins(fontSize: 14),
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    ),
                    child: Text(
                      'Continue Learning',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
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

// Assuming this is the code for search bar widget you want to customize with same theme
class CustomSearchBar extends StatelessWidget {
  final ValueChanged<String> onChanged;
  final String hintText;

  const CustomSearchBar({
    required this.onChanged,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: GoogleFonts.poppins(fontSize: 14, color: Colors.grey),
        prefixIcon: Icon(Icons.search, color: Colors.grey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.grey[100],
      ),
      onChanged: onChanged,
    );
  }
}
