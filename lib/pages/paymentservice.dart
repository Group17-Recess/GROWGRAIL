import 'package:flutter/material.dart';
import 'package:flutterwave_standard/flutterwave.dart';
import 'package:flutterwave_standard/models/requests/customer.dart';
import 'package:flutterwave_standard/models/responses/charge_response.dart';

class PaymentService {
<<<<<<< Updated upstream
  final String publicKey = 'FLWPUBK_TEST-e931b80b1f9dc244f8f9466593f25269-X';
  final String secretKey = 'FLWSECK_TEST-2765a8ccd0ebbe629792bb9314f4e1ef-X';
=======
  final String publicKey = 'FLWPUBK-ef107e156b3df873824cf60a405a85e6-X';
  final String secretKey =
      'FLWSECK-26009a3a1beacd6dac0e570727e0a445-1914824d7a1vt-X';
>>>>>>> Stashed changes

  Future<bool> initiatePayment({
    required BuildContext context,
    required String amount,
    required String currency,
    required String email,
    required String txRef,
    required String phoneNumber,
  }) async {
    final Customer customer = Customer(
      name: " User1",
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
      isTestMode: false, // Change to false for live payments
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
