import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BakasaColors {
  BakasaColors._();

  static const Color bgDeep = Color(0xFF070A12);
  static const Color bgPanel = Color(0xFF0F1526);
  static const Color borderGlow = Color(0x3322D3EE);
  static const Color neonCyan = Color(0xFF22D3EE);
  static const Color neonMagenta = Color(0xFFE879F9);
  static const Color gold = Color(0xFFFBBF24);
  static const Color textMuted = Color(0xFF94A3B8);
}

ThemeData buildBakasaTheme() {
  final base = ThemeData(
    brightness: Brightness.dark,
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: BakasaColors.neonCyan,
      brightness: Brightness.dark,
      primary: BakasaColors.neonCyan,
      secondary: BakasaColors.neonMagenta,
      surface: BakasaColors.bgPanel,
    ),
  );

  return base.copyWith(
    scaffoldBackgroundColor: BakasaColors.bgDeep,
    textTheme: GoogleFonts.exo2TextTheme(
      base.textTheme,
    ).apply(bodyColor: Colors.white, displayColor: Colors.white),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: BakasaColors.bgPanel,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFF1E293B)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFF1E293B)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: BakasaColors.neonCyan, width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 18),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: BakasaColors.neonCyan,
        foregroundColor: BakasaColors.bgDeep,
        textStyle: GoogleFonts.orbitron(fontWeight: FontWeight.w700),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: BakasaColors.neonCyan,
        side: const BorderSide(color: BakasaColors.neonCyan),
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    ),
  );
}
