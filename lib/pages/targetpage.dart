import 'package:flutter/material.dart';
import 'package:growgrail/pages/amount.dart';
import 'package:provider/provider.dart';
import '../models/goal.dart';
import 'dbscreen.dart';

import 'home.dart';

import 'userprovider.dart';

class TargetPage extends StatefulWidget {
  const TargetPage({Key? key, required String userName, required String phoneNumber}) : super(key: key);

  @override
  _TargetPageState createState() => _TargetPageState();
}

class _TargetPageState extends State<TargetPage> {
  @override
  Widget build(BuildContext context) {
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  OptionContainer(
                    imagePath: 'images/gadgets.jpg',
                    title: 'Gadgets',
                    subtitle: 'Save for new gadgets',
                    onTap: () => _saveGoalAndNavigate(context, 'Gadgets'),
                  ),
                  OptionContainer(
                    imagePath: 'images/shopping.jpg',
                    title: 'Shopping',
                    subtitle: 'Save for shopping',
                    onTap: () => _saveGoalAndNavigate(context, 'Shopping'),
                  ),
                  OptionContainer(
                    imagePath: 'images/tuition.jpg',
                    title: 'Tuition',
                    subtitle: 'Save for tuition fees',
                    onTap: () => _saveGoalAndNavigate(context, 'Tuition'),
                  ),
                  OptionContainer(
                    imagePath: 'images/business.jpg',
                    title: 'Starting A Business',
                    subtitle: 'Save for starting a business',
                    onTap: () => _saveGoalAndNavigate(context, 'Starting A Business'),
                  ),
                  OptionContainer(
                    imagePath: 'images/others.jpg',
                    title: 'Others',
                    subtitle: 'Specify your savings goal',
                    onTap: () => _showOthersDialog(context),
                  ),
                ],
              ),
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

  Future<void> _saveGoalAndNavigate(BuildContext context, String selectedGoal) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    final goal = Goal(
      target: selectedGoal,
      amount: 0,
      achieved: 0,
      balance: 0,
    );

    await Goal.saveGoal(userProvider.phoneNumber, goal);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HomeScreen(selectedGoal: selectedGoal, phoneNumber: '',),
      ),
    );
  }

  void _showOthersDialog(BuildContext context) {
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
                Navigator.of(context).pop();
                _saveGoalAndNavigate(context, customController.text);
              },
            ),
          ],
        );
      },
    );
  }
}

class OptionContainer extends StatelessWidget {
  final String imagePath;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const OptionContainer({
    required this.imagePath,
    required this.title,
    required this.subtitle,
    required this.onTap,
    Key? key,
  }) : super(key: key);

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
              CircleAvatar(
                backgroundImage: AssetImage(imagePath),
                radius: 25,
              ),
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
