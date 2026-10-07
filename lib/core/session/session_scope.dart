import 'package:flutter/widgets.dart';

import 'session_store.dart';

/// Exposes the [SessionStore] to the widget tree.
///
/// A tiny `InheritedNotifier` is used on purpose instead of pulling in the
/// `provider` package: it keeps dependencies minimal, gives the session a
/// well-defined scope, and offers both a reactive read ([of]) and a non
/// listening read ([read]) for event handlers.
class SessionScope extends InheritedNotifier<SessionStore> {
  const SessionScope({
    required super.notifier,
    required super.child,
    super.key,
  });

  /// Subscribes the calling widget to session changes (use inside `build`).
  static SessionStore of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<SessionScope>();
    assert(scope != null, 'SessionScope is missing from the widget tree.');
    return scope!.notifier!;
  }

  /// Reads the session without subscribing (use in callbacks / `initState`).
  static SessionStore read(BuildContext context) {
    final scope = context.getInheritedWidgetOfExactType<SessionScope>();
    assert(scope != null, 'SessionScope is missing from the widget tree.');
    return scope!.notifier!;
  }
}
