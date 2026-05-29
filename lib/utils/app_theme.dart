import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primary = Color(0xFF1a6b3c);
  static const Color primaryLight = Color(0xFF2d9e5a);
  static const Color primaryDark = Color(0xFF0f4726);
  static const Color gold = Color(0xFFc9a84c);
  static const Color goldLight = Color(0xFFe8c96a);

  static const List<String> supportedFonts = [
    'Amiri',
    'Cairo',
    'Tajawal',
    'Noto Naskh Arabic',
    'Scheherazade New',
  ];

  static ThemeData lightTheme({String fontFamily = 'Amiri'}) {
    final base = ThemeData(
      brightness: Brightness.light,
      primaryColor: primary,
      scaffoldBackgroundColor: const Color(0xFFF7F9F5),
      cardColor: Colors.white,
      dividerColor: const Color(0xFFD4E4D0),
      colorScheme: const ColorScheme.light(
        primary: primary,
        secondary: gold,
        surface: Colors.white,
        onPrimary: Colors.white,
        onSurface: Color(0xFF1a2e1e),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryDark,
        foregroundColor: Colors.white,
        elevation: 4,
        centerTitle: true,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          minimumSize: const Size(44, 44),
          tapTargetSize: MaterialTapTargetSize.padded,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      iconButtonTheme: const IconButtonThemeData(
        style: ButtonStyle(
          tapTargetSize: MaterialTapTargetSize.padded,
        ),
      ),
      useMaterial3: false,
    );
    return _withFont(base, fontFamily);
  }

  static ThemeData darkTheme({String fontFamily = 'Amiri'}) {
    final base = ThemeData(
      brightness: Brightness.dark,
      primaryColor: primary,
      scaffoldBackgroundColor: const Color(0xFF0d1f12),
      cardColor: const Color(0xFF1a3323),
      dividerColor: const Color(0xFF2a4d35),
      colorScheme: const ColorScheme.dark(
        primary: primary,
        secondary: gold,
        surface: Color(0xFF1a3323),
        onPrimary: Colors.white,
        onSurface: Color(0xFFe8f5eb),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryDark,
        foregroundColor: Colors.white,
        elevation: 4,
        centerTitle: true,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          minimumSize: const Size(44, 44),
          tapTargetSize: MaterialTapTargetSize.padded,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      iconButtonTheme: const IconButtonThemeData(
        style: ButtonStyle(
          tapTargetSize: MaterialTapTargetSize.padded,
        ),
      ),
      useMaterial3: false,
    );
    return _withFont(base, fontFamily);
  }

  static ThemeData _withFont(ThemeData base, String fontFamily) {
    final safeFont = supportedFonts.contains(fontFamily) ? fontFamily : 'Amiri';
    return base.copyWith(
      textTheme: GoogleFonts.getTextTheme(safeFont, base.textTheme),
      primaryTextTheme: GoogleFonts.getTextTheme(safeFont, base.primaryTextTheme),
    );
  }
}