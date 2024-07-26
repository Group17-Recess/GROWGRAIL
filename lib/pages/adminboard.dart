import 'package:flutter/material.dart';
import 'package:growgrail/pages/target_edit.dart';
import 'package:provider/provider.dart';
import 'package:growgrail/pages/targetpage.dart';
import 'package:growgrail/pages/userprovider.dart';
import '../models/goal.dart';
import 'admin_biodata.dart';
import 'home.dart';
import 'userlist.dart';


class Admin extends StatefulWidget {
  @override
  _AdminState createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 0) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MyHomePage(title: '',)),
        );
      } else if (index == 1) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Admin()),
        );
      }
    });
  }

  void _logout() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MyHomePage(title: '',)),
    );
  }

  void _navigateTo(String route) {
    switch (route) {
      case 'AddAdmin':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AdminBioDataForm()),
        );
        break;
      case 'Users':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => UserListPage()),
        );
        break;
      case 'AddTargetCategory':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => TargetEditPage()),
        );
        break;
      default:
        // Handle other cases or show an error
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final userName = userProvider.name.isEmpty ? 'Admin' : userProvider.name;
    // final firstGoal = userProvider.goals.isNotEmpty
    //     ? userProvider.goals.first
    //     : Goal(target: '', amount: 0, achieved: 0, balance: 0);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
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
                  color: Colors.blue,
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
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    ),
                    // SizedBox(height: 16.0),
                    // Card(
                    //   color: Colors.blue[400],
                    //   shape: RoundedRectangleBorder(
                    //     borderRadius: BorderRadius.circular(16.0),
                    //   ),
                    //   child: Padding(
                    //     padding: const EdgeInsets.all(16.0),
                    //     child: Column(
                    //       crossAxisAlignment: CrossAxisAlignment.start,
                    //       children: [
                    //         Text(
                    //           'Total Target',
                    //           style: TextStyle(color: Colors.white, fontSize: 16),
                    //         ),
                    //         SizedBox(height: 8.0),
                    //         Text(
                    //           '\UGX ${firstGoal.amount.toStringAsFixed(0)}',
                    //           style: TextStyle(
                    //               color: Colors.white,
                    //               fontSize: 32,
                    //               fontWeight: FontWeight.bold),
                    //         ),
                    //         SizedBox(height: 16.0),
                    //         Row(
                    //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //           children: [
                    //             Column(
                    //               crossAxisAlignment: CrossAxisAlignment.start,
                    //               children: [
                    //                 Text(
                    //                   'Savings',
                    //                   style: TextStyle(
                    //                       color: Colors.white70, fontSize: 16),
                    //                 ),
                    //                 Text(
                    //                   '\UGX ${firstGoal.achieved.toStringAsFixed(0)}',
                    //                   style: TextStyle(
                    //                       color: Colors.white,
                    //                       fontSize: 20,
                    //                       fontWeight: FontWeight.bold),
                    //                 ),
                    //               ],
                    //             ),
                    //             Column(
                    //               crossAxisAlignment: CrossAxisAlignment.start,
                    //               children: [
                    //                 Text(
                    //                   'Balance',
                    //                   style: TextStyle(
                    //                       color: Colors.white70, fontSize: 16),
                    //                 ),
                    //                 Text(
                    //                   '\UGX ${firstGoal.balance.toStringAsFixed(0)}',
                    //                   style: TextStyle(
                    //                       color: Colors.white,
                    //                       fontSize: 20,
                    //                       fontWeight: FontWeight.bold),
                    //                 ),
                    //               ],
                    //             ),
                    //           ],
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ],
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                _buildListItem(Icons.person, 'Users', 'Users'),
                _buildListItem(Icons.analytics, 'Analytics', 'Analytics'),
                _buildListItem(Icons.edit, 'Edit interest', 'EditInterest'),
                _buildListItem(Icons.attach_money, 'Deposit records', 'DepositRecords'),
                _buildListItem(Icons.money_off, 'Withdraw records', 'WithdrawRecords'),
                _buildListItem(Icons.category, 'Add target category', 'AddTargetCategory'),
                _buildListItem(Icons.admin_panel_settings, 'Add Admin', 'AddAdmin'),
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
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildListItem(IconData icon, String title, String route) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      elevation: 4,
      child: ListTile(
        leading: Icon(icon, color: Colors.blue),
        title: Text(title, style: TextStyle(fontSize: 18)),
        trailing: Icon(Icons.arrow_forward, color: Colors.blue),
        onTap: () => _navigateTo(route),
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
