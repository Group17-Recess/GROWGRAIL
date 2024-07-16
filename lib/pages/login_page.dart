import 'package:flutter/material.dart';
import 'package:growgrail/pages/targetpage.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // logo
              const Icon(
                Icons.lock,
                size: 100,
              ),
              const SizedBox(height: 20), // spacing
              // welcome text
              const Text(
                'Welcome to Financial Freedom, we have missed you',
                style: TextStyle(
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20), // spacing
              // username textfield
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.0),
                child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Username',
                  ),
                ),
              ),
              const SizedBox(height: 10), // spacing
              // password textfield
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.0),
                child: TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Password',
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // spacing
              // sign in button

              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const TargetPage()),
                  );
                },
                child: const Text('Sign In'),
              ),
              const SizedBox(height: 20), // spacing
              // or continue with

              const SizedBox(height: 10), // spacing
              // google + apple sign in buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // google button
                ],
              ),
              const SizedBox(height: 20), // spacing
              // not a member? register
            ],
          ),
        ),
      ),
    );
  }
}

class HomePage {
  const HomePage();
}
