import 'dart:math' as math;
import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_durations.dart';
import '../theme/app_theme_extension.dart';

/// Ambient background: a soft vertical gradient plus slowly drifting "aurora"
/// blobs. This single widget is what makes the app feel modern instead of
/// flat, and it costs one painter instead of per-screen decorations.
class AppBackground extends StatefulWidget {
  const AppBackground({
    required this.child,
    super.key,
    this.showBlobs = true,
    this.tint,
  });

  final Widget child;
  final bool showBlobs;

  /// Optional surface color painted under the gradient.
  final Color? tint;

  @override
  State<AppBackground> createState() => _AppBackgroundState();
}

class _AppBackgroundState extends State<AppBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: AppDurations.ambient,
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final animate = MediaQuery.maybeOf(context)?.disableAnimations != true;
    if (animate && !_controller.isAnimating) {
      _controller.repeat();
    } else if (!animate && _controller.isAnimating) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final base = widget.tint ?? context.scheme.surface;
    final isDark = context.scheme.brightness == Brightness.dark;

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: isDark
              ? <Color>[AppColors.darkSurface, base, AppColors.darkBackground]
              : <Color>[AppColors.lightSurface, base, AppColors.lightBackground],
        ),
      ),
      child: widget.showBlobs
          ? Stack(
              children: <Widget>[
                Positioned.fill(child: _blobs()),
                widget.child,
              ],
            )
          : widget.child,
    );
  }

  Widget _blobs() {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final t = _controller.value * math.pi * 2;
        return Stack(
          children: <Widget>[
            _AuroraBlob(
              alignment: Alignment(-0.95 + 0.25 * math.sin(t), -0.85 + 0.18 * math.cos(t)),
              diameter: 340,
              color: AppColors.auroraColors[0],
            ),
            _AuroraBlob(
              alignment: Alignment(0.95 + 0.22 * math.cos(t * 0.8), -0.55 + 0.2 * math.sin(t * 0.8)),
              diameter: 280,
              color: AppColors.auroraColors[1],
            ),
            _AuroraBlob(
              alignment: Alignment(0.6 + 0.3 * math.sin(t * 0.6), 0.95 + 0.15 * math.cos(t * 0.6)),
              diameter: 300,
              color: AppColors.auroraColors[2],
            ),
          ],
        );
      },
    );
  }
}

class _AuroraBlob extends StatelessWidget {
  const _AuroraBlob({
    required this.alignment,
    required this.diameter,
    required this.color,
  });

  final Alignment alignment;
  final double diameter;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: ImageFiltered(
        imageFilter: ImageFilter.blur(sigmaX: 70, sigmaY: 70),
        child: Container(
          width: diameter,
          height: diameter,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: <Color>[color, color.withValues(alpha: 0)],
            ),
          ),
        ),
      ),
    );
  }
}
