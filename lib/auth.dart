import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:testrru1/database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

import 'package:testrru1/models/user.dart';

class Authservice {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final CollectionReference eventDataCollection = FirebaseFirestore.instance.collection("events");

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




  // Upload image to Firebase Storage
  Future<String?> uploadImage(File imageFile,String title) async {
    try {

      final timestamp = DateTime.now().microsecondsSinceEpoch;
      final filename = imageFile.path.split("/").last;
      final storageRef = FirebaseStorage.instance.ref().child('$title/$timestamp-$filename');
      final uploadTask = storageRef.putFile(imageFile);

      final snapshot = await uploadTask.whenComplete(() {});
      final downloadUrl = await snapshot.ref.getDownloadURL();



      return downloadUrl;
    } catch (e) {
      print('Failed to upload image: $e');
      return null;
    }
    }


    //to creat new collection
  Future<void> createCollection(CollectionReference collection) async {
    try {
      await collection.doc().set({});
      print('Collection created successfully.');
    } catch (e) {
      print('Error creating collection: $e');
    }
  }

    //event adding
  Future<String?> updateEventData( Map<String, dynamic> eventData , String title) async {
    try
    {
      CollectionReference collection = eventDataCollection;

      final collectionExists = await collection.doc().get();
      if(!collectionExists.exists)
      {
        await createCollection(collection);
      }

      await collection.doc(title).set(eventData);
      print('Event data updated successfully.');
      return 'it is done.';
    }
    catch(e)
    {
      print('Event data cannot be added.');
      print(e);
      return null;
    }

  }


  }







