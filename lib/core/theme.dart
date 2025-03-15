import 'package:flutter/material.dart';

class AppTheme {
  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.blueAccent,
    scaffoldBackgroundColor: Colors.white,
    textTheme: const TextTheme(
      bodyLarge: TextStyle(fontSize: 18, fontFamily: "Poppins"),
      bodyMedium: TextStyle(fontSize: 16, fontFamily: "Poppins"),
      bodySmall: TextStyle(fontSize: 14, fontFamily: "Poppins"),
    ),
  );
}
