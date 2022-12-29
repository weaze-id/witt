import 'package:flutter/material.dart';
import 'package:nested/nested.dart';

class WMultiProvider extends StatelessWidget {
  const WMultiProvider({
    Key? key,
    required this.providers,
    required this.child,
  }) : super(key: key);

  final List<SingleChildWidget> providers;
  final Widget child;

  static WMultiProvider builder({
    required List<SingleChildWidget> providers,
    required Widget Function(BuildContext context) builder,
  }) {
    return WMultiProvider(
      providers: providers,
      child: Builder(builder: builder),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Nested(
      children: providers,
      child: child,
    );
  }
}
