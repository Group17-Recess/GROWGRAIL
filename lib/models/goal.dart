import 'package:cloud_firestore/cloud_firestore.dart';

class Goal {
  final String target;
  final double amount;
  final double achieved;
  final double balance;

  Goal({
    required this.target,
    this.amount = 0.0,
    this.achieved = 0.0,
    this.balance = 0.0,
  });

  // Convert Goal instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'Target': target,
      'Amount': amount,
      'Achieved': achieved,
      'Balance': balance,
    };
  }

  // Create a Goal instance from JSON
  factory Goal.fromJson(Map<String, dynamic> json) {
    return Goal(
      target: json['Target'],
      amount: json['Amount'].toDouble(),
      achieved: json['Achieved'].toDouble(),
      balance: json['Balance'].toDouble(),
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
}

// Function to save a user goal
Future<void> saveUserGoal(String phoneNumber, Goal goal) async {
  await Goal.saveGoal(phoneNumber, goal);
}