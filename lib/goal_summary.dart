// lib/services/goal_summary_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/goal.dart';

class TotalSummary {
  final double totalAchieved;
  final double totalAmount;
  final double totalInterest;
  final double totalBalance;

  TotalSummary({
    required this.totalAchieved,
    required this.totalAmount,
    required this.totalInterest,
    required this.totalBalance,
  });

  Map<String, dynamic> toJson() {
    return {
      'TotalAchieved': totalAchieved,
      'TotalAmount': totalAmount,
      'TotalInterest': totalInterest,
      'TotalBalance': totalBalance,
    };
  }

  factory TotalSummary.fromJson(Map<String, dynamic> json) {
    return TotalSummary(
      totalAchieved: json['TotalAchieved'].toDouble(),
      totalAmount: json['TotalAmount'].toDouble(),
      totalInterest: json['TotalInterest'].toDouble(),
      totalBalance: json['TotalBalance'].toDouble(),
    );
  }
}

class GoalSummaryService {
  final FirebaseFirestore firestore;

  GoalSummaryService({required this.firestore});

  Future<TotalSummary> calculateTotalSummary() async {
    final userGoalsCollection = firestore.collection('Goals');
    final querySnapshot = await userGoalsCollection.get();

    double totalAchieved = 0.0;
    double totalAmount = 0.0;
    double totalInterest = 0.0;
    double totalBalance = 0.0;

    for (var doc in querySnapshot.docs) {
      final goal = Goal.fromJson(doc.data());
      totalAchieved += goal.achieved;
      totalAmount += goal.amount;
      totalInterest += goal.interest;
      totalBalance += goal.balance;
    }

    return TotalSummary(
      totalAchieved: totalAchieved,
      totalAmount: totalAmount,
      totalInterest: totalInterest,
      totalBalance: totalBalance,
    );
  }
}
