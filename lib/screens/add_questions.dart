import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:scorebooster/config.dart';

class AddQuestions extends StatefulWidget {
  final Map<String, dynamic>? initialQuestion;
  final String? id;
  final String? testId;

  const AddQuestions({
    super.key,
    this.initialQuestion,
    this.id,
    this.testId,
  });

  @override
  // ignore: library_private_types_in_public_api
  _AddQuestionsState createState() => _AddQuestionsState();
}

class _AddQuestionsState extends State<AddQuestions> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController questionController;
  late List<TextEditingController> optionControllers;
  late TextEditingController solutionController;
  late TextEditingController numericAnswerController;
  late TextEditingController fillInBlankAnswerController;

  String questionType = 'MCQ';
  List<int> correctMCQAnswers = [];

  @override
  void initState() {
    super.initState();
    questionController = TextEditingController();
    optionControllers = [];
    solutionController = TextEditingController();
    numericAnswerController = TextEditingController();
    fillInBlankAnswerController = TextEditingController();

    if (widget.initialQuestion != null) {
      _initializeFromExistingQuestion();
    } else {
      _addOptionField(); // Add initial option field
    }
  }

  void _initializeFromExistingQuestion() {
    final question = widget.initialQuestion!;
    questionController.text = question['question'];
    questionType = question['type'] ?? 'MCQ';
    solutionController.text = question['solution'] ?? '';

    if (questionType == 'MCQ') {
      List<String> options = List<String>.from(question['options'] ?? []);
      for (var option in options) {
        _addOptionField(initialText: option);
      }
      correctMCQAnswers = List<int>.from(question['correctAnswer'] ?? []);
    } else if (questionType == 'Numeric') {
      numericAnswerController.text =
          question['correctAnswer']?.toString() ?? '';
    } else if (questionType == 'Fill-in-the-Blank') {
      fillInBlankAnswerController.text =
          question['correctAnswer']?.toString() ?? '';
    }
  }

  Widget _buildQuestionTypeDropdown() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: DropdownButtonFormField<String>(
          value: questionType,
          decoration: InputDecoration(
            labelText: 'Question Type',
            border: OutlineInputBorder(),
            filled: true,
            fillColor: Colors.white,
          ),
          items: ['MCQ', 'Numeric', 'Fill-in-the-Blank'].map((String type) {
            return DropdownMenuItem<String>(
              value: type,
              child: Text(type),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              questionType = newValue!;
              // Reset answers when changing question type
              correctMCQAnswers.clear();
              numericAnswerController.clear();
              fillInBlankAnswerController.clear();
            });
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please select a question type';
            }
            return null;
          },
        ),
      ),
    );
  }

  Widget _buildQuestionField() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextFormField(
          controller: questionController,
          maxLines: 3,
          decoration: InputDecoration(
            labelText: 'Question',
            border: OutlineInputBorder(),
            filled: true,
            fillColor: Colors.white,
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a question';
            }
            return null;
          },
        ),
      ),
    );
  }

  void _addOptionField({String? initialText}) {
    TextEditingController controller = TextEditingController(text: initialText);
    setState(() {
      optionControllers.add(controller);
    });
  }

  Widget _buildMCQOptions() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Options',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            ...List.generate(
              optionControllers.length,
              (index) => Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: optionControllers[index],
                        decoration: InputDecoration(
                          labelText: 'Option ${index + 1}',
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Option cannot be empty';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(width: 8),
                    Checkbox(
                      value: correctMCQAnswers.contains(index),
                      onChanged: (bool? value) {
                        setState(() {
                          if (value == true) {
                            correctMCQAnswers.clear();
                            correctMCQAnswers.add(index);
                          } else {
                            correctMCQAnswers.remove(index);
                          }
                        });
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete_outline),
                      onPressed: optionControllers.length <= 2
                          ? null
                          : () {
                              setState(() {
                                optionControllers[index].dispose();
                                optionControllers.removeAt(index);
                                correctMCQAnswers.remove(index);
                                // Update indices
                                correctMCQAnswers = correctMCQAnswers
                                    .map((e) => e > index ? e - 1 : e)
                                    .toList();
                              });
                            },
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: () => _addOptionField(),
              icon: Icon(Icons.add),
              label: Text('Add Option'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.orange,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNumericAnswer() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextFormField(
          controller: numericAnswerController,
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            labelText: 'Correct Numeric Answer',
            border: OutlineInputBorder(),
            filled: true,
            fillColor: Colors.white,
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter the correct answer';
            }
            if (double.tryParse(value) == null) {
              return 'Please enter a valid number';
            }
            return null;
          },
        ),
      ),
    );
  }

  Widget _buildFillInBlankAnswer() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextFormField(
          controller: fillInBlankAnswerController,
          decoration: InputDecoration(
            labelText: 'Correct Answer',
            border: OutlineInputBorder(),
            filled: true,
            fillColor: Colors.white,
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter the correct answer';
            }
            return null;
          },
        ),
      ),
    );
  }

  Widget _buildSolutionField() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextFormField(
          controller: solutionController,
          maxLines: 3,
          decoration: InputDecoration(
            labelText: 'Solution Explanation',
            border: OutlineInputBorder(),
            filled: true,
            fillColor: Colors.white,
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please provide a solution explanation';
            }
            return null;
          },
        ),
      ),
    );
  }

  Map<String, dynamic> _constructQuestionData() {
    dynamic correctAnswer;
    if (questionType == 'MCQ') {
      correctAnswer = correctMCQAnswers;
    } else if (questionType == 'Numeric') {
      correctAnswer = double.parse(numericAnswerController.text);
    } else {
      correctAnswer = fillInBlankAnswerController.text;
    }

    return {
      'question': questionController.text,
      'type': questionType,
      'options': questionType == 'MCQ'
          ? optionControllers.map((c) => c.text).toList()
          : null,
      'correctAnswer': correctAnswer,
      'solution': solutionController.text,
    };
  }

  Future<void> _saveQuestion(Map<String, dynamic> questionData) async {
    try {
      late http.Response response;

      if (widget.initialQuestion != null) {
        // Update existing question
        response = await http.put(
          Uri.parse(
              '${Config.baseUrl}/admin/update-question/${widget.id}/${widget.testId}/${widget.initialQuestion!['question_id']}'),
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'question_text': questionData['question'],
            'options': questionData['options'],
            'correct_answer': questionData['correctAnswer'],
            'solution': questionData['solution'],
            // Add other fields if needed
          }),
        );
      } else {
        // Create new question
        response = await http.post(
          Uri.parse(
              '${Config.baseUrl}/admin/add-question/${widget.id}/${widget.testId}'),
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'question_text': questionData['question'],
            'options': questionData['options'],
            'correct_answer': questionData['correctAnswer'],
            'solution': questionData['solution'],
            // Add other fields if needed
          }),
        );
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Success
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(widget.initialQuestion != null
                  ? 'Question updated successfully'
                  : 'Question saved successfully')),
        );
        Navigator.pop(context, questionData);
      } else {
        // Error
        throw Exception(
            'Failed to ${widget.initialQuestion != null ? 'update' : 'save'} question');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Error ${widget.initialQuestion != null ? 'updating' : 'saving'} question: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.initialQuestion == null ? 'Add Question' : 'Edit Question',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.orange,
        centerTitle: true,
      ),
      body: Container(
        color: Colors.grey[100],
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildQuestionField(),
                SizedBox(height: 16),
                if (questionType == 'MCQ') ...[
                  _buildMCQOptions(),
                ] else if (questionType == 'Numeric') ...[
                  _buildNumericAnswer(),
                ] else if (questionType == 'Fill-in-the-Blank') ...[
                  _buildFillInBlankAnswer(),
                ],
                SizedBox(height: 16),
                _buildSolutionField(),
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      if (questionType == 'MCQ' && correctMCQAnswers.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                'Please select at least one correct answer'),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }
                      final questionData = _constructQuestionData();
                      await _saveQuestion(questionData);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Text(
                      'Save Question',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    questionController.dispose();
    solutionController.dispose();
    numericAnswerController.dispose();
    fillInBlankAnswerController.dispose();
    for (var controller in optionControllers) {
      controller.dispose();
    }
    super.dispose();
  }
}
