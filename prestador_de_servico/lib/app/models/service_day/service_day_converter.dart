

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:prestador_de_servico/app/models/service_day/service_day.dart';

class ServiceDayConverter {

  static Map<String, dynamic> toFirebaseMap({required ServiceDay serviceDay}) {
    return {
      'name': serviceDay.name,
      'dayOfWeek': serviceDay.dayOfWeek,
      'isActive': serviceDay.isActive,
      'openingHour': serviceDay.openingHour,
      'openingMinute': serviceDay.openingMinute,
      'closingHour': serviceDay.closingHour,
      'closingMinute': serviceDay.closingMinute,
      'dateSync': FieldValue.serverTimestamp(), // Todo envio para o firebase deve conter a data atual do servidor
      'isDeleted': false,
    };
  }

  static ServiceDay fromDocumentSnapshot({required DocumentSnapshot doc}) {
    Map<String, dynamic> map = (doc.data() as Map<String, dynamic>);

    ServiceDay serviceDay = ServiceDay(
      id: doc.id,
      name: map['name'],
      dayOfWeek: map['dayOfWeek'],
      isActive: map['isActive'],
      openingHour: map['openingHour'],
      openingMinute: map['openingMinute'],
      closingHour: map['closingHour'],
      closingMinute: map['closingMinute'],
      syncDate: (map['dateSync'] as Timestamp).toDate(),
    );

    return serviceDay;
  }

  static ServiceDay fromSqflite({required Map map}) {
    return ServiceDay(
      id: map['id'],
      name: map['name'],
      dayOfWeek: map['dayOfWeek'],
      isActive: map['isActive'] == 1,
      openingHour: map['openingHour'],
      openingMinute: map['openingMinute'],
      closingHour: map['closingHour'],
      closingMinute: map['closingMinute'],
    );
  }
}