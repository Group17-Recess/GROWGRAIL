import 'package:cloud_firestore/cloud_firestore.dart';

class Goal {
  final String id; // Unique identifier for the goal
  String target;
  double amount;
  double achieved;
  double interest;
  List<Timestamp> deposits; // List to track deposit timestamps

  Goal({
    required this.id, // Initialize ID in the constructor
    required this.target,
    this.amount = 0.0,
    this.achieved = 0.0,
    this.interest = 0.0,
    this.deposits = const [], // Initialize with an empty list
  });

  // Calculate balance dynamically as amount minus achieved
  double get balance {
    return amount - achieved;
  }

  // Convert Goal instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id, // Include ID in JSON
      'Target': target,
      'Amount': amount,
      'Achieved': achieved,
      'Balance': balance, // Include balance in JSON
      'Interest': interest,
      'Deposits': deposits.map((timestamp) => timestamp.toDate()).toList(), // Convert timestamps to DateTime
    };
  }

  // Create a Goal instance from JSON
  factory Goal.fromJson(Map<String, dynamic> json) {
    return Goal(
      id: json['id'], // Extract ID from JSON
      target: json['Target'],
      amount: (json['Amount'] ?? 0).toDouble(),
      achieved: (json['Achieved'] ?? 0).toDouble(),
      interest: (json['Interest'] ?? 0).toDouble(),
      deposits: (json['Deposits'] as List<dynamic>?)
              ?.map((item) => Timestamp.fromDate(DateTime.parse(item.toString())))
              .toList() ?? [], // Convert list to timestamps
    );
  }

  // Save the Goal to Firestore
  static Future<void> saveGoal(String phoneNumber, Goal goal) async {
    final firestore = FirebaseFirestore.instance;
    final userGoalsCollection = firestore.collection('Goals').doc(phoneNumber).collection('userGoals');

    // Use the goal ID as the document ID
    final goalDocRef = userGoalsCollection.doc(goal.id);

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

  // Update the goal's target and amount
  void updateGoal(String newTarget, double newAmount) {
    target = newTarget;
    amount = newAmount;
    // Update interest calculation if necessary
    applyInterest();
  }
}
