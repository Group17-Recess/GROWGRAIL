import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/goal.dart';

class TotalSummary {
  final double totalAchieved;
  final double totalTargetAmount;
  final double totalInterest;
  final double totalBalance;

  TotalSummary({
    required this.totalAchieved,
    required this.totalTargetAmount,
    required this.totalInterest,
    required this.totalBalance,
  });

  Map<String, dynamic> toJson() {
    return {
      'TotalAchieved': totalAchieved,
      'TotalAmount': totalTargetAmount,
      'TotalInterest': totalInterest,
      'TotalBalance': totalBalance,
    };
  }

  factory TotalSummary.fromJson(Map<String, dynamic> json) {
    return TotalSummary(
      totalAchieved: json['TotalAchieved'].toDouble(),
      totalTargetAmount: json['TotalTargetAmount'].toDouble(),
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
    double totalTargetAmount = 0.0;
    double totalInterest = 0.0;
    double totalBalance = 0.0;

    for (var doc in querySnapshot.docs) {
      final goal = Goal.fromJson(doc.data());
      totalAchieved += goal.achieved;
      totalTargetAmount += goal.amount;
      totalInterest += goal.interest;
      totalBalance += goal.balance;
    }

    return TotalSummary(
      totalAchieved: totalAchieved,
      totalTargetAmount: totalTargetAmount,
      totalInterest: totalInterest,
      totalBalance: totalBalance,
    );
  }

  Future<int> getTotalPeopleSaved() async {
    final userGoalsCollection = firestore.collection('Goals');
    final querySnapshot = await userGoalsCollection.get();
    return querySnapshot.docs.length;
  }

  Future<String> getDistrictSavingMore() async {
    final userGoalsCollection = firestore.collection('Goals');
    final querySnapshot = await userGoalsCollection.get();

    Map<String, double> districtSavings = {};

    for (var doc in querySnapshot.docs) {
      final goal = Goal.fromJson(doc.data());
      final district = doc.data()['district'] as String? ?? 'Unknown';
      if (districtSavings.containsKey(district)) {
        districtSavings[district] = districtSavings[district]! + goal.amount;
      } else {
        districtSavings[district] = goal.amount;
      }
    }

    String topDistrict = '';
    double maxSavings = 0.0;

    districtSavings.forEach((district, savings) {
      if (savings > maxSavings) {
        maxSavings = savings;
        topDistrict = district;
      }
    });

    return topDistrict;
  }

  Future<String> getMostSavedGoals() async {
    final userGoalsCollection = firestore.collection('Goals');
    final querySnapshot = await userGoalsCollection.get();

    Map<String, double> goalSavings = {};

    for (var doc in querySnapshot.docs) {
      final goal = Goal.fromJson(doc.data());
      if (goalSavings.containsKey(goal.target)) {
        goalSavings[goal.target] = goalSavings[goal.target]! + goal.amount;
      } else {
        goalSavings[goal.target] = goal.amount;
      }
    }

    String topGoal = '';
    double maxSavings = 0.0;

    goalSavings.forEach((goal, savings) {
      if (savings > maxSavings) {
        maxSavings = savings;
        topGoal = goal;
      }
    });

    return topGoal;
  }
}
