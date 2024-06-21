import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:testrru1/eventPage.dart';
import 'package:testrru1/faculty_profile_page.dart';
import 'package:testrru1/register.dart';
import 'package:flutter_svg/svg.dart';

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
      home: AdminDashboard(),
      debugShowCheckedModeBanner: false,
    );


  }
}


class AdminDashboard extends StatefulWidget {

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Admin Dashboard',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Center(
            child: Opacity(
              opacity: 0.3,
              child: Image.asset(
                'assets/Logo copy.png',
                width: 200,  // Adjust the width as needed
                height: 200, // Adjust the height as needed
              ),
            ),
          ),
          ListView(
          children: [
            ListTile(
              leading: SvgPicture.asset(
                'assets/add-profile.svg',
                semanticsLabel: 'My SVG Image',
                width: 24,
              ),
              title: Text('Faculty Registration', style: TextStyle(fontSize: 20),),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FacultyRegistration()),
                );
              },
            ),
            ListTile(
              leading: SvgPicture.asset(
                'assets/add-profile.svg',
                semanticsLabel: 'My SVG Image',
                width: 24,
              ),
              title: Text('Student Registration', style: TextStyle(fontSize: 20),),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => StudentRegistrationPage()),
                );
              },
            ),
            ListTile(
              leading: SvgPicture.asset(
                'assets/edit-profile.svg',
                semanticsLabel: 'My SVG Image',
                width: 24,
              ),
              title: Text('Edit Faculty Profile', style: TextStyle(fontSize: 20)),
              onTap: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => RegisterPage()),
                // );
              },
            ),
            ListTile(
              leading: SvgPicture.asset(
                'assets/edit-profile.svg',
                semanticsLabel: 'My SVG Image',
                width: 24,
              ),
              title: Text('Edit Student Profile', style: TextStyle(fontSize: 20)),
              onTap: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => SettingsPage()),
                // );
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings', style: TextStyle(fontSize: 20)),
              onTap: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => RegisterPage()),
                // );
              },
            ),
            ListTile(
              leading: Icon(Icons.event),
              title: Text(
                'Add events',
                style: TextStyle(fontSize: 20),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddEvent()),
                );
              },
            ),
          ],
        ),
    ],
      ),
    );
  }
}


