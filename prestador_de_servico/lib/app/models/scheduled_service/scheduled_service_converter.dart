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

  static Map<String, dynamic> toFirebaseMap({required ScheduledService scheduledService}) {
    return {
      'scheduledServiceId': scheduledService.scheduledServiceId,
      'id': scheduledService.id,
      'name': scheduledService.name,
      'price': scheduledService.price,
      'hours': scheduledService.hours,
      'minutes': scheduledService.minutes,
      'isAdditional': scheduledService.isAdditional,
      'removed': scheduledService.removed,
    };
  }
}
