// lib/screens/bundle_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scorebooster/screens/home_screen.dart';

class BundleScreen extends StatefulWidget {
  final Course course;

  const BundleScreen({required this.course});

  @override
  _BundleScreenState createState() => _BundleScreenState();
}

class _BundleScreenState extends State<BundleScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, String>> _topics = [
    {
      'title': 'Center of Mass',
      'description':
          'Covering all the concepts related to center of mass and its applications.',
    },
    {
      'title': 'Organic Chemistry',
      'description':
          'Fundamentals of organic chemistry, including nomenclature and reactions.',
    },
    {
      'title': 'Integration Derivatives',
      'description':
          'Mastering integration and derivatives with practice problems and examples.',
    },
    {
      'title': 'Newton\'s Laws of Motion',
      'description':
          'A comprehensive study of Newton\'s three laws and their applications in mechanics.',
    },
    {
      'title': 'Thermodynamics',
      'description':
          'Exploring the principles of thermodynamics and their role in energy transfer.',
    },
    {
      'title': 'Chemical Bonding',
      'description':
          'Understanding the different types of chemical bonds and their properties.',
    },
    {
      'title': 'Matrices and Determinants',
      'description':
          'Learn about matrices, determinants, and their applications in linear algebra.',
    },
    {
      'title': 'Optics',
      'description':
          'Explore the principles of light, reflection, refraction, and optical instruments.',
    },
    {
      'title': 'Optics',
      'description':
          'Explore the principles of light, reflection, refraction, and optical instruments.',
    },
    {
      'title': 'Optics',
      'description':
          'Explore the principles of light, reflection, refraction, and optical instruments.',
    },
  ];
  List<Map<String, String>> _filteredTopics = [];

  @override
  void initState() {
    super.initState();
    _filteredTopics =
        List.from(_topics); // Initialize filtered list with all topics
  }

  void _filterTopics(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredTopics = List.from(_topics); // Reset to original list
      } else {
        _filteredTopics = _topics.where((topic) {
          return topic['title']!.toLowerCase().contains(query.toLowerCase()) ||
              topic['description']!.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.grey[50],
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.course.title,
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search topics...',
                hintStyle: GoogleFonts.poppins(color: Colors.grey),
                prefixIcon: Icon(Icons.search, color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
              onChanged: _filterTopics,
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Topics Covered',
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                    ),
                  ),
                  SizedBox(height: 16),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: _filteredTopics.length,
                    itemBuilder: (context, index) {
                      final topic = _filteredTopics[index];
                      return GestureDetector(
                        onTap: () => _showStartTestDialog(context),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                blurRadius: 8,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          margin: EdgeInsets.only(bottom: 16),
                          child: ListTile(
                            title: Text(
                              topic['title']!,
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[800],
                              ),
                            ),
                            subtitle: Text(
                              topic['description']!,
                              style: GoogleFonts.poppins(
                                fontSize: 10,
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showStartTestDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Start Test',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        content: Text(
          'Do you want to start the test?',
          style: GoogleFonts.poppins(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'No',
              style: GoogleFonts.poppins(),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              print('Test is Starting');
            },
            child: Text(
              'Yes',
              style: GoogleFonts.poppins(),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
