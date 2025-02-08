import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:prestador_de_servico/app/models/service/service.dart';
import 'package:prestador_de_servico/app/models/service/service_adapter.dart';
import 'package:prestador_de_servico/app/models/service_scheduling/service_scheduling.dart';
import 'package:prestador_de_servico/app/models/service_status/service_status_adapter.dart';
import 'package:prestador_de_servico/app/models/user/user_adapter.dart';

class ServiceSchedulingAdapter {
  static ServiceScheduling fromDocumentSnapshot({required DocumentSnapshot doc}) {
    Map<String, dynamic> map = (doc.data() as Map<String, dynamic>);
    map['id'] = doc.id;
    final List<Map<String, dynamic>> servicesMap = (map['services'] as List<Map<String, dynamic>>);
    final List<Service> services = servicesMap.map((e) => ServiceAdapter.fromServiceSchedulingMap(map: e)).toList();


    return ServiceScheduling(
      user: UserAdapter.fromServiceSchedulingMap(map: map['user']),
      services: services,
      serviceStatus: ServiceStatusAdapter.fromServiceSchedulingMap(map: map['serviceStatus']),
      startDateAndTime: (map['startDateAndTime'] as Timestamp).toDate(),
      endDateAndTime: (map['endDateAndTime'] as Timestamp).toDate(),
      totalDiscount: map['totalDiscount'],
      totalPrice: map['totalPrice'],
      totalPaid: map['totalPaid'],
    );
  }
}
