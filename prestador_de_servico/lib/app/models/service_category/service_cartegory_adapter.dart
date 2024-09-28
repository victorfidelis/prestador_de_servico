import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:prestador_de_servico/app/models/service_category/service_cartegory_model.dart';

class ServiceCartegoryAdapter {
  static Map<String, dynamic> toMap({required ServiceCategoryModel serviceCategory,}) {
    return {
      'id': serviceCategory.id,
      'name': serviceCategory.name,
    };
  }

  static ServiceCategoryModel fromMap({required Map<String, dynamic> map}) {
    return ServiceCategoryModel(id: map['id'], name: map['name']);
  }

  static Map<String, dynamic> toFirebaseMap({required ServiceCategoryModel serviceCategory}) {
    return {'name': serviceCategory.name};
  }

  static ServiceCategoryModel fromDocumentSnapshot({required DocumentSnapshot doc}) {
    Map<String, dynamic> map = (doc.data() as Map<String, dynamic>);
    map['id'] = doc.id;
    ServiceCategoryModel serviceCartegory = fromMap(map: map);
    return serviceCartegory;
  }

  static ServiceCategoryModel fromSqflite({required Map map}) {
    return ServiceCategoryModel(id: map['id'], name: map['name']);
  }
}