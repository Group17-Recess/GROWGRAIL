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

// Function to process payment
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
      currency: 'UGX',
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

// Function to handle payment webhook
exports.handlePaymentWebhook = functions.https.onRequest(async (req, res) => {
  if (req.method !== 'POST') {
    return res.status(405).send('Method Not Allowed');
  }

  const payload = req.body;

  if (payload.event === 'charge.completed' && payload.data.status === 'successful') {
    let phoneNumber = payload.data.customer.phone_number;
    const amount = payload.data.amount;

    // Ensure phone number format matches the database format
    if (!phoneNumber.startsWith('+')) {
      phoneNumber = `+${phoneNumber}`;
    }

    try {
      // Reference the specific goal document
      const goalsRef = db.collection('Goals').doc(phoneNumber).collection('userGoals');
      const snapshot = await goalsRef.get();

      if (snapshot.empty) {
        console.error('No goals found for user:', phoneNumber);
        return res.status(404).send('No goals found for user');
      }

      // Assume updating the first goal in the collection
      const firstGoalDoc = snapshot.docs[0];
      const goalData = firstGoalDoc.data();
      const newAchieved = (goalData.Achieved || 0) + amount;

      // Update the `Achieved` field in the first goal
      await firstGoalDoc.ref.update({ Achieved: newAchieved });

      return res.status(200).send({
        status: 'success',
        message: 'Payment processed and Achieved field updated',
      });
    } catch (error) {
      console.error('Error handling payment webhook:', error);
      return res.status(500).json({
        status: 'error',
        message: 'Failed to handle payment webhook',
        error: error.message,
      });
    }
  } else {
    return res.status(400).send('Invalid event or unsuccessful payment');
  }
});
