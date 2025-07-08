/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

const {onRequest} = require("firebase-functions/v2/https");
const logger = require("firebase-functions/logger");

const functions = require("firebase-functions");
const nodemailer = require("nodemailer");

const transporter = nodemailer.createTransport({
  service: "gmail",
  auth: {
    user: "your_email@gmail.com",        // الإيميل بتاعك
    pass: "your_app_password",           // كلمة مرور التطبيقات
  },
});

exports.sendVerificationCode = functions.https.onCall((data, context) => {
  const email = data.email;
  const code = data.code;

  const mailOptions = {
    from: "your_email@gmail.com",
    to: email,
    subject: "رمز التحقق الخاص بك",
    text: `رمز التحقق هو: ${code}`,
  };

  return transporter.sendMail(mailOptions)
    .then(() => {
      console.log("Email sent to", email);
      return { success: true };
    })
    .catch((error) => {
      console.error("Error sending email:", error);
      throw new functions.https.HttpsError('internal', 'فشل إرسال الإيميل');
    });
});


// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started

// exports.helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
