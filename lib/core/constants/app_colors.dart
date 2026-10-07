import 'package:flutter/material.dart';
 
abstract final class AppColors {
  const AppColors._();

  // ---------------------------------------------------------------------------
  // Brand palette
  // ---------------------------------------------------------------------------
  static const Color violet = Color(0xFF7C5CFF);
  static const Color violetDeep = Color(0xFF4B31C9);
  static const Color teal = Color(0xFF00C2A8);
  static const Color coral = Color(0xFFFF6B6B);
  static const Color amber = Color(0xFFFFB020);

  // ---------------------------------------------------------------------------
  // Light surfaces & text
  // ---------------------------------------------------------------------------
  static const Color lightBackground = Color(0xFFF5F6FB);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceMuted = Color(0xFFEDEFF7);
  static const Color lightTextPrimary = Color(0xFF15162E);
  static const Color lightTextSecondary = Color(0xFF6C7189);

  // ---------------------------------------------------------------------------
  // Dark surfaces & text
  // ---------------------------------------------------------------------------
  static const Color darkBackground = Color(0xFF0E1020);
  static const Color darkSurface = Color(0xFF181B30);
  static const Color darkSurfaceMuted = Color(0xFF222644);
  static const Color darkTextPrimary = Color(0xFFF4F5FF);
  static const Color darkTextSecondary = Color(0xFFA3A8C7);

  // ---------------------------------------------------------------------------
  // Semantic status colors
  // ---------------------------------------------------------------------------
  static const Color success = Color(0xFF15B46A);
  static const Color danger = Color(0xFFE53950);
  static const Color warning = Color(0xFFF5A524);

  // ---------------------------------------------------------------------------
  // Signature gradients
  // ---------------------------------------------------------------------------
  static const LinearGradient brandGradient = LinearGradient(
    colors: <Color>[violet, violetDeep],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient brandGradientHorizontal = LinearGradient(
    colors: <Color>[violet, violetDeep],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient freshGradient = LinearGradient(
    colors: <Color>[teal, Color(0xFF0091D5)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Decorative "aurora" blobs painted by `AppBackground`.
  static const List<Color> auroraColors = <Color>[
    Color(0x667C5CFF),
    Color(0x4D00C2A8),
    Color(0x3DFF6B6B),
  ];
}
