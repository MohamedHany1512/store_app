import 'dart:ui';

import 'package:flutter/material.dart';

import '../constants/app_radii.dart';
import '../constants/app_spacing.dart';
import '../theme/app_theme_extension.dart';

/// A frosted-glass surface: blurred backdrop + translucent fill + hairline
/// border + soft shadow.
///
/// Replaces ad-hoc `Container`s with `BoxShadow(color: Colors.black45)` that
/// were duplicated across the app.
class GlassCard extends StatelessWidget {
  const GlassCard({
    required this.child,
    super.key,
    this.padding = const EdgeInsets.all(AppSpacing.lg),
    this.borderRadius = AppRadii.large,
    this.blur = 18,
    this.elevated = true,
    this.onTap,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final BorderRadius borderRadius;
  final double blur;
  final bool elevated;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = context.appColors;

    return ClipRRect(
      borderRadius: borderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Material(
          color: tokens.glassFill,
          borderRadius: borderRadius,
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap,
            splashColor: tokens.ripple,
            child: Container(
              padding: padding,
              decoration: BoxDecoration(
                borderRadius: borderRadius,
                border: Border.all(color: tokens.glassBorder),
                boxShadow: elevated ? <BoxShadow>[tokens.softShadow] : null,
              ),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

/// A plain, opaque surface used for cards on dense screens (product grid).
class AppSurfaceCard extends StatelessWidget {
  const AppSurfaceCard({
    required this.child,
    super.key,
    this.padding = EdgeInsets.zero,
    this.borderRadius = AppRadii.large,
    this.elevated = true,
    this.onTap,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final BorderRadius borderRadius;
  final bool elevated;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = context.appColors;
    final isDark = context.scheme.brightness == Brightness.dark;

    return Material(
      color: isDark
          ? context.scheme.surfaceContainerHighest
          : context.scheme.surface,
      borderRadius: borderRadius,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        splashColor: tokens.ripple,
        highlightColor: tokens.ripple.withValues(alpha: 0.35),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            border: Border.all(color: tokens.divider),
            boxShadow: elevated ? <BoxShadow>[tokens.softShadow] : null,
          ),
          child: child,
        ),
      ),
    );
  }
}
