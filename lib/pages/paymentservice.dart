import 'package:flutter/material.dart';
import 'package:flutterwave_standard/flutterwave.dart';
import 'package:flutterwave_standard/models/requests/customer.dart';
import 'package:flutterwave_standard/models/responses/charge_response.dart';

class PaymentService {
  final String publicKey = 'FLWPUBK_TEST-e931b80b1f9dc244f8f9466593f25269-X';
  final String secretKey = 'FLWSECK_TEST-2765a8ccd0ebbe629792bb9314f4e1ef-X';

  Future<bool> initiatePayment({
    required BuildContext context,
    required String amount,
    required String currency,
    required String email,
    required String txRef,
    required String phoneNumber,
  }) async {
    final Customer customer = Customer(
      name: " User11",
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
      isTestMode: true, // Change to false for live payments
      redirectUrl:
          "https://your-redirect-url.com", // You can use any URL for testing
    );

    try {
      final ChargeResponse response = await flutterwave.charge();
      if (response != null && response.status == "successful") {
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
