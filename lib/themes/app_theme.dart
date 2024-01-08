import 'package:flutter/material.dart';

class AppTheme {
  static const primary = Colors.indigo;

  static final ThemeData lightTheme = ThemeData.light().copyWith(
    primaryColor: primary,
    appBarTheme: const AppBarTheme(
        centerTitle: true, color: Colors.indigo, elevation: 0),
  );
}
