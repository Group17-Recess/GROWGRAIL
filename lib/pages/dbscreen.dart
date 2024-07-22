import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:growgrail/pages/targetpage.dart';
import 'deposit.dart';
import 'amount.dart';
import 'home.dart';
import 'package:growgrail/pages/userprovider.dart';

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
    // Access UserProvider to get the user's name
    final userProvider = Provider.of<UserProvider>(context);
    final userName = userProvider.name.isEmpty ? 'Guest' : userProvider.name;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout,
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
                    SizedBox(height: 40),
                    Text(
                      'Welcome,',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    Text(
                      userName,
                      style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 16.0),
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
                            Text(
                              'Total Target ',
                              style: TextStyle(color: Colors.white, fontSize: 16),
                            ),
                            SizedBox(height: 8.0),
                            Text(
                              '\$2,957',
                              style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 16.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Savings',
                                      style: TextStyle(color: Colors.white70, fontSize: 16),
                                    ),
                                    Text(
                                      '\$1,450',
                                      style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Balance',
                                      style: TextStyle(color: Colors.white70, fontSize: 16),
                                    ),
                                    Text(
                                      '\$450',
                                      style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Interest',
                                      style: TextStyle(color: Colors.white70, fontSize: 16),
                                    ),
                                    Text(
                                      '\$450',
                                      style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
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
            child: ListView(
              padding: const EdgeInsets.all(8),
              children: <Widget>[
                GoalCard(
                  imagePath: 'assets/images/paris.jpg',
                  goalName: 'Trip To Paris',
                  goalAmount: 3000,
                  currentAmount: 2400,
                  textFieldController: textFieldController, // Pass the controller to the GoalCard
                ),
                GoalCard(
                  imagePath: 'assets/images/laptop.jpg',
                  goalName: 'New Laptop',
                  goalAmount: 2500,
                  currentAmount: 608,
                  textFieldController: textFieldController, // Pass the controller to the GoalCard
                ),
                GoalCard(
                  imagePath: 'assets/images/car.jpg',
                  goalName: 'Glc Coupe',
                  goalAmount: 50000,
                  currentAmount: 3400,
                  textFieldController: textFieldController, // Pass the controller to the GoalCard
                ),
                GoalCard(
                  imagePath: 'assets/images/emergency.jpg',
                  goalName: 'Emergency Fund',
                  goalAmount: 5000,
                  currentAmount: 2500,
                  textFieldController: textFieldController, // Pass the controller to the GoalCard
                ),
              ],
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
            MaterialPageRoute(builder: (context) => TargetPage(userName: '', phoneNumber: '',)),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.teal,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

class GoalCard extends StatelessWidget {
  final String imagePath;
  final String goalName;
  final double goalAmount;
  final double currentAmount;
  final TextEditingController textFieldController; // Add this line

  const GoalCard({
    required this.imagePath,
    required this.goalName,
    required this.goalAmount,
    required this.currentAmount,
    required this.textFieldController, // Add this line
  });

  @override
  Widget build(BuildContext context) {
    double progress = currentAmount / goalAmount;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage(imagePath),
              radius: 30,
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    goalName,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.grey[200],
                    color: Colors.teal,
                    minHeight: 5,
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$${currentAmount.toStringAsFixed(2)}',
                        style: TextStyle(color: Colors.grey),
                      ),
                      Text(
                        '\$${(goalAmount - currentAmount).toStringAsFixed(2)}',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(Icons.add, color: Colors.teal),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Choose an Option'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context); // Close the dialog
                              textFieldController.text = '09999'; // Set default number
                              showModalBottomSheet(
                                context: context,
                                builder: (context) => DepositSheetMy(
                                  selectedGoal: goalName, // Pass the goal name to DepositSheetMy
                                  textFieldController: textFieldController, // Pass the controller
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.teal,
                            ),
                            child: Text('My Number'),
                          ),
                          SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context); // Close the dialog
                              showModalBottomSheet(
                                context: context,
                                builder: (context) => DepositSheet(
                                  selectedGoal: goalName, // Pass the goal name to DepositSheet
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.teal,
                            ),
                            child: Text('Other Number'),
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

class UpperClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height * 0.75);
    var firstControlPoint = Offset(size.width / 4, size.height * 0.85);
    var firstEndPoint = Offset(size.width / 2, size.height * 0.75);
    var secondControlPoint = Offset(size.width * 3 / 4, size.height * 0.65);
    var secondEndPoint = Offset(size.width, size.height * 0.75);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy, firstEndPoint.dx, firstEndPoint.dy);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy, secondEndPoint.dx, secondEndPoint.dy);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
}
}