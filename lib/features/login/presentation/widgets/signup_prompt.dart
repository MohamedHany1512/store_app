import 'package:flutter/material.dart';
import 'package:store_app/core/constants/app_spacing.dart';
import 'package:store_app/core/constants/app_strings.dart';
import 'package:store_app/core/theme/app_theme_extension.dart';

/// "Don't have an account? Create one" row.
///
/// Wrapped in a `Material` + `InkWell` so the tappable area has a real ripple
/// (the old `Text` widgets had no feedback at all).
class SignupPrompt extends StatelessWidget {
  const SignupPrompt({super.key, this.onCreateAccount});

  final VoidCallback? onCreateAccount;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(AppSpacing.sm),
      child: InkWell(
        onTap: onCreateAccount,
        borderRadius: BorderRadius.circular(AppSpacing.sm),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.xs,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Flexible(
                child: Text(
                  '${AppStrings.noAccount} ',
                  style: context.texts.bodyMedium?.copyWith(
                    color: context.appColors.textSecondary,
                  ),
                ),
              ),
              Text(
                AppStrings.createAccount,
                style: context.texts.bodyMedium?.copyWith(
                  color: context.scheme.primary,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
