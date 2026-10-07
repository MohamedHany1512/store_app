import 'package:flutter/foundation.dart';

/// In-memory mirror of the persisted session.
///
/// It is a [ChangeNotifier] so two very different consumers can react to it
/// without depending on each other:
///  * [AppRouter] passes it as `refreshListenable` to re-run the redirect on
///    login / logout.
///  * Widgets can `context.watch<SessionStore>()` to show the user name.
class SessionStore extends ChangeNotifier {
  SessionStore({bool isAuthenticated = false, String? userName})
      : _isAuthenticated = isAuthenticated,
        _userName = userName;

  bool _isAuthenticated;
  String? _userName;

  bool get isAuthenticated => _isAuthenticated;

  String? get userName => _userName;

  /// Fallback name used by the home header for guests.
  String get displayName {
    final name = _userName;
    if (name == null || name.isEmpty) {
      return 'Guest';
    }
    return name;
  }

  /// Initials rendered inside the avatar circle.
  String get initials {
    final name = _userName;
    if (name == null || name.isEmpty) {
      return 'G';
    }
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length == 1) {
      return parts.first.substring(0, 1).toUpperCase();
    }
    return '${parts.first.substring(0, 1)}${parts.last.substring(0, 1)}'
        .toUpperCase();
  }

  void signIn({required String userName}) {
    if (_isAuthenticated && _userName == userName) {
      return;
    }
    _isAuthenticated = true;
    _userName = userName;
    notifyListeners();
  }

  void signOut() {
    if (!_isAuthenticated) {
      return;
    }
    _isAuthenticated = false;
    _userName = null;
    notifyListeners();
  }
}
