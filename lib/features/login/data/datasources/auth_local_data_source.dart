import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:store_app/features/login/data/models/auth_user_model.dart';
import 'package:store_app/features/login/domain/entities/auth_user.dart';

abstract interface class AuthLocalDataSource {
  Future<void> saveSession(AuthUser user);

  Future<AuthUser?> readSession();

  Future<void> clearSession();
}

/// `SharedPreferences` adapter. The instance is injected (instead of calling
/// `SharedPreferences.getInstance()` inside the repository), which keeps the
/// data layer unit testable with an in-memory fake.
class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  const AuthLocalDataSourceImpl(SharedPreferences prefs) : _prefs = prefs;

  final SharedPreferences _prefs;

  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'auth_user';

  @override
  Future<void> saveSession(AuthUser user) async {
    final model = AuthUserModel.fromEntity(user);
    final encoded = jsonEncode(<String, dynamic>{
      ...model.toJson(),
      'accessToken': model.accessToken,
    });

    await _prefs.setString(_tokenKey, model.accessToken);
    await _prefs.setString(_userKey, encoded);
  }

  @override
  Future<AuthUser?> readSession() async {
    final encoded = _prefs.getString(_userKey);
    final token = _prefs.getString(_tokenKey);
    if (encoded == null || token == null || token.isEmpty) {
      return null;
    }

    final decoded = jsonDecode(encoded);
    if (decoded is! Map<String, dynamic>) {
      return null;
    }

    return AuthUserModel.fromJson(<String, dynamic>{
      ...decoded,
      'accessToken': token,
    });
  }

  @override
  Future<void> clearSession() async {
    await _prefs.remove(_tokenKey);
    await _prefs.remove(_userKey);
  }
}
