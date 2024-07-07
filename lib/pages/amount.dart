import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'paymentservice.dart';
import 'userprovider.dart';
import 'dbscreen.dart';

// Assuming DashboardScreen widget is in dashboard_screen.dart

class HomeScreen extends StatelessWidget {
  final String selectedGoal;

  const HomeScreen({required this.selectedGoal});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('GROWGRAIL'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Selected Goal: $selectedGoal', // Display selected goal here
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
                  // icon: Icon(Icons.attach_money),
                ),
                onChanged: (value) {
                  userProvider.setTargetAmount(double.tryParse(value) ?? 0);
                },
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) => DepositSheet(),
                );
              },
              child: Text('Deposit'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DashboardScreen()),
                );
              },
              child: Text('View Total Savings'),
            ),
          ],
        ),
      ),
    );
  }
}

class DepositSheet extends StatefulWidget {
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
            'Make a Deposit',
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
              padding: EdgeInsets.symmetric(vertical: 15),
              backgroundColor: Colors.green,
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
