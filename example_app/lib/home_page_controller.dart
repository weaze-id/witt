import 'package:flutter/foundation.dart';
import 'package:witt/witt.dart';

class HomePageController {
  String? currentRouteName;

  final counter = ValueNotifier(0);
  final list = ValueNotifier<List<int>>([]);

  void incrementCounter() {
    counter.value++;
  }

  void addItem() {
    list.add(0);
  }
}
