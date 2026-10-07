import 'package:equatable/equatable.dart';

import '../constants/app_strings.dart';

 
/// centralized in `AppStrings`.
sealed class Failure extends Equatable {
  const Failure(this.message);

  /// Ready-to-display, user-facing message.
  final String message;

  @override
  List<Object?> get props => <Object?>[message];
}

/// The request reached the server but something went wrong (4xx/5xx).
final class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

/// The request never reached the server (offline, timeout, DNS).
final class NetworkFailure extends Failure {
  const NetworkFailure([super.message = AppStrings.networkError]);
}

/// Credentials were rejected.
final class AuthFailure extends Failure {
  const AuthFailure([super.message = AppStrings.invalidCredentials]);
}

/// Reading/writing local storage failed.
final class CacheFailure extends Failure {
  const CacheFailure([super.message = AppStrings.genericError]);
}

/// Client-side validation failed before any request was made.
final class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}
