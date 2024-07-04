import 'package:flutter/material.dart';
import 'deposit.dart';

class Targetpage extends StatelessWidget {
  const Targetpage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.blue[200],
        centerTitle: true,
        title: const Text(
          'WHAT WOULD YOU WANT TO SAVE FOR?',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            OptionContainer(
                text: 'Gadgets', onTap: () => navigateToDepositPage(context)),
            OptionContainer(
                text: 'Shopping', onTap: () => navigateToDepositPage(context)),
            OptionContainer(
                text: 'Tuition', onTap: () => navigateToDepositPage(context)),
            OptionContainer(
                text: 'Starting A Business',
                onTap: () => navigateToDepositPage(context)),
            OptionContainer(
                text: 'Others', onTap: () => showOthersDialog(context)),
          ],
        ),
      ),
    );
  }

  void navigateToDepositPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DepositPage()),
    );
  }

  void showOthersDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController customController = TextEditingController();
        return AlertDialog(
          title: const Text('Specify'),
          content: TextField(
            controller: customController,
            decoration: const InputDecoration(hintText: "Type here"),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Submit'),
              onPressed: () {
                // Handle the submit action here
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class OptionContainer extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const OptionContainer({required this.text, required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: Colors.blueGrey,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0, 4),
              blurRadius: 5.0,
            ),
          ],
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 20.0,
            fontFamily: 'Poppins',
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class DepositPage extends StatefulWidget {
  @override
  _DepositPageState createState() => _DepositPageState();
}

class _DepositPageState extends State<DepositPage> {
  final _amountController = TextEditingController();
  final _phoneNumberController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  void _showPhoneNumberDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Enter Phone Number'),
          content: TextField(
            controller: _phoneNumberController,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              hintText: 'Phone Number',
              prefixIcon: Icon(Icons.phone),
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
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Handle the deposit process here
              },
              child: Text('Deposit'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Deposit Money'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Enter Amount to Deposit',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Amount',
                prefixIcon: Icon(Icons.money),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _showPhoneNumberDialog();
              },
              child: Text('Next'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                textStyle: TextStyle(
                  fontSize: 18,
                ),
                backgroundColor: Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
