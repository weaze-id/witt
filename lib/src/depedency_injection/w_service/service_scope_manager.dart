import '../w_disposable.dart';
import 'models/service_scope.dart';
import 'service_logger.dart';

class ServiceScopeManager {
  static final scopes = <ServiceScope>[];
  static final uniqueService = <Type>[];

  /// Push new scope if empty.
  static void initializeScope() {
    if (ServiceScopeManager.scopes.isEmpty) {
      pushScope();
    }
  }

  /// Push a new scope.
  static void pushScope({String? scopeName}) {
    scopes.add(ServiceScope(name: scopeName, services: []));
  }

  /// Pop scope.
  static void popScope({String? scopeName}) {
    if (scopes.isEmpty) {
      throw Exception("Scope is empty");
    }

    late final int scopeIndex;
    late final ServiceScope scope;

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
      // Remove service from `uniqueService` if is registered with
      // `preventDuplicate` true.
      if (uniqueService.contains(service.instanceType)) {
        uniqueService.removeWhere((e) => e == service.instanceType);
      }

      // Call `dispose()` if service is implements `WDisposable`.
      if (service.instance != null && service.instance is WDisposable) {
        (service.instance as WDisposable).dispose();
      }

      ServiceLogger.log(service.instanceType, LogType.disposed);
    }

    // Finally remove scope at scopeIndex, or remove last scope.
    if (scopeName != null) {
      scopes.removeAt(scopeIndex);
      return;
    }

    scopes.removeLast();
  }
}
