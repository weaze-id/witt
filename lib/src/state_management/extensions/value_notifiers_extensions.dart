import 'package:flutter/widgets.dart';

import '../index.dart';

extension ValueNotifiersExtensions<T> on List<ValueNotifier<T>> {
  Widget builder(Widget Function(BuildContext context) builder) {
    return WMultiListener(
      notifiers: this,
      builder: (context) => builder(context),
    );
  }
}
