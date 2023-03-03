import 'package:flutter/material.dart';

ThemeData gameTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: Colors.lightBlue[800],
  fontFamily: 'Segoe UI',
  textTheme: const TextTheme(
    displayLarge: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
    titleLarge: TextStyle(fontSize: 30.0, fontStyle: FontStyle.normal),
    bodyMedium: TextStyle(fontSize: 14.0),
  ),
);
