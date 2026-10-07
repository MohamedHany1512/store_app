import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants/app_durations.dart';
import '../constants/app_radii.dart';
import '../theme/app_theme_extension.dart';

/// Reusable text field with an animated focus ring, an optional show/hide
/// password toggle and proper keyboard / autofill configuration.
///
/// Validation errors are rendered by the enclosing [Form] through
/// `TextFormField`'s built-in error slot (styled by the theme).
class AppTextField extends StatefulWidget {
  const AppTextField({
    required this.controller,
    required this.hint,
    super.key,
    this.icon,
    this.obscure = false,
    this.keyboardType,
    this.textInputAction,
    this.validator,
    this.onSubmitted,
    this.onChanged,
    this.autofillHints,
    this.enabled = true,
    this.focusNode,
    this.textCapitalization = TextCapitalization.none,
    this.inputFormatters,
  });

  final TextEditingController controller;
  final String hint;
  final IconData? icon;
  final bool obscure;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onSubmitted;
  final ValueChanged<String>? onChanged;
  final Iterable<String>? autofillHints;
  final bool enabled;
  final FocusNode? focusNode;
  final TextCapitalization textCapitalization;
  final List<TextInputFormatter>? inputFormatters;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late final FocusNode _focusNode = widget.focusNode ?? FocusNode();
  late final bool _ownsFocusNode = widget.focusNode == null;
  bool _isFocused = false;
  bool _obscured = true;

  @override
  void initState() {
    super.initState();
    _obscured = widget.obscure;
    _focusNode.addListener(_handleFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChange);
    if (_ownsFocusNode) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  void _handleFocusChange() {
    if (_focusNode.hasFocus != _isFocused) {
      setState(() => _isFocused = _focusNode.hasFocus);
    }
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.appColors;
    final scheme = context.scheme;

    return AnimatedContainer(
      duration: AppDurations.fast,
      curve: AppDurations.standard,
      decoration: BoxDecoration(
        color: widget.enabled
            ? scheme.surfaceContainerHighest
            : scheme.surfaceContainerLow,
        borderRadius: AppRadii.medium,
        border: Border.all(
          color: _isFocused ? scheme.primary : tokens.divider,
          width: _isFocused ? 1.6 : 1,
        ),
        boxShadow: _isFocused
            ? <BoxShadow>[
                BoxShadow(
                  color: scheme.primary.withValues(alpha: 0.18),
                  blurRadius: 14,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: TextFormField(
        controller: widget.controller,
        focusNode: _focusNode,
        validator: widget.validator,
        onFieldSubmitted: widget.onSubmitted,
        onChanged: widget.onChanged,
        enabled: widget.enabled,
        obscureText: widget.obscure && _obscured,
        keyboardType: widget.keyboardType,
        textInputAction: widget.textInputAction,
        textCapitalization: widget.textCapitalization,
        autofillHints: widget.autofillHints,
        inputFormatters: widget.inputFormatters,
        cursorColor: scheme.primary,
        style: context.texts.bodyLarge?.copyWith(
          fontWeight: FontWeight.w600,
          color: scheme.onSurface,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          focusedErrorBorder: InputBorder.none,
          hintText: widget.hint,
          hintStyle: TextStyle(
            color: tokens.textSecondary.withValues(alpha: 0.75),
            fontWeight: FontWeight.w500,
          ),
          prefixIcon: widget.icon == null
              ? null
              : Padding(
                  padding: const EdgeInsets.only(left: 14),
                  child: Icon(
                    widget.icon,
                    size: 20,
                    color: _isFocused ? scheme.primary : tokens.textSecondary,
                  ),
                ),
          prefixIconConstraints: const BoxConstraints(minWidth: 44),
          suffixIcon: widget.obscure
              ? IconButton(
                  onPressed: () => setState(() => _obscured = !_obscured),
                  tooltip: _obscured ? 'Show password' : 'Hide password',
                  icon: AnimatedSwitcher(
                    duration: AppDurations.fast,
                    transitionBuilder: (child, animation) => ScaleTransition(
                      scale: animation,
                      child: child,
                    ),
                    child: Icon(
                      _obscured
                          ? Icons.visibility_rounded
                          : Icons.visibility_off_rounded,
                      key: ValueKey<bool>(_obscured),
                      size: 20,
                    ),
                  ),
                )
              : null,
        ),
      ),
    );
  }
}