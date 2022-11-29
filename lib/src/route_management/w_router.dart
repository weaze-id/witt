import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../service_locator/w_service_builder.dart';
import 'w_page.dart';

/// Manipulate route without using [BuildContext],
/// [navigatorKey] must be registered at [MaterialApp].
class WRouter {
  /// A navigator key.
  static final navigatorKey = GlobalKey<NavigatorState>();

  /// A navigator key for nested navigation.
  static final _nestedKeys = Map<String, GlobalKey<NavigatorState>>();

  /// Add nested key.
  static GlobalKey<NavigatorState> addNestedKey(String label) {
    if (!_nestedKeys.containsKey(label)) {
      _nestedKeys.addAll({label: GlobalKey<NavigatorState>()});
    }

    return _nestedKeys[label]!;
  }

  /// Remove nested key.
  static void removeNestedKey(String label) {
    _nestedKeys.remove(label);
  }

  /// Push the given route onto the navigator.
  static Future<T?> push<T extends Object?>(Route<T> route) {
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
  static Future<T?> pushNamed<T>(
    String routeName, {
    Object? arguments,
    String? nestedKeyLabel,
  }) {
    final key =
        nestedKeyLabel != null ? _nestedKeys[nestedKeyLabel] : navigatorKey;
    return key!.currentState!.pushNamed(routeName, arguments: arguments);
  }

  /// Pop the top-most route off the navigator.
  static void pop<T extends Object?>({
    T? result,
    String? nestedKeyLabel,
  }) {
    final key =
        nestedKeyLabel != null ? _nestedKeys[nestedKeyLabel] : navigatorKey;
    key!.currentState!.pop(result);
  }

  /// Pop the current route off the navigator and push a named route in its
  /// place.
  static Future<T?> popAndPushNamed<T extends Object?, TO extends Object?>(
    String routeName, {
    TO? result,
    Object? arguments,
    String? nestedKeyLabel,
  }) {
    final key =
        nestedKeyLabel != null ? _nestedKeys[nestedKeyLabel] : navigatorKey;
    return key!.currentState!
        .popAndPushNamed(routeName, result: result, arguments: arguments);
  }

  /// Replace the current route of the navigator by pushing the route
  /// named [routeName] and then disposing the previous route once the
  /// new route has finished animating in.
  static Future<T?> pushReplacementNamed<T extends Object?, TO extends Object?>(
    String routeName, {
    TO? result,
    Object? arguments,
    String? nestedKeyLabel,
  }) {
    final key =
        nestedKeyLabel != null ? _nestedKeys[nestedKeyLabel] : navigatorKey;
    return key!.currentState!
        .pushReplacementNamed(routeName, result: result, arguments: arguments);
  }

  /// Calls [pop] repeatedly until the predicate returns true.
  static void popUntil(
    bool Function(Route<dynamic>) predicate, {
    String? nestedKeyLabel,
  }) {
    final key =
        nestedKeyLabel != null ? _nestedKeys[nestedKeyLabel] : navigatorKey;
    key!.currentState!.popUntil(predicate);
  }

  /// Push the route with the given name onto the navigator, and then remove
  /// all the previous routes until the predicate returns true.
  static Future<T?>
      pushNamedAndRemoveUntil<T extends Object?, TO extends Object?>(
    String newRouteName,
    bool Function(Route<dynamic>) predicate, {
    Object? arguments,
    String? nestedKeyLabel,
  }) {
    final key =
        nestedKeyLabel != null ? _nestedKeys[nestedKeyLabel] : navigatorKey;
    return key!.currentState!
        .pushNamedAndRemoveUntil(newRouteName, predicate, arguments: arguments);
  }

  /// Push the route with the given name onto the navigator, and then remove
  /// all the previous routes.
  static Future<T?>
      pushNamedAndRemoveAll<T extends Object?, TO extends Object?>(
    String routeName, {
    Object? arguments,
    String? nestedKeyLabel,
  }) {
    return pushNamedAndRemoveUntil(routeName, (route) => false,
        arguments: arguments, nestedKeyLabel: nestedKeyLabel);
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
                  serviceBuilder: (context) =>
                      page.serviceBuilder!.call(context, settings.arguments),
                  builder: (context) =>
                      page.builder(context, settings.arguments),
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
                  serviceBuilder: (context) =>
                      page.serviceBuilder!.call(context, settings.arguments),
                  builder: (context) =>
                      page.builder(context, settings.arguments),
                )
              : page.builder(context, settings.arguments),
          settings: settings,
        );
      }
    }

    return null;
  }
}
