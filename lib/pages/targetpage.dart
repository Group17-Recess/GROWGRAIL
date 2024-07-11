import 'package:flutter/material.dart';
import 'amount.dart';

class TargetPage extends StatelessWidget {
  const TargetPage({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'WHAT WOULD YOU WANT TO SAVE FOR?',
          style: TextStyle(
            color: Color.fromARGB(255, 3, 62, 110),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
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
    try {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(selectedGoal: selectedGoal),
        ),
      );
    } catch (error) {
      showErrorDialog(context, 'Navigation Error', 'Could not navigate to the deposit page.');
    }
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
                if (customGoal.isEmpty) {
                  showErrorDialog(context, 'Input Error', 'Please enter a valid savings goal.');
                } else {
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

  void showErrorDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
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
      onTap: () {
        try {
          onTap();
        } catch (error) {
          showErrorDialog(context, 'Error', 'An unexpected error occurred.');
        }
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: AssetImage(imagePath),
                radius: 30,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 3, 62, 110),
                      ),
                    ),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 10,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, color: Colors.black),
            ],
          ),
        ),
      ),
    );
  }

  void showErrorDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
