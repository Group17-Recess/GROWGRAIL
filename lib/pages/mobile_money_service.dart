import 'dart:convert';
import 'package:http/http.dart' as http;

class MobileMoneyService {
  final String apiUrl = 'https://sandbox.momodeveloper.mtn.com';
  final String primaryKey = 'e1518b2871014a2ea7689046cdc08bff';
  final String secondaryKey = '6bd4aeb7064d4f5cb3b126d59d5c4bd5';

  Future<String> getAccessToken() async {
    try {
      final response = await http.post(
        Uri.parse('$apiUrl/collection/token/'),
        headers: {
          'Ocp-Apim-Subscription-Key': primaryKey,
          'Authorization':
              'Basic ${base64Encode(utf8.encode('$primaryKey:$secondaryKey'))}',
          'Content-Type': 'application/json'
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['access_token'];
      } else {
        throw Exception('Failed to get access token: ${response.body}');
      }
    } catch (e) {
      print('Error getting access token: $e');
      rethrow;
    }
  }

  Future<void> initiateTransaction(
      String token, double amount, String phoneNumber) async {
    try {
      final response = await http.post(
        Uri.parse('$apiUrl/collection/v1_0/requesttopay'),
        headers: {
          'Authorization': 'Bearer $token',
          'X-Reference-Id':
              'your-unique-reference-id', // Replace with a unique ID for each transaction
          'X-Target-Environment': 'sandbox',
          'Ocp-Apim-Subscription-Key': primaryKey,
          'Content-Type': 'application/json'
        },
        body: jsonEncode({
          'amount': amount.toString(),
          'currency': 'EUR',
          'externalId': 'your-external-id', // Replace with your external ID
          'payer': {'partyIdType': 'MSISDN', 'partyId': phoneNumber},
          'payerMessage': 'Deposit',
          'payeeNote': 'Deposit to account'
        }),
      );

      if (response.statusCode != 202) {
        throw Exception('Failed to initiate transaction: ${response.body}');
      }
    } catch (e) {
      print('Error initiating transaction: $e');
      rethrow;
    }
  }
}
