import 'package:flutter/material.dart';

/// Centralized color constants for the NutriLens app.
/// Use these instead of hardcoded hex values.
class AppColors {
  AppColors._(); // Prevent instantiation

  // Brand
  static const Color primary = Color(0xFF8B9D42); // Olive green
  static const Color primaryLight = Color(0xFFA5B950); // Light olive
  static const Color primaryDark = Color(0xFF5D6B2C); // Dark olive
  static const Color secondary = Color(0xFF4A1817); // Dark reddish brown

  // Backgrounds
  static const Color background = Color(0xFFF5F5F5); // Light grey
  static const Color surface = Colors.white;
  static const Color surfaceTinted = Color(0xFFF5F5F0); // Warm light grey

  // Text
  static const Color textPrimary = Color(0xFF1E1E1E);
  static const Color textSecondary = Colors.grey;

  // Health Ratings
  static const Color healthy = Color(0xFF2E7D32);
  static const Color healthyBg = Color(0xFFE8F5E9);
  static const Color balanced = Color(0xFFF57C00);
  static const Color balancedBg = Color(0xFFFFF3E0);
  static const Color unhealthy = Color(0xFFC62828);
  static const Color unhealthyBg = Color(0xFFFFEBEE);

  // Sheet / Card
  static const Color sheetBackground = Color(0xFFFAFAFA);
  static const Color pinkTint = Color(0xFFFCE4E4);
}
