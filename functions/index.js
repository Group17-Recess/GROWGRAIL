const functions = require("firebase-functions");
const admin = require("firebase-admin");
const crypto = require("crypto");
admin.initializeApp();

exports.flutterwaveWebhook = functions.https.onRequest(async (req, res) => {
  try {
    if (req.method === "POST") {
      const payload = req.body;

      // Verify the webhook signature if needed
      const receivedSignature = req.headers["x-flutterwave-signature"];
      const secretKey = "FLWSECK-2a14c6ee2ffa2246fa4974adb05cc4c2-190a8801ecbvt-X";
      const computedSignature = generateSignature(JSON.stringify(payload), secretKey);

      if (receivedSignature !== computedSignature) {
        return res.status(400).send("Invalid signature");
      }

      // Process the payment
      const {status, amount, user_id} = payload;

      if (status === "successful") {
        console.log(`Payment successful. Amount: ${amount}, User ID: ${user_id}`);
        // Update user savings in your database
        await updateUserSavings(user_id, amount);
      } else {
        console.log("Payment failed or other status.");
      }

      return res.status(200).send("Webhook received");
    } else {
      return res.status(405).send("Method not allowed");
    }
  } catch (error) {
    console.error("Error handling webhook:", error);
    return res.status(500).send("Internal Server Error");
  }
});

function generateSignature(payload, secretKey) {
  return crypto.createHmac("sha256", secretKey)
      .update(payload)
      .digest("hex");
}

async function updateUserSavings(userId, depositAmount) {
  const userRef = admin.firestore().collection("users").doc(userId);
  const userDoc = await userRef.get();

  if (userDoc.exists) {
    const userData = userDoc.data();
    const newSavings = (userData.savings || 0) + depositAmount;
    await userRef.update({savings: newSavings});
  } else {
    console.log("User not found");
  }
}
