import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:scorebooster/config.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  bool _isLoading = true; // Add this line

  // Dummy Data for Analytics
  List<dynamic> analyticsData = [
    {'title': 'Total Revenue', 'value': '\$10,000'},
    {'title': 'Total Bundles Sold', 'value': '150'},
    {'title': 'Total Customers', 'value': '500'},
    {'title': 'Active Bundles', 'value': '10'},
  ];

  // Dummy Data for Customer Analytics
  List<dynamic> customerAnalytics = [
    {'name': 'John Doe', 'purchases': '5'},
    {'name': 'Jane Smith', 'purchases': '3'},
    {'name': 'Alice Johnson', 'purchases': '7'},
  ];

  // Dummy Data for Bundle Analytics
  List<dynamic> bundleAnalytics = [
    {'name': 'Bundle 1', 'sales': '50'},
    {'name': 'Bundle 2', 'sales': '30'},
    {'name': 'Bundle 3', 'sales': '20'},
  ];

  Future<void> _getAnalyticsData() async {
    // Fetch data from API
    final List<dynamic> customerAnalyticstemp = await fetchCustomerAnalytics();
    final List<dynamic> bundleAnalyticstemp = await fetchBundleAnalytics();
    final List<dynamic> analyticsDatatemp = await fetchAnalyticsData();
    setState(() {
      analyticsData = analyticsDatatemp;
      bundleAnalytics = bundleAnalyticstemp;
      customerAnalytics = customerAnalyticstemp;
      _isLoading = false; // Add this line
    });
  }

  Future<List> fetchCustomerAnalytics() async {
    final response = await http.get(
      Uri.parse('${Config.baseUrl}admin/customer-analytics'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
    );

    if (response.statusCode == 200) {
      List<dynamic> decodedData = json.decode(response.body);

      return decodedData.map((item) {
        return item
            .map((key, value) => MapEntry(key.toString(), value.toString()));
      }).toList();
    } else {
      throw Exception('Failed to load customer analytics');
    }
  }

  Future<List> fetchBundleAnalytics() async {
    final response = await http.get(
      Uri.parse('${Config.baseUrl}admin/bundle-analytics'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
    );

    if (response.statusCode == 200) {
      List<dynamic> decodedData = json.decode(response.body);

      return decodedData.map((item) {
        return item.map((key, value) => MapEntry(key, value.toString()));
      }).toList();
    } else {
      throw Exception('Failed to load customer analytics');
    }
  }

  Future<List> fetchAnalyticsData() async {
    final response = await http.get(
      Uri.parse('${Config.baseUrl}admin/dashboard-info'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
    );

    if (response.statusCode == 200) {
      List<dynamic> decodedData = json.decode(response.body);

      return decodedData.map((item) {
        return item.map((key, value) => MapEntry(key, value.toString()));
      }).toList();
    } else {
      throw Exception('Failed to load customer analytics');
    }
  }

  @override
  void initState() {
    _getAnalyticsData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Dashboard'),
        centerTitle: true,
        automaticallyImplyLeading: false, // Remove back button
      ),
      backgroundColor: Colors.white,
      body: _isLoading // Modify this line
          ? Center(child: CircularProgressIndicator()) // Add this line
          : SingleChildScrollView(
              child: Column(
                children: [
                  // Analytics Cards
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Expanded(child: _buildAnalyticsCard(analyticsData[0])),
                        SizedBox(width: 16),
                        Expanded(child: _buildAnalyticsCard(analyticsData[1])),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      children: [
                        Expanded(child: _buildAnalyticsCard(analyticsData[2])),
                        SizedBox(width: 16),
                        Expanded(child: _buildAnalyticsCard(analyticsData[3])),
                      ],
                    ),
                  ),
                  // Tabs for Analytics
                  DefaultTabController(
                    length: 2,
                    child: Column(
                      children: [
                        TabBar(
                          labelColor: Colors.orange,
                          indicatorColor: Colors.orange,
                          tabs: [
                            Tab(text: 'Customers'),
                            Tab(text: 'Bundles'),
                          ],
                        ),
                        SizedBox(
                          height: 300,
                          child: TabBarView(
                            physics: NeverScrollableScrollPhysics(),
                            children: [
                              _buildCustomerAnalytics(),
                              _buildBundleAnalytics(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildAnalyticsCard(dynamic data) {
    return Card(
      color: Colors.grey[50],
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(data['title']!,
                style: TextStyle(fontSize: 16, color: Colors.grey)),
            SizedBox(height: 8),
            Text(data['value']!,
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange)),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomerAnalytics() {
    return ListView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.all(16),
      itemCount: customerAnalytics.length,
      itemBuilder: (context, index) {
        return Card(
          color: Colors.grey[50],
          elevation: 4,
          child: ListTile(
            title: Text(customerAnalytics[index]['name']!),
            subtitle:
                Text('Purchases: ${customerAnalytics[index]['purchases']}'),
          ),
        );
      },
    );
  }

  Widget _buildBundleAnalytics() {
    return ListView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.all(16),
      itemCount: bundleAnalytics.length,
      itemBuilder: (context, index) {
        return Card(
          color: Colors.grey[50],
          elevation: 4,
          child: ListTile(
            title: Text(bundleAnalytics[index]['name']!),
            subtitle: Text('Sales: ${bundleAnalytics[index]['sales']}'),
          ),
        );
      },
    );
  }
}
