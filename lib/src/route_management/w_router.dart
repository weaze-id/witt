import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../depedency_injection/w_service_builder.dart';
import 'w_page.dart';

/// Manipulate route without using [BuildContext],
/// [navigatorKey] must be registered at [MaterialApp].
class WRouter {
  /// A navigator key.
  static final navigatorKey = GlobalKey<NavigatorState>();

  /// Push the given route onto the navigator.
  Future<T?> push<T extends Object?>(Route<T> route) {
    return navigatorKey.currentState!.push(route);
  }

  /// Push the given route onto the navigator.
  static Future<T?> pushCupertinoPage<T>({
    required Widget Function(BuildContext) builder,
    String? title,
    RouteSettings? settings,
    bool maintainState = true,
    bool fullscreenDialog = false,
  }) {
    return navigatorKey.currentState!.push(CupertinoPageRoute(
      builder: builder,
      title: title,
      settings: settings,
      maintainState: maintainState,
      fullscreenDialog: fullscreenDialog,
    ));
  }

  /// Push the given route onto the navigator.
  static Future<T?> pushMaterialPage<T>({
    required Widget Function(BuildContext) builder,
    RouteSettings? settings,
    bool maintainState = true,
    bool fullscreenDialog = false,
  }) {
    return navigatorKey.currentState!.push(MaterialPageRoute(
      builder: builder,
      settings: settings,
      maintainState: maintainState,
      fullscreenDialog: fullscreenDialog,
    ));
  }

  /// Push the given route onto the navigator.
  static Future<T?> pushNamed<T>(String routeName, {Object? arguments}) {
    return navigatorKey.currentState!.pushNamed(
      routeName,
      arguments: arguments,
    );
  }

  /// Push the given route onto the navigator.
  static void pop<T extends Object?>([T? result]) {
    navigatorKey.currentState!.pop();
  }

  /// Pop the current route off the navigator and push a named route in its
  /// place.
  static Future<T?> popAndPushNamed<T extends Object?, TO extends Object?>(
    String routeName, {
    TO? result,
    Object? arguments,
  }) {
    return navigatorKey.currentState!
        .popAndPushNamed(routeName, result: result, arguments: arguments);
  }

  /// Calls [pop] repeatedly until the predicate returns true.
  static void popUntil(bool Function(Route<dynamic>) predicate) {
    navigatorKey.currentState!.popUntil(predicate);
  }

  /// Calls [pop] repeatedly until the predicate returns true and push a
  /// named route.
  static Future<T?> popUntilAndPushNamed<T extends Object?, TO extends Object?>(
    bool Function(Route<dynamic>) predicate,
    String routeName, {
    Object? arguments,
  }) {
    popUntil(predicate);
    return pushNamed(routeName, arguments: arguments);
  }

  /// Calls [pop] repeatedly until all route popped and push a
  /// named route.
  static Future<T?> popAllAndPushNamed<T extends Object?, TO extends Object?>(
    String routeName, {
    Object? arguments,
  }) {
    return popUntilAndPushNamed((route) => false, routeName,
        arguments: arguments);
  }

  /// Generate material page route.
  static Route<dynamic>? onGenerateMaterialRoute({
    required RouteSettings settings,
    required List<WPage> pages,
  }) {
    for (final page in pages) {
      if (settings.name == page.path) {
        return MaterialPageRoute(
          builder: (context) => page.serviceBuilder != null
              ? WServiceBuilder(
                  serviceBuilder: page.serviceBuilder!,
                  child: page.builder(context, settings.arguments),
                )
              : page.builder(context, settings.arguments),
          settings: settings,
        );
      }
    }

    return null;
  }

  /// Generate cupertino page route.
  static Route<dynamic>? onGenerateCupertinoRoute({
    required RouteSettings settings,
    required List<WPage> pages,
  }) {
    for (final page in pages) {
      if (settings.name == page.path) {
        return CupertinoPageRoute(
          builder: (context) => page.serviceBuilder != null
              ? WServiceBuilder(
                  serviceBuilder: page.serviceBuilder!,
                  child: page.builder(context, settings.arguments),
                )
              : page.builder(context, settings.arguments),
          settings: settings,
        );
      }
    }

    return null;
  }
}
