import 'package:flutter/material.dart';

class AppColors {
  // Primary
  static const Color primary      = Color(0xFF2D4A8A);
  static const Color primaryLight = Color(0xFF3D5FA0);
  static const Color accent       = Color(0xFFF5A623);

  // Backgrounds
  static const Color background   = Color(0xFFF0F4FF);
  static const Color surface      = Color(0xFFFFFFFF);

  // Text
  static const Color textDark     = Color(0xFF1A1A2E);
  static const Color textMedium   = Color(0xFF4A5568);
  static const Color textLight    = Color(0xFF9AA5B4);

  // Status
  static const Color success      = Color(0xFF38A169);
  static const Color error        = Color(0xFFE53E3E);
  static const Color warning      = Color(0xFFF5A623);

  // Subject colors
  static const Color mathColor    = Color(0xFF6C63FF);
  static const Color physicsColor = Color(0xFF3182CE);
  static const Color chemColor    = Color(0xFF38A169);
  static const Color bioColor     = Color(0xFFE53E3E);
}

class AppTheme {
  static ThemeData get theme => ThemeData(
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.background,
    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.accent,
      surface: AppColors.surface,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      elevation: 0,
      titleTextStyle: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
  );
}