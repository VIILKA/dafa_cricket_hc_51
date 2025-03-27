import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  /// ---------------------------
  /// Цветовая палитра
  /// ---------------------------
  static const Color primaryColor = Color(0xFF7C4DFF);
  static const Color secondaryColor = Color(0xFF00BCD4);
  static const Color accentColor = Color(0xFFFF4081);
  static const Color backgroundColor = Color(0xFFF5F5F5);
  static const Color surfaceColor = Colors.white;
  static const Color textColor = Color(0xFF212121);
  static const Color textSecondaryColor = Color(0xFF757575);
  static const Color dividerColor = Color(0xFFE0E0E0);

  /// ---------------------------
  /// Текстовые стили
  /// ---------------------------
  static final TextStyle displayLarge = GoogleFonts.montserrat(
    fontSize: 34,
    fontWeight: FontWeight.bold,
    color: textColor,
    letterSpacing: -0.5,
  );

  static final TextStyle displayMedium = GoogleFonts.montserrat(
    fontSize: 28,
    fontWeight: FontWeight.w600,
    color: textColor,
    letterSpacing: -0.25,
  );

  static final TextStyle displaySmall = GoogleFonts.montserrat(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: textColor,
  );

  static final TextStyle titleLarge = GoogleFonts.montserrat(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: textColor,
  );

  static final TextStyle titleMedium = GoogleFonts.montserrat(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: textColor,
  );

  static final TextStyle titleSmall = GoogleFonts.montserrat(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: textColor,
  );

  static final TextStyle bodyLarge = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: textColor,
  );

  static final TextStyle bodyMedium = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: textSecondaryColor,
  );

  static final TextStyle bodySmall = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: textSecondaryColor,
  );

  /// ---------------------------
  /// Тема приложения
  /// ---------------------------
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      textTheme: GoogleFonts.kanitTextTheme(),
      colorScheme: ColorScheme.light(
        primary: const Color(0xFF9A0104),
        secondary: const Color(0xFFFDF7E0),
        surface: const Color(0xFFFDF7E0),
        onPrimary: const Color(0xFFFDF7E0),
        onSecondary: const Color(0xFF16151A),
        onSurface: const Color(0xFF16151A),
      ),
      scaffoldBackgroundColor: const Color(0xFFFDF7E0),
    );
  }
}
