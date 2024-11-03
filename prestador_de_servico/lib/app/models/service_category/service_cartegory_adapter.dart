import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:prestador_de_servico/app/models/service_category/service_cartegory.dart';

class ServiceCartegoryAdapter {
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
}
