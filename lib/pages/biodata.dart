import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:growgrail/pages/terms_and_conditions.dart';
import '../models/biomodel.dart';
import 'login_page.dart'; 


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
  bool _agreedToTerms = false;

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
      if (!_agreedToTerms) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('You must agree to the terms and conditions')),
        );
        return;
      }

      final phone = _phoneController.text;
      final name = _nameController.text;

      // Check if the phone number already exists
      final querySnapshot = await FirebaseFirestore.instance
          .collection('user_bio_data')
          .where('phone', isEqualTo: phone)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Phone number already exists
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Sorry, phone number already used')),
        );
      } else {
        // Phone number does not exist, proceed with form submission
        final userBioData = UserBioData(
          name: name,
          email: _emailController.text,
          phone: phone,
          nationalIdentificationNumber: _ninController.text,
          districtOfResidence: _locationController.text,
        );

        try {
          // Get a reference to the Firestore collection
          final collection =
              FirebaseFirestore.instance.collection('user_bio_data');

          // Add a new document with the user's name as the ID
          await collection.doc(name).set(userBioData.toJson());

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
            MaterialPageRoute(builder: (context) => LoginPage()),
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
                  Row(
                    children: [
                      Checkbox(
                        value: _agreedToTerms,
                        onChanged: (bool? value) {
                          setState(() {
                            _agreedToTerms = value ?? false;
                          });
                        },
                      ),
                      const Expanded(
                        child: Text('I agree to the Terms and Conditions'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => TermsAndConditions()),
                          );
                        },
                        child: const Text('View'),
                      ),
                    ],
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
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
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
