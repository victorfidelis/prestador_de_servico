
import 'package:prestador_de_servico/app/models/service/service.dart';
import 'package:prestador_de_servico/app/models/service_category/service_cartegory.dart';

class ServicesByCategory {
  ServiceCategory serviceCategory;
  List<Service> services;

  ServicesByCategory({
    required this.serviceCategory,
    required this.services,
  }); 
}