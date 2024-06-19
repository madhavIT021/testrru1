import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:testrru1/auth.dart';
import 'package:testrru1/exp_facultydata.dart';
import 'package:intl/intl.dart';

class FacultyRegistration extends StatefulWidget {
  @override
  _FacultyRegistrationState createState() => _FacultyRegistrationState();
}

class _FacultyRegistrationState extends State<FacultyRegistration> {
  final _formKey = GlobalKey<FormState>();
  final Authservice _auth = Authservice();
  List<EmploymentInfo> _employmentList = [
    EmploymentInfo(
        company: '', position: '', startMonthYear: '', endMonthYear: '')
  ];

  // Text editing controllers for form fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _birthdateController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _departmentController = TextEditingController();

  // Radio button values
  String? _gender;
  String? _maritalStatus;


  String _role = 'faculty';

  //add row
  void addRow() {
    setState(() {
      _employmentList.add(EmploymentInfo(
          company: '', position: '', startMonthYear: '', endMonthYear: ''));
    });
  }

  void removeRow(int index) {
    setState(() {
      if (_employmentList.length > 1) {
        _employmentList.removeAt(index);
      }
    });
  }

  // Handle form submission
  Future<void> _registerUserAndAddToDatabase() async {
    if (_formKey.currentState!.validate()) {
      // Get form values
      Map<String, dynamic> userData = {
        'role' : _role,
        'name': _nameController.text,
        'email': _emailController.text,
        'phone': _phoneController.text,
        'birthdate': _birthdateController.text,
        'address': _addressController.text,
        'gender': _gender,
        'maritalStatus': _maritalStatus,
        'department': _departmentController.text,
        'employmentInfo': _employmentList.map((info) => info.toJson()).toList(),
      };

      print("User Data: $userData");

      // Generate email
      String name = _nameController.text.trim().toLowerCase();
      String department = _departmentController.text.trim().toLowerCase();
      name = name.replaceAll(' ', '');
      department = department.replaceAll(' ', '');
      print(name);
      String generatedEmail = '${name}.${department}@rru.ac.in';


      // Generate password from birthdate
      DateTime birthdate = DateFormat('dd/MM/yyyy').parse(_birthdateController.text);
      String generatedPassword = DateFormat('ddMMyy').format(birthdate);


      // Register faculty member
      dynamic result = await _auth.registerWithEmailandPassword(
        _role,
        // _emailController.text,
        generatedEmail,
        generatedPassword,
        userData,
      );



      if (result != null) {
        await  FirebaseFirestore.instance.collection('facultyCredentials').doc(result.uid).set({
          'user-email': generatedEmail,
          'user-password': generatedPassword,
        });
        _showMessage('User registered successfully!');
        // Clear text field controllers after successful registration
        _nameController.clear();
        _emailController.clear();
        _phoneController.clear();
        _birthdateController.clear();
        _addressController.clear();
        _departmentController.clear();
        setState(() {
          _gender = null;
          _maritalStatus = null;
          _employmentList.clear(); // Clear employment list after successful registration
          _employmentList.add(EmploymentInfo(
              company: '', position: '', startMonthYear: '', endMonthYear: ''));
        });
      } else {
        _showMessage('User registration failed!');
      }
    }
  }

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

  Future<void> _selectDate(int index, bool isStartDate) async {
    DateTime now = DateTime.now();
    DateTime initialDate = DateTime(now.year, now.month - 1);

    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: initialDate,
    );
    if (picked != null && picked.isBefore(DateTime(now.year, now.month))) {
      setState(() {
        if (isStartDate) {
          _employmentList[index].startMonthYear = DateFormat('MM/yyyy').format(picked);
          _employmentList[index].endMonthYear = '';
        } else {
          DateTime startDate = DateFormat('MM/yyyy').parse(_employmentList[index].startMonthYear);
          if (picked.isAfter(startDate)) {
            _employmentList[index].endMonthYear = DateFormat('MM/yyyy').format(picked);
          } else {
            _showMessage('End month must be after start month');
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Faculty Registration'),
        centerTitle:true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                'Personal Information',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),

              // Name
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
              SizedBox(height: 16.0),
              // Email
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  // Add email validation logic here if needed
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              // Phone
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(labelText: 'Phone Number'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  // Add phone number validation logic here if needed
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              // Date of Birth
              TextFormField(
                controller: _birthdateController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Date of Birth',
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime(2101),
                  );

                  if (pickedDate != null) {
                    setState(() {
                      _birthdateController.text = DateFormat('dd/MM/yyyy').format(pickedDate);
                    });
                  }
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your date of birth';
                  }
                  return null;
                },
              ),

              SizedBox(height: 16.0),
              // Address
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
              SizedBox(height: 16.0),

              //department
              TextFormField(
                controller: _departmentController,
                decoration: InputDecoration(labelText: 'Department'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),

              // Gender
              Row(
                children: <Widget>[
                  Text('Gender: '),
                  Radio<String>(
                    value: 'Male',
                    groupValue: _gender,
                    onChanged: (value) {
                      setState(() {
                        _gender = value;
                      });
                    },
                  ),
                  Text('Male'),
                  Radio<String>(
                    value: 'Female',
                    groupValue: _gender,
                    onChanged: (value) {
                      setState(() {
                        _gender = value;
                      });
                    },
                  ),
                  Text('Female'),
                  Radio<String>(
                    value: 'Other',
                    groupValue: _gender,
                    onChanged: (value) {
                      setState(() {
                        _gender = value;
                      });
                    },
                  ),
                  Text('Other'),
                ],
              ),
              // SizedBox(height: 2.0),
              // Marital Status
              Row(
                children: <Widget>[
                  Text('Marital Status: '),
                  Radio<String>(
                    value: 'Married',
                    groupValue: _maritalStatus,
                    onChanged: (value) {
                      setState(() {
                        _maritalStatus = value;
                      });
                    },
                  ),
                  Text('Married'),
                  Radio<String>(
                    value: 'Unmarried',
                    groupValue: _maritalStatus,
                    onChanged: (value) {
                      setState(() {
                        _maritalStatus = value;
                      });
                    },
                  ),
                  Text('Unmarried'),
                ],
              ),
              // SizedBox(height: 16.0),
              // Husband/Father Name (Conditional)
              // if (_gender == 'Female')
              //   TextFormField(
              //     controller: _husbandFatherController,
              //     decoration: InputDecoration(labelText: 'Husband/Father Name'),
              //     validator: (value) {
              //       if (value == null || value.isEmpty) {
              //         return 'Please enter Husband/Father Name';
              //       }
              //       return null;
              //     },
              //   ),
              SizedBox(height: 16.0),
              // Table for Experience/Previous Employment Info
              // Table Header
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Text(
                  'Previous Employment Information',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),

              // Table Rows
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                    width: 2.0,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: EdgeInsets.all(5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Add Row Button
                    TextButton.icon(
                      onPressed: addRow,
                      icon: Icon(Icons.add),
                      label: Text('Add Row'),
                    ),
                    for (int i = 0; i < _employmentList.length; i++)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          padding: EdgeInsets.all(5),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      initialValue: _employmentList[i].company,
                                      onChanged: (value) {
                                        setState(() {
                                          _employmentList[i].company = value;
                                        });
                                      },
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter Company Name';
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(labelText: 'Company'),
                                    ),
                                  ),
                                  SizedBox(width: 8.0),
                                  Expanded(
                                    child: TextFormField(
                                      initialValue: _employmentList[i].position,
                                      onChanged: (value) {
                                        setState(() {
                                          _employmentList[i].position = value;
                                        });
                                      },
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter position';
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(labelText: 'Position'),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8.0),
                              Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      controller: TextEditingController(
                                          text: _employmentList[i].startMonthYear),
                                      readOnly: true,
                                      onTap: () => _selectDate(i, true),
                                      decoration: InputDecoration(
                                        labelText: 'Start Month-Year',
                                        suffixIcon: Icon(Icons.calendar_today),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Select Satart Month-Year';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                  SizedBox(width: 16.0),
                                  Expanded(
                                    child: TextFormField(
                                      controller: TextEditingController(
                                          text: _employmentList[i].endMonthYear),
                                      readOnly: true,
                                      onTap: () => _selectDate(i, false),
                                      decoration: InputDecoration(
                                        labelText: 'End Month-Year',
                                        suffixIcon: Icon(Icons.calendar_today),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Select End Month-Year';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                  if (i > 0)
                                    IconButton(
                                      icon: Icon(Icons.delete, color: Colors.red),
                                      onPressed: () => removeRow(i),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              SizedBox(height: 24,),
              // Register Button
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
