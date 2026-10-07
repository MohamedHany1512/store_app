import 'package:flutter/material.dart';

import '../constants/app_spacing.dart';

/// Layout breakpoints following the Material 3 window size classes.
abstract final class Breakpoints {
  static const double compact = 600; // phones
  static const double medium = 900; // tablets / small laptops
  static const double expanded = 1400; // desktop
}

/// Responsive helpers available on any [BuildContext].
extension ResponsiveContext on BuildContext {
  Size get screenSize => MediaQuery.sizeOf(this);

  double get screenWidth => screenSize.width;

  double get screenHeight => screenSize.height;

  bool get isCompact => screenWidth < Breakpoints.compact;

  bool get isMedium =>
      screenWidth >= Breakpoints.compact && screenWidth < Breakpoints.medium;

  bool get isExpanded => screenWidth >= Breakpoints.medium;

  bool get isLargeDesktop => screenWidth >= Breakpoints.expanded;

  /// Caps the content width on big screens so lines never stretch too far.
  double get maxContentWidth {
    if (isLargeDesktop) {
      return 1200;
    }
    if (isExpanded) {
      return 900;
    }
    return double.infinity;
  }

  /// Horizontal page gutter, adapted to the screen size.
  double get gutter => isExpanded ? AppSpacing.xl : AppSpacing.md;

  /// Grid columns for the product list (responsive instead of a fixed extent).
  int get productColumns {
    if (isLargeDesktop) {
      return 4;
    }
    if (isExpanded || isMedium) {
      return 3;
    }
    return 2;
  }

  /// Product card aspect ratio - taller cards on mobile, wider on desktop.
  double get productAspectRatio => isExpanded ? 0.78 : 0.62;

  /// EdgeInsets matching the current gutter.
  EdgeInsets get pagePadding => EdgeInsets.symmetric(horizontal: gutter);
}
