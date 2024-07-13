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
      backgroundColor: Color(0xFF013125), // background color
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircleAvatar(
              backgroundColor: Colors.white, // background color of the circle avatar
              radius: 50, // radius of the circle avatar
              child: ClipOval(
                child: Image.asset(
                  'images/GGlogo.png', // path to your logo image
                  width: 100, // width of the image inside the circle avatar
                  height: 100, // height of the image inside the circle avatar
                  fit: BoxFit.cover, // adjust how the image fits within the circle
                ),
              ),
            ),
            SizedBox(height: 20),
            CircularProgressIndicator(), // loading indicator
          ],
        ),
      ),
    );
  }
}
