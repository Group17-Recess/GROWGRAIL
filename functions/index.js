const functions = require('firebase-functions');
const admin = require('firebase-admin');
const axios = require('axios');

admin.initializeApp();

// Initialize Firestore
const db = admin.firestore();

// Access environment variables
const publicKey = functions.config().payment.public_key || 'FLWPUBK_TEST-e931b80b1f9dc244f8f9466593f25269-X'; // public key
const secretKey = functions.config().payment.secret_key || 'FLWSECK_TEST-2765a8ccd0ebbe629792bb9314f4e1ef-X'; // secret key
const encryptionKey = functions.config().payment.encryption_key || 'FLWSECK_TEST6350e5c551aa'; // encryption key

exports.processPayment = functions.https.onRequest(async (req, res) => {
  if (req.method !== 'POST') {
    return res.status(405).send('Method Not Allowed');
  }

  const { phoneNumber, amount } = req.body;

  if (!phoneNumber || !amount) {
    return res.status(400).send('Phone number and amount are required');
  }

  try {
    // Example API call with your payment details
    const response = await axios.post('https://api.paymentprovider.com/charge', {
      amount,
      currency: 'USD',
      public_key: publicKey,
      secret_key: secretKey,
      encryption_key: encryptionKey,
    });

    res.status(200).send({
      status: 'success',
      message: 'Payment initiated successfully',
      data: response.data,
    });
  } catch (error) {
    console.error('Error processing payment:', error);
    res.status(500).json({
      status: 'error',
      message: 'Payment processing failed',
      error: error.message,
    });
  }
});

exports.handlePaymentWebhook = functions.https.onRequest(async (req, res) => {
  if (req.method !== 'POST') {
    return res.status(405).send('Method Not Allowed');
  }

  // Check Content-Type
  if (req.headers['content-type'] !== 'application/json') {
    console.error('Invalid Content-Type:', req.headers['content-type']);
    return res.status(400).send('Invalid Content-Type');
  }

  const payload = req.body;

  // Log Headers for Debugging
  console.log('Headers:', req.headers);
  console.log('Payload:', payload);

  // Validate payload structure
  if (payload.event !== 'charge.completed' || !payload.data || !payload.data.metadata) {
    console.error('Invalid payload structure:', payload);
    return res.status(400).send('Invalid payload');
  }

  // Extract data
  const { phone_number } = payload.data.customer || {}; // Safeguard if customer is not present
  const { status, amount } = payload.data;

  if (!phone_number || !amount) {
    console.error('Missing phone number or amount in payload:', payload);
    return res.status(400).send('Phone number or amount missing');
  }

  if (status === 'successful') {
    try {
      const userRef = db.collection('users').doc(phone_number);
      const userDoc = await userRef.get();

      if (!userDoc.exists) {
        console.error('User not found:', phone_number);
        return res.status(404).send('User not found');
      }

      const userData = userDoc.data();
      const newBalance = (userData.balance || 0) + amount;

      await userRef.update({ balance: newBalance });

      res.status(200).send({
        status: 'success',
        message: 'Payment processed and balance updated',
      });
    } catch (error) {
      console.error('Error handling payment webhook:', error);
      res.status(500).json({
        status: 'error',
        message: 'Failed to handle payment webhook',
        error: error.message,
      });
    }
  } else {
    res.status(400).send('Unsuccessful payment');
  }
});
