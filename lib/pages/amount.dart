import 'package:flutter/material.dart';
import '../models/goal.dart';
import 'home.dart';
import 'package:provider/provider.dart';
import 'paymentservice.dart';
import 'userprovider.dart';
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
                      // textFieldController.text = '09999';
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









class DepositSheet extends StatefulWidget {
  final String selectedGoal;

  DepositSheet({required this.selectedGoal});

  @override
  _DepositSheetState createState() => _DepositSheetState();
}

class _DepositSheetState extends State<DepositSheet> {
  final _phoneController = TextEditingController();
  final _amountController = TextEditingController();
  String _errorMessage = '';

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
              labelText: 'Enter phone number (+256xxxxxxxxx)',
              prefixIcon: Icon(Icons.phone),
            ),
          ),
          SizedBox(height: 20),
          TextField(
            controller: _amountController,
            
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Enter deposit amount (UGX)',
              prefixIcon: Icon(Icons.money),
            ),
          ),
          SizedBox(height: 20),
          if (_errorMessage.isNotEmpty)
            Text(
              _errorMessage,
              style: TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              final phone = _phoneController.text;
              final amount = double.tryParse(_amountController.text) ?? 0;
              final minDeposit = userProvider.targetAmount * 0.01;

              if (!RegExp(r'^\+256\d{9}$').hasMatch(phone)) {
                setState(() {
                  _errorMessage = 'Invalid phone number';
                });
                return;
              }

              if (amount < minDeposit) {
                setState(() {
                  _errorMessage = 'Minimum deposit is UGX $minDeposit';
                });
                return;
              }

              setState(() {
                _errorMessage = '';
              });

              final paymentService = PaymentService();

              final success = await paymentService.initiatePayment(
                context: context,
                amount: amount.toString(),
                currency: 'UGX',
                email: 'user@example.com',
                txRef: 'TX${DateTime.now().millisecondsSinceEpoch}',
                phoneNumber: phone,
              );

              if (success) {
                userProvider.addSavings(amount);
                Navigator.pop(context);
              } else {
                setState(() {
                  _errorMessage = 'Payment failed. Please try again.';
                });
              }
            },
            child: Text('Deposit'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal, // Set button color to teal
              padding: EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
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
                // Add hint text to provide a visual indication of the field being disabled
                hintText: 'Phone number',
              ),
              enabled: false, // Make the field non-editable
              style: TextStyle(
                color: Colors.grey, // Set text color to grey to make it faint
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Enter deposit amount (UGX)',
                prefixIcon: Icon(Icons.money),
              ),
            ),
            SizedBox(height: 20),
            if (_errorMessage.isNotEmpty)
              Text(
                _errorMessage,
                style: TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
            SizedBox(height: _errorMessage.isNotEmpty ? 20 : 0),
            ElevatedButton(
              onPressed: () async {
                final phone = _phoneController.text;
                final amount = double.tryParse(_amountController.text) ?? 0;
                final minDeposit = userProvider.targetAmount * 0.01;

                if (!RegExp(r'^\+256\d{9}$').hasMatch(phone)) {
                  setState(() {
                    _errorMessage = 'Invalid phone number';
                  });
                  return;
                }

                if (amount < minDeposit) {
                  setState(() {
                    _errorMessage = 'Minimum initial deposit is UGX $minDeposit';
                  });
                  return;
                }

                setState(() {
                  _errorMessage = '';
                });

                final paymentService = PaymentService();

                final success = await paymentService.initiatePayment(
                  context: context,
                  amount: amount.toString(),
                  currency: 'UGX',
                  email: 'user@example.com',
                  txRef: 'TX${DateTime.now().millisecondsSinceEpoch}',
                  phoneNumber: phone,
                );

                if (success) {
                  userProvider.addSavings(amount);
                  Navigator.pop(context);
                } else {
                  setState(() {
                    _errorMessage = 'Payment failed. Please try again.';
                  });
                }
              },
              child: Text('Deposit'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                padding: EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 10), // Add some extra space at the bottom
          ],
        ),
      ),
    );
  }
}