import 'package:flutter/material.dart';
import 'models/goal.dart';

class UserProvider extends ChangeNotifier {
  String name = '';
  String phoneNumber = '';
  double targetAmount = 0.0;
  double totalSavings = 0.0;
  List<Goal> goals = [];

  bool get isSignedIn => name.isNotEmpty;

  void setUser(String newName, String newPhoneNumber) {
    name = newName;
    phoneNumber = newPhoneNumber;
    notifyListeners();
  }

  void updateGoals(List<Goal> newGoals) {
    goals = newGoals;
    notifyListeners();
  }

  bool hasGoals() {
    return goals.isNotEmpty;
  }
}
