import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../constants/app_durations.dart';
import '../constants/app_radii.dart';
import '../constants/app_spacing.dart';
import '../theme/app_theme_extension.dart';
import 'shimmer.dart';

 
class AppNetworkImage extends StatelessWidget {
  const AppNetworkImage({
    required this.url,
    super.key,
    this.fit = BoxFit.cover,
    this.borderRadius = BorderRadius.zero,
    this.width,
    this.height,
  });

  final String url;
  final BoxFit fit;
  final BorderRadius borderRadius;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final tokens = context.appColors;

    return ClipRRect(
      borderRadius: borderRadius,
      child: SizedBox(
        width: width,
        height: height,
        child: url.isEmpty
            ? const _ImageFallback()
            : CachedNetworkImage(
                imageUrl: url,
                fit: fit,
                width: width,
                height: height,
                fadeInDuration: AppDurations.normal,
                fadeOutDuration: AppDurations.instant,
                placeholder: (context, url) => Shimmer(
                  child: ColoredBox(color: tokens.skeletonBase),
                ),
                errorWidget: (context, url, error) => const _ImageFallback(),
              ),
      ),
    );
  }
}

class _ImageFallback extends StatelessWidget {
  const _ImageFallback();

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: context.appColors.skeletonBase,
      child: Center(
        child: Icon(
          Icons.image_not_supported_rounded,
          color: context.appColors.textSecondary,
          size: AppSpacing.xl,
        ),
      ),
    );
  }
}

/// Small avatar bubble with initials - used in the home header.
class AppAvatar extends StatelessWidget {
  const AppAvatar({
    required this.initials,
    super.key,
    this.size = 44,
    this.gradient,
  });

  final String initials;
  final double size;
  final LinearGradient? gradient;

  @override
  Widget build(BuildContext context) {
    final tokens = context.appColors;

    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: gradient ?? tokens.brandGradient,
        boxShadow: <BoxShadow>[tokens.softShadow],
      ),
      child: Text(
        initials,
        style: TextStyle(
          color: Colors.white,
          fontSize: size * 0.36,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

/// Pill-shaped filter chip with an animated selected state.
class AppFilterChip extends StatelessWidget {
  const AppFilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
    super.key,
    this.icon,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final tokens = context.appColors;
    final scheme = context.scheme;

    return AnimatedContainer(
      duration: AppDurations.fast,
      curve: AppDurations.standard,
      decoration: BoxDecoration(
        gradient: selected ? tokens.brandGradient : null,
        color: selected ? null : scheme.surface,
        borderRadius: AppRadii.circle,
        border: Border.all(
          color: selected ? Colors.transparent : tokens.divider,
        ),
        boxShadow: selected
            ? <BoxShadow>[
                BoxShadow(
                  color: tokens.brandGradient.colors.first.withValues(
                    alpha: 0.35,
                  ),
                  blurRadius: 14,
                  offset: const Offset(0, 6),
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: AppRadii.circle,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          splashColor: Colors.white.withValues(alpha: 0.18),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.xs,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                if (icon != null) ...<Widget>[
                  Icon(
                    icon,
                    size: 15,
                    color: selected ? Colors.white : tokens.textSecondary,
                  ),
                  const SizedBox(width: AppSpacing.xxs),
                ],
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: selected ? Colors.white : tokens.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}