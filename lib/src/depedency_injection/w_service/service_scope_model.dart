import 'service_model.dart';

class ServiceScopeModel {
  String? name;
  final List<ServiceModel<Object>> services;

  ServiceScopeModel({
    this.name,
    required this.services,
  });

  ServiceScopeModel copyWith({
    String? name,
    List<ServiceModel<Object>>? services,
  }) {
    return ServiceScopeModel(
      name: name ?? this.name,
      services: services ?? this.services,
    );
  }
}
