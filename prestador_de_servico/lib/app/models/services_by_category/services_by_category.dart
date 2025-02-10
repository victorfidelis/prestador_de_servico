// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:prestador_de_servico/app/models/service/service.dart';
import 'package:prestador_de_servico/app/models/service_category/service_cartegory.dart';

class ServicesByCategory {
  ServiceCategory serviceCategory;
  List<Service> services;

  ServicesByCategory({
    required this.serviceCategory,
    required this.services,
  });

  ServicesByCategory copyWith({
    ServiceCategory? serviceCategory,
    List<Service>? services,
  }) {
    return ServicesByCategory(
      serviceCategory: serviceCategory ?? this.serviceCategory,
      services: services ?? this.services,
    );
  }

  @override
  bool operator ==(covariant ServicesByCategory other) {
    return other.serviceCategory == serviceCategory && other.services.length == services.length;
  }

  @override
  int get hashCode {
    return serviceCategory.hashCode ^ services.length.hashCode;
  }
}
