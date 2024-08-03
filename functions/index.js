const functions = require('firebase-functions');
const admin = require('firebase-admin');
const axios = require('axios'); // Assuming you are using axios for making HTTP requests
admin.initializeApp();

// Access environment variables
const publicKey = functions.config().payment.public_key || 'FLWPUBK_TEST-e931b80b1f9dc244f8f9466593f25269-X';//publivc key
const secretKey = functions.config().payment.secret_key || 'FLWSECK_TEST-2765a8ccd0ebbe629792bb9314f4e1ef-X'; // secret key
const encryptionKey = functions.config().payment.encryption_key || 'FLWSECK_TEST6350e5c551aa'; //encryption key

exports.processPayment = functions.https.onRequest(async (req, res) => {
  try {
    // Example API call with your payment details
    const response = await axios.post('https://api.paymentprovider.com/charge', {
      amount: req.body.amount,
      currency: 'USD',
      public_key: publicKey,
      secret_key: secretKey,
      encryption_key: encryptionKey,
    });
    res.status(200).send(response.data);
  } catch (error) {
    console.error('Error processing payment:', error);
    res.status(500).send('Payment processing failed');
  }
});
