# Witt

Simple state management powered by ValueNotifier and InheritedWidget.

## Getting started

Installing package

```bash
flutter pub add witt
flutter pub get
```

Import it

```bash
import 'package:witt/witt.dart
```

## Usage

### Basic usage

```dart
class CounterProvider {
  final counter = ValueNotifier(0);

  void incrementCounter() {
    counter.value++;
  }
}

...
 return WProvider(
  create: (context) => CounterProvider(),
  child: const MaterialApp(
    title: "Example App",
    home: HomePage(),
  ),
);

...

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final counterP = WProvider.of<CounterProvider>(context);
    return Scaffold(
      body: WListener(
        notifier: counterP.counter,
        builder: (context) {
          final counter = counterP.counter.value;
          return Text(counter.toString());
        },
      ),
      floationActionButton: FloationActionButton(
        onPressed: counterP.incrementCounter,
        child: const Icon(Icons.add),
      ),
    );
  }
}
```

## Important note

Widget will not be re-rendered if `WListener` return `const` widget.

```dart
WListener(
  notifier: counterP.counter,
  (context, value) => const _CounterText(),
);
...

// This widget will not be re-rendered.
class _CounterText extends StatelessWidget {
  const _CounterText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final counterP = WProvider.of<CounterProvider>(context);
    final counterValue = counterP.counter.value;

    return Center(child: Text(counterValue.toString()));
  }
}
```

## Additional Information

This library is currently on experimental status and not ready for production. The API may change slightly when more features are added, and some use-cases may not be as simple as they could be.

## Contributing

Contributions are welcomed!

Here is a curated list of how you can help:

- Report bugs and scenarios that are difficult to implement
- Report parts of the documentation that are unclear
- Update the documentation / add examples
- Implement new features by making a pull-request
