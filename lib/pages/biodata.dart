import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/biomodel.dart';
import 'login_page.dart'; // Assuming you have a separate file for the login page

class UserBioDataForm extends StatefulWidget {
  @override
  _UserBioDataFormState createState() => _UserBioDataFormState();
}

class _UserBioDataFormState extends State<UserBioDataForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _ninController = TextEditingController();
  final _locationController = TextEditingController();
  final _passwordController = TextEditingController(); // Password controller

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _ninController.dispose();
    _locationController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();
      final phone = _phoneController.text.trim();
      final name = _nameController.text.trim();

      try {
        // Create user with email and password using Firebase Auth
        UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        // Get the user's UID from Firebase Auth
        String uid = userCredential.user!.uid;

        // Create user bio data model
        final userBioData = UserBioData(
          name: name,
          email: email,
          phone: phone,
          nationalIdentificationNumber: _ninController.text,
          districtOfResidence: _locationController.text,
        );

        // Save additional user information in Firestore using the UID as the document ID
        await FirebaseFirestore.instance.collection('user_bio_data').doc(uid).set(userBioData.toJson());

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registration successful!')),
        );

        // Clear the form fields
        _nameController.clear();
        _emailController.clear();
        _phoneController.clear();
        _ninController.clear();
        _locationController.clear();
        _passwordController.clear();

        // Redirect to login page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      } catch (e) {
        // Handle errors
        print('Error: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registration failed. Please try again.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Center(
          child: Text(
            'USER BIODATA FORM',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
              horizontal: 16.0, vertical: 8.0), // Reduced top padding
          child: Form(
            key: _formKey,
            child: Container(
              width: 300, // Adjusted width
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildTextField(
                    controller: _nameController,
                    label: 'Name',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  _buildTextField(
                    controller: _emailController,
                    label: 'Email',
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  _buildTextField(
                    controller: _phoneController,
                    label: 'Phone Number',
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your phone number';
                      }
                      if (!RegExp(r'^\+256\d{9}$').hasMatch(value)) {
                        return 'Please enter a valid phone number starting with +256 and followed by 9 digits';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  _buildTextField(
                    controller: _ninController,
                    label: 'National Identification Number',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your National Identification Number';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  _buildTextField(
                    controller: _locationController,
                    label: 'District of Residence',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your District of Residence';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  _buildTextField(
                    controller: _passwordController,
                    label: 'Password',
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters long';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),

                  ElevatedButton(
                    onPressed: _submitForm,
                    child: Text('Submit'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        hintText: 'Enter your $label',
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      validator: validator,
    );
  }
}


