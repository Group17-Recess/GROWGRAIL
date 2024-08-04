import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _ninController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      final phone = _phoneController.text;

      // Check if the phone number already exists
      final querySnapshot = await FirebaseFirestore.instance
          .collection('admin_bio_data')
          .where('phone', isEqualTo: phone)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Phone number already exists
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Sorry, phone number already used')),
        );
      } else {
        // Phone number does not exist, proceed with form submission
        final adminBioData = AdminBioData(
          name: _nameController.text,
          email: _emailController.text,
          phone: phone,
          nationalIdentificationNumber: _ninController.text,
          districtOfResidence: _locationController.text,
        );

        try {
          // Get a reference to the Firestore collection
          final collection =
              FirebaseFirestore.instance.collection('admin_bio_data');

          // Add a new document with a generated ID
          await collection.add(adminBioData.toJson());

          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Form submitted successfully!')),
          );

          // Optionally, clear the form fields
          _nameController.clear();
          _emailController.clear();
          _phoneController.clear();
          _ninController.clear();
          _locationController.clear();

          // Redirect to login page
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginPage()),
          );
        } catch (e) {
          // Handle errors
          print('Error saving data to Firestore: $e');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to submit form.')),
          );
        }
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
                  const SizedBox(height: 20),
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
}
