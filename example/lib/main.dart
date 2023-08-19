import 'package:flutter/material.dart';
import 'package:witt/witt.dart';

void main() {
  runApp(const MyApp());
}

class Counter1Provider {
  final counter = ValueNotifier(0);

  void incrementCounter() {
    counter.value++;
  }
}

class Counter2Provider {
  final counter = ValueNotifier(0);

  void incrementCounter() {
    counter.value++;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WMultiProvider(
      providers: [
        WProvider(create: (context) => Counter1Provider()),
        WProvider(create: (context) => Counter2Provider()),
      ],
      child: const MaterialApp(
        title: "Example App",
        home: HomePage(),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final counter1P = WProvider.of<Counter1Provider>(context);
    final counter2P = WProvider.of<Counter2Provider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Counter App")),
      body: WListener(
        notifiers: [
          counter1P.counter,
          counter2P.counter,
        ],
        builder: (context) {
          final counter1 = counter1P.counter.value;
          final counter2 = counter2P.counter.value;

          return Column(
            children: [
              Text(counter1.toString()),
              ElevatedButton(
                onPressed: counter1P.incrementCounter,
                child: const Text("Increment"),
              ),
              const SizedBox(height: 32),
              Text(counter2.toString()),
              ElevatedButton(
                onPressed: counter2P.incrementCounter,
                child: const Text("Increment"),
              ),
            ],
          );
        },
      ),
    );
  }
}
