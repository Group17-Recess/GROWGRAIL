import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> creditUserAccount(String userId, double amount) async {
    try {
      final userRef = _db.collection('users').doc(userId);

      await _db.runTransaction((transaction) async {
        final userSnapshot = await transaction.get(userRef);
        if (!userSnapshot.exists) {
          throw Exception("User does not exist!");
        }

        final currentBalance = userSnapshot.data()?['balance'] ?? 0.0;
        final newBalance = currentBalance + amount;

        transaction.update(userRef, {'balance': newBalance});
      });
    } catch (e) {
      print("Failed to credit user account: $e");
      throw e;
    }
  }
}
