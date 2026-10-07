import 'package:flutter/material.dart';
import 'package:store_app/core/constants/app_strings.dart';
import 'package:store_app/core/widgets/app_button.dart';

/// Gradient CTA wired to the form's submit callback.
///
/// The button owns *no* state: the loading flag comes from the Cubit, which
/// keeps a single source of truth (the previous implementation rebuilt the
/// whole button subtree from inside a `BlocBuilder`).
class LoginSubmitButton extends StatelessWidget {
  const LoginSubmitButton({
    required this.isLoading,
    required this.onPressed,
    super.key,
  });

  final bool isLoading;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return AppButton(
      label: isLoading ? AppStrings.loggingIn : AppStrings.login,
      icon: Icons.login_rounded,
      isLoading: isLoading,
      onPressed: onPressed,
    );
  }
}
