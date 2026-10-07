import 'package:dartz/dartz.dart';
import 'package:store_app/core/error/failure.dart';
import 'package:store_app/features/login/domain/entities/auth_user.dart';
import 'package:store_app/features/login/domain/repositories/auth_repository.dart';

/// Single-responsibility use case: everything that happens when the user taps
/// "Log in", including trimming and validating the input before any I/O.
class LoginUser {
  const LoginUser(AuthRepository repository) : _repository = repository;

  final AuthRepository _repository;

  static const int minUsernameLength = 3;
  static const int minPasswordLength = 6;

  Future<Either<Failure, AuthUser>> call({
    required String username,
    required String password,
  }) {
    final user = username.trim();
    final pass = password.trim();

    if (user.length < minUsernameLength) {
      return Future<Either<Failure, AuthUser>>.value(
        const Left(ValidationFailure('Please enter a valid username')),
      );
    }
    if (pass.length < minPasswordLength) {
      return Future<Either<Failure, AuthUser>>.value(
        const Left(ValidationFailure('Please enter a valid password')),
      );
    }

    return _repository.login(username: user, password: pass);
  }
}
