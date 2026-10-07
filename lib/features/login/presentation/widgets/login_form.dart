import 'package:flutter/material.dart';
import 'package:store_app/core/constants/app_spacing.dart';
import 'package:store_app/core/constants/app_strings.dart';
import 'package:store_app/core/theme/app_theme_extension.dart';
import 'package:store_app/core/widgets/app_text_field.dart';
import 'package:store_app/features/login/domain/usecases/login_user.dart';

/// Username + password fields with per-field validation.
///
/// The old implementation applied the same "length >= 6" rule to *both* fields
/// (including the username) and had no keyboard type / autofill configuration.
class LoginForm extends StatelessWidget {
  const LoginForm({
    required this.usernameController,
    required this.passwordController,
    required this.onSubmit,
    super.key,
    this.enabled = true,
  });

  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final VoidCallback onSubmit;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        AppTextField(
          controller: usernameController,
          hint: AppStrings.username,
          icon: Icons.person_outline_rounded,
          enabled: enabled,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
          textCapitalization: TextCapitalization.none,
          autofillHints: const <String>[AutofillHints.username],
          validator: _validateUsername,
        ),
        const SizedBox(height: AppSpacing.md),
        AppTextField(
          controller: passwordController,
          hint: AppStrings.password,
          icon: Icons.lock_outline_rounded,
          obscure: true,
          enabled: enabled,
          keyboardType: TextInputType.visiblePassword,
          // Submit from the keyboard instead of a second tap on the button.
          textInputAction: TextInputAction.done,
          autofillHints: const <String>[AutofillHints.password],
          onSubmitted: enabled ? (_) => onSubmit() : null,
          validator: _validatePassword,
        ),
        const SizedBox(height: AppSpacing.xs),
        Align(
          alignment: AlignmentDirectional.centerEnd,
          child: TextButton(
            onPressed: enabled ? () => _showForgotPasswordHint(context) : null,
            child: Text(
              AppStrings.forgotPassword,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ),
      ],
    );
  }

  String? _validateUsername(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) {
      return AppStrings.usernameRequired;
    }
    if (text.length < LoginUser.minUsernameLength) {
      return AppStrings.usernameTooShort;
    }
    return null;
  }

  String? _validatePassword(String? value) {
    final text = value ?? '';
    if (text.isEmpty) {
      return AppStrings.passwordRequired;
    }
    if (text.length < LoginUser.minPasswordLength) {
      return AppStrings.passwordTooShort;
    }
    return null;
  }

  void _showForgotPasswordHint(BuildContext context) {
    final tokens = context.appColors;
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 2),
          backgroundColor: tokens.glassFill.withValues(alpha: 0.95),
          content: Text(
            AppStrings.forgotPasswordHint,
            style: TextStyle(color: context.scheme.onSurface),
          ),
        ),
      );
  }
}
