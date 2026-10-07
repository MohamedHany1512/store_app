import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../constants/app_durations.dart';
import '../constants/app_radii.dart';
import '../constants/app_spacing.dart';
import '../theme/app_theme_extension.dart';

/// Brand mark: a gradient medallion with a soft glow, gently floating.
///
/// It gracefully falls back to an icon when the asset is missing, which is what
/// caused a runtime crash before (`Image.asset` on an undeclared asset).
class AppLogo extends StatefulWidget {
  const AppLogo({
    super.key,
    this.size = 104,
    this.assetPath = 'assets/images/store.png',
    this.animate = true,
  });

  final double size;
  final String assetPath;
  final bool animate;

  @override
  State<AppLogo> createState() => _AppLogoState();
}

class _AppLogoState extends State<AppLogo>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: AppDurations.ambient,
  );

  @override
  void initState() {
    super.initState();
    if (widget.animate) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.appColors;

    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          final progress = Curves.easeInOut.transform(_controller.value);

          return Transform.translate(
            // Gentle floating motion.
            offset: Offset(0, -5 * math.sin(progress * math.pi)),
            child: Container(
              width: widget.size,
              height: widget.size,
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: tokens.brandGradient,
                boxShadow: <BoxShadow>[
                  tokens.elevatedShadow,
                  BoxShadow(
                    color: tokens.brandGradient.colors.first
                        .withValues(alpha: 0.35),
                    blurRadius: 20 + 16 * progress,
                    spreadRadius: -2,
                  ),
                ],
              ),
              child: ClipOval(child: _logoImage()),
            ),
          );
        },
      ),
    );
  }

  Widget _logoImage() {
    return Image.asset(
      widget.assetPath,
      fit: BoxFit.contain,
      // Never crash on a missing asset - show the brand icon instead.
      errorBuilder: (context, error, stackTrace) => Icon(
        Icons.storefront_rounded,
        size: widget.size * 0.5,
        color: Colors.white,
      ),
    );
  }
}

/// Small gradient pill used for badges (categories, counts, ratings).
class AppBadge extends StatelessWidget {
  const AppBadge({
    required this.label,
    super.key,
    this.icon,
    this.gradient,
    this.padding = const EdgeInsets.symmetric(
      horizontal: AppSpacing.xs,
      vertical: AppSpacing.xxs,
    ),
  });

  final String label;
  final IconData? icon;
  final LinearGradient? gradient;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final tokens = context.appColors;

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        gradient: gradient ?? tokens.freshGradient,
        borderRadius: AppRadii.circle,
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: tokens.ripple.withValues(alpha: 0.18),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (icon != null) ...<Widget>[
            Icon(icon, size: 12, color: Colors.white),
            const SizedBox(width: AppSpacing.xxs),
          ],
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
