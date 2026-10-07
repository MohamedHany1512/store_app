import 'package:dio/dio.dart';
import 'package:store_app/core/constants/api_endpoints.dart';
import 'package:store_app/features/login/data/models/auth_user_model.dart';

abstract interface class AuthRemoteDataSource {
  Future<AuthUserModel> login({
    required String username,
    required String password,
  });
}

/// Talks to the REST API. Transport errors are intentionally **not** handled
/// here: the repository maps `DioException` into typed failures, so this class
/// stays a thin, easily faked adapter.
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  const AuthRemoteDataSourceImpl(Dio dio) : _dio = dio;

  final Dio _dio;

  @override
  Future<AuthUserModel> login({
    required String username,
    required String password,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      ApiEndpoints.login,
      data: <String, dynamic>{
        'username': username,
        'password': password,
      },
    );

    return AuthUserModel.fromJson(response.data ?? const <String, dynamic>{});
  }
}
