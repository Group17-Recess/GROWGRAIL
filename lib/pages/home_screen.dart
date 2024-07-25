import 'package:flutter/material.dart';
import '../models/goal.dart';
import 'home.dart';
import 'package:provider/provider.dart';
import 'paymentservice.dart';
import 'user_provider.dart';
import 'dbscreen.dart';

class HomeScreen extends StatelessWidget {
  final String selectedGoal;
  final String phoneNumber;

  const HomeScreen({required this.selectedGoal, required this.phoneNumber});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final TextEditingController textFieldController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        elevation: 0,
        title: Text(
          selectedGoal,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Selected Goal: $selectedGoal',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                controller: textFieldController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Enter target amount (UGX)',
                  border: InputBorder.none,
                ),
                // Removed the onChanged listener for testing
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Dashboard()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.teal,
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text('View Total Savings'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final targetAmount = double.tryParse(textFieldController.text) ?? 0;

                    if (targetAmount > 0) {
                      // Create a new goal with the entered target amount
                      final goal = Goal(
                        target: selectedGoal,
                        amount: targetAmount,
                        achieved: 0,
                        balance: 0,
                      );

                      // Save the goal to Firestore
                      await Goal.saveGoal(userProvider.phoneNumber, goal);

                      // Proceed to open the DepositSheetMy
                      showModalBottomSheet(
                        context: context,
                        builder: (context) => DepositSheetMy(
                          selectedGoal: selectedGoal,
                          textFieldController: textFieldController,
                        ),
                      );
                    } else {
                      // Show error if the target amount is not valid
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Please enter a valid target amount.'),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.teal,
                  ),
                  child: Text('Deposit'),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Account',
          ),
        ],
        selectedItemColor: Colors.teal,
        onTap: (int index) {
          switch (index) {
            case 0:
              // Navigate to HomeScreen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyHomePage(title: '',)),
              );
              break;
            case 1:
              // Navigate to Dashboard
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Dashboard()),
              );
              break;
            default:
              break;
          }
        },
      ),
    );
  }
}

class DepositSheetMy extends StatefulWidget {
  final String selectedGoal;
  final TextEditingController textFieldController;

  DepositSheetMy({required this.selectedGoal, required this.textFieldController});

  @override
  _DepositSheetMyState createState() => _DepositSheetMyState();
}

class _DepositSheetMyState extends State<DepositSheetMy> {
  final _phoneController = TextEditingController();
  final _amountController = TextEditingController();
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    // Retrieve phone number from UserProvider and set it in the controller
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    _phoneController.text = userProvider.phoneNumber;
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Save for ${widget.selectedGoal}',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: 'Phone number (+256xxxxxxxxx)',
                prefixIcon: Icon(Icons.phone),
                hintText: 'Phone number',
              ),
              enabled: false, // Make the field non-editable
              style: TextStyle(
                color: Colors.grey, // Set text color to grey to make it faint
              ),
            ),
            SizedBox(height
