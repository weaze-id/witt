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
class CounterController {
  final counter = ValueNotifier(0);

  void incrementCounter() {
    counter.value++;
  }
}

WProvider.builder(
  service: () => CounterController(),
  builder: (context) {
    final counterC = WServicWProvidere.of<CounterController>(context);
    return Scaffold(
        ...
        body: WListener(
          notifier: counterC.counter,
          builder: (context) {
            final counter = counterC.counter.value;
            return Text(counter.toString());
          },
        ),
        floationActionButton: FloationActionButton(
          onPressed: counterC.incrementCounter,
          child: const Icon(Icons.add),
        ),
    );
  },
)
```

### Routing

```dart
// Set `navigatorKey` with`WRouter.navigatorKey` and set onGenerateRoute.
return MaterialApp(
  navigatorKey: WRouter.navigatorKey,
  onGenerateRoute: (settings) => WRouter.onGenerateRoute(
    settings: settings,
    pages: [
      WPage(
        path: "/",
        builder: (context, args) => HomePage(args: args),
        providerBuilder: (context, args) {
          return [
            WProvider(service: () => Service1()),
            WProvider(service: () => Service2()),
          ];
        }
      )
    ],
  ),
);

// Push page
WRouter.pushNamed("/");
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

## Additional Information

This library is currently on experimental status and not ready for production. The API may change slightly when more features are added, and some use-cases may not be as simple as they could be.

## Contributing

Contributions are welcomed!

Here is a curated list of how you can help:

- Report bugs and scenarios that are difficult to implement
- Report parts of the documentation that are unclear
- Update the documentation / add examples
- Implement new features by making a pull-request
