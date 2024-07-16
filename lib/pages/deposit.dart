import 'package:flutter/material.dart';
import 'mobile_money_service.dart';

class DepositPage extends StatefulWidget {
  @override
  _DepositPageState createState() => _DepositPageState();
}

class _DepositPageState extends State<DepositPage> {
  final _amountController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final MobileMoneyService _service = MobileMoneyService();
  String _token;
  String _transactionResult;

  @override
  void dispose() {
    _amountController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _authenticate();
  }

  Future<void> _authenticate() async {
    try {
      final token = await _service.getAccessToken();
      setState(() {
        _token = token;
      });
    } catch (e) {
      print('Failed to authenticate: $e');
    }
  }

  Future<void> _initiateTransaction() async {
    try {
      final amount = double.parse(_amountController.text);
      final phoneNumber = _phoneNumberController.text;
      await _service.initiateTransaction(_token, amount, phoneNumber);
      setState(() {
        _transactionResult = 'Transaction successful';
      });
    } catch (e) {
      print('Failed to initiate transaction: $e');
      setState(() {
        _transactionResult = 'Transaction failed';
      });
    }
  }

  void _showPhoneNumberDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: AlertDialog(
            title: const Text('Enter Phone Number'),
            content: TextField(
              controller: _phoneNumberController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                hintText: 'Phone Number',
                prefixIcon: const Icon(Icons.phone),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _initiateTransaction();
                },
                child: const Text('Deposit'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Deposit Money'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Enter Amount to Deposit',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Amount',
                prefixIcon: const Icon(Icons.money),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _showPhoneNumberDialog,
              child: const Text('Next'),
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                textStyle: const TextStyle(
                  fontSize: 18,
                ),
                backgroundColor: Colors.green,
              ),
            ),
            if (_transactionResult != null)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('Transaction Result: $_transactionResult'),
              ),
          ],
        ),
      ),
    );
  }
}
