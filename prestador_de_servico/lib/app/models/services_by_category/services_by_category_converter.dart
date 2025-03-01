import 'package:prestador_de_servico/app/models/service/service_converter.dart';
import 'package:prestador_de_servico/app/models/service_category/service_cartegory_converter.dart';
import 'package:prestador_de_servico/app/models/services_by_category/services_by_category.dart';

class ServicesByCategoryConverter {
  static List<ServicesByCategory> fromListSqflite(List<Map<String, dynamic>> servicesMap) {
    List<ServicesByCategory> servicesByCategories = [];

    for (var serviceMap in servicesMap) {
      final category = ServiceCartegoryConverter.fromSqfliteJoins(serviceMap);
      final service = serviceMap['serviceId'] == null ? null : ServiceConverter.fromSqfliteJoins(map: serviceMap);

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
