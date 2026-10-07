part of 'login_cubit.dart';

enum LoginStatus { initial, loading, success, failure }

/// A single immutable state with a `status` discriminator.
///
/// This is intentionally *not* a hierarchy of `InitialState/LoadingState/...`
/// classes: one class + [LoginStatus] makes `switch` statements exhaustive,
/// keeps `copyWith` trivial and plays nicely with `AnimatedSwitcher`.
final class LoginState extends Equatable {
  const LoginState({required this.status, this.message, this.user});

  const LoginState.initial()
      : status = LoginStatus.initial,
        message = null,
        user = null;

  final LoginStatus status;

  /// User-facing error text, set only when [status] is [LoginStatus.failure].
  final String? message;

  final AuthUser? user;

  bool get isLoading => status == LoginStatus.loading;

  bool get isSuccess => status == LoginStatus.success;

  LoginState copyWith({
    LoginStatus? status,
    String? message,
    AuthUser? user,
    bool clearMessage = false,
  }) {
    return LoginState(
      status: status ?? this.status,
      message: clearMessage ? null : message ?? this.message,
      user: user ?? this.user,
    );
  }

  @override
  List<Object?> get props => <Object?>[status, message, user];
}
