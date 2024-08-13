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
        backgroundColor: Colors.blue,
        title: const Text(
          'ANALYTICS',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
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
                  'Total Target Amount',
                  summary?.totalTargetAmount ?? 0.0,
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
                FutureBuilder<int>(
                  future: goalSummaryService.getTotalPeopleSaved(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }

                    final totalPeopleSaved = snapshot.data ?? 0;

                    return _buildSummaryCard(
                      context,
                      'People Who Have Saved',
                      totalPeopleSaved.toDouble(),
                      Colors.teal,
                      Icons.people,
                    );
                  },
                ),
                FutureBuilder<String>(
                  future: goalSummaryService.getDistrictSavingMore(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }

                    final districtSavingMore = snapshot.data ?? 'Unknown';

                    return _buildSummaryCard(
                      context,
                      'District Saving More',
                      districtSavingMore,
                      Colors.red,
                      Icons.location_city,
                    );
                  },
                ),
                FutureBuilder<String>(
                  future: goalSummaryService.getMostSavedGoals(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }

                    final mostSavedGoal = snapshot.data ?? 'Unknown';

                    return _buildSummaryCard(
                      context,
                      'Goal Being Saved For the Most',
                      mostSavedGoal,
                      Colors.indigo,
                      Icons.star,
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSummaryCard(BuildContext context, String title, dynamic value,
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
          value is double ? value.toStringAsFixed(2) : value.toString(),
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
