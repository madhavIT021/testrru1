import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseServices {
  final String uid;

  DatabaseServices({required this.uid});

  // Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Collections for students and faculty
  final CollectionReference studentCollection = FirebaseFirestore.instance.collection("students");
  final CollectionReference facultyCollection = FirebaseFirestore.instance.collection("faculty");

  Future<void> updateUserData(String role, Map<String, dynamic> userData) async {
    try {

      CollectionReference collection;
      if (role == 'student') {
        collection = studentCollection;
      } else if (role == 'faculty') {
        collection = facultyCollection;
      } else {
        throw Exception("Invalid role");
      }

      // Check if the collection exists
      final collectionExists = await collection.doc().get();
      if (!collectionExists.exists) {
        // Collection does not exist, create it
        await createCollection(collection);
      }

      // Add a new document with the user's UID
      await collection.doc(uid).set(userData);

      print('User data updated successfully.');
    } catch (e) {
      print('Error updating user data: $e');
    }
  }

  Future<void> createCollection(CollectionReference collection) async {
    try {
      await collection.doc().set({});
      print('Collection created successfully.');
    } catch (e) {
      print('Error creating collection: $e');
    }
  }


// Future<DocumentSnapshot> getUserData(String role) async {
  //   if (role == 'student') {
  //     return await studentCollection.doc(uid).get();
  //   } else if (role == 'faculty') {
  //     return await facultyCollection.doc(uid).get();
  //   } else {
  //     throw Exception("Invalid role");
  //   }
  // }
}