import 'package:flutter/cupertino.dart' show CupertinoPageTransitionsBuilder;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants/app_colors.dart';
import '../constants/app_radii.dart';
import '../constants/app_spacing.dart';
import 'app_theme_extension.dart';

/// Builds the light and dark Material 3 themes.
///
/// Everything visual is defined once here: no screen builds a `ThemeData`, and
/// no widget hardcodes a color, font size or radius.
abstract final class AppTheme {
  const AppTheme._();

  static ThemeData get light => _build(Brightness.light);

  static ThemeData get dark => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final tokens = isDark ? AppThemeExtension.dark : AppThemeExtension.light;

    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.violet,
      brightness: brightness,
    ).copyWith(
      primary: AppColors.violet,
      secondary: AppColors.teal,
      error: AppColors.danger,
      surface: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      onSurface:
          isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
    );

    final base = ThemeData(useMaterial3: true, colorScheme: colorScheme);
    final textTheme = _textTheme(base.textTheme);

    return base.copyWith(
      scaffoldBackgroundColor: colorScheme.surface,
      textTheme: textTheme,
      extensions: <ThemeExtension<dynamic>>[tokens],
      splashFactory: InkSparkle.splashFactory,

      // --- App bar ------------------------------------------------------------
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: textTheme.titleLarge,
        systemOverlayStyle: isDark
            ? SystemUiOverlayStyle.light
            : SystemUiOverlayStyle.dark,
      ),

      // --- Cards --------------------------------------------------------------
      cardTheme: CardThemeData(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
        shape: const RoundedRectangleBorder(borderRadius: AppRadii.large),
      ),

      // --- Inputs -------------------------------------------------------------
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark
            ? AppColors.darkSurfaceMuted
            : AppColors.lightSurfaceMuted,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
        hintStyle: TextStyle(
          color: tokens.textSecondary.withValues(alpha: 0.9),
        ),
        labelStyle: TextStyle(color: tokens.textSecondary),
        floatingLabelStyle: TextStyle(
          color: colorScheme.primary,
          fontWeight: FontWeight.w600,
        ),
        prefixIconColor: tokens.textSecondary,
        suffixIconColor: tokens.textSecondary,
        errorStyle: TextStyle(
          color: colorScheme.error,
          fontWeight: FontWeight.w600,
        ),
        border: _fieldBorder(Colors.transparent),
        enabledBorder: _fieldBorder(tokens.divider),
        focusedBorder: _fieldBorder(colorScheme.primary, width: 1.6),
        errorBorder: _fieldBorder(colorScheme.error),
        focusedErrorBorder: _fieldBorder(colorScheme.error, width: 1.6),
      ),

      // --- Buttons ------------------------------------------------------------
      elevatedButtonTheme: _buttonTheme(colorScheme.primary),
      filledButtonTheme: FilledButtonThemeData(
        style: _buttonStyle(colorScheme.primary),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colorScheme.onSurface,
          side: BorderSide(color: tokens.divider),
          minimumSize: const Size.fromHeight(52),
          padding: AppSpacing.buttonContent,
          shape: const RoundedRectangleBorder(borderRadius: AppRadii.medium),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: colorScheme.primary),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(foregroundColor: colorScheme.onSurface),
      ),

      // --- Feedback -----------------------------------------------------------
      dividerTheme: DividerThemeData(color: tokens.divider, thickness: 1),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: colorScheme.primary,
        linearTrackColor: tokens.skeletonBase,
        circularTrackColor: tokens.skeletonBase,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor:
            isDark ? AppColors.darkSurfaceMuted : AppColors.lightTextPrimary,
        contentTextStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
        shape: const RoundedRectangleBorder(borderRadius: AppRadii.medium),
        insetPadding: const EdgeInsets.all(AppSpacing.md),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor:
            isDark ? AppColors.darkSurface : AppColors.lightSurface,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(borderRadius: AppRadii.large),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
      ),

      // --- Motion -------------------------------------------------------------
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: <TargetPlatform, PageTransitionsBuilder>{
          TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
    );
  }

  static TextTheme _textTheme(TextTheme base) {
    return base.copyWith(
      displaySmall: base.displaySmall?.copyWith(
        fontWeight: FontWeight.w800,
        letterSpacing: -1,
        height: 1.1,
      ),
      headlineMedium: base.headlineMedium?.copyWith(
        fontWeight: FontWeight.w800,
        letterSpacing: -0.6,
      ),
      headlineSmall: base.headlineSmall?.copyWith(
        fontWeight: FontWeight.w700,
        letterSpacing: -0.4,
      ),
      titleLarge: base.titleLarge?.copyWith(
        fontWeight: FontWeight.w700,
        letterSpacing: -0.2,
      ),
      titleMedium: base.titleMedium?.copyWith(fontWeight: FontWeight.w600),
      bodyMedium: base.bodyMedium?.copyWith(height: 1.45),
      labelLarge: base.labelLarge?.copyWith(
        fontWeight: FontWeight.w700,
        letterSpacing: 0.2,
      ),
    );
  }

  static ElevatedButtonThemeData _buttonTheme(Color background) {
    return ElevatedButtonThemeData(
      style: _buttonStyle(background),
    );
  }

  static ButtonStyle _buttonStyle(Color background) {
    return ElevatedButton.styleFrom(
      elevation: 0,
      backgroundColor: background,
      foregroundColor: Colors.white,
      minimumSize: const Size.fromHeight(52),
      padding: AppSpacing.buttonContent,
      shape: const RoundedRectangleBorder(borderRadius: AppRadii.medium),
      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
    );
  }

  static OutlineInputBorder _fieldBorder(Color color, {double width = 1}) {
    return OutlineInputBorder(
      borderRadius: AppRadii.medium,
      borderSide: BorderSide(color: color, width: width),
    );
  }
}
