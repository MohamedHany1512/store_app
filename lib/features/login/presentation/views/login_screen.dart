import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store_app/core/constants/app_strings.dart';
import 'package:store_app/core/widgets/app_background.dart';
import 'package:store_app/core/widgets/app_toast.dart';
import 'package:store_app/features/login/presentation/cubit/login_cubit.dart';
import 'package:store_app/features/login/presentation/views/login_view.dart';

/// Login screen: owns *side effects* only.
///
/// Navigation is intentionally absent - [SessionStore] notifies the router,
/// which then redirects to the home page, so the view never calls Navigator.
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: _handleStateChange,
      child: const Scaffold(
        backgroundColor: Colors.transparent,
        // Lets the scroll view shrink when the keyboard opens.
        resizeToAvoidBottomInset: true,
        body: AppBackground(
          child: SafeArea(
            child: LoginView(),
          ),
        ),
      ),
    );
  }

  void _handleStateChange(BuildContext context, LoginState state) {
    switch (state.status) {
      case LoginStatus.success:
        FocusScope.of(context).unfocus();
      case LoginStatus.failure:
        FocusScope.of(context).unfocus();
        AppToast.error(context, state.message ?? AppStrings.genericError);
      case LoginStatus.initial:
      case LoginStatus.loading:
        break;
    }
  }
}
