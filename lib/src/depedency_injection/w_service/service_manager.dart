import 'package:collection/collection.dart';

import 'models/service.dart';
import 'service_logger.dart';
import 'service_scope_manager.dart';

class ServiceManager {
  /// Find and return registered service.
  static T? findService<T extends Object>() {
    ServiceScopeManager.initializeScope();

    // Reverse scope and check every scope if has requested service.
    final reversedScopes = ServiceScopeManager.scopes.reversed;
    for (final scope in reversedScopes) {
      final serviceIndex =
          scope.services.indexWhere((e) => e.instanceType == T);

      if (serviceIndex != -1) {
        // If registered service is lazy and hasn't been initialize yet.
        if (scope.services[serviceIndex].instance == null &&
            scope.services[serviceIndex].isLazy) {
          final service = scope.services[serviceIndex].factoryFunction();
          scope.services[serviceIndex] =
              scope.services[serviceIndex].copyWith(instance: service);

          ServiceLogger.log(T, LogType.created);
        }

        return scope.services[serviceIndex].instance as T;
      }
    }

    return null;
  }

  /// Register a service to ServiceScopeManager.scopes.
  static void register<T extends Object>({
    required T Function() factoryFunction,
    required bool isLazy,
    required bool preventDuplicate,
  }) {
    ServiceScopeManager.initializeScope();

    final lastScope = ServiceScopeManager.scopes.last;

    // Throw exception if service already registered on latest scope.
    final isRegisteredOnLastScope =
        lastScope.services.where((e) => e.instanceType == T).firstOrNull;
    if (isRegisteredOnLastScope != null) {
      throw Exception(
          "$T is already registered, Only one $T can be registered per scope");
    }

    // Throw exception if service already registered on previous scope
    // with `preventDuplicate` true.
    if (ServiceScopeManager.uniqueService.contains(T)) {
      throw Exception("$T is already registered on oldest scope");
    }

    ServiceLogger.log(T, LogType.registered);

    // Add this service type to `ServiceScopeManager.uniqueService` if
    // preventDuplicate is true.
    if (preventDuplicate) {
      ServiceScopeManager.uniqueService.add(T);
    }

    if (isLazy) {
      lastScope.services.add(Service(
        instance: null,
        instanceType: T,
        factoryFunction: factoryFunction,
        isLazy: isLazy,
      ));

      return;
    }

    ServiceLogger.log(T, LogType.created);

    lastScope.services.add(Service(
      instance: factoryFunction(),
      instanceType: T,
      factoryFunction: factoryFunction,
      isLazy: isLazy,
    ));
  }
}
