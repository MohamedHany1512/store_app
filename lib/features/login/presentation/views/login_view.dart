import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store_app/core/constants/app_radii.dart';
import 'package:store_app/core/constants/app_spacing.dart';
import 'package:store_app/core/constants/app_strings.dart';
import 'package:store_app/core/theme/app_theme_extension.dart';
import 'package:store_app/core/utils/responsive.dart';
import 'package:store_app/core/widgets/app_logo.dart';
import 'package:store_app/core/widgets/glass_card.dart';
import 'package:store_app/core/widgets/shimmer.dart';
import 'package:store_app/features/login/presentation/cubit/login_cubit.dart';
import 'package:store_app/features/login/presentation/widgets/login_form.dart';
import 'package:store_app/features/login/presentation/widgets/login_submit_button.dart';
import 'package:store_app/features/login/presentation/widgets/signup_prompt.dart';

/// The login form itself.
///
/// It is a separate widget (instead of living inside [LoginScreen]) so it can
/// be pumped in isolation by widget tests, and so the screen stays focused on
/// side effects.
class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState?.validate() ?? false) {
      context.read<LoginCubit>().login(
            username: _usernameController.text,
            password: _passwordController.text,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isCompact = context.isCompact;

    return GestureDetector(
      // Dismiss the keyboard when tapping outside the fields.
      behavior: HitTestBehavior.opaque,
      onTap: () => FocusScope.of(context).unfocus(),
      child: Center(
        child: SingleChildScrollView(
          // Bottom padding keeps the CTA above the on-screen keyboard.
          padding: EdgeInsets.fromLTRB(
            AppSpacing.md,
            AppSpacing.lg,
            AppSpacing.md,
            MediaQuery.viewInsetsOf(context).bottom + AppSpacing.lg,
          ),
          child: ConstrainedBox(
            // Centered + width-capped: no stretched fields on tablets.
            constraints: BoxConstraints(maxWidth: context.maxContentWidth),
            child: BlocBuilder<LoginCubit, LoginState>(
              builder: (context, state) {
                final isLoading = state.isLoading;

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    FadeInSlide(
                      child: AppLogo(size: isCompact ? 92 : 112),
                    ),
                    SizedBox(height: isCompact ? AppSpacing.lg : AppSpacing.xl),
                    FadeInSlide(
                      delay: const Duration(milliseconds: 80),
                      child: const _LoginHeadline(),
                    ),
                    SizedBox(height: isCompact ? AppSpacing.lg : AppSpacing.xl),
                    FadeInSlide(
                      delay: const Duration(milliseconds: 160),
                      child: GlassCard(
                        padding: EdgeInsets.all(
                          isCompact ? AppSpacing.md : AppSpacing.lg,
                        ),
                        borderRadius: AppRadii.extraLarge,
                        child: Form(
                          key: _formKey,
                          child: LoginForm(
                            usernameController: _usernameController,
                            passwordController: _passwordController,
                            enabled: !isLoading,
                            onSubmit: _submit,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: isCompact ? AppSpacing.md : AppSpacing.lg),
                    FadeInSlide(
                      delay: const Duration(milliseconds: 240),
                      child: LoginSubmitButton(
                        isLoading: isLoading,
                        onPressed: _submit,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    const FadeInSlide(
                      delay: Duration(milliseconds: 320),
                      child: SignupPrompt(),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _LoginHeadline extends StatelessWidget {
  const _LoginHeadline();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        // `FittedBox` guarantees the title never overflows on narrow screens
        // or with a large accessibility text scale.
        FittedBox(
          child: Text(
            AppStrings.welcomeBack,
            textAlign: TextAlign.center,
            style: context.texts.displaySmall,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          AppStrings.loginSubtitle,
          textAlign: TextAlign.center,
          style: context.texts.bodyLarge?.copyWith(
            color: context.appColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
