import 'package:flutter/material.dart';
import 'package:nested/nested.dart';

import 'w_provider_base.dart';

class WProvider<T extends Object> extends SingleChildStatelessWidget {
  const WProvider({
    Key? key,
    Widget? child,
    required this.service,
  }) : super(key: key, child: child);

  final T Function(BuildContext context) service;

  static T of<T extends Object>(BuildContext context) {
    return WProviderBase.of<T>(context);
  }

  static WProvider<T> builder<T extends Object>({
    required T Function(BuildContext context) service,
    required Widget Function(BuildContext context) builder,
  }) {
    return WProvider(
      service: service,
      child: Builder(builder: builder),
    );
  }

  @override
  Widget buildWithChild(BuildContext context, Widget? child) {
    return WProviderBase(
      service: service,
      child: child ?? const SizedBox(),
    );
  }
}
