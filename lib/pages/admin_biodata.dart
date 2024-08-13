import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/adminmodel.dart';
import 'login_page.dart'; // Assuming you have a separate file for the login page

class AdminBioDataForm extends StatefulWidget {
  @override
  _AdminBioDataFormState createState() => _AdminBioDataFormState();
}

class _AdminBioDataFormState extends State<AdminBioDataForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _ninController = TextEditingController();
  final _locationController = TextEditingController();
  final _passwordController = TextEditingController(); // Password controller
  final _confirmPasswordController = TextEditingController(); // Confirm password controller

  bool _passwordVisible = false; // Toggle for password visibility
  bool _confirmPasswordVisible = false; // Toggle for confirm password visibility

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _ninController.dispose();
    _locationController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();
      final phone = _phoneController.text.trim();
      final name = _nameController.text.trim();

      try {
        // Create admin with email and password using Firebase Auth
        UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        // Get the user's UID from Firebase Auth
        String uid = userCredential.user!.uid;

        // Create admin bio data model
        final adminBioData = AdminBioData(
          name: name,
          email: email,
          phone: phone,
          nationalIdentificationNumber: _ninController.text,
          districtOfResidence: _locationController.text,
        );

        // Save additional user information in Firestore using the UID as the document ID
        await FirebaseFirestore.instance.collection('admin_bio_data').doc(uid).set(adminBioData.toJson());

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
        _confirmPasswordController.clear();

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
        backgroundColor: Colors.blue,
        title: const Center(
          child: Text(
            'ADMIN BIODATA FORM',
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
            child: SizedBox(
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
                  const SizedBox(height: 16),
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
                  const SizedBox(height: 16),
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
                  const SizedBox(height: 16),
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
                  const SizedBox(height: 16),
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
                  _buildPasswordField(
                    controller: _passwordController,
                    label: 'Password',
                    obscureText: !_passwordVisible,
                    toggleVisibility: () {
                      setState(() {
                        _passwordVisible = !_passwordVisible;
                      });
                    },
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
                  SizedBox(height: 16),
                  _buildPasswordField(
                    controller: _confirmPasswordController,
                    label: 'Confirm Password',
                    obscureText: !_confirmPasswordVisible,
                    toggleVisibility: () {
                      setState(() {
                        _confirmPasswordVisible = !_confirmPasswordVisible;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please confirm your password';
                      }
                      if (value != _passwordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _submitForm,
                    child: const Text('Submit'),
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
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        hintText: 'Enter your $label',
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      validator: validator,
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required bool obscureText,
    required VoidCallback toggleVisibility,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        hintText: 'Enter your $label',
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        filled: true,
        fillColor: Colors.white,
        suffixIcon: IconButton(
          icon: Icon(
            obscureText ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: toggleVisibility,
        ),
      ),
      validator: validator,
    );
  }
}
