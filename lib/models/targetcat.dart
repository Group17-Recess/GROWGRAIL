import 'package:cloud_firestore/cloud_firestore.dart';

class TargetCategory {
  final String id;
  final String name;

  TargetCategory({required this.id, required this.name});

  factory TargetCategory.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return TargetCategory(
      id: doc.id,
      name: data['name'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
    };
  }
}