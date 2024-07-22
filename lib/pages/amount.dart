import 'package:flutter/material.dart';
import 'home.dart';
import 'package:provider/provider.dart';
import 'paymentservice.dart';
import 'userprovider.dart';
import 'dbscreen.dart';
import 'dashbord.dart';

class HomeScreen extends StatelessWidget {
  final String selectedGoal;

  const HomeScreen({required this.selectedGoal});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

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
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Enter target amount (UGX)',
                  border: InputBorder.none,
                ),
                onChanged: (value) {
                  userProvider.setTargetAmount(double.tryParse(value) ?? 0);
                },
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) => DepositSheet(selectedGoal: selectedGoal),
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
                  child: Text('Deposit'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => UserDashboard()),
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
                MaterialPageRoute(builder: (context) => UserDashboard()),
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