import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:testrru1/database.dart';
import 'dart:io';

import 'package:testrru1/models/user.dart';

class Authservice {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Create user object based on firebaseUser(User)
  Users? _userFromFirebaseUser(User? user) {
    return user != null ? Users(uid: user.uid) : null;
  }

  // Register using email and password
  Future registerWithEmailandPassword(String role,String email, String password, Map<String, dynamic> userData) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = result.user;

      print("Hiiiiiiiiiiiiiiiiiiiiiiii"); // log for initiation

      // //update the sequence number
      // final HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('getNextSequenceNumber');
      // final response = await callable();
      // final int sequenceNumber = response.data;

      // userData['sequenceNumber'] = sequenceNumber;

      // Create a new document for the user with uid
      await DatabaseServices(uid : user!.uid).updateUserData(role,userData);

      print("Byeeeeeeeeeeeeeeeeeeeeeee"); // log for confirmation

      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
