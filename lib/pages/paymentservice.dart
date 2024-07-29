import 'package:flutter/material.dart';
import 'package:flutterwave_standard/flutterwave.dart';
import 'package:flutterwave_standard/models/requests/customer.dart';
import 'package:flutterwave_standard/models/responses/charge_response.dart';
import 'package:provider/provider.dart';
import 'package:growgrail/pages/userprovider.dart'; // Import your UserProvider

class PaymentService {
  final String publicKey = 'FLWPUBK-3e4514215898208e91495577492530d7-X';
  final String secretKey =
      'FLWSECK-2a14c6ee2ffa2246fa4974adb05cc4c2-190a8801ecbvt-X';

  Future<bool> initiatePayment({
    required BuildContext context,
    required String amount,
    required String currency,
    required String email,
    required String txRef,
    required String phoneNumber,
  }) async {
    final Customer customer = Customer(
      name: "User",
      phoneNumber: phoneNumber,
      email: email,
    );

    final Flutterwave flutterwave = Flutterwave(
      context: context,
      publicKey: publicKey,
      currency: currency,
      amount: amount,
      customer: customer,
      paymentOptions: "mobilemoneyuganda",
      customization: Customization(title: "Live Payment"),
      txRef: txRef,
      isTestMode: false,
      redirectUrl: "https://your-redirect-url.com",
    );

    try {
      final ChargeResponse response = await flutterwave.charge();
      if (response != null && response.status == "successful") {
        // Payment was successful, update user balance
        final userProvider = Provider.of<UserProvider>(context, listen: false);
        double paymentAmount = double.tryParse(amount) ?? 0.0;
        await userProvider.updateUserBalance(paymentAmount);
        return true;
      } else {
        print("Transaction failed");
        return false;
      }
    } catch (error) {
      print("An error occurred: $error");
      return false;
    }
  }
}
