// lib/pages/summary_page.dart

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../goal_summary.dart'; // Updated import to match your file structure

class SummaryPage extends StatelessWidget {
  final GoalSummaryService goalSummaryService =
      GoalSummaryService(firestore: FirebaseFirestore.instance);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Summary'),
      ),
      body: FutureBuilder<TotalSummary>(
        future: goalSummaryService.calculateTotalSummary(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final summary = snapshot.data;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSummaryCard(
                  context,
                  'Total Achieved',
                  summary?.totalAchieved ?? 0.0,
                  Colors.green,
                  Icons.check_circle_outline,
                ),
                _buildSummaryCard(
                  context,
                  'Total Amount',
                  summary?.totalAmount ?? 0.0,
                  Colors.blue,
                  Icons.attach_money,
                ),
                _buildSummaryCard(
                  context,
                  'Total Interest',
                  summary?.totalInterest ?? 0.0,
                  Colors.orange,
                  Icons.trending_up,
                ),
                _buildSummaryCard(
                  context,
                  'Total Balance',
                  summary?.totalBalance ?? 0.0,
                  Colors.purple,
                  Icons.account_balance_wallet,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSummaryCard(BuildContext context, String title, double value,
      Color color, IconData icon) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color,
          child: Icon(icon, color: Colors.white),
        ),
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        trailing: Text(
          value.toStringAsFixed(2),
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ),
    );
  }
}
