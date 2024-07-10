import 'package:flutter/material.dart';
//import 'pages/login_page.dart';
import 'user_dashboard.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GrowGrail',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const UserDashboard(),
    );
  }
}
