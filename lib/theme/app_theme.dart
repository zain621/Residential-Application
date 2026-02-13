import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  // Color definitions
  static const Color primaryGold = Color(0xFFB99146);
  static const Color black = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);
  static const Color beige = Color(0xFFE3D3B5);

  // Dashboard backgrounds
  static const Color topBackground = Color(0xFF050B18);
  static const Color pageBackground = Color(0xFFF4F5F7);
  static const Color cardBackground = Colors.white;

  // Dashboard text
  static const Color textPrimary = Color(0xFF111827);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textMuted = Color(0xFF9CA3AF);

  // Dashboard accents
  static const Color quickOptionCircle = Color(0xFFF5E7CF);
  static const Color accentYellow = Color(0xFFFBBF24);
  static const Color tagRed = Color(0xFFEF4444);
  static const Color tagGrey = Color(0xFF9CA3AF);

  // Dashboard layout
  static const double horizontalPadding = 20;
  static const double sectionSpacing = 24;
  static const double cardBorderRadius = 16;

  // Theme Data
  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme(
        brightness: Brightness.light,
        primary: primaryGold,
        onPrimary: white,
        secondary: beige,
        onSecondary: black,
        error: Colors.red,
        onError: white,
        surface: white,
        onSurface: black,
        background: white,
        onBackground: black,
      ),
      scaffoldBackgroundColor: white,
      appBarTheme: const AppBarTheme(
        backgroundColor: white,
        foregroundColor: black,
        elevation: 0,
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          color: black,
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
        displayMedium: TextStyle(
          color: black,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        bodyLarge: TextStyle(
          color: black,
          fontSize: 16,
        ),
        bodyMedium: TextStyle(
          color: black,
          fontSize: 14,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryGold,
          foregroundColor: white,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: black,
          side: const BorderSide(color: black, width: 1),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: primaryGold, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }
}

