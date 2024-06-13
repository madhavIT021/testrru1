import 'package:flutter/material.dart';
import 'package:testrru1/auth.dart';
import 'package:intl/intl.dart';

class AdminRegistrationPage extends StatefulWidget {
  @override
  _AdminRegistrationPageState createState() => _AdminRegistrationPageState();
}

class _AdminRegistrationPageState extends State<AdminRegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final Authservice _auth = Authservice();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _birthdateController = TextEditingController();
  final TextEditingController _yearController = TextEditingController(text: (DateTime.now().year.toInt()).toString());
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _schoolController = TextEditingController();
  final TextEditingController _degreeController = TextEditingController();
  final TextEditingController _fieldOfStudyController = TextEditingController();
  final TextEditingController _graduationYearController = TextEditingController();
  String _role = 'student';

  Future<void> _registerUserAndAddToDatabase() async {
    if (_formKey.currentState!.validate()) {

      // Creates a map with user data
      Map<String, dynamic> userData = {
        'name': _nameController.text,
        'email': _emailController.text,
        'phone': _phoneController.text,
        'address': _addressController.text,
        'yearOfAdmission': _yearController.text,
        'school': _schoolController.text,
        'degree': _degreeController.text,
        'fieldOfStudy': _fieldOfStudyController.text,
        'graduationYear': _graduationYearController.text,

      };
      print("User Data: $userData");

      // Generate email
      int sequenceNumber = await _getNextSequenceNumber(_fieldOfStudyController.text);
      String year = _yearController.text.substring(2); // Get last two digits of the year
      String fieldOfStudy = _fieldOfStudyController.text;
      String formattedSequence = sequenceNumber.toString().padLeft(3, '0');
      String generatedEmail = '$year$fieldOfStudy$formattedSequence@rru.ac.in';


      // Generate password from birthdate
      DateTime birthdate = DateFormat('yyyy-MM-dd').parse(_birthdateController.text);
      String generatedPassword = DateFormat('ddMMyy').format(birthdate);


      // Register the user with email and password
      dynamic result = await _auth.registerWithEmailandPassword(
        _role,
        generatedEmail,
        generatedPassword,
        userData,
      );

      if (result != null) {
        _showMessage('User registered successfully!');
        // Clear text field controllers after successful registration
        _nameController.clear();
        _emailController.clear();
        _passwordController.clear();
        _phoneController.clear();
        _addressController.clear();
        _schoolController.clear();
        _degreeController.clear();
        _fieldOfStudyController.clear();
        _graduationYearController.clear();
        _birthdateController.clear();
      } else {
        _showMessage('User registration failed!');
      }
    }
  }


  Future<int> _getNextSequenceNumber(String fieldOfStudy) async {
    // Replace this with your logic to get the next sequence number from your database
    // For now, we'll just return a dummy value for demonstration
    return 2; // This should be replaced with actual logic
  }

  ///show message when user try to register
  void _showMessage(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Message"),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              SafeArea(
                child: Center(
                  child: Image.asset('assets/Logo copy.png',
                    width: 100,
                    height: 100,
                  ),
                ),
              ),

              DropdownButtonFormField(
                value: _role,
                decoration: InputDecoration(labelText: 'Role'),
                items: ['student', 'faculty'].map((role) {
                  return DropdownMenuItem(
                    value: role,
                    child: Text(role),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _role = newValue!;
                  });
                },
              ),
              SizedBox(height: 16,),
              Text(
                'Personal Information',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(labelText: 'Phone Number'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(labelText: 'Address'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your address';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16,),
              TextFormField(
                controller: _birthdateController,
                decoration: InputDecoration(
                  labelText: 'Birthdate',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                      );

                      if (pickedDate != null) {
                        setState(() {
                          _birthdateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
                        });
                      }
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your birthdate';
                  }
                  return null;
                },
              ),
              SizedBox(height: 32),
              // Academic Information
              Text(
                'Academic Information',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _yearController,
                decoration: InputDecoration(labelText: 'Admission Year'),
                enabled: false,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  // Regular expression to validate YYYY format
                  RegExp yearExp = RegExp(r'^\d{4}$');
                  if (!yearExp.hasMatch(value)) {
                    return 'Please enter a valid year in YYYY format';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _schoolController,
                decoration: InputDecoration(labelText: 'School/University'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your school or university';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _degreeController,
                decoration: InputDecoration(labelText: 'Degree'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your degree';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _fieldOfStudyController,
                decoration: InputDecoration(labelText: 'Field of Study'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your field of study';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _graduationYearController,
                decoration: InputDecoration(labelText: 'Graduation Year'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your graduation year';
                  }
                  return null;
                },
              ),

              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _registerUserAndAddToDatabase,
                child: Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
