import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:store_app/core/constants/app_strings.dart';
import 'package:store_app/core/error/failure.dart';
import 'package:store_app/core/session/session_store.dart';
import 'package:store_app/features/login/data/datasources/auth_local_data_source.dart';
import 'package:store_app/features/login/data/datasources/auth_remote_data_source.dart';
import 'package:store_app/features/login/domain/entities/auth_user.dart';
import 'package:store_app/features/login/domain/repositories/auth_repository.dart';

/// Concrete implementation of the domain contract.
///
/// It is also the single place that updates [SessionStore], which makes
/// `AppRouter`'s auth redirect work without any navigation calls in the view.
class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl({
    required AuthRemoteDataSource remote,
    required AuthLocalDataSource local,
    required SessionStore session,
  })  : _remote = remote,
        _local = local,
        _session = session;

  final AuthRemoteDataSource _remote;
  final AuthLocalDataSource _local;
  final SessionStore _session;

  @override
  Future<Either<Failure, AuthUser>> login({
    required String username,
    required String password,
  }) async {
    try {
      final user = await _remote.login(username: username, password: password);

      final cacheFailure = await _persist(user);
      if (cacheFailure != null) {
        return Left(cacheFailure);
      }

      _session.signIn(userName: user.displayName);
      return Right(user);
    } on DioException catch (error) {
      return Left(_mapDioError(error));
    } on FormatException {
      return const Left(ServerFailure('Unexpected response from the server'));
    }
  }

  @override
  Future<Either<Failure, Unit>> logout() async {
    try {
      await _local.clearSession();
      _session.signOut();
      return const Right(unit);
    } catch (_) {
      return const Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, AuthUser?>> restoreSession() async {
    try {
      final user = await _local.readSession();
      if (user == null) {
        _session.signOut();
        return const Right(null);
      }
      _session.signIn(userName: user.displayName);
      return Right(user);
    } catch (_) {
      return const Left(CacheFailure());
    }
  }

  /// Persists the session, returning a [CacheFailure] instead of throwing so
  /// the user still gets a clean, typed error.
  Future<Failure?> _persist(AuthUser user) async {
    try {
      await _local.saveSession(user);
      return null;
    } catch (_) {
      return const CacheFailure();
    }
  }

  /// Single mapping point from transport errors to domain failures.
  Failure _mapDioError(DioException error) {
    final statusCode = error.response?.statusCode;

    if (statusCode == 400 || statusCode == 401 || statusCode == 403) {
      return const AuthFailure();
    }
    if (statusCode != null) {
      return ServerFailure('Server error ($statusCode). ${AppStrings.serverError}');
    }
    return const NetworkFailure();
  }
}
