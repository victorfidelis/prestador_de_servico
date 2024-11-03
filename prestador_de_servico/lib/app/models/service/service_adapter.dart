import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:prestador_de_servico/app/models/service/service.dart';

class ServiceAdapter {
  static Map<String, dynamic> toMap({required Service service}) {
    return {
      'id': service.id,
      'serviceCategoryId': service.serviceCategoryId,
      'name': service.name,
      'price': service.price,
      'hours': service.hours,
      'minutes': service.minutes,
      'urlImage': service.urlImage,
      'dateSync': service.syncDate,
      'isDeleted': service.isDeleted,
    };
  }

  static Service fromMap({required Map<String, dynamic> map}) {
    return Service(
      id: map['id'],
      serviceCategoryId: map['serviceCategoryId'],
      name: map['name'],
      price: map['price'],
      hours: map['hours'],
      minutes: map['minutes'],
      urlImage: map['urlImage'],
      syncDate: map.containsKey('dateSync') ? map['dateSync'] : null,
      isDeleted: map.containsKey('isDeleted') ? map['isDeleted'] : false,
    );
  }

  static Map<String, dynamic> toFirebaseMap({required Service service}) {
    return {
      'serviceCategoryId': service.serviceCategoryId,
      'name': service.name,
      'price': service.price,
      'hours': service.hours,
      'minutes': service.minutes,
      'urlImage': service.urlImage,
      'dateSync': FieldValue.serverTimestamp(), // Todo envio para o firebase deve conter a data atual do servidor
      'isDeleted': service.isDeleted,
    };
  }

  static Service fromDocumentSnapshot({required DocumentSnapshot doc}) {
    Map<String, dynamic> map = (doc.data() as Map<String, dynamic>);

    Service service = Service(
      id: doc.id,
      serviceCategoryId: map['serviceCategoryId'],
      name: map['name'],
      price: map['price'],
      hours: map['hours'],
      minutes: map['minutes'],
      urlImage: map['urlImage'],
      syncDate: (map['dateSync'] as Timestamp).toDate(),
      isDeleted: map['isDeleted'],
    );

    return service;
  }

  static Service fromSqflite({required Map map}) {
    return Service(
      id: map['id'],
      serviceCategoryId: map['serviceCategoryId'],
      name: map['name'],
      price: map['price'],
      hours: map['hours'],
      minutes: map['minutes'],
      urlImage: map['urlImage'],
    );
  }

  static Service fromSqfliteJoins({required Map map}) {
    return Service(
      id: map['serviceId'],
      serviceCategoryId: map['serviceCategoryId'],
      name: map['serviceName'],
      price: map['servicePrice'],
      hours: map['serviceHours'],
      minutes: map['serviceMinutes'],
      urlImage: map['serviceUrlImage'],
    );
  }
}
