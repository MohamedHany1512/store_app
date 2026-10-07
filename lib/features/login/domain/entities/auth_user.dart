import 'package:equatable/equatable.dart';

/// Domain entity: the authenticated user + access token.
///
/// Pure Dart, no JSON / Dio / Flutter knowledge, so it can be used by the
/// domain layer and unit tested on its own.
class AuthUser extends Equatable {
  const AuthUser({
    required this.id,
    required this.userName,
    required this.accessToken,
    this.firstName,
    this.lastName,
    this.imageUrl,
  });

  final int id;
  final String userName;
  final String accessToken;
  final String? firstName;
  final String? lastName;
  final String? imageUrl;

  /// Name shown in the home header, falling back to the username.
  String get displayName {
    final name = <String?>[firstName, lastName]
        .whereType<String>()
        .where((part) => part.isNotEmpty)
        .join(' ');
    return name.isEmpty ? userName : name;
  }

  @override
  List<Object?> get props => <Object?>[
        id,
        userName,
        accessToken,
        firstName,
        lastName,
        imageUrl,
      ];
}
