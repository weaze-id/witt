import 'package:flutter/foundation.dart';

class HomePageController {
  String? currentRouteName;

  final counter = ValueNotifier(0);

  void incrementCounter() {
    counter.value++;
  }
}
