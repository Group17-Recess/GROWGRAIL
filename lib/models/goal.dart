import 'package:cloud_firestore/cloud_firestore.dart';

class Goal {
  final String target;
  final double amount;
  late final double achieved;
  final double balance;
  double interest;
  List<Timestamp> deposits; // List to track deposit timestamps

  Goal({
    required this.target,
    this.amount = 0.0,
    this.achieved = 0.0,
    this.balance = 0.0,
    this.interest = 0.0,
    this.deposits = const [], // Initialize with an empty list
  });

  // Convert Goal instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'Target': target,
      'Amount': amount,
      'Achieved': achieved,
      'Balance': balance,
      'Interest': interest,
      'Deposits': deposits, // Convert timestamps to list
    };
  }

  // Create a Goal instance from JSON
  factory Goal.fromJson(Map<String, dynamic> json) {
    return Goal(
      target: json['Target'],
      amount: json['Amount'].toDouble(),
      achieved: json['Achieved'].toDouble(),
      balance: json['Balance'].toDouble(),
      interest: json['Interest']?.toDouble() ?? 0.0,
      deposits: List<Timestamp>.from(json['Deposits'] ?? []), // Convert list to timestamps
    );
  }

  // Save the Goal to Firestore
  static Future<void> saveGoal(String phoneNumber, Goal goal) async {
    final firestore = FirebaseFirestore.instance;
    final userGoalsCollection = firestore.collection('Goals');

    // Use the phone number as the document ID
    final goalDocRef = userGoalsCollection.doc(phoneNumber);
    
    // Add or update the goal
    await goalDocRef.set(goal.toJson(), SetOptions(merge: true));
  }

  // Check and apply interest if deposits condition is met
  void applyInterest() {
    final now = Timestamp.now();
    final ninetyDaysAgo = now.toDate().subtract(const Duration(days: 90));
    final recentDeposits = deposits.where((deposit) => deposit.toDate().isAfter(ninetyDaysAgo)).toList();

    if (recentDeposits.length >= 3) {
      interest = achieved * 0.05;
    } else {
      interest = 0.0; // Reset interest if condition is not met
    }
  }

  // Add a deposit timestamp
  void addDeposit(Timestamp timestamp) {
    deposits.add(timestamp);
    applyInterest(); // Recalculate interest whenever a new deposit is added
  }
}

// Function to save a user goal
Future<void> saveUserGoal(String phoneNumber, Goal goal) async {
  await Goal.saveGoal(phoneNumber, goal);
}
