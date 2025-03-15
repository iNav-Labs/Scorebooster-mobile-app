import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:scorebooster/config.dart';
import 'package:scorebooster/screens/add_questions.dart';

class AddEditTest extends StatefulWidget {
  // ignore: non_constant_identifier_names
  const AddEditTest({super.key, this.test_id, this.bundleId});
  // ignore: non_constant_identifier_names
  final String? test_id;
  final String? bundleId;

  @override
  // ignore: library_private_types_in_public_api
  _AddEditTestState createState() => _AddEditTestState();
}

class _AddEditTestState extends State<AddEditTest> {
  final _formKey = GlobalKey<FormState>();
  final _testNameController = TextEditingController();

  List<Map<String, dynamic>> addedQuestions = [];

  final orangeTheme = const Color(0xFFFF9800);

  void _getTestData() async {
    final response = await get(
      Uri.parse(
          '${Config.baseUrl}/admin/fetch-test/${widget.bundleId}/${widget.test_id}'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
    );
    final decodedDataDynamic = json.decode(response.body);
    final decodedData = decodedDataDynamic as Map<String, dynamic>;
    final List<Map<String, dynamic>> addedQuestionsTemp = [];
    for (final question in decodedData['questions']) {
      addedQuestionsTemp.add({
        'question': question['question_text'],
        'type': question['type'] ?? 'MCQ',
        'options': question['options'],
        'solution': question['solution'] ?? '',
        'correctAnswer': [question['correct_answer']],
        'question_id': question['question_id'],
      });
      print(addedQuestionsTemp);
    }
    setState(() {
      addedQuestions = addedQuestionsTemp;
      _testNameController.text = decodedData['name'];
    });
  }

  void _addTest() async {
    final response = await post(
      Uri.parse('${Config.baseUrl}/admin/add-test'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: json.encode({
        'test_name': _testNameController.text,
      }),
    );
    final decodedData = json.decode(response.body) as Map<String, dynamic>;
    if (decodedData['status'] == 'success') {
      _showSnackBar('Test added successfully');
    } else {
      _showSnackBar('Failed to add test');
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.test_id != null && widget.bundleId != null)
      _getTestData();
    else {
      addedQuestions = [];
      _testNameController.text = '';
    }
  }

  Widget _buildTestNameField() {
    return Card(
      color: Colors.white,
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextFormField(
          controller: _testNameController,
          decoration: InputDecoration(
            labelText: 'Test Name',
            labelStyle: TextStyle(color: orangeTheme),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: orangeTheme, width: 2),
            ),
            filled: true,
            fillColor: Colors.white,
            prefixIcon: Icon(Icons.assignment, color: orangeTheme),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a test name';
            }
            return null;
          },
        ),
      ),
    );
  }

  Widget _buildAddQuestionButton() {
    return ElevatedButton.icon(
      onPressed: () => _addQuestion(),
      icon: Icon(
        Icons.add_circle_outline,
        color: Colors.white,
      ),
      label: Text('Add New Question'),
      style: ElevatedButton.styleFrom(
        backgroundColor: orangeTheme,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: 3,
      ),
    );
  }

  Widget _buildQuestionCard(Map<String, dynamic> question, int index) {
    return Card(
      color: Colors.white,
      elevation: 3,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: orangeTheme,
          child: Text(
            '${index + 1}',
            style: TextStyle(color: Colors.white),
          ),
        ),
        title: Text(
          question['question']!,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        subtitle: Text(
          'Type: ${question['type']}',
          style: TextStyle(color: Colors.grey[600]),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.edit, color: orangeTheme),
              onPressed: () => _editQuestion(index),
            ),
            IconButton(
              icon: Icon(Icons.delete_outline, color: Colors.red),
              onPressed: () => _deleteQuestion(index),
            ),
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (question['type'] == 'MCQ') ...[
                  Text(
                    'Options:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  ...List<String>.from(question['options']).asMap().entries.map(
                        (entry) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              Icon(
                                (question['correctAnswer'] as List)
                                        .contains(entry.key)
                                    ? Icons.check_circle
                                    : Icons.circle_outlined,
                                color: (question['correctAnswer'] as List)
                                        .contains(entry.key)
                                    ? Colors.green
                                    : Colors.grey,
                                size: 20,
                              ),
                              SizedBox(width: 8),
                              Text(entry.value),
                            ],
                          ),
                        ),
                      ),
                ] else ...[
                  Text(
                    'Correct Answer: ${question['correctAnswer']}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
                SizedBox(height: 12),
                Text(
                  'Solution:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(
                  question['solution'] ?? 'No solution provided',
                  style: TextStyle(color: Colors.grey[700]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _addQuestion() async {
    final newQuestion = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddQuestions(
          id: widget.bundleId,
          testId: widget.test_id,
        ),
      ),
    );

    if (newQuestion != null && newQuestion is Map<String, dynamic>) {
      setState(() {
        addedQuestions.add(newQuestion);
      });
      _showSnackBar('Question added successfully');
    }
  }

  Future<void> _editQuestion(int index) async {
    final editedQuestion = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddQuestions(
          initialQuestion: addedQuestions[index],
          testId: widget.test_id,
          id: widget.bundleId,
        ),
      ),
    );

    if (editedQuestion != null && editedQuestion is Map<String, dynamic>) {
      setState(() {
        addedQuestions[index] = editedQuestion;
      });
      _showSnackBar('Question updated successfully');
    }
  }

  void _deleteQuestion(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Question'),
        content: Text('Are you sure you want to delete this question?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                addedQuestions.removeAt(index);
              });
              Navigator.pop(context);
              _showSnackBar('Question deleted');
            },
            child: Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: orangeTheme,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Create Test',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: orangeTheme,
        elevation: 0,
      ),
      body: Container(
        color: Colors.grey[50],
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildTestNameField(),
                    SizedBox(height: 16),
                    _buildAddQuestionButton(),
                  ],
                ),
              ),
              Expanded(
                child: addedQuestions.isEmpty
                    ? Center(
                        child: Text(
                          'No questions added yet',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 16,
                          ),
                        ),
                      )
                    : ListView.builder(
                        padding: EdgeInsets.all(16),
                        itemCount: addedQuestions.length,
                        itemBuilder: (context, index) =>
                            _buildQuestionCard(addedQuestions[index], index),
                      ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      if (addedQuestions.isEmpty) {
                        _showSnackBar('Please add at least one question');
                        return;
                      }
                      // Save test logic here
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: orangeTheme,
                    foregroundColor: Colors.white,
                    minimumSize: Size(double.infinity, 56),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 3,
                  ),
                  child: Text(
                    'Save Test',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _testNameController.dispose();
    super.dispose();
  }
}
