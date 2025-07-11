import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// The [applicationTheme] is the main theme for the application.
/// It is used to define the overall look and feel of the app.
/// You can customize it by modifying the properties of [ThemeData].
ThemeData applicationTheme = ThemeData(
  brightness: Brightness.dark,
  fontFamily: GoogleFonts.poppins().fontFamily,
  useMaterial3: true,
  colorScheme: ColorScheme.dark(
    surface: const Color(0xFF0D0D0D),
    primary: const Color(0xFFF9A825),
    tertiary: Colors.white10,
  ),
);
