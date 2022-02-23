import 'package:flutter/foundation.dart';
import 'package:witt/witt.dart';

class HomePageController extends WDisposable {
  HomePageController() {
    counter.value++;
  }

  final counter = ValueNotifier(0);

  void incrementCounter() {
    counter.value++;
  }

  @override
  void initialize() {
    print("on init");
  }

  @override
  void dispose() {
    print("on dispose");
  }
}
