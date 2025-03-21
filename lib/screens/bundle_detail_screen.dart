// lib/screens/bundle_screen.dart
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:scorebooster/config.dart';
import 'package:scorebooster/screens/home_screen.dart';
import 'package:scorebooster/users/test_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BundleScreen extends StatefulWidget {
  final Course course;

  const BundleScreen({required this.course});

  @override
  _BundleScreenState createState() => _BundleScreenState();
}

class _BundleScreenState extends State<BundleScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _topics = [];
  List<Map<String, dynamic>> _filteredTopics = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchTopics();
  }

  Future<void> _fetchTestQuestions(String testId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('uid');

      if (token == null) {
        setState(() {
          _errorMessage = 'Authentication token not found';
        });
        return;
      }
      print(testId);

      final response = await http.get(
        Uri.parse(
            '${Config.baseUrl}api/test-questions/${widget.course.id}/$testId'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print(data);

        final List<Map<String, dynamic>> formattedQuestions =
            (data['questions'] as List)
                .map<Map<String, dynamic>>((q) => {
                      'question': q['question'],
                      'options': q['options'],
                      'correctAnswer': q['correctAnswer'],
                      'solution': q['solution'] ?? '',
                    })
                .toList();

        // Check if there are no questions
        if (formattedQuestions.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('No questions available for this test')),
          );
          return;
        }

        // Navigate to test page
        // TODO added the commet here
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => QuizPage(
              bundleName: widget.course.title,
              testId: testId,
              questions: formattedQuestions,
              bundleId: widget.course.id,
              // timeInSeconds: data['timeInSeconds'],
              timeInSeconds: formattedQuestions.length,
              title: data['title'],
            ),
          ),
        );
      } else {
        final errorData = json.decode(response.body);
        setState(() {
          _errorMessage =
              'Failed to load test questions: ${errorData['error']}';
        });

        // Show error message to user
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_errorMessage ?? 'Unknown error occurred')),
        );
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error: ${e.toString()}';
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_errorMessage ?? 'Unknown error occurred')),
      );
    }
  }

  Future<void> _fetchTopics() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      setState(() => _isLoading = true);
      print(widget.course.id);
      print(prefs.getString('uid'));

      final response = await http.get(
        Uri.parse('${Config.baseUrl}api/tests/${widget.course.id}'),
        headers: {
          'Authorization': 'Bearer ${prefs.getString('uid')}',
        },
      );
      print(response.body);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        setState(() {
          _topics = data
              .map((test) => {
                    'title': test['title'],
                    'description': test['description'] ?? '',
                    'id': test['id'],
                    'questionsCount': test['questionsCount'].toString(),
                  })
              .toList();

          _filteredTopics = List.from(_topics);
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = 'Failed to load topics: ${response.statusCode}';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error: ${e.toString()}';
        _isLoading = false;
      });
    }
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
                hintStyle: TextStyle(color: Colors.grey),
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
                    style: TextStyle(
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
                        onTap: () => _showStartTestDialog(context, index),
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
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[800],
                              ),
                            ),
                            subtitle: Text(
                              topic['description']!,
                              style: TextStyle(
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

  void _showStartTestDialog(BuildContext context, int index) {
    print(index);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Start Test',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        content: Text(
          'Do you want to start the test?',
          style: TextStyle(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'No',
              style: TextStyle(),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => QuizPage(
              //         // questions: _filteredTopics,
              //         ),
              //   ),
              // );
              _fetchTestQuestions(_filteredTopics[index]['id']);
              if (kDebugMode) {
                print('Test is Starting');
              }
            },
            child: Text(
              'Yes',
              style: TextStyle(),
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
