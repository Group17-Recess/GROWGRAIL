import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/goal.dart';

class UserProvider with ChangeNotifier {
  double _targetAmount = 0;
  double _totalSavings = 0;
  String _name = '';
  String _phoneNumber = '';
  String _email = ''; // Added for email
  List<Goal> _goals = [];
  bool _isAdmin = false;
  late StreamSubscription<QuerySnapshot> _goalSubscription;

  double get targetAmount => _targetAmount;
  double get totalSavings => _totalSavings;
  String get name => _name;
  String get phoneNumber => _phoneNumber;
  String get email => _email; // Added for email
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

  // Method to check if the user is an admin
  Future<bool> isAdmin() async {
    final adminQuerySnapshot = await FirebaseFirestore.instance
        .collection('admin_bio_data')
        .where('name', isEqualTo: _name)
        .where('phone', isEqualTo: _phoneNumber)
        .get();

    _isAdmin = adminQuerySnapshot.docs.isNotEmpty;
    return _isAdmin;
  }

  // Method to set user details
  Future<void> setUser(String name, String phone, String email) async {
    _name = name;
    _phoneNumber = phone;
    _email = email;

    final userQuerySnapshot = await FirebaseFirestore.instance
        .collection('user_bio_data')
        .where('name', isEqualTo: name)
        .where('phone', isEqualTo: phone)
        .get();

    final adminQuerySnapshot = await FirebaseFirestore.instance
        .collection('admin_bio_data')
        .where('name', isEqualTo: name)
        .where('phone', isEqualTo: phone)
        .get();

    if (userQuerySnapshot.docs.isNotEmpty) {
      // Handle regular user
      await fetchGoals(); // Fetch user goals after setting user details
    } else if (adminQuerySnapshot.docs.isNotEmpty) {
      // Handle admin user
      // Set a flag or perform admin-specific initialization if needed
    } else {
      _name = '';
      _phoneNumber = '';
      _email = ''; // Reset email if user not found
      _goals = []; // Reset goals if user not found
    }
    notifyListeners();
  }

  // Method to check if the user is logged in
  bool isLoggedIn() {
    return _name.isNotEmpty && _phoneNumber.isNotEmpty;
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

    _goalSubscription = goalsCollection.snapshots().listen((snapshot) {
      _goals = snapshot.docs
          .map((doc) => Goal.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
      notifyListeners();
    });
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

  // Method to get a goal by ID
  Goal getGoalById(String id) {
    return _goals.firstWhere((goal) => goal.id == id);
  }

  // Method to update user profile
  Future<void> updateUserProfile(String name, String email, String phone) async {
    _name = name;
    _email = email;
    _phoneNumber = phone;

    // Update Firestore with the new user data
    final userDoc = FirebaseFirestore.instance.collection('user_bio_data').doc(_phoneNumber);
    await userDoc.update({
      'name': _name,
      'email': _email,
      'phone': _phoneNumber,
    });

    notifyListeners();
  }

  // Clear user data and cancel goal subscription
  void clearUserData() {
    if (!_isAdmin) {
      _targetAmount = 0;
      _totalSavings = 0;
      _goals = [];
      _goalSubscription.cancel();
    }
    _name = '';
    _phoneNumber = '';
    _email = ''; // Clear email
    notifyListeners();
  }

  @override
  void dispose() {
    _goalSubscription.cancel();
    super.dispose();
  }
}