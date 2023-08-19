import 'dart:developer';

import 'package:flutter/material.dart';

import 'w_disposable.dart';

class WProviderStore<T extends Object> extends StatefulWidget {
  const WProviderStore({
    Key? key,
    required this.service,
    required this.child,
  }) : super(key: key);

  final T Function(BuildContext context) service;
  final Widget child;

  static T of<T extends Object>(BuildContext context) {
    return _GenericInheritedWidget.of<T>(context);
  }

  @override
  State<WProviderStore<T>> createState() => _WProviderStoreState<T>();
}

class _WProviderStoreState<T extends Object> extends State<WProviderStore<T>> {
  late T value;

  @override
  void initState() {
    value = widget.service.call(context);
    log("Initializing $T", name: "Witt");

    super.initState();
  }

  @override
  void dispose() {
    if (value is WDisposable) {
      (value as WDisposable).dispose();
    }

    log("Disposing $T", name: "Witt");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _GenericInheritedWidget<T>(
      value: value,
      child: widget.child,
    );
  }
}

class _GenericInheritedWidget<T extends Object> extends InheritedWidget {
  const _GenericInheritedWidget({
    Key? key,
    required this.value,
    required Widget child,
  }) : super(key: key, child: child);

  final T value;

  static T of<T extends Object>(BuildContext context) {
    final result = context
        .dependOnInheritedWidgetOfExactType<_GenericInheritedWidget<T>>();
    assert(result != null, 'No $T found in context');

    return result!.value;
  }

  @override
  bool updateShouldNotify(_GenericInheritedWidget<T> old) => value != old.value;
}
