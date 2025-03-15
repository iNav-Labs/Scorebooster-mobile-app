import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:scorebooster/config.dart';
import 'package:scorebooster/screens/add_edit_test.dart';

class BundleDetails extends StatefulWidget {
  const BundleDetails({super.key, required this.bundleId});
  final String bundleId;

  @override
  State<BundleDetails> createState() => _BundleDetailsState();
}

class _BundleDetailsState extends State<BundleDetails> {
  final TextEditingController _testNameController = TextEditingController();
  bool _isLoading = true; // Add loading state

  // Dummy Data for Tests
  List<Map<String, String>> tests = [
    {'name': 'Test 1', 'questions': '10'},
    {'name': 'Test 2', 'questions': '5'},
    {'name': 'Test 3', 'questions': '8'},
  ];

  Future<void> fetchTests() async {
    setState(() {
      _isLoading = true; // Set loading state to true
    });

    final response = await get(
      Uri.parse('${Config.baseUrl}/admin/all-tests/${widget.bundleId}'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
    );

    if (response.statusCode == 200) {
      List<dynamic> decodedDataDynamic = json.decode(response.body);
      List<Map<String, String>> decodedData = List<Map<String, String>>.from(
          decodedDataDynamic.map((item) => Map<String, String>.from(
              item.map((key, value) => MapEntry(key, value.toString())))));

      setState(() {
        tests = decodedData;
      });
    }

    setState(() {
      _isLoading = false; // Set loading state to false
    });
  }

  @override
  void initState() {
    super.initState();
    fetchTests();
  }

  void _showAddTestDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Add New Test',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _testNameController,
                  decoration: InputDecoration(
                    labelText: 'Test Name',
                    labelStyle: TextStyle(color: Colors.orange),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.orange, width: 2),
                    ),
                    prefixIcon: Icon(Icons.assignment, color: Colors.orange),
                  ),
                ),
                SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _testNameController.clear();
                      },
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (_testNameController.text.trim().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Please enter a test name'),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }
                        Navigator.pop(context); // Close dialog
                        // Add test to bundle via API
                        final response = await post(
                          Uri.parse(
                              '${Config.baseUrl}/admin/add-test/${widget.bundleId}'),
                          headers: {
                            'Content-Type': 'application/json; charset=UTF-8'
                          },
                          body: jsonEncode({
                            'test_name': _testNameController.text,
                            'questions': [],
                          }),
                        );

                        if (response.statusCode != 201) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Failed to create test'),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }
                        _testNameController.clear();
                        fetchTests();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        padding:
                            EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Create',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTestCard(Map<String, String> test) {
    return Card(
      elevation: 3,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: Colors.orange,
          child: Icon(
            Icons.assignment,
            color: Colors.white,
          ),
        ),
        title: Text(
          test['name']!,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            'Questions: ${test['questions']}',
            style: TextStyle(
              color: Colors.grey[600],
            ),
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.edit, color: Colors.orange),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddEditTest(
                            test_id: test['test_id']!,
                            bundleId: widget.bundleId,
                          )),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.delete_outline, color: Colors.red),
              onPressed: () {
                _showDeleteConfirmation(test);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(Map<String, String> test) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Test'),
          content: Text('Are you sure you want to delete "${test['name']}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  tests.remove(test);
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Test deleted'),
                    backgroundColor: Colors.orange,
                  ),
                );
              },
              child: Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Bundle Details',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.orange,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _showAddTestDialog,
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(), // Show loading indicator
            )
          : tests.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.assignment_outlined,
                        size: 64,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'No tests added yet',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount: tests.length,
                  itemBuilder: (context, index) => _buildTestCard(tests[index]),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTestDialog,
        backgroundColor: Colors.orange,
        child: Icon(Icons.add),
      ),
    );
  }

  @override
  void dispose() {
    _testNameController.dispose();
    super.dispose();
  }
}
