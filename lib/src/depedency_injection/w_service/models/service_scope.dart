import 'service.dart';

class ServiceScope {
  String? name;
  final List<Service<Object>> services;

  ServiceScope({
    this.name,
    required this.services,
  });

  ServiceScope copyWith({
    String? name,
    List<Service<Object>>? services,
  }) {
    return ServiceScope(
      name: name ?? this.name,
      services: services ?? this.services,
    );
  }
}
