import 'package:flutter/material.dart';
import 'amount.dart';

class TargetPage extends StatelessWidget {
  const TargetPage({Key? key, required String userName, required String phoneNumber});

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
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OptionContainer(
                  imagePath: 'images/gadgets.jpg',
                  title: 'Gadgets',
                  subtitle: 'Save for new gadgets',
                  onTap: () => navigateToDepositPage(context, 'Gadgets'),
                ),
                OptionContainer(
                  imagePath: 'images/shopping.jpg',
                  title: 'Shopping',
                  subtitle: 'Save for shopping',
                  onTap: () => navigateToDepositPage(context, 'Shopping'),
                ),
                OptionContainer(
                  imagePath: 'images/tuition.jpg',
                  title: 'Tuition',
                  subtitle: 'Save for tuition fees',
                  onTap: () => navigateToDepositPage(context, 'Tuition'),
                ),
                OptionContainer(
                  imagePath: 'images/business.jpg',
                  title: 'Starting A Business',
                  subtitle: 'Save for starting a business',
                  onTap: () =>
                      navigateToDepositPage(context, 'Starting A Business'),
                ),
                OptionContainer(
                  imagePath: 'images/others.jpg',
                  title: 'Others',
                  subtitle: 'Specify your savings goal',
                  onTap: () => showOthersDialog(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void navigateToDepositPage(BuildContext context, String selectedGoal) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => HomeScreen(selectedGoal: selectedGoal, phoneNumber: '',)),
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
                Navigator.of(context).pop();
                navigateToDepositPage(context, customController.text);
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
