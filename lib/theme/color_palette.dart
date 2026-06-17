// lib/theme/color_palette.dart
import 'package:flutter/material.dart';

class AppColors {
  // Primary gradient colors (vibrant teal to deep indigo)
  static const Color primaryStart = Color(0xFF00BFA6); // teal
  static const Color primaryEnd = Color(0xFF6200EE); // indigo

  // Background glassmorphism layers
  static const Color glassBackground = Color.fromRGBO(255, 255, 255, 0.12);
  static const Color glassBorder = Color.fromRGBO(255, 255, 255, 0.18);

  // Dark mode surface colors
  static const Color darkSurface = Color(0xFF121212);
  static const Color darkSurfaceVariant = Color(0xFF1E1E1E);

  // Text colors
  static const Color onPrimary = Colors.white;
  static const Color onBackground = Colors.white70;
  static const Color onSurface = Colors.white54;

  // Accent colors for charts and highlights
  static const Color accentPositive = Color(0xFF4CAF50);
  static const Color accentWarning = Color(0xFFFFC107);
  static const Color accentError = Color(0xFFF44336);

  // Utilization gauge colors
  static const Color gaugeSafe = Color(0xFF00E676);
  static const Color gaugeWarning = Color(0xFFFFEA00);
  static const Color gaugeCritical = Color(0xFFFF1744);
  static const Color gaugeBackground = Color.fromRGBO(255, 255, 255, 0.05);
}
