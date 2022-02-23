import 'package:flutter/material.dart';
import 'package:witt/witt.dart';

import 'home_page.dart';
import 'home_page_controller.dart';

void main() {
  WService.enableLog = true;
  WService.addLazySingleton(() => HomePageController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: WRouter.navigatorKey,
      title: "Example App",
      home: const HomePage(),
    );
  }
}
