import 'package:dartz/dartz.dart';
import 'package:store_app/core/error/failure.dart';
import 'package:store_app/features/login/domain/entities/auth_user.dart';

/// Contract owned by the domain layer and implemented in `data`.
///
/// The Cubit depends on this abstraction only, which is what allows the login
/// flow to be unit tested without Dio, SharedPreferences or the network.
abstract interface class AuthRepository {
  /// Authenticates the user and persists the session.
  Future<Either<Failure, AuthUser>> login({
    required String username,
    required String password,
  });

  /// Clears the persisted session and notifies the app (router redirect).
  Future<Either<Failure, Unit>> logout();

  /// Restores a previously persisted session on cold start.
  Future<Either<Failure, AuthUser?>> restoreSession();
}
