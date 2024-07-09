import 'package:flutter/material.dart';
import 'package:growgrail/pages/splash.dart';
import 'package:growgrail/pages/login_page.dart';
import 'package:provider/provider.dart';
import 'package:growgrail/pages/userprovider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => UserProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Savings App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(), // Set SplashScreen as the initial screen
    );
  }
}
