// lib/theme/app_theme.dart
import 'package:flutter/material.dart';
import 'color_palette.dart';

class AppTheme {
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: AppColors.primaryStart,
    scaffoldBackgroundColor: AppColors.darkSurface,
    fontFamily: 'Inter',
    textTheme: ThemeData.dark().textTheme.apply(
      fontFamily: 'Inter',
      bodyColor: AppColors.onBackground,
      displayColor: AppColors.onPrimary,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      foregroundColor: AppColors.onPrimary,
    ),
    cardTheme: CardThemeData(
      color: AppColors.darkSurfaceVariant,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color.fromRGBO(255, 255, 255, 0.05),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.transparent),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color.fromRGBO(255, 255, 255, 0.1)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primaryStart, width: 2),
      ),
      labelStyle: const TextStyle(color: AppColors.onSurface),
      floatingLabelStyle: const TextStyle(color: AppColors.primaryStart),
    ),
  );
}
