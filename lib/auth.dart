import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:testrru1/database.dart';
import 'dart:io';

import 'package:testrru1/user.dart';

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
      print("HIiiiiiiiiiiiiiiiiiiiiiii");
      // Create a new document for the user with uid
      await DatabaseServices(uid : user!.uid).updateUserData(role,userData);
      print("Byeeeeeeeeeeeeeeeeeeeeeee");
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
