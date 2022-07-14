import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';

extension ValueNotifierListExtensions<T> on ValueNotifier<List<T>> {
  void add(T item) {
    value = [...value, item];
  }

  void addAll(Iterable<T> items) {
    value = [...value, ...items];
  }

  void replaceAll(Iterable<T> items) {
    value = [...items];
  }

  void clear() {
    value = [];
  }

  void removeAt(int index) {
    final newValue = [...value];
    newValue.removeAt(index);

    value = newValue;
  }

  void updateAt(int index, T Function(T) newItem) {
    final newValue = [...value];
    newValue[index] = newItem(newValue[index]);

    value = newValue;
  }

  int indexWhere(bool Function(T) test, [int start = 0]) {
    return value.indexWhere(test, start);
  }

  Iterable<N> map<N>(N Function(T) toElement) {
    return value.map<N>(toElement);
  }

  Iterable<T> where(bool Function(T) test) {
    return value.where(test);
  }

  bool contains(Object? element) {
    return value.contains(element);
  }

  T get first => value.first;

  T? get firstOrNull => value.firstOrNull;

  T get last => value.last;

  T? get lastOrNull => value.lastOrNull;

  int get length => value.length;

  bool get isEmpty => value.isEmpty;

  bool get isNotEmpty => value.isNotEmpty;
}
