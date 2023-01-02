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
    return const MaterialApp(
      title: "Example App",
      home: HomePage(),
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
    return Scaffold(
      appBar: AppBar(title: const Text("Counter App")),
      body: WMultiProvider.builder(
        providers: [
          WProvider(service: (context) => CounterController()),
        ],
        builder: (context) {
          final counterC = WProvider.of<CounterController>(context);
          return WListener(
            notifier: counterC.counter,
            builder: (context) => Column(
              children: [
                Text(counterC.counter.value.toString()),
                ElevatedButton(
                  onPressed: counterC.incrementCounter,
                  child: const Text("Increment"),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
