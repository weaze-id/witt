import 'package:flutter/material.dart';
import 'package:nested/nested.dart';

import 'w_provider_store.dart';

class WProvider<T extends Object> extends SingleChildStatelessWidget {
  const WProvider({
    Key? key,
    Widget? child,
    required this.create,
  }) : super(key: key, child: child);

  final T Function(BuildContext context) create;

  static T of<T extends Object>(BuildContext context) {
    return WProviderStore.of<T>(context);
  }

  static T? maybeOf<T extends Object>(BuildContext context) {
    return WProviderStore.maybeOf<T>(context);
  }

  static WProvider<T> builder<T extends Object>({
    required T Function(BuildContext context) service,
    required Widget Function(BuildContext context) builder,
  }) {
    return WProvider(
      create: service,
      child: Builder(builder: builder),
    );
  }

  @override
  Widget buildWithChild(BuildContext context, Widget? child) {
    return WProviderStore(
      service: create,
      child: child ?? const SizedBox(),
    );
  }
}
