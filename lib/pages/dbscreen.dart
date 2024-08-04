import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:growgrail/pages/targetpage.dart';
import 'package:growgrail/pages/userprovider.dart';
import 'amount.dart';
import 'home.dart';
import 'profile.dart';
import 'withdraw.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:growgrail/models/goal.dart'; // Ensure you import the Goal model

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _selectedIndex = 0;
  final TextEditingController textFieldController = TextEditingController();
  final user=FirebaseAuth.instance.currentUser;

  @override
  void dispose() {
    textFieldController.dispose(); // Dispose the controller when the widget is disposed
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _logout(BuildContext context, UserProvider userProvider) {
  // Clear user data and cancel goal subscription
  userProvider.clearUserData();

  // Add your additional logout logic here (e.g., clearing tokens, etc.)

  // Navigate to MyHomePage after logging out
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => MyHomePage(title: '',)),
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          TextButton(
  onPressed: () {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    _logout(context, userProvider);
  },
  child: const Text(
    'Logout',
    style: TextStyle(color: Colors.white),
  ),
),

TextButton(
 onPressed: () {
 Navigator.push(
    context,
      MaterialPageRoute(builder: (context) => ProfilePage()), // Navigate to Profile Page
               );
        },
         child: const Text(
        'Edit profile',
         style: TextStyle(
          color: Colors.white,
         ),

            ),
              ),
        ],
      ),
      body: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          final userName = userProvider.name.isEmpty ? 'Guest' : userProvider.name;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Stack(
                children: [
                  ClipPath(
                    clipper: UpperClipper(),
                    child: Container(
                      color: Colors.teal,
                      height: 300,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 40),
                        const Text(
                          'Welcome,',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        Text(
                          userName,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold),
                        ),
                            
                        const SizedBox(height: 16.0),
                        Card(
                          color: Colors.teal[400],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Total Target',
                                  style: TextStyle(color: Colors.white, fontSize: 16),
                                ),
                                const SizedBox(height: 8.0),
                                Text(
                                  'UGX ${userProvider.totalTarget.toStringAsFixed(0)}',
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 16.0),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Savings',
                                          style: TextStyle(
                                              color: Colors.white70, fontSize: 16),
                                        ),
                                        Text(
                                          'UGX ${userProvider.totalAchieved.toStringAsFixed(0)}',
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Balance',
                                          style: TextStyle(
                                              color: Colors.white70, fontSize: 16),
                                        ),
                                        Text(
                                          'UGX ${userProvider.totalBalance.toStringAsFixed(0)}',
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Interest',
                                          style: TextStyle(
                                              color: Colors.white70, fontSize: 16),
                                        ),
                                        Text(
                                          'UGX ${userProvider.goals.fold<double>(0, (prev, goal) => prev + goal.interest).toStringAsFixed(0)}',
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: userProvider.goals.length,
                  itemBuilder: (context, index) {
                    final goal = userProvider.goals[index];
                    return GoalCard(
                      goal: goal,
                      textFieldController: textFieldController,
                    );
                  },
                ),
              ),
            ],
          );
        },
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
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.teal,
        onTap: (int index) {
          _onItemTapped(index);
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const TargetPage(
                      userName: '',
                      phoneNumber: '',
                    )),
          );
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.teal,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

class UpperClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height * 0.75);
    var firstControlPoint = Offset(size.width / 4, size.height * 0.85);
    var firstEndPoint = Offset(size.width / 2, size.height * 0.75);
    var secondControlPoint = Offset(size.width * 3 / 4, size.height * 0.65);
    var secondEndPoint = Offset(size.width, size.height * 0.75);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}




 // Ensure you import the Goal model





class GoalCard extends StatelessWidget {
  final TextEditingController textFieldController;
  final Goal goal;

  const GoalCard({
    required this.textFieldController,
    required this.goal,
  });

  @override
  Widget build(BuildContext context) {
    double progress = goal.amount > 0 ? goal.achieved / goal.amount : 0.0; // Avoid division by zero

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8.0), // Add margin for spacing between cards
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        goal.target,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'UGX ${goal.amount.toStringAsFixed(2)}',
                        style: const TextStyle(fontSize: 14, color: Colors.black),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.grey[200],
                    color: Colors.teal,
                    minHeight: 5,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'UGX ${goal.achieved.toStringAsFixed(2)}',
                        style: const TextStyle(color: Colors.grey),
                      ),
                      Text(
                        'UGX ${(goal.amount - goal.achieved).toStringAsFixed(2)}',
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert, color: Colors.teal),
              onSelected: (String value) {
                switch (value) {
                  case 'Add Deposit':
                    _showDepositOptions(context, textFieldController);
                    break;
                  case 'Withdraw':
                    _showWithdrawOptions(context, textFieldController);
                    break;
                  case 'Edit':
                    _showEditDialog(context, goal);
                    break;
                }
              },
              itemBuilder: (BuildContext context) {
                return [
                  const PopupMenuItem<String>(
                    value: 'Add Deposit',
                    child: Text('Add Deposit'),
                  ),
                  const PopupMenuItem<String>(
                    value: 'Withdraw',
                    child: Text('Withdraw'),
                  ),
                  const PopupMenuItem<String>(
                    value: 'Edit',
                    child: Text('Edit'),
                  ),
                ];
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showDepositOptions(BuildContext context, TextEditingController textFieldController) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Deposit Options'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('My Number'),
                onTap: () {
                  Navigator.pop(context);
                  _showDepositModalMy(context, textFieldController);
                },
              ),
              ListTile(
                title: const Text('Other Number'),
                onTap: () {
                  Navigator.pop(context);
                  _showDepositModal(context, textFieldController);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showWithdrawOptions(BuildContext context, TextEditingController textFieldController) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Withdraw Options'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('My Number'),
                onTap: () {
                  Navigator.pop(context);
                  _showWithdrawModalMy(context, textFieldController);
                },
              ),
              ListTile(
                title: const Text('Other Number'),
                onTap: () {
                  Navigator.pop(context);
                  _showWithdrawModal(context, textFieldController);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showWithdrawModalMy(BuildContext context, TextEditingController textFieldController) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final defaultPhoneNumber = userProvider.phoneNumber; // Get the default phone number

    showModalBottomSheet(
      context: context,
      builder: (context) => WithdrawSheetMy(
        selectedGoal: goal.target, // Pass the goal name to WithdrawSheetMy
        textFieldController: textFieldController, // Pass the controller
        targetAmount: goal.amount, // Pass the goal amount as targetAmount
        defaultPhoneNumber: defaultPhoneNumber, // Pass the default phone number
        selectedGoals: null, 
        phoneNumber: '', 
      ),
    );
  }

  void _showWithdrawModal(BuildContext context, TextEditingController textFieldController) {
    showModalBottomSheet(
      context: context,
      builder: (context) => WithdrawSheet(
        selectedGoal: goal.target, // Pass the goal name to WithdrawSheet
        goal: goal, // Pass the goal
        textFieldController: textFieldController, // Pass the controller
        targetAmount: goal.amount, // Pass the goal amount as targetAmount
      ),
    );
  }

  void _showDepositModalMy(BuildContext context, TextEditingController textFieldController) {
    showModalBottomSheet(
      context: context,
      builder: (context) => DepositSheetMy(
        selectedGoal: goal.target, // Pass the goal name to DepositSheetMy
        textFieldController: textFieldController, // Pass the controller
        selectedGoals: null,
      ),
    );
  }

  void _showDepositModal(BuildContext context, TextEditingController textFieldController) {
    showModalBottomSheet(
      context: context,
      builder: (context) => DepositSheet(
        selectedGoal: goal.target, // Pass the goal name to DepositSheet
        textFieldController: textFieldController, // Pass the controller
      ),
    );
  }

  void _showEditDialog(BuildContext context, Goal goal) {
    final TextEditingController targetController = TextEditingController(text: goal.target);
    final TextEditingController amountController = TextEditingController(text: goal.amount.toString());

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Goal'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: targetController,
                decoration: const InputDecoration(labelText: 'Target Name'),
              ),
              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Target Amount'),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () async {
                final newTarget = targetController.text;
                final newAmount = double.tryParse(amountController.text) ?? 0.0;

                // Update the goal in the database
                await _updateGoalInDatabase(context, goal, newTarget, newAmount);

                Navigator.pop(context); // Close the dialog
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
              ),
              child: const Text('Save'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _updateGoalInDatabase(BuildContext context, Goal oldGoal, String newTarget, double newAmount) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    // Update the goal in the user's goals list
    await userProvider.updateGoal(oldGoal.id, newTarget, newAmount);

    // Notify listeners to refresh the UI
    userProvider.notifyListeners();
  }
}