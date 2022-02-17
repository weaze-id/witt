import 'package:flutter/widgets.dart';

/// Rebuild widget when notifier is notified.
class WListener extends StatefulWidget {
  const WListener({
    Key? key,
    required this.notifier,
    this.conditions,
    required this.builder,
  }) : super(key: key);

  /// A notifier.
  ///
  /// It can be a [ChangeNotifier], [ValueNotifier] or any other
  /// class that implements [Listenable]
  final Listenable notifier;

  /// If true and when notifier is notified, the widget will be rebuilt.
  /// `true` will be used if null.
  final bool Function()? conditions;

  final Widget Function(BuildContext context) builder;

  @override
  State<StatefulWidget> createState() => _WListenerState();
}

class _WListenerState<T> extends State<WListener> {
  @override
  void initState() {
    widget.notifier.addListener(_onValueChanged);
    super.initState();
  }

  @override
  void didUpdateWidget(WListener oldWidget) {
    if (oldWidget.notifier != widget.notifier) {
      oldWidget.notifier.removeListener(_onValueChanged);
      widget.notifier.addListener(_onValueChanged);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    widget.notifier.removeListener(_onValueChanged);
    super.dispose();
  }

  void _onValueChanged() {
    if (widget.conditions?.call() ?? true) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context);
  }
}
