import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'userprovider.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final TextEditingController nameController = TextEditingController(text: userProvider.name);
    final TextEditingController emailController = TextEditingController(text: userProvider.email);
    final TextEditingController phoneController = TextEditingController(text: userProvider.phoneNumber);


    Future<void> updateProfile() async {
      // Update the user's profile in the Firestore database
      final userDoc = FirebaseFirestore.instance.collection('user_bio_data').doc(userProvider.phoneNumber);

      await userDoc.update({
        'name': nameController.text,
        'email': emailController.text,
        'phone': phoneController.text,
      });

      // Update the user data in the provider
      userProvider.setUser(nameController.text, emailController.text, phoneController.text);

      Navigator.pop(context); // Go back to the previous page
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('My Profile'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.teal.shade100,
              child: Icon(
                Icons.person,
                size: 80,
                color: Colors.teal,
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: phoneController,
              decoration: InputDecoration(
                labelText: 'Phone',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: updateProfile,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
              ),
              child: Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}