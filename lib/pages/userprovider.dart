import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  double _targetAmount = 0;
  double _totalSavings = 0;

  double get targetAmount => _targetAmount;
  double get totalSavings => _totalSavings;

  void setTargetAmount(double amount) {
    _targetAmount = amount;
    notifyListeners();
  }

  void addSavings(double amount) {
    _totalSavings += amount;
    notifyListeners();
  }
}
