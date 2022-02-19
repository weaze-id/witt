import 'package:collection/collection.dart';

class _Scope {
  final List<_Service<Object>> services;

  _Scope({required this.services});
}

class _Service<T extends Object> {
  final T object;

  _Service({required this.object});
}

class WService {
  static final _scopes = <_Scope>[];

  /// Push new scope if empty.
  static void _initializeScope() {
    if (_scopes.isEmpty) {
      pushScope();
    }
  }

  /// Find and return registered service.
  static T? _findService<T extends Object>() {
    _initializeScope();

    /// Reverse scope and check every scope if has requested service.
    final scopes = _scopes.reversed;
    for (final scope in scopes) {
      final registeredService =
          scope.services.where((e) => e.object.runtimeType == T).firstOrNull;

      if (registeredService != null) {
        return registeredService.object as T;
      }
    }
  }

  /// Push a new scope.
  static void pushScope() {
    _scopes.add(_Scope(services: []));
  }

  /// Register a singleton service.
  static void popScope() {
    if (_scopes.isEmpty) {
      throw Exception("Scope is empty");
    }

    _scopes.removeLast();
  }

  /// Register a singleton service.
  static void addSingleton<T extends Object>(T Function() builder) {
    _initializeScope();

    /// Get last scope and check if service already registered.
    final lastScope = _scopes.last;
    final isRegisteredOnLastScope = lastScope.services
            .where((e) => e.object.runtimeType == T)
            .firstOrNull !=
        null;

    if (isRegisteredOnLastScope) {
      throw Exception(
          "$T is already registered, Only one $T can be registered per scope");
    }

    /// Add service to last scope.
    lastScope.services.add(_Service(object: builder.call()));
  }

  /// Return true if service already registered.
  static bool isRegistered<T extends Object>() {
    return _findService<T>() != null;
  }

  /// Get registered service.
  static T get<T extends Object>() {
    _initializeScope();

    final registeredService = _findService<T>();
    if (registeredService == null) {
      throw Exception(
          "$T is not registered, Make sure you have register the $T by calling "
          "WService.addSingleton(() => <$T>())");
    }

    return registeredService;
  }
}
