import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:prestador_de_servico/app/models/service/service_converter.dart';
import 'package:prestador_de_servico/app/models/service_category/service_cartegory.dart';

class ServiceCartegoryConverter {
  static Map<String, dynamic> toMap(ServiceCategory serviceCategory) {
    return {
      'id': serviceCategory.id,
      'name': serviceCategory.name,
      'dateSync': serviceCategory.syncDate,
      'isDeleted': serviceCategory.isDeleted,
    };
  }

  static ServiceCategory fromMap(Map<String, dynamic> map) {
    return ServiceCategory(
      id: map['id'],
      name: map['name'],
      syncDate: map.containsKey('dateSync') ? map['dateSync'] : null,
      isDeleted: map.containsKey('isDeleted') ? map['isDeleted'] : false,
    );
  }

  static Map<String, dynamic> toFirebaseMap(ServiceCategory serviceCategory) {
    return {
      'name': serviceCategory.name,
      'dateSync': FieldValue.serverTimestamp(), // Todo envio para o firebase deve conter a data atual do servidor
      'isDeleted': serviceCategory.isDeleted,
    };
  }

  static ServiceCategory fromFirebase(DocumentSnapshot doc) {
    Map<String, dynamic> map = (doc.data() as Map<String, dynamic>);

    ServiceCategory serviceCartegory = ServiceCategory(
      id: doc.id,
      name: map['name'],
      syncDate: (map['dateSync'] as Timestamp).toDate(),
      isDeleted: map['isDeleted'],
    );

    return serviceCartegory;
  }

  static ServiceCategory fromSqflite(Map map) {
    return ServiceCategory(
      id: map['id'],
      name: map['name'],
    );
  }

  static ServiceCategory fromSqfliteJoins(Map map) {
    return ServiceCategory(
      id: map['serviceCategoryId'],
      name: map['serviceCategoryName'],
    );
  }
  
  static List<ServiceCategory> fromListSqfliteWithServices(List<Map<String, dynamic>> servicesMap) {
    List<ServiceCategory> serviceCategories = [];

    for (var serviceMap in servicesMap) {
      final category = ServiceCartegoryConverter.fromSqfliteJoins(serviceMap);
      final service = serviceMap['serviceId'] == null ? null : ServiceConverter.fromSqfliteJoins(map: serviceMap);

      var catIndex = serviceCategories.indexWhere((e) => e == category);
      if (service == null) {
        serviceCategories.add(category);
      } else if (catIndex == -1) {
        serviceCategories.add(category.copyWith(services: [service]));
      } else {
        serviceCategories[catIndex].services.add(service);
      }
    }

    return serviceCategories;
  }
}
