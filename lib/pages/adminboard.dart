import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:growgrail/pages/target_edit.dart';
import 'package:growgrail/pages/targetpage.dart';
import 'package:growgrail/pages/userprovider.dart';
import 'package:growgrail/pages/admin_biodata.dart';
import 'package:growgrail/pages/home.dart';
import 'package:growgrail/pages/summary_page.dart';
import 'package:growgrail/pages/userlist.dart';

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

  void _logout(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    // Clear user data
    userProvider.clearUserData();

    // Sign out from Firebase
    FirebaseAuth.instance.signOut().then((_) {
      // Navigate to MyHomePage after logging out
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MyHomePage(title: '',)),
      );
    }).catchError((error) {
      // Handle errors if any
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Logout failed: ${error.toString()}')),
      );
    });
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
      case 'Analytics':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SummaryPage()),
        );
        break;
      case 'EditInterest':
        // Add the corresponding page or action
        break;
      case 'DepositRecords':
        // Add the corresponding page or action
        break;
      case 'WithdrawRecords':
        // Add the corresponding page or action
        break;
      default:
        // Handle other cases or show an error
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          TextButton(
            onPressed: () => _logout(context),
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
                  color: Colors.blue,
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
                    const Text(
                      'ADMIN',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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
                _buildListItem(Icons.attach_money, 'Deposit records', 'DepositRecords'),
                _buildListItem(Icons.money_off, 'Withdraw records', 'WithdrawRecords'),
              ],
            ),
          ),
        ],
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
        title: Text(title, style: const TextStyle(fontSize: 18)),
        trailing: const Icon(Icons.arrow_forward, color: Colors.blue),
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
