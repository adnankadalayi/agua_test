import 'package:flutter/material.dart';

class AppTheme {
  static final light = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xff6101EE),
      foregroundColor: Colors.white,
    ),
    cardTheme: CardTheme(
      color: Colors.grey.shade200,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.black),
      bodyMedium: TextStyle(color: Colors.black),
      bodySmall: TextStyle(color: Colors.black),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      fillColor: Colors.white,
      filled: true,
      hintStyle: const TextStyle(color: Colors.grey),
    ),
  );

  static final dark = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xff2B333E),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xff6101EE),
      foregroundColor: Colors.white,
    ),
    cardTheme: CardTheme(
      color: Colors.grey.shade900,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white),
      bodySmall: TextStyle(color: Colors.white),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      fillColor: const Color(0xff2B333E),
      filled: true,
      hintStyle: const TextStyle(color: Colors.grey),
    ),
  );
}
