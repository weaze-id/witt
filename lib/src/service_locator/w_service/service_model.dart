class ServiceModel<T extends Object> {
  final T? instance;
  final Type instanceType;
  final bool preventDuplicate;

  ServiceModel({
    required this.instance,
    required this.instanceType,
    required this.preventDuplicate,
  });

  ServiceModel<T> copyWith({
    T? instance,
    Type? instanceType,
    bool? preventDuplicate,
  }) {
    return ServiceModel<T>(
      instance: instance ?? this.instance,
      instanceType: instanceType ?? this.instanceType,
      preventDuplicate: preventDuplicate ?? this.preventDuplicate,
    );
  }
}
