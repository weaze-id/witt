import 'package:flutter/foundation.dart';

class HomePageController {
  HomePageController() {
    counter.value++;
  }

  final counter = ValueNotifier(0);

  void incrementCounter() {
    counter.value++;
  }
}
