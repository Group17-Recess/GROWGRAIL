import 'package:flutter/material.dart';

class DepositSheetMy extends StatelessWidget {
  final String selectedGoal;
  final TextEditingController textFieldController;

  const DepositSheetMy({
    Key? key,
    required this.selectedGoal,
    required this.textFieldController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Deposit for $selectedGoal',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          TextField(
            controller: textFieldController,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              labelText: 'Phone Number',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              // Handle deposit logic here
              Navigator.pop(context); // Close the bottom sheet after depositing
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.teal,
            ),
            child: Text('Deposit'),
          ),
        ],
      ),
    );
  }
}
