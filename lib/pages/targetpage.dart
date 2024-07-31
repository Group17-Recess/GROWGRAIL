import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'targetprovider.dart';
import 'home.dart';
import 'dbscreen.dart';
import 'amount.dart';

class TargetPage extends StatelessWidget {
  final String userName;
  final String phoneNumber;

  const TargetPage({
    Key? key,
    required this.userName,
    required this.phoneNumber,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final targetProvider = Provider.of<TargetProvider>(context);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80.0), // Adjust the height as needed
        child: AppBar(
          title: const Text(
            'WHAT WOULD YOU WANT TO SAVE FOR?',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ), // Bold font
          ),
          backgroundColor: Colors.teal,
          elevation: 0,
          centerTitle: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30),
            ),
          ),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ...targetProvider.targets.map((target) => OptionContainer(
                  title: target.name,
                  subtitle: 'Save for ${target.name}',
                  onTap: () => navigateToDepositPage(context, target.name),
                )),
                OptionContainer(
                  title: 'Others',
                  subtitle: 'Specify your savings goal',
                  onTap: () => showOthersDialog(context),
                ),
              ],
            ),
          ),
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

  void navigateToDepositPage(BuildContext context, String selectedGoal) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HomeScreen(selectedGoal: selectedGoal, phoneNumber: ''),
      ),
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
                String customGoal = customController.text;
                if (customGoal.isNotEmpty) {
                  Navigator.of(context).pop();
                  navigateToDepositPage(context, customGoal);
                }
              },
            ),
          ],
        );
      },
    );
  }
}

class OptionContainer extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const OptionContainer({
    required this.title,
    required this.subtitle,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold, color: Colors.teal),
                    ),
                    Text(
                      subtitle,
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, color: Colors.teal),
            ],
          ),
        ),
      ),
    );
  }
}