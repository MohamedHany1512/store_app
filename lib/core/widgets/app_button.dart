import 'package:flutter/material.dart';

import '../constants/app_durations.dart';
import '../constants/app_radii.dart';
import '../constants/app_spacing.dart';
import '../theme/app_theme_extension.dart';

/// Primary CTA: gradient surface + ripple + press-scale animation + inline
/// loading state.
///
/// `Ink` is used over a gradient so ripples render *on top of* the gradient,
/// something `ElevatedButton` with a gradient background cannot do.
class AppButton extends StatefulWidget {
  const AppButton({
    required this.label,
    super.key,
    this.onPressed,
    this.icon,
    this.isLoading = false,
    this.gradient,
    this.expand = true,
    this.height = 54,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;
  final LinearGradient? gradient;
  final bool expand;
  final double height;

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (_pressed == value) {
      return;
    }
    setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.appColors;
    final isEnabled = widget.onPressed != null && !widget.isLoading;
    final gradient = widget.gradient ?? tokens.brandGradient;

    return AnimatedScale(
      scale: _pressed ? 0.975 : 1,
      duration: AppDurations.instant,
      curve: AppDurations.standard,
      child: Opacity(
        opacity: isEnabled ? 1 : 0.65,
        child: Material(
          type: MaterialType.transparency,
          child: Ink(
            decoration: BoxDecoration(
              gradient: gradient,
              borderRadius: AppRadii.medium,
              boxShadow:
                  isEnabled ? <BoxShadow>[tokens.elevatedShadow] : null,
            ),
            child: InkWell(
              onTap: isEnabled ? widget.onPressed : null,
              onTapDown: isEnabled ? (_) => _setPressed(true) : null,
              onTapUp: isEnabled ? (_) => _setPressed(false) : null,
              onTapCancel: isEnabled ? () => _setPressed(false) : null,
              borderRadius: AppRadii.medium,
              splashColor: tokens.ripple,
              child: SizedBox(
                height: widget.height,
                width: widget.expand ? double.infinity : null,
                child: Center(
                  child: AnimatedSwitcher(
                    duration: AppDurations.fast,
                    // The label stays visible while loading (with an inline
                    // spinner) so the user always knows what is happening.
                    child: Row(
                      key: const ValueKey<String>('label'),
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        if (widget.isLoading) ...<Widget>[
                          const _ButtonSpinner(),
                          const SizedBox(width: AppSpacing.xs),
                        ] else if (widget.icon != null) ...<Widget>[
                          Icon(widget.icon, size: 20, color: Colors.white),
                          const SizedBox(width: AppSpacing.xs),
                        ],
                        Flexible(
                          child: Text(
                            widget.label,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.2,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ButtonSpinner extends StatelessWidget {
  const _ButtonSpinner();

  @override
  Widget build(BuildContext context) {
    return const SizedBox.square(
      dimension: 18,
      child: CircularProgressIndicator(
        strokeWidth: 2.2,
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      ),
    );
  }
}

/// Circular glass icon button with an optional animated badge.
class AppIconButton extends StatelessWidget {
  const AppIconButton({
    required this.icon,
    super.key,
    this.onPressed,
    this.badgeCount,
    this.tooltip,
    this.size = 44,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final int? badgeCount;
  final String? tooltip;
  final double size;

  @override
  Widget build(BuildContext context) {
    final tokens = context.appColors;
    final count = badgeCount ?? 0;

    final button = SizedBox.square(
      dimension: size,
      child: Material(
        color: tokens.glassFill,
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed,
          child: Icon(icon, size: size * 0.45),
        ),
      ),
    );

    final withBadge = count <= 0
        ? button
        : Stack(
            clipBehavior: Clip.none,
            children: <Widget>[
              button,
              Positioned(
                top: -2,
                right: -2,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xxs,
                    vertical: 2,
                  ),
                  constraints: const BoxConstraints(minWidth: 18),
                  decoration: BoxDecoration(
                    color: tokens.danger,
                    borderRadius: AppRadii.circle,
                    border: Border.all(color: context.scheme.surface, width: 2),
                  ),
                  child: Text(
                    count > 9 ? '9+' : '$count',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ],
          );

    return tooltip == null ? withBadge : Tooltip(message: tooltip!, child: withBadge);
  }
}

/// Small pill-shaped icon button used inside cards (favorite toggle).
class AppChipIconButton extends StatelessWidget {
  const AppChipIconButton({
    required this.icon,
    required this.onPressed,
    super.key,
    this.isActive = false,
    this.size = 34,
  });

  final IconData icon;
  final VoidCallback onPressed;
  final bool isActive;
  final double size;

  @override
  Widget build(BuildContext context) {
    final scheme = context.scheme;

    return AnimatedContainer(
      duration: AppDurations.fast,
      curve: AppDurations.standard,
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: isActive ? scheme.primary : scheme.surface.withValues(alpha: 0.9),
        shape: BoxShape.circle,
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: scheme.shadow.withValues(alpha: 0.16),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed,
          child: Icon(
            icon,
            size: size * 0.5,
            color: isActive ? Colors.white : scheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}