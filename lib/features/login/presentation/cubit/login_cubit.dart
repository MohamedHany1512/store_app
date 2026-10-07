import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store_app/features/login/domain/entities/auth_user.dart';
import 'package:store_app/features/login/domain/usecases/login_user.dart';

part 'login_state.dart';

/// Owns the login flow.
///
/// Two important improvements over the original Cubit:
/// 1. It talks to a **use case**, not directly to a repository - so it has a
///    single, well-defined dependency that is trivial to fake in tests.
/// 2. It guards against double submits (double tap on the CTA).
class LoginCubit extends Cubit<LoginState> {
  LoginCubit({required LoginUser loginUser})
      : _loginUser = loginUser,
        super(const LoginState.initial());

  final LoginUser _loginUser;

  Future<void> login({
    required String username,
    required String password,
  }) async {
    if (state.status == LoginStatus.loading) {
      return;
    }

    emit(state.copyWith(status: LoginStatus.loading, clearMessage: true));

    final result = await _loginUser(username: username, password: password);

    // The screen may have been disposed while awaiting the response.
    if (isClosed) {
      return;
    }

    result.fold(
      (failure) => emit(
        LoginState(status: LoginStatus.failure, message: failure.message),
      ),
      (user) => emit(LoginState(status: LoginStatus.success, user: user)),
    );
  }

  /// Lets the user retry after a failure.
  void reset() => emit(const LoginState.initial());
}
