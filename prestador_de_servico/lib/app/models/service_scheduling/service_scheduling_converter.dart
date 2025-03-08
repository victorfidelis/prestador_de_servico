import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:prestador_de_servico/app/models/address/address_converter.dart';
import 'package:prestador_de_servico/app/models/service/service.dart';
import 'package:prestador_de_servico/app/models/service/service_converter.dart';
import 'package:prestador_de_servico/app/models/service_scheduling/service_scheduling.dart';
import 'package:prestador_de_servico/app/models/service_status/service_status.dart';
import 'package:prestador_de_servico/app/models/user/user.dart';

class ServiceSchedulingConverter {
  static ServiceScheduling fromDocumentSnapshot({required DocumentSnapshot doc}) {
    Map<String, dynamic> map = (doc.data() as Map<String, dynamic>);

    final List<Map<String, dynamic>> servicesMap = (map['services'] as List).map((e) => e as Map<String, dynamic>).toList();
    final List<Service> services = servicesMap.map((e) => ServiceConverter.fromServiceSchedulingMap(map: e)).toList();

    final user = User(id: map['userId'], name: map['userName'], surname: map['userSurname']);

    final serviceStatus = ServiceStatus(code: map['serviceStatusCode'], name: map['serviceStatusName']);

    DateTime? oldStartDateAndTime;
    if (map.containsKey('oldStartDateAndTime')) {
      oldStartDateAndTime = (map['oldStartDateAndTime'] as Timestamp).toDate();
    }

    DateTime? oldEndDateAndTime;
    if (map.containsKey('oldEndDateAndTime')) {
      oldEndDateAndTime = (map['oldEndDateAndTime'] as Timestamp).toDate();
    }

    return ServiceScheduling(
      id: doc.id,
      user: user,
      services: services,
      serviceStatus: serviceStatus,
      startDateAndTime: (map['startDateAndTime'] as Timestamp).toDate(),
      endDateAndTime: (map['endDateAndTime'] as Timestamp).toDate(),
      oldStartDateAndTime: oldStartDateAndTime,
      oldEndDateAndTime: oldEndDateAndTime,
      totalRate: (map['totalRate'] * 1.0),
      totalDiscount: (map['totalDiscount'] * 1.0),
      totalPrice: (map['totalPrice'] * 1.0),
      totalPaid: (map['totalPaid'] * 1.0),
      isPaid: map['isPaid'], 
      creationDate: (map['endDateAndTime'] as Timestamp).toDate(),
      address: AddressConverter.fromMap(map: map['address']),
    );
  }
}
