// Method to update user balance
Future<void> updateUserBalance(double amount) async {
  try {
    // Update the balance in Firestore
    await FirebaseFirestore.instance
        .collection('user_bio_data')
        .doc(_phoneNumber) // Use phone number as the document ID
        .update({
      'balance': FieldValue.increment(amount),
    });

    // Update the local state if needed
    _totalSavings += amount; // Update local balance state
    notifyListeners(); // Notify listeners to update UI
  } catch (e) {
    print("Failed to update balance: $e");
  }
}
