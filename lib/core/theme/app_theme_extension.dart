import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

/// Design tokens that do not fit in Material's [ColorScheme] (gradients,
/// glass surfaces, shadows, shimmer colors) are exposed as a [ThemeExtension].
///
/// This is the key to a consistent modern look:
/// * widgets never hardcode a color,
/// * light and dark themes stay in sync automatically,
/// * and `context.appColors` reads nicely inside `build` methods.
@immutable
class AppThemeExtension extends ThemeExtension<AppThemeExtension> {
  const AppThemeExtension({
    required this.brandGradient,
    required this.heroGradient,
    required this.freshGradient,
    required this.glassFill,
    required this.glassBorder,
    required this.softShadow,
    required this.elevatedShadow,
    required this.skeletonBase,
    required this.skeletonHighlight,
    required this.textSecondary,
    required this.divider,
    required this.success,
    required this.danger,
    required this.warning,
    required this.ripple,
  });

  /// Primary CTA gradient (violet -> deep violet).
  final LinearGradient brandGradient;

  /// Header / hero gradient.
  final LinearGradient heroGradient;

  /// Secondary accent gradient (teal -> sky).
  final LinearGradient freshGradient;

  /// Translucent fill used by glassmorphism surfaces.
  final Color glassFill;

  /// Hairline border for glass surfaces.
  final Color glassBorder;

  /// Ambient, low-spread shadow used by cards.
  final BoxShadow softShadow;

  /// Stronger shadow used by floating elements (buttons, dialogs).
  final BoxShadow elevatedShadow;

  final Color skeletonBase;
  final Color skeletonHighlight;
  final Color textSecondary;
  final Color divider;
  final Color success;
  final Color danger;
  final Color warning;

  /// Color used for press feedback on custom (gradient) surfaces.
  final Color ripple;

  static const AppThemeExtension light = AppThemeExtension(
    brandGradient: AppColors.brandGradient,
    heroGradient: LinearGradient(
      colors: <Color>[Color(0xFF7C5CFF), Color(0xFF4B31C9)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    freshGradient: AppColors.freshGradient,
    glassFill: Color(0xCCFFFFFF),
    glassBorder: Color(0x14FFFFFF),
    softShadow: BoxShadow(
      color: Color(0x14151A3C),
      blurRadius: 24,
      offset: Offset(0, 10),
      spreadRadius: -6,
    ),
    elevatedShadow: BoxShadow(
      color: Color(0x337C5CFF),
      blurRadius: 22,
      offset: Offset(0, 12),
      spreadRadius: -8,
    ),
    skeletonBase: Color(0xFFE7E9F2),
    skeletonHighlight: Color(0xFFF7F8FC),
    textSecondary: AppColors.lightTextSecondary,
    divider: Color(0x0F15162E),
    success: AppColors.success,
    danger: AppColors.danger,
    warning: AppColors.warning,
    ripple: Color(0x1A000000),
  );

  static const AppThemeExtension dark = AppThemeExtension(
    brandGradient: LinearGradient(
      colors: <Color>[Color(0xFF7C5CFF), Color(0xFF2C1F73)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    heroGradient: LinearGradient(
      colors: <Color>[Color(0xFF241C5C), Color(0xFF0E1020)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    freshGradient: AppColors.freshGradient,
    glassFill: Color(0x1FFFFFFF),
    glassBorder: Color(0x1FFFFFFF),
    softShadow: BoxShadow(
      color: Color(0x40000000),
      blurRadius: 26,
      offset: Offset(0, 12),
      spreadRadius: -8,
    ),
    elevatedShadow: BoxShadow(
      color: Color(0x557C5CFF),
      blurRadius: 24,
      offset: Offset(0, 12),
      spreadRadius: -8,
    ),
    skeletonBase: Color(0xFF222644),
    skeletonHighlight: Color(0xFF2C3157),
    textSecondary: AppColors.darkTextSecondary,
    divider: Color(0x14FFFFFF),
    success: AppColors.success,
    danger: Color(0xFFFF6178),
    warning: AppColors.warning,
    ripple: Color(0x33FFFFFF),
  );

  @override
  AppThemeExtension copyWith({
    LinearGradient? brandGradient,
    LinearGradient? heroGradient,
    LinearGradient? freshGradient,
    Color? glassFill,
    Color? glassBorder,
    BoxShadow? softShadow,
    BoxShadow? elevatedShadow,
    Color? skeletonBase,
    Color? skeletonHighlight,
    Color? textSecondary,
    Color? divider,
    Color? success,
    Color? danger,
    Color? warning,
    Color? ripple,
  }) {
    return AppThemeExtension(
      brandGradient: brandGradient ?? this.brandGradient,
      heroGradient: heroGradient ?? this.heroGradient,
      freshGradient: freshGradient ?? this.freshGradient,
      glassFill: glassFill ?? this.glassFill,
      glassBorder: glassBorder ?? this.glassBorder,
      softShadow: softShadow ?? this.softShadow,
      elevatedShadow: elevatedShadow ?? this.elevatedShadow,
      skeletonBase: skeletonBase ?? this.skeletonBase,
      skeletonHighlight: skeletonHighlight ?? this.skeletonHighlight,
      textSecondary: textSecondary ?? this.textSecondary,
      divider: divider ?? this.divider,
      success: success ?? this.success,
      danger: danger ?? this.danger,
      warning: warning ?? this.warning,
      ripple: ripple ?? this.ripple,
    );
  }

  @override
  AppThemeExtension lerp(covariant AppThemeExtension? other, double t) {
    if (other == null) {
      return this;
    }
    return AppThemeExtension(
      brandGradient: LinearGradient.lerp(brandGradient, other.brandGradient, t)!,
      heroGradient: LinearGradient.lerp(heroGradient, other.heroGradient, t)!,
      freshGradient: LinearGradient.lerp(freshGradient, other.freshGradient, t)!,
      glassFill: Color.lerp(glassFill, other.glassFill, t)!,
      glassBorder: Color.lerp(glassBorder, other.glassBorder, t)!,
      softShadow: BoxShadow.lerp(softShadow, other.softShadow, t)!,
      elevatedShadow: BoxShadow.lerp(elevatedShadow, other.elevatedShadow, t)!,
      skeletonBase: Color.lerp(skeletonBase, other.skeletonBase, t)!,
      skeletonHighlight:
          Color.lerp(skeletonHighlight, other.skeletonHighlight, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      divider: Color.lerp(divider, other.divider, t)!,
      success: Color.lerp(success, other.success, t)!,
      danger: Color.lerp(danger, other.danger, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      ripple: Color.lerp(ripple, other.ripple, t)!,
    );
  }
}

/// Ergonomic, never-null access to the active theme from any widget.
extension AppThemeContext on BuildContext {
  ThemeData get theme => Theme.of(this);

  ColorScheme get scheme => Theme.of(this).colorScheme;

  TextTheme get texts => Theme.of(this).textTheme;

  /// Falls back to the light tokens so widgets still render correctly when
  /// used outside a `MaterialApp` (isolated widget tests, for example).
  AppThemeExtension get appColors =>
      Theme.of(this).extension<AppThemeExtension>() ?? AppThemeExtension.light;
}
