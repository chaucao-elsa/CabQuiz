/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

const { validateTopic } = require("./topic.validate");

exports.topic_validation = functions
  .region("asia-southeast1")
  .https.onRequest(async (req, res) => {
    if (!req.query.topic) {
      return res.status(400).json({ error: "topic must not be blank" });
    }
    const ok = await validateTopic(req.query.topic);
    return res.json({ ok });
  });
