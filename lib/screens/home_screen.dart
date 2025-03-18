// lib/main.dart
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:scorebooster/config.dart';
import 'package:scorebooster/screens/course_card.dart';
import 'package:scorebooster/screens/profile_screen.dart';
import 'package:scorebooster/screens/purchased_bundle.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  List<Course> _courses = [];
  bool _isLoading = true;
  String? _error;

  Future<void> _fetchCourses() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final prefs = await SharedPreferences.getInstance();
      final uid = await FirebaseAuth.instance.currentUser!.getIdToken();
      final response = await http.get(
        Uri.parse('${Config.baseUrl}api/all-bundles'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $uid',
        },
      );

      if (kDebugMode) {
        print(response.body);
      }

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          _courses = data
              .map((item) => Course(
                    id: item['id'],
                    title: item['title'],
                    description: item['description'],
                    imageUrl: item['imageUrl'],
                    price: item['price'].toDouble(),
                  ))
              .toList();
          _filteredCourses = _courses;
          _isLoading = false;
        });
      } else {
        setState(() {
          _error = 'Failed to load courses: ${response.statusCode}';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Error: ${e.toString()}';
        _isLoading = false;
      });
      if (kDebugMode) {
        print('Error fetching courses: $e');
      }
    }
  }

  List<Course> _filteredCourses = [];

  @override
  void initState() {
    super.initState();
    _fetchCourses();
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
