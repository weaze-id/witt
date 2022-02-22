import 'dart:developer';

import 'package:collection/collection.dart';

import 'w_disposable.dart';

class _Scope {
  String? name;
  final List<_Service<Object>> services;

  _Scope({
    this.name,
    required this.services,
  });

  _Scope copyWith({
    String? name,
    List<_Service<Object>>? services,
  }) {
    return _Scope(
      name: name ?? this.name,
      services: services ?? this.services,
    );
  }
}

class _Service<T extends Object> {
  final T? instance;
  final Type instanceType;
  final T Function() factoryFunction;
  final bool isLazy;

  _Service({
    required this.instance,
    required this.instanceType,
    required this.factoryFunction,
    required this.isLazy,
  });

  _Service<T> copyWith({
    T? instance,
    Type? instanceType,
    T Function()? factoryFunction,
    bool? isLazy,
  }) {
    return _Service<T>(
      instance: instance ?? this.instance,
      instanceType: instanceType ?? this.instanceType,
      factoryFunction: factoryFunction ?? this.factoryFunction,
      isLazy: isLazy ?? this.isLazy,
    );
  }
}

enum _LogType { created, disposed, registered }

class WService {
  static bool enableLog = false;
  static final _scopes = <_Scope>[];

  static void _log(Type instanceType, _LogType logType) {
    if (!enableLog) {
      return;
    }

    switch (logType) {
      case _LogType.created:
        log("Creating $instanceType.", name: "WService");
        break;
      case _LogType.disposed:
        log("Disposing $instanceType.", name: "WService");
        break;
      case _LogType.registered:
        log("Registering $instanceType.", name: "WService");
        break;
      default:
    }
  }

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
      final serviceIndex =
          scope.services.indexWhere((e) => e.instanceType == T);

      if (serviceIndex != -1) {
        final registeredService = scope.services[serviceIndex];
        // If registered service is lazy and hasn't been initialize yet.
        if (registeredService.instance == null && registeredService.isLazy) {
          final service = registeredService.factoryFunction();
          scope.services[serviceIndex] =
              registeredService.copyWith(instance: service);

          _log(T, _LogType.created);
        }

        return scope.services[serviceIndex].instance as T;
      }
    }

    return null;
  }

  /// Register a service to _scopes.
  static void _register<T extends Object>({
    required T Function() factoryFunction,
    required bool isLazy,
  }) {
    _initializeScope();

    /// Get last scope and check if service already registered.
    final lastScope = _scopes.last;
    final isRegisteredOnLastScope = lastScope.services
            .where((e) => e.instanceType == T.runtimeType)
            .firstOrNull !=
        null;

    if (isRegisteredOnLastScope) {
      throw Exception(
          "$T is already registered, Only one $T can be registered per scope");
    }

    _log(T, _LogType.registered);

    if (isLazy) {
      lastScope.services.add(_Service(
        instance: null,
        instanceType: T,
        factoryFunction: factoryFunction,
        isLazy: isLazy,
      ));

      return;
    }

    _log(T, _LogType.created);

    lastScope.services.add(_Service(
      instance: factoryFunction(),
      instanceType: T,
      factoryFunction: factoryFunction,
      isLazy: isLazy,
    ));
  }

  /// Push a new scope.
  static void pushScope({String? scopeName}) {
    _scopes.add(_Scope(name: scopeName, services: []));
  }

  /// Pop scope.
  static void popScope({String? scopeName}) {
    if (_scopes.isEmpty) {
      throw Exception("Scope is empty");
    }

    late final int scopeIndex;
    late final _Scope scopes;
    if (scopeName != null) {
      for (int i = _scopes.length - 1; i >= 0; i--) {
        final scope = _scopes[i];
        if (scope.name == scopeName) {
          scopeIndex = i;
          scopes = _scopes[i];
        }
      }
    } else {
      scopes = _scopes.last;
    }

    for (final service in scopes.services) {
      if (service.instance != null && service.instance is WDisposable) {
        (service.instance as WDisposable).dispose();
      }

      _log(service.instanceType, _LogType.disposed);
    }

    if (scopeName != null) {
      _scopes.removeAt(scopeIndex);
      return;
    }

    _scopes.removeLast();
  }

  /// Register a singleton service.
  static void addSingleton<T extends Object>(T Function() factoryFunction) {
    _register(factoryFunction: factoryFunction, isLazy: false);
  }

  /// Register a lazy singleton service, the service will be initialize when
  /// [get] or [isRegistered] called.
  static void addLazySingleton<T extends Object>(T Function() factoryFunction) {
    _register(factoryFunction: factoryFunction, isLazy: true);
  }

  /// Return true if service already registered.
  static bool isRegistered<T extends Object>() {
    return _findService<T>() != null;
  }

  /// Get registered service.
  static T get<T extends Object>() {
    final registeredService = _findService<T>();
    if (registeredService == null) {
      throw Exception(
          "$T is not registered, Make sure you have register the $T by calling "
          "WService.addSingleton(() => $T()) or "
          "WService.addLazySingleton(() => $T())");
    }

    return registeredService;
  }
}
