import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:scorebooster/config.dart';

class AddEditBundle extends StatefulWidget {
  const AddEditBundle({super.key, this.bundleId});

  final String? bundleId;

  @override
  State<AddEditBundle> createState() => _AddEditBundleState();
}

class _AddEditBundleState extends State<AddEditBundle> {
  TextEditingController _bundleNameController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _priceController = TextEditingController();

  bool isLive = false;
  dynamic bundleData;

  Future<void> _getBundleData() async {
    final Response response = await get(
      Uri.parse(
          '${Config.baseUrl}/admin/fetch-bundle-details/${widget.bundleId}'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
    );
    response.statusCode == 200
        ? print('Bundle data fetched successfully')
        : throw Exception('Failed to load bundle data');

    setState(() {
      bundleData = jsonDecode(response.body);
      _bundleNameController.text = bundleData['name'];
      _descriptionController.text = bundleData['description'];
      _priceController.text = bundleData['price'].toString();
      isLive = bundleData['active'];
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.bundleId != null) {
      _getBundleData();
    }
  }

  Future<void> _addBundle() async {
    final Response response = await post(
      Uri.parse('${Config.baseUrl}/admin/create-bundle'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode(
        {
          'name': _bundleNameController.text,
          'description': _descriptionController.text,
          'price': _priceController.text,
          'active': isLive,
        },
      ),
    );
    response.statusCode == 201
        // ignore: avoid_print
        ? print('Bundle added successfully')
        : throw Exception('Failed to add bundle');
  }

  Future<void> _updateBundle() async {
    final Response response = await put(
      Uri.parse(
          '${Config.baseUrl}/admin/update-bundle-details/${widget.bundleId}'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode(
        {
          'name': _bundleNameController.text,
          'description': _descriptionController.text,
          'price': double.parse(_priceController.text),
          'active': isLive,
        },
      ),
    );
    response.statusCode == 200
        // ignore: avoid_print
        ? print('Bundle updated successfully')
        : throw Exception('Failed to update bundle');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add/Edit Bundle'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _bundleNameController,
              decoration: InputDecoration(labelText: 'Bundle Name'),
              keyboardType: TextInputType.text,
            ),
            SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
              keyboardType: TextInputType.text,
            ),
            SizedBox(height: 16),
            TextField(
              controller: _priceController,
              decoration: InputDecoration(labelText: 'Price'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Text('Live on Sale'),
                Switch(
                    activeTrackColor: Colors.orange,
                    value: isLive,
                    onChanged: (value) {
                      setState(() {
                        isLive = !isLive;
                      });
                    }),
              ],
            ),
            Spacer(),
            ElevatedButton(
              onPressed: () {
                // Navigator.pop(context);
                if (widget.bundleId != null) {
                  // Update Bundle
                  _updateBundle();
                  Navigator.pop(context);
                } else {
                  // Add Bundle
                  _addBundle();
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 16),
              ),
              child: Text('Save Bundle', style: TextStyle(color: Colors.white)),
            ),
            SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }
}
