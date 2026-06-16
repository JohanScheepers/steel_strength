// lib/theme/app_theme.dart
import 'package:flutter/material.dart';
import 'color_palette.dart';

class AppTheme {
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: AppColors.primaryStart,
    scaffoldBackgroundColor: AppColors.darkSurface,
    fontFamily: 'Inter',
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: AppColors.onBackground),
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
  );
}
