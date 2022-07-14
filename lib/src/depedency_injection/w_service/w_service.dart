import 'service_manager.dart';
import 'service_scope_manager.dart';

class WService {
  static bool enableLog = true;

  /// Push a new scope.
  static void pushScope({String? scopeName}) {
    ServiceScopeManager.pushScope(scopeName: scopeName);
  }

  /// Pop scope.
  static void popScope({String? scopeName}) {
    ServiceScopeManager.popScope(scopeName: scopeName);
  }

  /// Get registered service.
  static T get<T extends Object>() {
    final registeredService = ServiceManager.findService<T>();
    if (registeredService == null) {
      throw Exception(
        "$T is not registered, Make sure you have register the $T by calling "
        "WService.addSingleton(() => $T()) or "
        "WService.addLazySingleton(() => $T())",
      );
    }

    return registeredService;
  }

  /// Return true if service already registered.
  static bool isRegistered<T extends Object>() {
    return ServiceManager.findService<T>() != null;
  }

  /// Register a singleton service.
  static void addSingleton<T extends Object>(
    T Function() factoryFunction, {
    bool preventDuplicate = true,
  }) {
    ServiceManager.register(
      factoryFunction: factoryFunction,
      preventDuplicate: preventDuplicate,
    );
  }
}
