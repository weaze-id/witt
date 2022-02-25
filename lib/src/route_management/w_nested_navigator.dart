import 'package:flutter/material.dart';

import '../../witt.dart';

class _RouteObserver extends RouteObserver<PageRoute<dynamic>> {
  final void Function(String? routeName)? onRouteChanged;

  _RouteObserver({this.onRouteChanged});

  void _onRouteChangedHandler(PageRoute<dynamic> route) {
    var routeName = route.settings.name;
    onRouteChanged?.call(routeName);
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    if (route is PageRoute) {
      _onRouteChangedHandler(route);
    }
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (newRoute is PageRoute) {
      _onRouteChangedHandler(newRoute);
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    if (previousRoute is PageRoute && route is PageRoute) {
      _onRouteChangedHandler(previousRoute);
    }
  }
}

/// [Navigator] wrapper.
///
/// Creates a widget that maintains a stack-based history of child widgets.
class WNestedNavigator extends StatelessWidget {
  const WNestedNavigator({
    Key? key,
    required this.nestedKeyLabel,
    this.initialRoute,
    this.onGenerateInitialRoutes = Navigator.defaultGenerateInitialRoutes,
    this.onGenerateRoute,
    this.onUnknownRoute,
    this.transitionDelegate = const DefaultTransitionDelegate<dynamic>(),
    this.onRouteChanged,
  }) : super(key: key);

  /// Used for [WRouter.addNestedKey(label)].
  final String nestedKeyLabel;

  /// The name of the first route to show.
  final String? initialRoute;

  /// Called when the widget is created to generate the initial list of
  /// [Route] objects if [initialRoute] is not null.
  final List<Route<dynamic>> Function(NavigatorState, String)
      onGenerateInitialRoutes;

  /// Called to generate a route for a given [RouteSettings].
  final Route<dynamic>? Function(RouteSettings)? onGenerateRoute;

  /// Called when [onGenerateRoute] fails to generate a route.
  final Route<dynamic>? Function(RouteSettings)? onUnknownRoute;

  /// The delegate used for deciding how routes transition in or off the
  /// screen during the [pages] updates.
  final TransitionDelegate<dynamic> transitionDelegate;

  /// A callback when route stack is changed.
  final void Function(String? routeName)? onRouteChanged;

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: WRouter.addNestedKey(nestedKeyLabel),
      observers: [_RouteObserver(onRouteChanged: onRouteChanged)],
      initialRoute: initialRoute,
      onGenerateInitialRoutes: onGenerateInitialRoutes,
      onGenerateRoute: onGenerateRoute,
      onUnknownRoute: onUnknownRoute,
      transitionDelegate: transitionDelegate,
    );
  }
}
