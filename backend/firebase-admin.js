require("dotenv").config();
const admin = require("firebase-admin");

const GOOGLE_APPLICATION_CREDENTIALS =
  process.env.GOOGLE_APPLICATION_CREDENTIALS;
if (!GOOGLE_APPLICATION_CREDENTIALS) {
  throw new Error("GOOGLE_APPLICATION_CREDENTIALS must be set");
}
// Initialize Firebase Admin SDK
admin.initializeApp({
  credential: admin.credential.cert(require(GOOGLE_APPLICATION_CREDENTIALS)),
  projectId: "elsa-cabquiz",
});
