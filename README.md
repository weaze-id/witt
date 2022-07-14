# Witt

Simple state management powered by ValueNotifier with service locator.

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
class CounterController {
  final counter = ValueNotifier(0);

  void incrementCounter() {
    counter.value++;
  }
}

// Register your service.
WService.addSingleton(() => CounterController());

// In your widget.
final counterC = WService.get<CounterController>();
return Scaffold(
    ...
    body: WListener(
      notifier: counterC.counter,
      builder: (context) => Text(counterC.counter.value.toString()),
    ),
);
```

### Routing

```dart
// Set `navigatorKey` with`WRouter.navigatorKey` and set onGenerateRoute.
return MaterialApp(
  navigatorKey: WRouter.navigatorKey,
  onGenerateRoute: (settings) => WRouter.onGenerateMaterialRoute(
    settings: settings,
    pages: [
      WPage(
        path: "/",
        builder: (context, args) => HomePage(args: args),
        serviceBuilder: (context, args) {
          WService.addSingleton(() => Service1());
          WService.addSingleton(() => Service2());
        }
      )
    ],
  ),
);

// Push page
WRouter.pushNamed("/");
```

### Listen to `ValueNotifier` using extensions

```dart
// Listen to single `ValueNotifer`
return counterC.counter.builder(
    (context, value) => Text(value.toString()),
);

// Listen to multiple `ValueNotifer`
return [
    counterC.counter,
    counterC.counter2,
    counterC.counter3,
].builder((context) {
    value = counterC.counter.value;
    value2 = counterC.counter2.value;
    value3 = counterC.counter3.value;

    return Column(children: [
        Text(value.toString()),
        Text(value2.toString()),
        Text(value3.toString()),
    ]);
});
```

## Important note

Widget will not be re-rendered if `WListener` return `const` widget.

```dart
WListener(
  notifier: counterC.counter,
  (context, value) => const _CounterText(),
);

...

// This widget will not be re-rendered.
class _CounterText extends StatelessWidget {
  const _CounterText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final counterC = WService.get<CounterController>();
    final counterValue = counterC.counter.value;

    return Center(child: Text(counterValue.toString()));
  }
}
```

## Motivation

The main idea of ​​this library being created is to manage state, dependency injection and routes in one library without bloated features.

## Additional Information

This library is currently on experimental status and not ready for production. The API may change slightly when more features are added, and some use-cases may not be as simple as they could be.

## Contributing

Contributions are welcomed!

Here is a curated list of how you can help:

- Report bugs and scenarios that are difficult to implement
- Report parts of the documentation that are unclear
- Update the documentation / add examples
- Implement new features by making a pull-request
