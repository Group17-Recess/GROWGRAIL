import 'package:flutter/material.dart';
import 'dart:async';

import 'package:growgrail/pages/home.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Simulate a delay before navigating to the home screen
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MyHomePage(title: 'GrowGrail')),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue, // Example background color
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'images/GGlogo.png', // Replace with your logo asset path
              width: 100, // Adjust size as needed
              height: 100,
            ),
            SizedBox(height: 20),
            Text(
              'Welcome to GrowGrail!',
              style: TextStyle(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            CircularProgressIndicator(), // Example loading indicator
          ],
        ),
      ),
    );
  }
}
