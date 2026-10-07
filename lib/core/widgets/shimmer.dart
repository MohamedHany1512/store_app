import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../constants/app_durations.dart';
import '../constants/app_radii.dart';
import '../constants/app_spacing.dart';
import '../theme/app_theme_extension.dart';

/// Sweeping highlight animation shared by every skeleton placeholder.
///
/// Instead of a bare `CircularProgressIndicator` (which looks dated and jumps
/// the layout), loading states are built from shimmering blocks.
class Shimmer extends StatefulWidget {
  const Shimmer({required this.child, super.key, this.enabled = true});

  final Widget child;

  /// When false the child is rendered as-is (used when animations are disabled
  /// by the OS accessibility settings).
  final bool enabled;

  @override
  State<Shimmer> createState() => _ShimmerState();
}

class _ShimmerState extends State<Shimmer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: AppDurations.shimmer,
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) {
      return widget.child;
    }
    final tokens = context.appColors;

    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _controller,
        child: widget.child,
        builder: (context, child) {
          final slide = _controller.value * 2 - 1; // -1 → 1
          return ShaderMask(
            blendMode: BlendMode.srcATop,
            shaderCallback: (bounds) {
              return LinearGradient(
                begin: Alignment(slide - 1, 0),
                end: Alignment(slide + 1, 0),
                colors: <Color>[
                  tokens.skeletonBase,
                  tokens.skeletonHighlight,
                  tokens.skeletonBase,
                ],
                stops: const <double>[0.3, 0.5, 0.7],
              ).createShader(bounds);
            },
            child: child,
          );
        },
      ),
    );
  }
}

/// A single skeleton block.
class SkeletonBox extends StatelessWidget {
  const SkeletonBox({
    super.key,
    this.width,
    this.height,
    this.borderRadius = AppRadii.small,
    this.shape = BoxShape.rectangle,
  });

  final double? width;
  final double? height;
  final BorderRadius borderRadius;
  final BoxShape shape;

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: context.appColors.skeletonBase,
          shape: shape,
          borderRadius: shape == BoxShape.rectangle ? borderRadius : null,
        ),
      ),
    );
  }
}

/// A row of shimmering lines that mimics a paragraph of text.
class SkeletonLines extends StatelessWidget {
  const SkeletonLines({super.key, this.lines = 3, this.lineHeight = 12});

  final int lines;
  final double lineHeight;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List<Widget>.generate(
        lines,
        (index) {
          // Last line is shorter, exactly like real text.
          final widthFactor = index == lines - 1 ? 0.55 : 1.0;
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.xs),
            child: FractionallySizedBox(
              widthFactor: widthFactor,
              child: SkeletonBox(
                height: lineHeight,
                borderRadius: BorderRadius.circular(lineHeight / 2),
                width: double.infinity,
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Fades + slides its child in on first build.
///
/// Used for headers, cards and empty states so screens never "pop" into place.
class FadeInSlide extends StatefulWidget {
  const FadeInSlide({
    required this.child,
    super.key,
    this.delay = Duration.zero,
    this.offset = const Offset(0, 0.08),
  });

  final Widget child;
  final Duration delay;
  final Offset offset;

  @override
  State<FadeInSlide> createState() => _FadeInSlideState();
}

class _FadeInSlideState extends State<FadeInSlide>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: AppDurations.slow,
  );

  @override
  void initState() {
    super.initState();
    if (widget.delay == Duration.zero) {
      _controller.forward();
    } else {
      Future<void>.delayed(widget.delay, () {
        if (mounted) {
          _controller.forward();
        }
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      child: widget.child,
      builder: (context, child) {
        final value = Curves.easeOutCubic.transform(_controller.value);
        return Opacity(
          opacity: value.clamp(0.0, 1.0),
          child: Transform.translate(
            offset: widget.offset * (1 - value),
            child: child,
          ),
        );
      },
    );
  }
}

/// Nice-to-have helper used by decorative widgets.
double triangleWave(double t) => (math.sin(t * math.pi * 2) + 1) / 2;
