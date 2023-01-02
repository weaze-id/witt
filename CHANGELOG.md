## 1.1.0

- Add BuildContext to service property on WProvider

## 1.0.0

- Remove service locator
- Add inherited widget wrapper (WProvider, WMultiProvider)
- Remove onGenerateMaterialRoute and onGenerateCupertinoRoute
- Add onGenerateRoute
- Change WPage property
- Remove value notifier extensions

## 0.7.0

- Use uuid for default scope name
- Change WServiceBuilder API

## 0.6.0

- Add value notifer extension

```dart
// Now you can listen to `ValueNotifer` using extension
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

- Remove `addLazySingleton`
- Set `preventDuplicate` default value to `true`

## 0.5.1

- Fix router pop method

## 0.5.0

- Add `preventDuplicate` property to `addSingleton` and `addLazySingleton`
- Add more value notifier list extension method

## 0.4.0

- WDisposable initialize now called after first frame was rendered
- WPage serviceBuilder now have arguments parameter

## 0.3.0

- Change API name
- Add WNestedNavigator
- Add nested key to WRouter

## 0.2.0

- Fix popUntilAndPushNamed
- Add WPage
- Add popAllAndPushNamed method to WRouter
- Add onGenerateMaterialRoute method to WRouter
- Add onGenerateCupertinoRoute method to WRouter
- Add initalize method to WDisposable

## 0.1.0

- Add addLazySingleton

## 0.0.1

- Initial Release
