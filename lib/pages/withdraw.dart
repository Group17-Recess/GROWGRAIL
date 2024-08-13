import 'package:flutter/material.dart';
import 'package:growgrail/models/goal.dart';
import 'package:provider/provider.dart';
import 'paymentservice.dart';
import 'userprovider.dart';



import 'package:flutter/material.dart';

class WithdrawSheetMy extends StatelessWidget {
  final String selectedGoal;
  final TextEditingController textFieldController;
  final double targetAmount;
  final String defaultPhoneNumber;

  WithdrawSheetMy({
    required this.selectedGoal,
    required this.textFieldController,
    required this.targetAmount,
    required this.defaultPhoneNumber, required String goalId, required String phoneNumber,
  });

  @override
  Widget build(BuildContext context) {
    // Pre-fill the amount in the text field
    textFieldController.text = targetAmount.toStringAsFixed(2);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Text(
                'Withdraw from $selectedGoal',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
              ),
            ),
            SizedBox(height: 24),
            TextField(
              controller: textFieldController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Withdrawal Amount',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                prefixText: 'UGX ',
                filled: true,
                fillColor: Colors.grey[100],
              ),
              readOnly: true, // Make the field uneditable
            ),
            SizedBox(height: 20),
            TextField(
              controller: TextEditingController(text: defaultPhoneNumber),
              decoration: InputDecoration(
                labelText: 'Phone Number',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                filled: true,
                fillColor: Colors.grey[100],
                // Removing the dropdown arrow
                suffixIcon: null,
              ),
              readOnly: true, // Make the phone number uneditable
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                final enteredAmount = double.tryParse(textFieldController.text);
                if (enteredAmount != null && enteredAmount <= targetAmount) {
                  // Perform the withdrawal
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Invalid withdrawal amount')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                padding: EdgeInsets.symmetric(vertical: 14.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              child: Text(
                'Confirm Withdrawal',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 10),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the modal
              },
              child: Text(
                'Cancel',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.teal,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}






class WithdrawSheet extends StatelessWidget {
  final String selectedGoal;
  final TextEditingController textFieldController;
  final Goal goal;
  final double targetAmount;

  const WithdrawSheet({
    required this.selectedGoal,
    required this.textFieldController,
    required this.goal,
    required this.targetAmount,
  });

  @override
  Widget build(BuildContext context) {
    // Pre-fill the amount in the text field
    final amountController = TextEditingController(text: targetAmount.toStringAsFixed(2));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Text(
                'Withdraw to Other Number',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
              ),
            ),
            SizedBox(height: 24),
            TextField(
              controller: amountController,
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'Amount',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                prefixText: 'UGX ',
                filled: true,
                fillColor: Colors.grey[100],
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: textFieldController,
              decoration: InputDecoration(
                labelText: 'Phone Number',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                // Handle withdraw logic here
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                padding: EdgeInsets.symmetric(vertical: 14.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              child: Text(
                'Withdraw',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 10),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the modal
              },
              child: Text(
                'Cancel',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.teal,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
