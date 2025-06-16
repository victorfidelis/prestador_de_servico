
import 'package:prestador_de_servico/app/models/service_scheduling/service_image.dart';

class ServiceImageConverter {
  static ServiceImage fromMap(Map<String, dynamic> map) {
    return ServiceImage(id: map['id'], image: map['image']);
  }

  static Map<String, dynamic> toMap(ServiceImage serviceImage) {
    return {
      'id': serviceImage.id,
      'image': serviceImage.image,
    };
  }
}