import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:scorebooster/users/results_page.dart';
import 'package:scorebooster/users/widgets/custom_drawer.dart';
import 'package:scorebooster/users/widgets/timer.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int _currentQuestionIndex = 0;
  final List<Map<String, dynamic>> _questions = [
    {
      'question': 'A cup of water was enough to _____ his thirst.',
      'options': [
        'satisfy',
        'appease',
        'quench',
        'extinguish',
      ],
      'correctAnswer': 'quench'
    },
    {
      'question': 'The police have _____ the suspect.',
      'options': [
        'arrested',
        'captured',
        'seized',
        'apprehended',
      ],
      'correctAnswer': 'arrested'
    },
    {
      'question': 'A cup of water was enough to _____ his thirst.',
      'options': [
        'satisfy',
        'appease',
        'quench',
        'extinguish',
      ],
      'correctAnswer': 'quench'
    },
    {
      'question': 'The police have _____ the suspect.',
      'options': [
        'arrested',
        'captured',
        'seized',
        'apprehended',
      ],
      'correctAnswer': 'arrested'
    },
    {
      'question': 'A cup of water was enough to _____ his thirst.',
      'options': [
        'satisfy',
        'appease',
        'quench',
        'extinguish',
      ],
      'correctAnswer': 'quench'
    },
    {
      'question': 'The police have _____ the suspect.',
      'options': [
        'arrested',
        'captured',
        'seized',
        'apprehended',
      ],
      'correctAnswer': 'arrested'
    },
    {
      'question': 'A cup of water was enough to _____ his thirst.',
      'options': [
        'satisfy',
        'appease',
        'quench',
        'extinguish',
      ],
      'correctAnswer': 'quench'
    },
    {
      'question': 'The police have _____ the suspect.',
      'options': [
        'arrested',
        'captured',
        'seized',
        'apprehended',
      ],
      'correctAnswer': 'arrested'
    },
    {
      'question': 'A cup of water was enough to _____ his thirst.',
      'options': [
        'satisfy',
        'appease',
        'quench',
        'extinguish',
      ],
      'correctAnswer': 'quench'
    },
    {
      'question': 'The police have _____ the suspect.',
      'options': [
        'arrested',
        'captured',
        'seized',
        'apprehended',
      ],
      'correctAnswer': 'arrested'
    },
    {
      'question': 'A cup of water was enough to _____ his thirst.',
      'options': [
        'satisfy',
        'appease',
        'quench',
        'extinguish',
      ],
      'correctAnswer': 'quench'
    },
    {
      'question': 'The police have _____ the suspect.',
      'options': [
        'arrested',
        'captured',
        'seized',
        'apprehended',
      ],
      'correctAnswer': 'arrested'
    },
    {
      'question': 'A cup of water was enough to _____ his thirst.',
      'options': [
        'satisfy',
        'appease',
        'quench',
        'extinguish',
      ],
      'correctAnswer': 'quench'
    },
    {
      'question': 'The police have _____ the suspect.',
      'options': [
        'arrested',
        'captured',
        'seized',
        'apprehended',
      ],
      'correctAnswer': 'arrested'
    },
    {
      'question': 'A cup of water was enough to _____ his thirst.',
      'options': [
        'satisfy',
        'appease',
        'quench',
        'extinguish',
      ],
      'correctAnswer': 'quench'
    },
    {
      'question': 'The police have _____ the suspect.',
      'options': [
        'arrested',
        'captured',
        'seized',
        'apprehended',
      ],
      'correctAnswer': 'arrested'
    },
    {
      'question': 'A cup of water was enough to _____ his thirst.',
      'options': [
        'satisfy',
        'appease',
        'quench',
        'extinguish',
      ],
      'correctAnswer': 'quench'
    },
    {
      'question': 'The police have _____ the suspect.',
      'options': [
        'arrested',
        'captured',
        'seized',
        'apprehended',
      ],
      'correctAnswer': 'arrested'
    },
    {
      'question': 'A cup of water was enough to _____ his thirst.',
      'options': [
        'satisfy',
        'appease',
        'quench',
        'extinguish',
      ],
      'correctAnswer': 'quench'
    },
    {
      'question': 'The police have _____ the suspect.',
      'options': [
        'arrested',
        'captured',
        'seized',
        'apprehended',
      ],
      'correctAnswer': 'arrested'
    },
    {
      'question': 'A cup of water was enough to _____ his thirst.',
      'options': [
        'satisfy',
        'appease',
        'quench',
        'extinguish',
      ],
      'correctAnswer': 'quench'
    },
    {
      'question': 'The police have _____ the suspect.',
      'options': [
        'arrested',
        'captured',
        'seized',
        'apprehended',
      ],
      'correctAnswer': 'arrested'
    },
    {
      'question': 'A cup of water was enough to _____ his thirst.',
      'options': [
        'satisfy',
        'appease',
        'quench',
        'extinguish',
      ],
      'correctAnswer': 'quench'
    },
    {
      'question': 'The police have _____ the suspect.',
      'options': [
        'arrested',
        'captured',
        'seized',
        'apprehended',
      ],
      'correctAnswer': 'arrested'
    },
    {
      'question': 'A cup of water was enough to _____ his thirst.',
      'options': [
        'satisfy',
        'appease',
        'quench',
        'extinguish',
      ],
      'correctAnswer': 'quench'
    },
    {
      'question': 'The police have _____ the suspect.',
      'options': [
        'arrested',
        'captured',
        'seized',
        'apprehended',
      ],
      'correctAnswer': 'arrested'
    },
    {
      'question': 'A cup of water was enough to _____ his thirst.',
      'options': [
        'satisfy',
        'appease',
        'quench',
        'extinguish',
      ],
      'correctAnswer': 'quench'
    },
    {
      'question': 'The police have _____ the suspect.',
      'options': [
        'arrested',
        'captured',
        'seized',
        'apprehended',
      ],
      'correctAnswer': 'arrested'
    },
    {
      'question': 'A cup of water was enough to _____ his thirst.',
      'options': [
        'satisfy',
        'appease',
        'quench',
        'extinguish',
      ],
      'correctAnswer': 'quench'
    },
    {
      'question': 'The police have _____ the suspect.',
      'options': [
        'arrested',
        'captured',
        'seized',
        'apprehended',
      ],
      'correctAnswer': 'arrested'
    },
    {
      'question': 'A cup of water was enough to _____ his thirst.',
      'options': [
        'satisfy',
        'appease',
        'quench',
        'extinguish',
      ],
      'correctAnswer': 'quench'
    },
    {
      'question': 'The police have _____ the suspect.',
      'options': [
        'arrested',
        'captured',
        'seized',
        'apprehended',
      ],
      'correctAnswer': 'arrested'
    },
    {
      'question': 'A cup of water was enough to _____ his thirst.',
      'options': [
        'satisfy',
        'appease',
        'quench',
        'extinguish',
      ],
      'correctAnswer': 'quench'
    },
    {
      'question': 'The police have _____ the suspect.',
      'options': [
        'arrested',
        'captured',
        'seized',
        'apprehended',
      ],
      'correctAnswer': 'arrested'
    },
    {
      'question': 'A cup of water was enough to _____ his thirst.',
      'options': [
        'satisfy',
        'appease',
        'quench',
        'extinguish',
      ],
      'correctAnswer': 'quench'
    },
    {
      'question': 'The police have _____ the suspect.',
      'options': [
        'arrested',
        'captured',
        'seized',
        'apprehended',
      ],
      'correctAnswer': 'arrested'
    },
    {
      'question': 'A cup of water was enough to _____ his thirst.',
      'options': [
        'satisfy',
        'appease',
        'quench',
        'extinguish',
      ],
      'correctAnswer': 'quench'
    },
    {
      'question': 'The police have _____ the suspect.',
      'options': [
        'arrested',
        'captured',
        'seized',
        'apprehended',
      ],
      'correctAnswer': 'arrested'
    },
    {
      'question': 'A cup of water was enough to _____ his thirst.',
      'options': [
        'satisfy',
        'appease',
        'quench',
        'extinguish',
      ],
      'correctAnswer': 'quench'
    },
    {
      'question': 'The police have _____ the suspect.',
      'options': [
        'arrested',
        'captured',
        'seized',
        'apprehended',
      ],
      'correctAnswer': 'arrested'
    },
    {
      'question': 'A cup of water was enough to _____ his thirst.',
      'options': [
        'satisfy',
        'appease',
        'quench',
        'extinguish',
      ],
      'correctAnswer': 'quench'
    },
    {
      'question': 'The police have _____ the suspect.',
      'options': [
        'arrested',
        'captured',
        'seized',
        'apprehended',
      ],
      'correctAnswer': 'arrested'
    },
    {
      'question': 'A cup of water was enough to _____ his thirst.',
      'options': [
        'satisfy',
        'appease',
        'quench',
        'extinguish',
      ],
      'correctAnswer': 'quench'
    },
    {
      'question': 'The police have _____ the suspect.',
      'options': [
        'arrested',
        'captured',
        'seized',
        'apprehended',
      ],
      'correctAnswer': 'arrested'
    },
    {
      'question': 'A cup of water was enough to _____ his thirst.',
      'options': [
        'satisfy',
        'appease',
        'quench',
        'extinguish',
      ],
      'correctAnswer': 'quench'
    },
    {
      'question': 'The police have _____ the suspect.',
      'options': [
        'arrested',
        'captured',
        'seized',
        'apprehended',
      ],
      'correctAnswer': 'arrested'
    },
    {
      'question': 'A cup of water was enough to _____ his thirst.',
      'options': [
        'satisfy',
        'appease',
        'quench',
        'extinguish',
      ],
      'correctAnswer': 'quench'
    },
    {
      'question': 'The police have _____ the suspect.',
      'options': [
        'arrested',
        'captured',
        'seized',
        'apprehended',
      ],
      'correctAnswer': 'arrested'
    },
    {
      'question': 'A cup of water was enough to _____ his thirst.',
      'options': [
        'satisfy',
        'appease',
        'quench',
        'extinguish',
      ],
      'correctAnswer': 'quench'
    },
    {
      'question': 'The police have _____ the suspect.',
      'options': [
        'arrested',
        'captured',
        'seized',
        'apprehended',
      ],
      'correctAnswer': 'arrested'
    },
    {
      'question': 'A cup of water was enough to _____ his thirst.',
      'options': [
        'satisfy',
        'appease',
        'quench',
        'extinguish',
      ],
      'correctAnswer': 'quench'
    },
    {
      'question': 'The police have _____ the suspect.',
      'options': [
        'arrested',
        'captured',
        'seized',
        'apprehended',
      ],
      'correctAnswer': 'arrested'
    },
    {
      'question': 'A cup of water was enough to _____ his thirst.',
      'options': [
        'satisfy',
        'appease',
        'quench',
        'extinguish',
      ],
      'correctAnswer': 'quench'
    },
    {
      'question': 'The police have _____ the suspect.',
      'options': [
        'arrested',
        'captured',
        'seized',
        'apprehended',
      ],
      'correctAnswer': 'arrested'
    },
    {
      'question': 'A cup of water was enough to _____ his thirst.',
      'options': [
        'satisfy',
        'appease',
        'quench',
        'extinguish',
      ],
      'correctAnswer': 'quench'
    },
    {
      'question': 'The police have _____ the suspect.',
      'options': [
        'arrested',
        'captured',
        'seized',
        'apprehended',
      ],
      'correctAnswer': 'arrested'
    },
    {
      'question': 'A cup of water was enough to _____ his thirst.',
      'options': [
        'satisfy',
        'appease',
        'quench',
        'extinguish',
      ],
      'correctAnswer': 'quench'
    },
    {
      'question': 'The police have _____ the suspect.',
      'options': [
        'arrested',
        'captured',
        'seized',
        'apprehended',
      ],
      'correctAnswer': 'arrested'
    },
    {
      'question': 'A cup of water was enough to _____ his thirst.',
      'options': [
        'satisfy',
        'appease',
        'quench',
        'extinguish',
      ],
      'correctAnswer': 'quench'
    },
    {
      'question': 'The police have _____ the suspect.',
      'options': [
        'arrested',
        'captured',
        'seized',
        'apprehended',
      ],
      'correctAnswer': 'arrested'
    },
    {
      'question': 'A cup of water was enough to _____ his thirst.',
      'options': [
        'satisfy',
        'appease',
        'quench',
        'extinguish',
      ],
      'correctAnswer': 'quench'
    },
    {
      'question': 'The police have _____ the suspect.',
      'options': [
        'arrested',
        'captured',
        'seized',
        'apprehended',
      ],
      'correctAnswer': 'arrested'
    },
    {
      'question': 'A cup of water was enough to _____ his thirst.',
      'options': [
        'satisfy',
        'appease',
        'quench',
        'extinguish',
      ],
      'correctAnswer': 'quench'
    },
    {
      'question': 'The police have _____ the suspect.',
      'options': [
        'arrested',
        'captured',
        'seized',
        'apprehended',
      ],
      'correctAnswer': 'arrested'
    },
    {
      'question': 'A cup of water was enough to _____ his thirst.',
      'options': [
        'satisfy',
        'appease',
        'quench',
        'extinguish',
      ],
      'correctAnswer': 'quench'
    },
    {
      'question': 'The police have _____ the suspect.',
      'options': [
        'arrested',
        'captured',
        'seized',
        'apprehended',
      ],
      'correctAnswer': 'arrested'
    },
    {
      'question': 'A cup of water was enough to _____ his thirst.',
      'options': [
        'satisfy',
        'appease',
        'quench',
        'extinguish',
      ],
      'correctAnswer': 'quench'
    },
    {
      'question': 'The police have _____ the suspect.',
      'options': [
        'arrested',
        'captured',
        'seized',
        'apprehended',
      ],
      'correctAnswer': 'arrested'
    },
    {
      'question': 'A cup of water was enough to _____ his thirst.',
      'options': [
        'satisfy',
        'appease',
        'quench',
        'extinguish',
      ],
      'correctAnswer': 'quench'
    },
    {
      'question': 'The police have _____ the suspect.',
      'options': [
        'arrested',
        'captured',
        'seized',
        'apprehended',
      ],
      'correctAnswer': 'arrested'
    },
    {
      'question': 'A cup of water was enough to _____ his thirst.',
      'options': [
        'satisfy',
        'appease',
        'quench',
        'extinguish',
      ],
      'correctAnswer': 'quench'
    },
    {
      'question': 'The police have _____ the suspect.',
      'options': [
        'arrested',
        'captured',
        'seized',
        'apprehended',
      ],
      'correctAnswer': 'arrested'
    },
    {
      'question': 'A cup of water was enough to _____ his thirst.',
      'options': [
        'satisfy',
        'appease',
        'quench',
        'extinguish',
      ],
      'correctAnswer': 'quench'
    },
    {
      'question': 'The police have _____ the suspect.',
      'options': [
        'arrested',
        'captured',
        'seized',
        'apprehended',
      ],
      'correctAnswer': 'arrested'
    },
    {
      'question': 'A cup of water was enough to _____ his thirst.',
      'options': [
        'satisfy',
        'appease',
        'quench',
        'extinguish',
      ],
      'correctAnswer': 'quench'
    },
    {
      'question': 'The police have _____ the suspect.',
      'options': [
        'arrested',
        'captured',
        'seized',
        'apprehended',
      ],
      'correctAnswer': 'arrested'
    },
    {
      'question': 'A cup of water was enough to _____ his thirst.',
      'options': [
        'satisfy',
        'appease',
        'quench',
        'extinguish',
      ],
      'correctAnswer': 'quench'
    },
    {
      'question': 'The police have _____ the suspect.',
      'options': [
        'arrested',
        'captured',
        'seized',
        'apprehended',
      ],
      'correctAnswer': 'arrested'
    },
    {
      'question': 'A cup of water was enough to _____ his thirst.',
      'options': [
        'satisfy',
        'appease',
        'quench',
        'extinguish',
      ],
      'correctAnswer': 'quench'
    },
    {
      'question': 'The police have _____ the suspect.',
      'options': [
        'arrested',
        'captured',
        'seized',
        'apprehended',
      ],
      'correctAnswer': 'arrested'
    },
    // Add more questions here
  ];

  void _saveNextQuestion() {
    setState(() {
      if (_questions[_currentQuestionIndex]['selectedOption'] != null) {
        _questions[_currentQuestionIndex]['save'] = true;
      } else {
        _questions[_currentQuestionIndex]['save'] = false;
      }
      // _questions[_currentQuestionIndex]['save'] = true;
      if (_currentQuestionIndex < _questions.length - 1) {
        _currentQuestionIndex++;
      }
    });
    if (kDebugMode) {
      print(_questions);
    }
  }

  void _clearSelectedOption() {
    if (kDebugMode) {
      print(_questions);
    }
    setState(() {
      _questions[_currentQuestionIndex]['markForReview'] = false;
      _questions[_currentQuestionIndex]['save'] = false;
      _questions[_currentQuestionIndex]['selectedOption'] = null;
    });
  }

  void _markForReview() {
    if (kDebugMode) {
      print(_questions);
    }
    setState(() {
      _questions[_currentQuestionIndex]['markForReview'] = true;
      _saveNextQuestion();
    });
  }

  void _changeQuestion(int index) {
    setState(() {
      _currentQuestionIndex = index;
    });
  }

  void onTimerEnd(List<Map<String, dynamic>> questions) {
    // Implement the logic to submit the quiz
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => ResultsPage(
                  questions: _questions,
                )), // Replace with actual result page
      );
    });

    if (kDebugMode) {
      print(questions);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: QuestionListDrawer(
        onTap: _changeQuestion,
        questions: _questions,
      ),
      appBar: AppBar(
        leading: Builder(builder: (context) {
          return IconButton(
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              icon: const Icon(Icons.menu_book_rounded));
        }),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            GestureDetector(
              onTap: () {
                onTimerEnd(_questions);
                // Implement the logic to submit the quiz
                if (kDebugMode) {
                  print(_questions);
                }
              },
              child: Container(
                margin: EdgeInsets.only(right: 10),
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.deepPurple,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Submit',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            CountdownTimer(
              onTimerEnd: () => onTimerEnd(_questions),
              durationInMinutes: 1,
            ),
          ],
        ),
        actions: [],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                '${_currentQuestionIndex + 1}. ${_questions[_currentQuestionIndex]['question']}',
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
            Column(
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      for (final option in _questions[_currentQuestionIndex]
                          ['options'])
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              // dded setState here
                              _questions[_currentQuestionIndex]
                                  ['selectedOption'] = option;
                            });
                          },
                          child: Container(
                            width: double.infinity,
                            margin: const EdgeInsets.all(8),
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: _questions[_currentQuestionIndex]
                                          ['selectedOption'] ==
                                      option
                                  ? Color.fromARGB(40, 1, 33, 105)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                style: BorderStyle.solid,
                                color: _questions[_currentQuestionIndex]
                                            ['selectedOption'] ==
                                        option
                                    ? Color.fromARGB(255, 1, 33, 105)
                                    : Colors.grey,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "\t $option",
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        height: 70,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                fixedSize: Size(120, 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
                backgroundColor: Colors.blue[400],
              ),
              onPressed: _markForReview,
              child: const Text('Mark & Next',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  )),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                fixedSize: Size(90, 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
                backgroundColor: Colors.redAccent,
              ),
              onPressed: _clearSelectedOption,
              child: const Text('Clear',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  )),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                fixedSize: Size(120, 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
                backgroundColor: Colors.green[400],
              ),
              onPressed: _saveNextQuestion,
              child: const Text(
                'Next',
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
