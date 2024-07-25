import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TargetProvider extends ChangeNotifier {
  List<String> _targets = ['Gadgets', 'Shopping', 'Tuition', 'Starting A Business'];

  List<String> get targets => _targets;

  TargetProvider() {
    _loadTargets();
  }

  void addTarget(String target) {
    _targets.add(target);
    _saveTargets();
    notifyListeners();
  }

  void removeTarget(String target) {
    _targets.remove(target);
    _saveTargets();
    notifyListeners();
  }

  void editTarget(String oldTarget, String newTarget) {
    final index = _targets.indexOf(oldTarget);
    if (index != -1) {
      _targets[index] = newTarget;
      _saveTargets();
      notifyListeners();
    }
  }

  void _loadTargets() async {
    final prefs = await SharedPreferences.getInstance();
    final savedTargets = prefs.getStringList('targets') ?? [];
    if (savedTargets.isNotEmpty) {
      _targets = savedTargets;
    }
    notifyListeners();
  }

  void _saveTargets() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList('targets', _targets);
  }
}
