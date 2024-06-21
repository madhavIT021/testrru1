import 'package:flutter/material.dart';

final textDecoretion =  InputDecoration(
  filled: true,
  fillColor: Colors.white,

  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.blue.shade100,width: 2.0),

  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.black,width: 2.0),

  ),


);