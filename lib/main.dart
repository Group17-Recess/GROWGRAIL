import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:growgrail/firebase_options.dart';
import 'package:provider/provider.dart';
import 'pages/splash.dart';
import 'pages/userprovider.dart'; // Ensure this path is correct
import 'pages/targetprovider.dart'; // Ensure this path is correct
import 'pages/adminboard.dart'; // Ensure this path is correct

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(
            create: (context) => TargetProvider()), // Add TargetProvider here
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
