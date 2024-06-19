const functions = require('firebase-functions');
const admin = require('firebase-admin');
const nodemailer = require('nodemailer');

admin.initializeApp();

const db = admin.firestore();

const transporter = nodemailer.createTransport({
  service: 'gmail',
  auth: {
    user: 'mddesai207@gmail.com',
    pass: 'madhav207'
  },
});

exports.sendWelcomeEmail = functions.auth.user().onCreate(async (user) => {
  const userUid = user.uid;

  try {
    const doc = await db.collection('userCredentials').doc(userUid).get();
    if (!doc.exists) {
      console.log('No user credentials found!');
      return;
    }

    const userData = doc.data();
    const userEmail = userData['user-email'];
    const userPassword = userData['user-password'];

    const mailOptions = {
      from: 'mddesai207@gmail.com',
      to: userEmail,
      subject: 'Welcome to Our App!',
      text: `Your credentials:\nEmail: ${userEmail}\nPassword: ${userPassword}`,
    };

    await transporter.sendMail(mailOptions);
    console.log(`Welcome email sent to ${userEmail}`);
  } catch (error) {
    console.error('Error sending email:', error);
  }
});


//to get sequence number
exports.getNextSequenceNumber = functions.https.onCall(async (data, context) => {
  const docRef = db.collection('metadata').doc('sequenceNumber');

  return db.runTransaction(async (transaction) => {
    const doc = await transaction.get(docRef);
    if (!doc.exists) {
      throw "Document does not exist!";
    }

    const newSequenceNumber = doc.data().lastSequenceNumber + 1;
    transaction.update(docRef, { lastSequenceNumber: newSequenceNumber });
    return newSequenceNumber;
  });
});
