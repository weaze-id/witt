import 'package:flutter/widgets.dart';

/// Rebuild widget when any of notifiers are notified.
class WMultiListener extends StatefulWidget {
  const WMultiListener({
    Key? key,
    required this.notifiers,
    required this.builder,
  }) : super(key: key);

  /// A list of notifiers.
  ///
  /// It can be a list of [ChangeNotifier], [ValueNotifier] or any other
  /// class that implements [Listenable]
  final List<Listenable> notifiers;

  /// A widget builder.
  final Widget Function(BuildContext context) builder;

  @override
  State<StatefulWidget> createState() => _WMultiListenerState();
}

class _WMultiListenerState extends State<WMultiListener> {
  @override
  void initState() {
    for (final value in widget.notifiers) {
      value.addListener(_onValueChanged);
    }
    super.initState();
  }

  @override
  void didUpdateWidget(WMultiListener oldWidget) {
    if (oldWidget.notifiers != widget.notifiers) {
      for (final value in oldWidget.notifiers) {
        value.removeListener(_onValueChanged);
      }
      for (final value in widget.notifiers) {
        value.addListener(_onValueChanged);
      }
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    for (final value in widget.notifiers) {
      value.removeListener(_onValueChanged);
    }
    super.dispose();
  }

  void _onValueChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context);
  }
}
