# Witt

Simple state management powered by ValueNotifier with depedency injection.

## Features

1. State management
2. Depedency Injection
3. Route management

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

### State management

Create a class that extends ValueNotifier or create a final ValueNotifier variable

```dart
final counter = ValueNotifier(0);

// or
class CounterController {
  final counter = ValueNotifier(0);

  void incrementCounter() {
    counter.value++;
  }
}
```

Listen to value change by using `WListener` or `WMultiListener`

```dart
WListener(
  notifier: CounterController.counter,
  builder: (context) => Text(CounterController.counter.value.toString()),
);

// or
WMultiListener(
  notifiers: [CounterController.counter],
  builder: (context) => Text(CounterController.counter.value.toString()),
);
```

### Depedency injection

Register an object to depedency injection

```dart
WService.addSingleton(() => CounterController());
```

Get a registered object

```dart
final counterC = WService.get<CounterController>();
```

### Depedency injection scope

By wrapping page/widget using `WServiceBuilder`, your object will be automatically registered/unregistered when the page/widget appear/disappear from the widget tree by managing depedency injection scope for you.

```dart
WServiceBuilder(
  serviceBuilder: () {},
  child: HomePage(),
);
```

Register the object on `serviceBuilder` property

```dart
WServiceBuilder(
  serviceBuilder: () {
    WService.addSingleton(() => CounterController());
  },
  child: HomePage(),
);
```

Or you can manage the scope by your self

Pushing new scope

```dart
WService.pushScope();

// or
WService.pushScope(scopeName: "My scope");
```

Popping scope

```dart
WService.popScope();

// or
WService.popScope(scopeName: "My scope");
```

When you are trying to get the registered object, Witt will find the object from newest scope, so older object will be shadowed.

### Route management

Register `WRouter.navigatorKey` on `MaterialApp` or `CupertinoApp`

```dart
return MaterialApp(
  navigatorKey: WRouter.navigatorKey,
  title: "My Awesome App",
  home: const HomePage(),
);
```

Navigate

```dart
WRouter.pushMaterialPage(
  builder: (context) => WServiceBuilder(
    serviceBuilder: (context) {},
    child: const SecondPage(),
  ),
);

// or using named route
WRouter.pushNamed("/second-page");
```

## Counter app with Witt

1. Create your business logic class

```dart
class CounterController {
    final counter = ValueNotifier(0);

    void incrementCounter() {
        counter.value++;
    }
}
```

2. Register your business logic class to depedency injection

```dart
// Register your business logic before runApp function.
void main() {
  WService.addSingleton(() => HomePageController());
  runApp(const MyApp());
}

// Or you can register your business logic using `WServiceBuilder`
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
```

3. Create your view

```dart
class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get CounterController instance from depedency injection.
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
