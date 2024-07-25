import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:growgrail/pages/targetpage.dart';
import 'package:growgrail/pages/userprovider.dart';
import 'amount.dart';
import 'package:growgrail/models/goal.dart'; // Ensure you import the Goal model
import 'home.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _selectedIndex = 0;
  final TextEditingController textFieldController = TextEditingController();

  static const List<Widget> _widgetOptions = <Widget>[
    Text('Home Page'),
    Text('Profile Page'),
  ];

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

  void _logout() {
    // Add your logout logic here (e.g., clearing user data, tokens, etc.)

    // Navigate to MyHomePage after logging out
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MyHomePage(title: '',)),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Access UserProvider to get the user's name and goals
    final userProvider = Provider.of<UserProvider>(context);
    final userName = userProvider.name.isEmpty ? 'Guest' : userProvider.name;
    final firstGoal = userProvider.goals.isNotEmpty
        ? userProvider.goals.first
        : Goal(target: '', amount: 0, achieved: 0, balance: 0);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          TextButton(
            onPressed: _logout,
            child: const Text(
              'Logout',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: Column(
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
                              '\UGX ${firstGoal.amount.toStringAsFixed(0)}',
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
                                      '\UGX ${firstGoal.achieved.toStringAsFixed(0)}',
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
                                      '\UGX ${firstGoal.balance.toStringAsFixed(0)}',
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
                                      '\UGX ${firstGoal.interest.toStringAsFixed(0)}',
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
    double progress = goal.achieved / goal.amount;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    goal.target,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
            IconButton(
              icon: const Icon(Icons.add, color: Colors.teal),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Choose an Option'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context); // Close the dialog
                              textFieldController.text = Provider.of<UserProvider>(context, listen: false).phoneNumber; // Set user's phone number
                              showModalBottomSheet(
                                context: context,
                                builder: (context) => DepositSheetMy(
                                  selectedGoal: goal.target, // Pass the goal name to DepositSheetMy
                                  textFieldController: textFieldController, // Pass the controller
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.teal,
                            ),
                            child: const Text('My Number'),
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context); // Close the dialog
                              showModalBottomSheet(
                                context: context,
                                builder: (context) => DepositSheet(
                                  selectedGoal: goal.target, // Pass the goal name to DepositSheet
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.teal,
                            ),
                            child: const Text('Other Number'),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
