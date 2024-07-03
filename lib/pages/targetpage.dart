import 'package:flutter/material.dart';

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
            OptionContainer(text: 'Gadgets', onTap: () => navigateToDepositPage(context)),
            OptionContainer(text: 'Shopping', onTap: () => navigateToDepositPage(context)),
            OptionContainer(text: 'Tuition', onTap: () => navigateToDepositPage(context)),
            OptionContainer(text: 'Starting A Business', onTap: () => navigateToDepositPage(context)),
            OptionContainer(text: 'Others', onTap: () => showOthersDialog(context)),
          ],
        ),
      ),
    );
  }

  void navigateToDepositPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const DepositPage()),
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

class DepositPage extends StatelessWidget {
  const DepositPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Deposit Page'),
      ),
      body: const Center(
        child: Text('Welcome to the Deposit Page!'),
      ),
    );
  }
}
