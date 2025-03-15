import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:scorebooster/config.dart';
import 'package:scorebooster/screens/add_edit_bundle.dart';
import 'package:scorebooster/screens/bundle_details.dart';
import 'package:http/http.dart' as http;

class BundleManagement extends StatefulWidget {
  const BundleManagement({super.key});

  @override
  State<BundleManagement> createState() => _BundleManagementState();
}

class _BundleManagementState extends State<BundleManagement> {
  bool _isLoading = true;
  List<Map<String, dynamic>> bundles = [];

  @override
  void initState() {
    super.initState();
    _getBundleData();
  }

  void _getBundleData() async {
    setState(() {
      _isLoading = true;
    });
    final List<Map<String, dynamic>> bundlestemp = await fetchAllBundleInfo();
    setState(() {
      bundles = bundlestemp;
      _isLoading = false;
    });
  }

  Future<List<Map<String, dynamic>>> fetchAllBundleInfo() async {
    final response = await http.get(
      Uri.parse('${Config.baseUrl}admin/all-bundle-info'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
    );

    if (response.statusCode == 200) {
      List<dynamic> decodedDataDynamic = json.decode(response.body);

      final List<Map<String, dynamic>> decodedData = (decodedDataDynamic)
          .map((item) => (item as Map)
              .map((key, value) => MapEntry(key.toString(), value)))
          .toList();

      return decodedData.map((item) {
        return item
            .map((key, value) => MapEntry(key.toString(), value.toString()));
      }).toList();
    } else {
      throw Exception('Failed to load customer analytics');
    }
  }

  final orangeTheme = const Color(0xFFFF9800);

  void deleteBundle(String bundleId) async {
    final response = await http.delete(
      Uri.parse('${Config.baseUrl}admin/delete-bundle/$bundleId'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
    );

    if (response.statusCode == 200) {
      _getBundleData();
      _showSnackBar('Bundle deleted successfully');
    } else {
      throw Exception('Failed to delete bundle');
    }
  }

  void _showDeleteConfirmation(Map<String, dynamic> bundle) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Bundle'),
          content: Text('Are you sure you want to delete "${bundle['name']}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  deleteBundle(bundle['_id']);
                  bundles.remove(bundle);
                });
                Navigator.pop(context);
                _showSnackBar('Bundle deleted successfully');
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

  Widget _buildBundleCard(Map<String, dynamic> bundle) {
    return Card(
      elevation: 3,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: orangeTheme,
          child: Icon(
            Icons.inventory_2,
            color: Colors.white,
          ),
        ),
        title: Text(
          bundle['name'],
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4),
            Text(
              'Price: ${bundle['price']}',
              style: TextStyle(
                color: Colors.green[700],
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              '${bundle['testsCount']} Tests',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.edit, color: orangeTheme),
              tooltip: 'Edit Bundle',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddEditBundle(
                            bundleId: bundle['_id'],
                          )),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.delete_outline, color: Colors.red),
              tooltip: 'Delete Bundle',
              onPressed: () => _showDeleteConfirmation(bundle),
            ),
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Description:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  bundle['description'],
                  style: TextStyle(color: Colors.grey[600]),
                ),
                SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => BundleDetails(
                                bundleId: bundle['_id'],
                              )),
                    );
                  },
                  icon: Icon(Icons.visibility),
                  label: Text('View Tests'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: orangeTheme,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Bundle Management',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: orangeTheme,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddEditBundle()),
              );
            },
          ),
        ],
      ),
      body: Container(
        color: Colors.grey[50],
        child: _isLoading
            ? Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(orangeTheme),
                ),
              )
            : bundles.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.inventory_2_outlined,
                          size: 64,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'No bundles available',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(height: 24),
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AddEditBundle()),
                            );
                          },
                          icon: Icon(Icons.add),
                          label: Text('Create Bundle'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: orangeTheme,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(
                                horizontal: 24, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.all(16),
                    itemCount: bundles.length,
                    itemBuilder: (context, index) =>
                        _buildBundleCard(bundles[index]),
                  ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddEditBundle()),
          );
        },
        backgroundColor: orangeTheme,
        child: Icon(Icons.add),
      ),
    );
  }
}
