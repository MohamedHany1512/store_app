import 'package:flutter/material.dart';

 
abstract final class AppDurations {
  const AppDurations._();

  /// Ripple / hover feedback.
  static const Duration instant = Duration(milliseconds: 120);

  /// Small state changes (icon swaps, chip selection).
  static const Duration fast = Duration(milliseconds: 180);

  /// Default transition (page transitions, card press).
  static const Duration normal = Duration(milliseconds: 280);

  /// Entrances / expansions.
  static const Duration slow = Duration(milliseconds: 420);

  /// Full shimmer sweep of a skeleton placeholder.
  static const Duration shimmer = Duration(milliseconds: 1500);

  /// How long a toast stays on screen.
  static const Duration toast = Duration(milliseconds: 3000);

  /// Ambient background/logo breathing animation.
  static const Duration ambient = Duration(seconds: 6);

  static const Curve standard = Curves.easeOutCubic;
  static const Curve emphasized = Cubic(0.2, 0.0, 0.0, 1.0);
  static const Curve spring = Curves.easeOutBack;
}
