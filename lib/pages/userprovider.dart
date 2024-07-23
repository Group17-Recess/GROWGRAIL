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
    final docSnapshot = await FirebaseFirestore.instance
        .collection('Goals')
        .doc(_phoneNumber)
        .get();

    if (docSnapshot.exists) {
      final goalData = docSnapshot.data()!;
      _goals = [Goal.fromJson(goalData)];
    } else {
      _goals = [];
    }
    notifyListeners();
  }

  // Check if the user has goals
  bool hasGoals() {
    return _goals.isNotEmpty;
  }
}
