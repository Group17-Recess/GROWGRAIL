import 'package:flutter/material.dart';

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
              Icon(
                Icons.lock,
                size: 100,
              ),
              SizedBox(height: 20), // spacing
              // welcome text
              Text(
                'Welcome to Financial Freedom, we have missed you',
                style: TextStyle(
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20), // spacing
              // username textfield
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Username',
                  ),
                ),
              ),
              SizedBox(height: 10), // spacing
              // password textfield
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Password',
                  ),
                ),
              ),
              SizedBox(height: 20), // spacing
              // sign in button
              ElevatedButton(
                onPressed: () {
                  // sign in logic
                },
                child: Text('Sign In'),
              ),
              SizedBox(height: 20), // spacing
              // or continue with
              Text('Or continue with'),
              SizedBox(height: 10), // spacing
              // google + apple sign in buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // google button
                  IconButton(
                    icon: Icon(Icons.account_circle),
                    onPressed: () {
                      // google sign in logic
                    },
                  ),
                  // spacing between buttons
                  SizedBox(width: 10),
                  // apple button
                  IconButton(
                    icon: Icon(Icons.account_circle),
                    onPressed: () {
                      // apple sign in logic
                    },
                  ),
                ],
              ),
              SizedBox(height: 20), // spacing
              // not a member? register
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Not a member?'),
                  TextButton(
                    onPressed: () {
                      // registration logic
                    },
                    child: Text('Register now'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
