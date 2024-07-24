import 'package:flutter/material.dart';
import 'userprovider.dart';
import 'package:provider/provider.dart';

class WithdrawSheetMy extends StatelessWidget {
  final String selectedGoal;
  final TextEditingController textFieldController;

  const WithdrawSheetMy({
    required this.selectedGoal,
    required this.textFieldController,
  });

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Withdraw from $selectedGoal', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          TextField(
            controller: textFieldController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: 'Amount to withdraw'),
          ),
          SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () {
              final amount = double.tryParse(textFieldController.text);
              if (amount != null && amount > 0) {
                userProvider.withdraw(amount, selectedGoal).then((_) {
                  Navigator.pop(context);
                });
              } else {
                print("Invalid amount");
              }
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.teal,
            ),
            child: Text('Withdraw'),
          ),
        ],
      ),
    );
  }
}


class WithdrawSheet extends StatelessWidget {
  final String selectedGoal;

  const WithdrawSheet({
    required this.selectedGoal,
  });

  @override
  Widget build(BuildContext context) {
    final textFieldController = TextEditingController();
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Withdraw from $selectedGoal', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          TextField(
            controller: textFieldController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: 'Amount to withdraw'),
          ),
          SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () {
              final amount = double.tryParse(textFieldController.text);
              if (amount != null && amount > 0) {
                userProvider.withdraw(amount, selectedGoal).then((_) {
                  Navigator.pop(context);
                });
              } else {
                print("Invalid amount");
              }
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.teal,
            ),
            child: Text('Withdraw'),
          ),
        ],
      ),
    );
  }
}