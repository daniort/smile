import 'package:flutter/material.dart';

InputDecoration myInputDecoration(String label, Color col) {
  return InputDecoration(
    errorStyle: TextStyle(color: Colors.white),
    contentPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 10),
    labelStyle: TextStyle(color: Colors.grey),
    // labelText: label,
    hintText: label,
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(width: 0, color: Colors.white),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(width: 0, color: Colors.white),
    ),
    fillColor: col,
    filled: true,
  );
}
