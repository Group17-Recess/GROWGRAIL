import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:growgrail/firebase_options.dart';
import 'package:growgrail/pages/splash.dart';
import 'package:growgrail/pages/login_page.dart';
import 'package:provider/provider.dart';
import 'package:growgrail/pages/userprovider.dart';
import 'pages/summary_page.dart'; // Import the summary page

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
      routes: {
        '/summary': (context) => SummaryPage(), // Define the summary route
      },
    );
  }
}
