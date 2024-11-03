import 'package:prestador_de_servico/app/models/service/service_adapter.dart';
import 'package:prestador_de_servico/app/models/service_category/service_cartegory_adapter.dart';
import 'package:prestador_de_servico/app/models/services_by_category/services_by_category.dart';

class ServicesByCategoryAdapter {
  static List<ServicesByCategory> fromListSqflite(List<Map<String, dynamic>> servicesMap) {
    List<ServicesByCategory> servicesByCategories = [];

    for (var serviceMap in servicesMap) {
      final category = ServiceCartegoryAdapter.fromSqfliteJoins(serviceMap);
      final service = serviceMap['serviceId'] == null ? null : ServiceAdapter.fromSqfliteJoins(map: serviceMap);

      var catIndex = servicesByCategories.indexWhere((e) => e.serviceCategory == category);
      if (service == null) {
        servicesByCategories.add(ServicesByCategory(serviceCategory: category, services: []));
      } else if (catIndex == -1) {
        servicesByCategories.add(ServicesByCategory(serviceCategory: category, services: [service]));
      } else {
        servicesByCategories[catIndex].services.add(service);
      }
    }

    return servicesByCategories;
  }
}
