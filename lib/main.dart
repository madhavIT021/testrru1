import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:testrru1/faculty_profile_page.dart';
import 'package:testrru1/register.dart';

void main() async{
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyABmLpgxS_t3qr4WZLqBiVqNKAgxI_pun0",
        appId: "1:154033199482:android:993035257e013e22a49ec3",
        messagingSenderId: "154033199482",
        projectId: "testrru2-fd458",
        storageBucket: "testrru2-fd458.appspot.com",

      )
  );
  // debugStorageBucket();
  runApp(const MyApp());
}
// void debugStorageBucket() {
//   final storageBucket = FirebaseStorage.instance.bucket;
//   print('Firebase Storage Bucket: $storageBucket');
// }

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  Widget build(BuildContext context) {
    return MaterialApp(
      home: FacultyRegistration(),
      debugShowCheckedModeBanner: false,
    );


  }
}

