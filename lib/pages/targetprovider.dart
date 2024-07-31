import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/targetcat.dart';

class TargetProvider with ChangeNotifier {
  List<TargetCategory> _targets = [];

  List<TargetCategory> get targets => _targets;

  TargetProvider() {
    fetchTargets();
  }

  Future<void> fetchTargets() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('target_categories').get();
    _targets =
        snapshot.docs.map((doc) => TargetCategory.fromFirestore(doc)).toList();
    notifyListeners();
  }

  Future<void> addTarget(String targetName) async {
    final newCategory = TargetCategory(id: '', name: targetName);
    _targets.add(newCategory);
    notifyListeners();
    await FirebaseFirestore.instance
        .collection('target_categories')
        .add(newCategory.toMap());
  }

  Future<void> editTarget(String targetId, String newName) async {
    await FirebaseFirestore.instance
        .collection('target_categories')
        .doc(targetId)
        .update({'name': newName});
    _targets = _targets.map((target) {
      if (target.id == targetId) {
        return TargetCategory(id: targetId, name: newName);
      }
      return target;
    }).toList();
    notifyListeners();
  }

  Future<void> deleteTarget(String targetId) async {
    await FirebaseFirestore.instance
        .collection('target_categories')
        .doc(targetId)
        .delete();
    _targets.removeWhere((target) => target.id == targetId);
    notifyListeners();
  }

  void removeTarget(String target) {}
}
