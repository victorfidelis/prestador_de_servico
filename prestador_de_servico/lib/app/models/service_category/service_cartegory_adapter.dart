import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:prestador_de_servico/app/models/service_category/service_cartegory.dart';

class ServiceCartegoryAdapter {
  static Map<String, dynamic> toMap({
    required ServiceCategory serviceCategory,
  }) {
    return {
      'id': serviceCategory.id,
      'name': serviceCategory.name,
      'dateSync': serviceCategory.dateSync,
    };
  }

  static ServiceCategory fromMap({required Map<String, dynamic> map}) {
    return ServiceCategory(
      id: map['id'],
      name: map['name'],
      dateSync: map.containsKey('dateSync') ? map['dateSync'] : null,
    );
  }

  static Map<String, dynamic> toFirebaseMap(
      {required ServiceCategory serviceCategory}) {
    return {
      'name': serviceCategory.name,
      'dateSync': Timestamp.fromDate(serviceCategory.dateSync!),
    };
  }

  static ServiceCategory fromDocumentSnapshot({required DocumentSnapshot doc}) {
    Map<String, dynamic> map = (doc.data() as Map<String, dynamic>);
    map['id'] = doc.id;
    map['dateSync'] = (map['dateSync'] as Timestamp).toDate();
    ServiceCategory serviceCartegory = fromMap(map: map);
    return serviceCartegory;
  }

  static ServiceCategory fromSqflite({required Map map}) {
    return ServiceCategory(
      id: map['id'],
      name: map['name'],
    );
  }
}
