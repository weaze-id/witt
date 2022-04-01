class Service<T extends Object> {
  final T? instance;
  final Type instanceType;
  final T Function() factoryFunction;
  final bool isLazy;

  Service({
    required this.instance,
    required this.instanceType,
    required this.factoryFunction,
    required this.isLazy,
  });

  Service<T> copyWith({
    T? instance,
    Type? instanceType,
    T Function()? factoryFunction,
    bool? isLazy,
    bool? preventDuplicate,
  }) {
    return Service<T>(
      instance: instance ?? this.instance,
      instanceType: instanceType ?? this.instanceType,
      factoryFunction: factoryFunction ?? this.factoryFunction,
      isLazy: isLazy ?? this.isLazy,
    );
  }
}
