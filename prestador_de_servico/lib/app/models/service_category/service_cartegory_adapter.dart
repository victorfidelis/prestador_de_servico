import 'package:prestador_de_servico/app/models/service_category/service_cartegory_model.dart';

class ServiceCartegoryAdapter {
  static Map<String, dynamic> toMap({required ServiceCartegoryModel serviceCategory,}) {
    return {
      'id': serviceCategory.id,
      'name': serviceCategory.name,
    };
  }
}