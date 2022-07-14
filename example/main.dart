import 'package:flutter/material.dart';
import 'package:witt/witt.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Example App",
      home: WServiceBuilder(
        serviceBuilder: (context) {
          WService.addSingleton(() => CounterController());
        },
        child: const HomePage(),
      ),
    );
  }
}

class CounterController {
  final counter = ValueNotifier(0);

  void incrementCounter() {
    counter.value++;
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get CounterController instance from service locator.
    final counterC = WService.get<CounterController>();
    return Scaffold(
      appBar: AppBar(title: const Text("Counter App")),
      body: Center(
        // Listen to ValueNotifier.
        child: WListener(
          notifier: counterC.counter,
          builder: (context) => Text(counterC.counter.value.toString()),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        // Increment the counter.
        onPressed: counterC.incrementCounter,
        child: const Icon(Icons.add),
      ),
    );
  }
}
