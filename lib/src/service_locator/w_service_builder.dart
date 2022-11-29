import 'package:flutter/widgets.dart';
import 'package:uuid/uuid.dart';

import 'w_service/w_service.dart';

/// Automatically push and pop scope.
class WServiceBuilder extends StatefulWidget {
  const WServiceBuilder({
    Key? key,
    required this.serviceBuilder,
    required this.builder,
  }) : super(key: key);

  /// A function for registering services.
  final void Function(BuildContext context) serviceBuilder;

  /// A widget to show.
  final Widget Function(BuildContext context) builder;

  @override
  State<WServiceBuilder> createState() => _WServiceBuilderState();
}

class _WServiceBuilderState extends State<WServiceBuilder> {
  late final String scopeName;

  @override
  void initState() {
    if (!WService.isRegistered<Uuid>()) {
      WService.addSingleton(() => const Uuid());
    }

    final uuid = WService.get<Uuid>();
    scopeName = uuid.v4();

    WService.pushScope(scopeName: scopeName);
    widget.serviceBuilder.call(context);

    super.initState();
  }

  @override
  void dispose() {
    WService.popScope(scopeName: scopeName);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context);
  }
}
