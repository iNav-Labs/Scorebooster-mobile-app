import 'package:flutter/material.dart';
import 'package:scorebooster/config.dart';
import 'package:scorebooster/screens/home_screen.dart';
import 'package:scorebooster/users/widgets/divider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class ResultsPage extends StatefulWidget {
  const ResultsPage({
    super.key,
    required this.questions,
    required this.bundleId,
    required this.testId,
    required this.testName,
    required this.bundleName,
  });
  final List<Map<String, dynamic>> questions;

  final String bundleId;

  final String testId;

  final String bundleName;

  final String testName;

  @override
  State<ResultsPage> createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage> {
  bool _isSaving = false;
  bool _saveSuccessful = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _saveTestResult();
  }

  int _calculateScore() {
    int correctAnswers = 0;
    for (var question in widget.questions) {
      if (question['selectedOption'] == question['correctAnswer']) {
        correctAnswers++;
      }
    }
    return correctAnswers;
  }

  Future<void> _saveTestResult() async {
    if (_isSaving) return;

    setState(() {
      _isSaving = true;
      _errorMessage = '';
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      // Get the ID token from Firebase
      final idToken = await user.getIdToken();

      final score = _calculateScore();
      final totalQuestions = widget.questions.length;
      final scoreValue = '$score/$totalQuestions';

      final response = await http.post(
        Uri.parse('${Config.baseUrl}api/save-test-result'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $idToken',
        },
        body: jsonEncode({
          'bundleId': widget.bundleId,
          'testId': widget.testId,
          'score': score,
          'bundleName': widget.bundleName,
          'testName': widget.testName,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        setState(() {
          _saveSuccessful = true;
        });
        if (kDebugMode) {
          print('Test result saved successfully');
          print(response.body);
        }
      } else {
        throw Exception('Failed to save test result: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
      if (kDebugMode) {
        print('Error saving test result: $e');
      }
    } finally {
      setState(() {
        _isSaving = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final int score = _calculateScore();
    final int totalQuestions = widget.questions.length;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: GestureDetector(
            onTap: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) {
                return MainScreen();
              }));
            },
            child: Icon(Icons.arrow_back_ios, color: Colors.black)),
        title: Text('Test Results',
            style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.w700)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 244, 134, 23),
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 25),
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Your Score",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 20,
                        ),
                      ),
                      Text(
                        "$score/$totalQuestions",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                  if (_isSaving)
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 15,
                            height: 15,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          ),
                          SizedBox(width: 10),
                          Text(
                            "Saving result...",
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  if (_saveSuccessful && !_isSaving)
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.check_circle,
                              color: Colors.white, size: 15),
                          SizedBox(width: 5),
                          Text(
                            "Result saved",
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  if (_errorMessage.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.error, color: Colors.white, size: 15),
                          SizedBox(width: 5),
                          Flexible(
                            child: Text(
                              "Failed to save result",
                              style: TextStyle(color: Colors.white),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: CustomDivider(text: "Test Analysis"),
            ),
            ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: widget.questions.length,
                itemBuilder: (context, index) {
                  return McqResult(
                    question: widget.questions[index],
                    index: index,
                  );
                })
          ],
        ),
      ),
    );
  }
}

class McqResult extends StatelessWidget {
  const McqResult({
    super.key,
    required this.question,
    required this.index,
  });

  final int index;
  final Map<String, dynamic> question;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            textAlign: TextAlign.start,
            "${index + 1}. ${question['question']}",
            overflow: TextOverflow.clip,
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
          SizedBox(height: 10),
          ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: question['options'].length,
              itemBuilder: (context, optionIndex) {
                final option = question['options'][optionIndex];
                final isSelected = question['selectedOption'] == option;
                final isCorrect = question['correctAnswer'] == option;

                Color backgroundColor = Colors.white;
                Color borderColor = Colors.black;
                Color textColor = Colors.black;

                if (isSelected) {
                  if (isCorrect) {
                    backgroundColor = Colors.green.withOpacity(0.3);
                    borderColor = Colors.green;
                    textColor = Colors.green;
                  } else {
                    backgroundColor = Colors.red.withOpacity(0.3);
                    borderColor = Colors.red;
                    textColor = Colors.red;
                  }
                } else if (isCorrect) {
                  backgroundColor = Colors.green.withOpacity(0.3);
                  borderColor = Colors.green;
                  textColor = Colors.green;
                }

                return Container(
                  margin: EdgeInsets.only(bottom: 5),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                      color: borderColor,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Text(
                        "${String.fromCharCode(65 + optionIndex)}.",
                        style: TextStyle(
                          color: textColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          option,
                          style: TextStyle(
                            color: textColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
          SizedBox(height: 10),
          if (question['selectedOption'] != question['correctAnswer'])
            Text(
              "Correct Answer: ${question['correctAnswer']}",
              style: TextStyle(
                color: Colors.green,
                fontSize: 14,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.5,
              ),
            ),
          if (question['selectedOption'] == null)
            Text(
              "Not attempted",
              style: TextStyle(
                color: Colors.red,
                fontSize: 14,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.5,
              ),
            ),
        ],
      ),
    );
  }
}
