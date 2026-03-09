import 'package:flutter/material.dart';

/// Design tokens extracted from the Stitch reference designs.
/// Primary palette: soft mint/teal on light background.
class AppColors {
  AppColors._();

  // Brand Colors
  static const Color primary = Color(0xFFB3DFDC);
  static const Color primaryDark = Color(0xFF8BCBC6);

  // Backgrounds
  static const Color background = Colors.white; // Was #F6F7F7
  static const Color surface = Colors.white;
  static const Color cardBorder = Color(0x33B3DFDC); // primary/20

  // Input Fields
  static const Color inputBorder = Color(0x66B3DFDC); // primary/40
  static const Color inputBackground = Colors.white; // Was #F8FAFC

  // Text Colors
  static const Color textPrimary = Color(0xFF0F172A); // slate-900
  static const Color textSecondary = Color(0xFF475569); // slate-600
  static const Color textHint = Color(0xFF94A3B8); // slate-400
  static const Color textLabel = Color(0xFF334155); // slate-700 (for labels)

  // Functional
  static const Color error = Color(0xFFEF4444);
  static const Color divider = Color(0xFFE2E8F0); // slate-200

  // Social Buttons
  static const Color facebookBlue = Color(0xFF1877F2);
}
