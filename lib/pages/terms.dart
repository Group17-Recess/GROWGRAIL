import 'package:flutter/material.dart';


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TermsAndConditions(),
    );
  }
}

class TermsAndConditions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Terms and Conditions'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Terms and Conditions',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('Last Updated: [Date]'),
            SizedBox(height: 16),
            Text(
              'Welcome to GrowGrail! These Terms and Conditions ("Terms") govern your use of the GrowGrail application ("App"). By using the App, you agree to these Terms. If you do not agree to these Terms, please do not use the App.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            buildSectionTitle('1. Acceptance of Terms'),
            buildSectionContent(
                'By accessing or using the App, you agree to be bound by these Terms and our Privacy Policy. If you do not agree to these Terms, you must not access or use the App.'),
            buildSectionTitle('2. Eligibility'),
            buildSectionContent(
                'You must be at least 18 years old to use the App. By using the App, you represent and warrant that you meet this requirement.'),
            buildSectionTitle('3. Account Registration'),
            buildSectionContent(
                'To use the App, you must create an account by providing accurate and complete information. You are responsible for maintaining the confidentiality of your account and password, and you are responsible for all activities that occur under your account.'),
            buildSectionTitle('4. Saving Targets'),
            buildSectionContent(
                '- Users can set a savings target within the App.\n- Users can deposit funds towards their savings target until the target is reached.\n- All deposits are voluntary, and users are solely responsible for managing their deposits.'),
            buildSectionTitle('5. Deposits'),
            buildSectionContent(
                '- Deposits can be made through the payment methods available in the App.\n- We are not responsible for any fees or charges incurred during the deposit process.'),
            buildSectionTitle('6. Withdrawals'),
            buildSectionContent(
                '- Users can request withdrawals once their savings target is reached.\n- Withdrawals will be processed according to the method selected by the user within the App.\n- Processing times for withdrawals may vary depending on the payment method.'),
            buildSectionTitle('7. Fees'),
            buildSectionContent(
                '- [Outline any fees associated with using the App, if applicable.]'),
            buildSectionTitle('8. User Conduct'),
            buildSectionContent(
                '- You agree not to use the App for any unlawful or prohibited activities.\n- You agree not to interfere with the App\'s operation or security.'),
            buildSectionTitle('9. Privacy'),
            buildSectionContent(
                'Your use of the App is also governed by our Privacy Policy, which can be found at [Privacy Policy URL].'),
            buildSectionTitle('10. Intellectual Property'),
            buildSectionContent(
                'All content and materials within the App, including but not limited to text, graphics, logos, and software, are the property of GrowGrail and are protected by intellectual property laws.'),
            buildSectionTitle('11. Limitation of Liability'),
            buildSectionContent(
                '- GrowGrail is not liable for any direct, indirect, incidental, special, or consequential damages resulting from your use of the App.\n- We do not guarantee that the App will be error-free or uninterrupted.'),
            buildSectionTitle('12. Changes to Terms'),
            buildSectionContent(
                'We may update these Terms from time to time. If we make significant changes, we will notify you by email or through the App. Your continued use of the App after any changes indicates your acceptance of the new Terms.'),
            buildSectionTitle('13. Termination'),
            buildSectionContent(
                'We reserve the right to terminate or suspend your account at any time for any reason, including if you violate these Terms.'),
            buildSectionTitle('14. Governing Law'),
            buildSectionContent(
                'These Terms are governed by and construed in accordance with the laws of [Your Country/State]. Any disputes arising from these Terms or your use of the App will be resolved in the courts of [Your Country/State].'),
            buildSectionTitle('15. Contact Us'),
            buildSectionContent(
                'If you have any questions about these Terms, please contact us at [Your Contact Information].'),
          ],
        ),
      ),
    );
  }

  Widget buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget buildSectionContent(String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Text(
        content,
        style: TextStyle(fontSize: 16),
      ),
    );
  }
}
