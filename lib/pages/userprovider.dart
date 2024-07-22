import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserProvider with ChangeNotifier {
  double _targetAmount = 0;
  double _totalSavings = 0;
  String _name = '';
  String _phoneNumber = ''; // Add a field for the user's phone number

  double get targetAmount => _targetAmount;
  double get totalSavings => _totalSavings;
  String get name => _name; // Add a getter for the name
  String get phoneNumber => _phoneNumber; // Add a getter for the phone number

  // Method to set user details
  Future<void> setUser(String name, String phone) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('user_bio_data')
        .where('name', isEqualTo: name)
        .where('phone', isEqualTo: phone)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      _name = name;
      _phoneNumber = phone; // Set the phone number
    } else {
      _name = '';
      _phoneNumber = ''; // Reset the phone number if not found
    }
    notifyListeners(); // Notify listeners to update UI
  }

  void setTargetAmount(double amount) {
    _targetAmount = amount;
    notifyListeners();
  }

  void addSavings(double amount) {
    _totalSavings += amount;
    notifyListeners();
  }
}
