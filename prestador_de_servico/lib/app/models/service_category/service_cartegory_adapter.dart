import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:prestador_de_servico/app/models/service_category/service_cartegory.dart';

class ServiceCartegoryAdapter {
  static Map<String, dynamic> toMap({required ServiceCategory serviceCategory,}) {
    return {
      'id': serviceCategory.id,
      'name': serviceCategory.name,
    };
  }

  static ServiceCategory fromMap({required Map<String, dynamic> map}) {
    return ServiceCategory(id: map['id'], name: map['name']);
  }

  static Map<String, dynamic> toFirebaseMap({required ServiceCategory serviceCategory}) {
    return {'name': serviceCategory.name};
  }

  static ServiceCategory fromDocumentSnapshot({required DocumentSnapshot doc}) {
    Map<String, dynamic> map = (doc.data() as Map<String, dynamic>);
    map['id'] = doc.id;
    ServiceCategory serviceCartegory = fromMap(map: map);
    return serviceCartegory;
  }

  static ServiceCategory fromSqflite({required Map map}) {
    return ServiceCategory(id: map['id'], name: map['name']);
  }
}