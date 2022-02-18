import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';

extension ValueNotifierListExtensions<T> on ValueNotifier<List<T>> {
  void add(T item) {
    value = [...value, item];
  }

  void addAll(Iterable<T> items) {
    value = [...value, ...items];
  }

  void clear() {
    value = [];
  }

  void removeAt(int index) {
    final newValue = [...value];
    newValue.removeAt(index);

    value = newValue;
  }

  T get first => value.first;

  T? get firstOrNull => value.firstOrNull;

  T get last => value.last;

  T? get lastOrNull => value.lastOrNull;
}
