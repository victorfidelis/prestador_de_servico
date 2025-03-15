import 'package:prestador_de_servico/app/models/scheduled_service/scheduled_service.dart';

class ScheduledServiceConverter {

  static ScheduledService fromServiceSchedulingMap({required Map map}) {
    return ScheduledService(
      scheduledServiceId: map['scheduledServiceId'],
      id: map['id'],
      serviceCategoryId: '',
      name: map['name'],
      price: (map['price'] * 1.0),
      hours: map['hours'],
      minutes: map['minutes'],
      imageUrl: '',
      isAdditional: map['isAdditional'],
      removed: map['removed'],
    );
  }
}
