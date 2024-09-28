import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:prestador_de_servico/app/models/service_category/service_cartegory_model.dart';

class ServiceCartegoryAdapter {
  static Map<String, dynamic> toMap({required ServiceCartegoryModel serviceCategory,}) {
    return {
      'id': serviceCategory.id,
      'name': serviceCategory.name,
    };
  }

  static ServiceCartegoryModel fromMap({required Map<String, dynamic> map}) {
    return ServiceCartegoryModel(id: map['id'], name: map['name']);
  }

  static Map<String, dynamic> toFirebaseMap({required ServiceCartegoryModel serviceCategory}) {
    return {'name': serviceCategory.name};
  }

  static ServiceCartegoryModel fromDocumentSnapshot({required DocumentSnapshot doc}) {
    Map<String, dynamic> map = (doc.data() as Map<String, dynamic>);
    map['id'] = doc.id;
    ServiceCartegoryModel serviceCartegory = fromMap(map: map);
    return serviceCartegory;
  }
}