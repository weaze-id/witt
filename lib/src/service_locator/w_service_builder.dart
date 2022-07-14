import 'dart:math';

import 'package:flutter/widgets.dart';

import 'w_service/w_service.dart';

/// Automatically push and pop scope.
class WServiceBuilder extends StatefulWidget {
  const WServiceBuilder({
    Key? key,
    required this.serviceBuilder,
    this.onWillPush,
    this.onWillPop,
    required this.child,
  }) : super(key: key);

  /// A function for registering services.
  final void Function(BuildContext context) serviceBuilder;

  /// A function called before [GetIt] pushed.
  final void Function()? onWillPush;

  /// A function called before [GetIt] popped.
  final void Function()? onWillPop;

  /// A widget to show.
  final Widget child;

  @override
  State<WServiceBuilder> createState() => _WServiceBuilderState();
}

class _WServiceBuilderState extends State<WServiceBuilder> {
  late final String scopeName;

  @override
  void initState() {
    scopeName = _generateScopeName();

    widget.onWillPush?.call();
    WService.pushScope(scopeName: scopeName);
    widget.serviceBuilder.call(context);

    super.initState();
  }

  @override
  void dispose() {
    widget.onWillPop?.call();
    WService.popScope(scopeName: scopeName);

    super.dispose();
  }

  String _generateScopeName() {
    var r = Random();
    return String.fromCharCodes(
      List.generate(5, (index) => r.nextInt(33) + 89),
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
