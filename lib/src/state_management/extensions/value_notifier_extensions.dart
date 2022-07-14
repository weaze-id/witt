import 'package:flutter/widgets.dart';

import '../index.dart';

extension ValueNotifierExtensions<T> on ValueNotifier<T> {
  Widget builder(Widget Function(BuildContext context, T value) builder) {
    return WListener(
      notifier: this,
      builder: (context) => builder(context, value),
    );
  }
}
