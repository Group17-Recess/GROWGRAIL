import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'pages/userprovider.dart';

import 'pages/login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UserProvider(),
      child: MaterialApp(
        title: 'GrowGrail',
        theme: ThemeData(
          primarySwatch: Colors.teal,
        ),
        home: AuthWrapper(),
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    if (userProvider.isSignedIn) {
      return HomeScreen(); // Your HomeScreen widget
    } else {
      return LoginPage();
    }
  }
}
