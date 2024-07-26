import 'package:flutter/material.dart';
import 'package:growgrail/models/goal.dart';
import 'package:provider/provider.dart';
import 'userprovider.dart';


class WithdrawSheetMy extends StatelessWidget {
  final String selectedGoal;
  final TextEditingController textFieldController;
  final double targetAmount;
  final dynamic selectedGoals;
  final String phoneNumber;

  const WithdrawSheetMy({
    required this.selectedGoal,
    required this.textFieldController,
    required this.targetAmount,
    required this.selectedGoals,
    required this.phoneNumber, required String defaultPhoneNumber,
  });

  @override
  Widget build(BuildContext context) {
    // Initialize the text field controller with the default phone number
    textFieldController.text = phoneNumber;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Withdraw to My Number',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          TextField(
            controller: TextEditingController(text: targetAmount.toStringAsFixed(2)),
            readOnly: true,
            decoration: InputDecoration(
              labelText: 'Amount',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 16),
          TextField(
            controller: textFieldController,
            decoration: InputDecoration(
              labelText: 'Phone Number',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.phone,
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              // Perform the withdraw operation here
              Navigator.pop(context);
            },
            child: Text('Withdraw'),
          ),
        ],
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
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Withdraw to Other Number',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          TextField(
            controller: TextEditingController(text: targetAmount.toStringAsFixed(2)),
            readOnly: true,
            decoration: InputDecoration(
              labelText: 'Amount',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 16),
          TextField(
            controller: textFieldController,
            decoration: InputDecoration(
              labelText: 'Phone Number',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.phone,
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              // Handle withdraw logic here
            },
            child: Text('Withdraw'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
            ),
          ),
        ],
      ),
    );
  }
}