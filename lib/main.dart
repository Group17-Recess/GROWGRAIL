// File path: lib/main.dart

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:growgrail/firebase_options.dart';
import 'package:growgrail/pages/splash.dart';

import 'package:provider/provider.dart';
import 'package:growgrail/pages/userprovider.dart';

import 'package:growgrail/pages/targetprovider.dart';
import 'package:growgrail/pages/transaction_provider.dart'; // Add this import

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => TargetProvider()),
        ChangeNotifierProvider(create: (context) => TransactionProvider()), // Add this line
      ],
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
        primarySwatch: Colors.teal,
      ),
      home: SplashScreen(), // Set the initial screen here
    );
  }
}
