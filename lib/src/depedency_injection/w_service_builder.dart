import 'package:flutter/widgets.dart';

import 'w_service.dart';

/// Automatically push and pop [GetIt] scope.
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
  @override
  void initState() {
    widget.onWillPush?.call();
    WService.pushScope();
    widget.serviceBuilder.call(context);

    super.initState();
  }

  @override
  void dispose() {
    widget.onWillPop?.call();
    WService.popScope();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
