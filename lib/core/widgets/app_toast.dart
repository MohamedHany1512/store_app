import 'dart:async';

import 'package:flutter/material.dart';

import '../constants/app_durations.dart';
import '../constants/app_radii.dart';
import '../constants/app_spacing.dart';
import '../theme/app_theme_extension.dart';

enum AppToastType { success, error, info }

/// A custom toast rendered inside the app [Overlay].
///
/// Why not `SnackBar`? Toasts can be styled freely (icon + glass surface +
/// slide animation), never queue up behind each other, and are dismissed
/// automatically - which is exactly what the old red `SnackBar` lacked.
abstract final class AppToast {
  const AppToast._();

  static OverlayEntry? _entry;
  static Timer? _timer;

  static void success(BuildContext context, String message) =>
      show(context, message, type: AppToastType.success);

  static void error(BuildContext context, String message) =>
      show(context, message, type: AppToastType.error);

  static void info(BuildContext context, String message) =>
      show(context, message, type: AppToastType.info);

  static void show(
    BuildContext context,
    String message, {
    AppToastType type = AppToastType.info,
    Duration? duration,
  }) {
    final overlay = Overlay.maybeOf(context, rootOverlay: true);
    if (overlay == null) {
      return;
    }
    dismiss();

    final entry = OverlayEntry(
      builder: (context) => _ToastCard(message: message, type: type),
    );
    _entry = entry;
    overlay.insert(entry);
    _timer = Timer(duration ?? AppDurations.toast, dismiss);
  }

  /// Safe to call repeatedly - it no-ops when nothing is showing.
  static void dismiss() {
    _timer?.cancel();
    _timer = null;
    _entry?.remove();
    _entry = null;
  }
}

class _ToastCard extends StatefulWidget {
  const _ToastCard({required this.message, required this.type});

  final String message;
  final AppToastType type;

  @override
  State<_ToastCard> createState() => _ToastCardState();
}

class _ToastCardState extends State<_ToastCard> {
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() => _visible = true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.appColors;
    final media = MediaQuery.of(context);
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    final (accent, icon) = switch (widget.type) {
      AppToastType.success => (tokens.success, Icons.check_circle_rounded),
      AppToastType.error => (tokens.danger, Icons.error_rounded),
      AppToastType.info => (context.scheme.primary, Icons.info_rounded),
    };

    return Positioned(
      top: media.padding.top + media.viewPadding.top + AppSpacing.sm,
      left: AppSpacing.md,
      right: AppSpacing.md,
      child: IgnorePointer(
        ignoring: !_visible,
        child: GestureDetector(
          onTap: AppToast.dismiss,
          child: AnimatedSlide(
            offset: _visible ? Offset.zero : Offset(0, isRtl ? 0 : -0.6),
            duration: AppDurations.normal,
            curve: AppDurations.emphasized,
            child: AnimatedOpacity(
              opacity: _visible ? 1 : 0,
              duration: AppDurations.fast,
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 480),
                  child: Material(
                    color: tokens.glassFill,
                    borderRadius: AppRadii.medium,
                    clipBehavior: Clip.antiAlias,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: AppSpacing.sm,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: AppRadii.medium,
                        border: Border.all(color: tokens.glassBorder),
                        boxShadow: <BoxShadow>[tokens.elevatedShadow],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Icon(icon, color: accent, size: 22),
                          const SizedBox(width: AppSpacing.sm),
                          Flexible(
                            child: Text(
                              widget.message,
                              style: context.texts.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: context.scheme.onSurface,
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
      ),
    );
  }
}