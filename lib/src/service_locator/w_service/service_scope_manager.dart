import '../w_disposable.dart';
import 'service_logger.dart';
import 'service_scope_model.dart';

class ServiceScopeManager {
  static final scopes = <ServiceScopeModel>[];

  /// Push new scope if empty.
  static void initializeScope() {
    if (ServiceScopeManager.scopes.isEmpty) {
      pushScope();
    }
  }

  /// Push a new scope.
  static void pushScope({String? scopeName}) {
    scopes.add(ServiceScopeModel(name: scopeName, services: []));
  }

  /// Pop scope.
  static void popScope({String? scopeName}) {
    if (scopes.isEmpty) {
      throw Exception("Scope is empty");
    }

    late final int scopeIndex;
    late final ServiceScopeModel scope;

    if (scopeName != null) {
      // Scan _scopes from end to start, and compare the name.
      for (int i = scopes.length - 1; i >= 0; i--) {
        if (scopes[i].name == scopeName) {
          scopeIndex = i;
          scope = scopes[i];
        }
      }
    } else {
      // If scopeName is null, assign last scope.
      scope = scopes.last;
    }

    // Get all service on this scopes.
    for (final service in scope.services) {
      // Call `dispose()` if service is implements `WDisposable`.
      if (service.instance != null && service.instance is WDisposable) {
        (service.instance as WDisposable).dispose();
      }

      ServiceLogger.log(service.instanceType, LogType.disposed);
    }

    // Finally remove scope at scopeIndex.
    if (scopeName != null) {
      scopes.removeAt(scopeIndex);
      return;
    }

    // or remove last scope.
    scopes.removeLast();
  }
}
