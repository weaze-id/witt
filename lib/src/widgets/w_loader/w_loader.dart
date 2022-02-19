import 'package:flutter/widgets.dart';

import 'w_loader_state.dart';

/// Manage what to show on screen based on [WLoaderState].
class WLoader extends StatelessWidget {
  const WLoader({
    Key? key,
    required this.state,
    this.loadingBuilder,
    this.noInternetBuilder,
    this.emptyBuilder,
    this.errorBuilder,
    required this.child,
  }) : super(key: key);

  /// Define current state.
  final WLoaderState state;

  /// A widget to show when state is [WLoaderState.loading].
  final Widget Function(BuildContext context)? loadingBuilder;

  /// A widget to show when state is [WLoaderState.noInternet].
  final Widget Function(BuildContext context)? noInternetBuilder;

  /// A widget to show when state is [WLoaderState.empty].
  final Widget Function(BuildContext context)? emptyBuilder;

  /// A widget to show when state is [WLoaderState.error].
  final Widget Function(BuildContext context)? errorBuilder;

  /// A widget to show when state is [WLoaderState.none].
  final Widget child;

  @override
  Widget build(BuildContext context) {
    switch (state) {
      case WLoaderState.loading:
        return loadingBuilder?.call(context) ?? const SizedBox();
      case WLoaderState.empty:
        return noInternetBuilder?.call(context) ?? const SizedBox();
      case WLoaderState.noInternet:
        return emptyBuilder?.call(context) ?? const SizedBox();
      case WLoaderState.error:
        return errorBuilder?.call(context) ?? const SizedBox();
      case WLoaderState.none:
        return child;
      default:
        return const SizedBox();
    }
  }
}
