import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/goal.dart';

class UserProvider with ChangeNotifier {
  double _targetAmount = 0;
  double _totalSavings = 0;
  String _name = '';
  String _phoneNumber = '';
  List<Goal> _goals = [];

  double get targetAmount => _targetAmount;
  double get totalSavings => _totalSavings;
  String get name => _name;
  String get phoneNumber => _phoneNumber;
  List<Goal> get goals => _goals;

  double get totalTarget {
    return _goals.fold<double>(0, (prev, goal) => prev + goal.amount);
  }

  double get totalAchieved {
    return _goals.fold<double>(0, (prev, goal) => prev + goal.achieved);
  }

  double get totalBalance {
    return _goals.fold<double>(0, (prev, goal) => prev + goal.balance);
  }

  // Method to set user details
  Future<void> setUser(String name, String phone) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('user_bio_data')
        .where('name', isEqualTo: name)
        .where('phone', isEqualTo: phone)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      _name = name;
      _phoneNumber = phone;
      await fetchGoals(); // Fetch user goals after setting user details
    } else {
      _name = '';
      _phoneNumber = '';
      _goals = []; // Reset goals if user not found
    }
    notifyListeners();
  }

  void setTargetAmount(double amount) {
    _targetAmount = amount;
    notifyListeners();
  }

  void addSavings(double amount) {
    _totalSavings += amount;
    notifyListeners();
  }

  // Fetch user goals
  Future<void> fetchGoals() async {
    final goalsCollection = FirebaseFirestore.instance
        .collection('Goals')
        .doc(_phoneNumber)
        .collection('userGoals'); // Reference to user-specific goals collection

    final querySnapshot = await goalsCollection.get();

    if (querySnapshot.docs.isNotEmpty) {
      _goals = querySnapshot.docs
          .map((doc) => Goal.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } else {
      _goals = [];
    }
    notifyListeners();
  }

  // Check if the user has goals
  bool hasGoals() {
    return _goals.isNotEmpty;
  }

  // Method to withdraw savings
  Future<void> withdraw(double amount, String goalId) async {
    if (_totalSavings >= amount) {
      final goalIndex = _goals.indexWhere((goal) => goal.id == goalId);
      if (goalIndex != -1) {
        _goals[goalIndex].achieved -= amount;
        _totalSavings -= amount;

        // Update Firestore with the new goal data
        await FirebaseFirestore.instance
            .collection('Goals')
            .doc(_phoneNumber)
            .collection('userGoals')
            .doc(goalId) // Use goalId for the document reference
            .update(_goals[goalIndex].toJson());

        notifyListeners();
      } else {
        print("Goal not found");
      }
    } else {
      print("Insufficient funds");
    }
  }

  // Method to update goal details
  Future<void> updateGoal(String goalId, String newTarget, double newAmount) async {
    final goalIndex = _goals.indexWhere((goal) => goal.id == goalId);
    if (goalIndex != -1) {
      _goals[goalIndex].target = newTarget;
      _goals[goalIndex].amount = newAmount;

      // Update Firestore with the new goal data
      await FirebaseFirestore.instance
          .collection('Goals')
          .doc(_phoneNumber)
          .collection('userGoals')
          .doc(goalId) // Use goalId for the document reference
          .update(_goals[goalIndex].toJson());

      notifyListeners();
    } else {
      print("Goal not found");
    }
  }
}
