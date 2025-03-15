// lib/main.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scorebooster/screens/course_card.dart';
import 'package:scorebooster/screens/profile_screen.dart';
import 'package:scorebooster/screens/purchased_bundle.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(),
    PurchasedScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.grey[50],
        selectedItemColor: Colors.black,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_books),
            label: 'Purchased',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        selectedLabelStyle: GoogleFonts.poppins(
            fontSize: 12), // Apply Poppins to selected label
        unselectedLabelStyle: GoogleFonts.poppins(
            fontSize: 12), // Apply Poppins to unselected label
      ),
    );
  }
}

// lib/models/course.dart
class Course {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final double price;

  Course({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.price,
  });
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Course> _courses = [
    Course(
      id: '1',
      title: 'JEE Mains 2025',
      description:
          'Covering all the concepts of physics and maths and chemistry',
      imageUrl: 'assets/jee.png',
      price: 499,
    ),
    Course(
      id: '2',
      title: 'NEET Exam 2025',
      description:
          'Covering all the concepts of physics and maths and chemistry',
      imageUrl: 'assets/neet.png',
      price: 499,
    ),
    Course(
      id: '1',
      title: 'JEE Mains 2025',
      description:
          'Covering all the concepts of physics and maths and chemistry',
      imageUrl: 'assets/jee.png',
      price: 499,
    ),
    Course(
      id: '2',
      title: 'NEET Exam 2025',
      description:
          'Covering all the concepts of physics and maths and chemistry',
      imageUrl: 'assets/neet.png',
      price: 499,
    ),
    Course(
      id: '1',
      title: 'JEE Mains 2025',
      description:
          'Covering all the concepts of physics and maths and chemistry',
      imageUrl: 'assets/jee.png',
      price: 499,
    ),
    Course(
      id: '2',
      title: 'NEET Exam 2025',
      description:
          'Covering all the concepts of physics and maths and chemistry',
      imageUrl: 'assets/neet.png',
      price: 499,
    ),
    Course(
      id: '1',
      title: 'JEE Mains 2025',
      description:
          'Covering all the concepts of physics and maths and chemistry',
      imageUrl: 'assets/jee.png',
      price: 499,
    ),
    Course(
      id: '2',
      title: 'NEET Exam 2025',
      description:
          'Covering all the concepts of physics and maths and chemistry',
      imageUrl: 'assets/neet.png',
      price: 499,
    ),
  ];

  List<Course> _filteredCourses = [];

  @override
  void initState() {
    super.initState();
    _filteredCourses = _courses;
  }

  void _filterCourses(String query) {
    setState(() {
      _filteredCourses = _courses
          .where((course) =>
              course.title.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
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
                      onChanged: _filterCourses,
                      hintText: 'Search your Next Goal!',
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.all(16),
                itemCount: _filteredCourses.length,
                itemBuilder: (context, index) {
                  return CourseCard(
                    course: _filteredCourses[index],
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

// lib/widgets/search_bar.dart
class CustomSearchBar extends StatelessWidget {
  final Function(String) onChanged;
  final String hintText;

  const CustomSearchBar({
    required this.onChanged,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: Icon(Icons.search),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
      ),
    );
  }
}
