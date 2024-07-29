import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/goal.dart';
import 'package:growgrail/pages/dashboard.dart';

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

  double get totalTarget =>
      _goals.fold<double>(0, (prev, goal) => prev + goal.amount);
  double get totalAchieved =>
      _goals.fold<double>(0, (prev, goal) => prev + goal.achieved);
  double get totalBalance =>
      _goals.fold<double>(0, (prev, goal) => prev + goal.balance);

  Future<void> setUser(String name, String phone) async {
    final userQuerySnapshot = await FirebaseFirestore.instance
        .collection('user_bio_data')
        .where('name', isEqualTo: name)
        .where('phone', isEqualTo: phone)
        .get();

    if (userQuerySnapshot.docs.isNotEmpty) {
      _name = name;
      _phoneNumber = phone;
      await fetchGoals();
    } else {
      _name = '';
      _phoneNumber = '';
      _goals = [];
    }
    notifyListeners();
  }

  void setTargetAmount(double amount) {
    _targetAmount = amount;
    notifyListeners();
  }

  void addSavings(double amount) {
    _totalSavings += amount;
    FirebaseFirestore.instance
        .collection('users')
        .doc(_phoneNumber)
        .update({'totalSavings': _totalSavings});
    notifyListeners();
  }

  Future<void> fetchGoals() async {
    final goalsCollection = FirebaseFirestore.instance
        .collection('Goals')
        .doc(_phoneNumber)
        .collection('userGoals');

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

  bool hasGoals() => _goals.isNotEmpty;

  Future<void> withdraw(double amount, String goalId) async {
    if (_totalSavings >= amount) {
      final goalIndex = _goals.indexWhere((goal) => goal.id == goalId);
      if (goalIndex != -1) {
        _goals[goalIndex].achieved -= amount;
        _totalSavings -= amount;

        await FirebaseFirestore.instance
            .collection('Goals')
            .doc(_phoneNumber)
            .collection('userGoals')
            .doc(goalId)
            .update(_goals[goalIndex].toJson());

        notifyListeners();
      } else {
        print("Goal not found");
      }
    } else {
      print("Insufficient funds");
    }
  }

  Future<void> updateGoal(
      String goalId, String newTarget, double newAmount) async {
    final goalIndex = _goals.indexWhere((goal) => goal.id == goalId);
    if (goalIndex != -1) {
      _goals[goalIndex].target = newTarget;
      _goals[goalIndex].amount = newAmount;

      await FirebaseFirestore.instance
          .collection('Goals')
          .doc(_phoneNumber)
          .collection('userGoals')
          .doc(goalId)
          .update(_goals[goalIndex].toJson());

      notifyListeners();
    } else {
      print("Goal not found");
    }
  }
}
