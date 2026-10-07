import 'package:store_app/features/login/domain/entities/auth_user.dart';

/// Data-layer model: knows how to read/write JSON, extends the domain entity.
class AuthUserModel extends AuthUser {
  const AuthUserModel({
    required super.id,
    required super.userName,
    required super.accessToken,
    super.firstName,
    super.lastName,
    super.imageUrl,
  });

  /// Parses the `/auth/login` response:
  /// `{ "accessToken": "...", "user": { "id": 1, "username": "...", ... } }`
  factory AuthUserModel.fromJson(Map<String, dynamic> json) {
    final user = json['user'];
    final userJson = user is Map<String, dynamic>
        ? user
        : const <String, dynamic>{};

    return AuthUserModel(
      id: (userJson['id'] as num?)?.toInt() ?? 0,
      userName: (userJson['username'] as String?) ?? '',
      accessToken: (json['accessToken'] as String?) ?? '',
      firstName: userJson['firstName'] as String?,
      lastName: userJson['lastName'] as String?,
      imageUrl: userJson['image'] as String?,
    );
  }

  factory AuthUserModel.fromEntity(AuthUser user) {
    return AuthUserModel(
      id: user.id,
      userName: user.userName,
      accessToken: user.accessToken,
      firstName: user.firstName,
      lastName: user.lastName,
      imageUrl: user.imageUrl,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'username': userName,
        'firstName': firstName,
        'lastName': lastName,
        'image': imageUrl,
      };
}
