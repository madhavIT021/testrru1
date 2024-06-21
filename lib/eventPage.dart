import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:testrru1/auth.dart';
import 'package:testrru1/shared/constants.dart';

class AddEvent extends StatefulWidget {
  const AddEvent({Key? key}) : super(key: key);

  @override
  State<AddEvent> createState() => _AddEventState();
}

class _AddEventState extends State<AddEvent> {

  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  TextEditingController _tagLineController = TextEditingController();


  final ImagePicker _picker = ImagePicker();
  List<File> _images = [];
  List<String>? _imageUrls = []; // Initialize as an empty list
  late int i;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Authservice _auth = Authservice();


  Future<void> _pickImage() async {
    final List<XFile>? pickedFiles = await _picker.pickMultiImage();
    final List<String> uploadimageUrls = [];

    if (pickedFiles != null) {
      setState(() {
        _images = pickedFiles.map((pickedFile) => File(pickedFile.path)).toList();
      });

      for (File image in _images) {
        String? imageUrl = await _auth.uploadImage(image,_titleController.text);
        if (imageUrl != null) {

            uploadimageUrls.add(imageUrl);
        }
      }

      setState(() {
        _imageUrls = uploadimageUrls;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    i = 0;
  }

  Future<void> _addEventToDatabase() async {
    if (_formKey.currentState!.validate()) {
      // Get form values
      Map<String, dynamic> eventData = {
        'title' : _titleController.text,
        'description' : _descriptionController.text,
        'date' : _dateController.text,
        'location' : _tagLineController.text,
        'imageurl' : _imageUrls,
      };

      // print("User Data: $eventData");

      final result = await _auth.updateEventData(eventData, _titleController.text);

      if(result!=null){
        _showMessage('Event added successfully!');

        // Clear text field controllers after successful registration
        _titleController.clear();
        _descriptionController.clear();
        _tagLineController.clear();
        _dateController.clear();
        setState(() {
          _images = [];
          _imageUrls = [];
        });
      }
    } else {
      _showMessage('Cannot add the event!');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Event"),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: textDecoretion.copyWith(hintText: "Title"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _descriptionController,
                decoration: textDecoretion.copyWith(hintText: "Description"),
                maxLines: null, // Allow multi-line input
                keyboardType: TextInputType.multiline,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _dateController,
                readOnly: true,
                decoration: textDecoretion.copyWith(hintText: "Date",suffixIcon: Icon(Icons.calendar_month)),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime(2101),
                  );

                  if (pickedDate != null) {
                    setState(() {
                      _dateController.text = DateFormat('dd/MM/yyyy').format(pickedDate);
                    });
                  }
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select the date';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _tagLineController,
                decoration: textDecoretion.copyWith(hintText: "Tagline"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a location';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Images',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                  ),
                  SizedBox(height: 8.0),
                  ElevatedButton(
                    onPressed: _pickImage,
                    child: Text('Select Images'),
                  ),
                  SizedBox(height: 16.0),
                  _images.isNotEmpty
                      ? Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: _images.map((image) {
                      return Image.file(
                        image,
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      );
                    }).toList(),
                  )
                      : Text('No images selected'),
                ],
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _addEventToDatabase,
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
