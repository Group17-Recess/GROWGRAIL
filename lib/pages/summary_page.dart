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
                Text('Total Achieved: ${summary?.totalAchieved ?? 0.0}'),
                Text('Total Amount: ${summary?.totalAmount ?? 0.0}'),
                Text('Total Interest: ${summary?.totalInterest ?? 0.0}'),
                Text('Total Balance: ${summary?.totalBalance ?? 0.0}'),
              ],
            ),
          );
        },
      ),
    );
  }
}
