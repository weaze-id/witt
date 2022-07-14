import 'package:collection/collection.dart';

import 'service_logger.dart';
import 'service_model.dart';
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
        return scope.services[serviceIndex].instance as T;
      }
    }

    return null;
  }

  /// Register a service to ServiceScopeManager.scopes.
  static void register<T extends Object>({
    required T Function() factoryFunction,
    required bool preventDuplicate,
  }) {
    ServiceScopeManager.initializeScope();

    final lastScope = ServiceScopeManager.scopes.last;

    // Throw exception if service already registered on latest scope.
    final isRegisteredOnLastScope =
        lastScope.services.where((e) => e.instanceType == T).firstOrNull;
    if (isRegisteredOnLastScope != null) {
      throw Exception(
        "$T is already registered, Only one $T can be registered per scope",
      );
    }

    // Throw exception if service already registered on previous scope
    // with `preventDuplicate` true.
    for (final scope in ServiceScopeManager.scopes) {
      final services = scope.services;
      for (final service in services) {
        if (service.preventDuplicate && service.instanceType == T) {
          throw Exception("$T is already registered on oldest scope");
        }
      }
    }

    ServiceLogger.log(T, LogType.created);

    lastScope.services.add(ServiceModel(
      instance: factoryFunction(),
      instanceType: T,
      preventDuplicate: preventDuplicate,
    ));
  }
}
