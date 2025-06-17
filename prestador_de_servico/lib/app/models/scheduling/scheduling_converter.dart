import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:prestador_de_servico/app/models/address/address_converter.dart';
import 'package:prestador_de_servico/app/models/scheduled_service/scheduled_service.dart';
import 'package:prestador_de_servico/app/models/scheduled_service/scheduled_service_converter.dart';
import 'package:prestador_de_servico/app/models/scheduling/scheduling.dart';
import 'package:prestador_de_servico/app/models/service_status/service_status.dart';
import 'package:prestador_de_servico/app/models/user/user.dart';

class SchedulingConverter {
  static Scheduling fromFirebaseDoc({required DocumentSnapshot doc}) {
    Map<String, dynamic> map = (doc.data() as Map<String, dynamic>);

    final List<Map<String, dynamic>> servicesMap =
        (map['services'] as List).map((e) => e as Map<String, dynamic>).toList();
    final List<ScheduledService> services =
        servicesMap.map((e) => ScheduledServiceConverter.fromSchedulingMap(map: e)).toList();

    final user = User(id: map['userId'], name: map['userName'], surname: map['userSurname']);

    final serviceStatus =
        ServiceStatus(code: map['serviceStatusCode'], name: map['serviceStatusName']);

    DateTime? oldStartDateAndTime;
    if (map.containsKey('oldStartDateAndTime')) {
      oldStartDateAndTime = (map['oldStartDateAndTime'] as Timestamp).toDate();
    }

    DateTime? oldEndDateAndTime;
    if (map.containsKey('oldEndDateAndTime')) {
      oldEndDateAndTime = (map['oldEndDateAndTime'] as Timestamp).toDate();
    } 

    int? review;
    if (map.containsKey('review')) {
      review = map['review'];
    }

    String? reviewDetails;
    if (map.containsKey('reviewDetails')) {
      reviewDetails = map['reviewDetails'];
    }
    List<String> images = [];
    if (map.containsKey('images')) {
      images = map['images'];
    }

    return Scheduling(
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
      review: review,
      reviewDetails: reviewDetails,
      images: images,
    );
  }

  static Map<String, dynamic> toEditDateAndTimeFirebaseMap({
    required DateTime startDateAndTime,
    required DateTime endDateAndTime,
    required DateTime oldStartDateAndTime,
    required DateTime oldEndDateAndTime,
  }) {
    return {
      'startDateAndTime': Timestamp.fromDate(startDateAndTime),
      'endDateAndTime': Timestamp.fromDate(endDateAndTime),
      'oldStartDateAndTime': Timestamp.fromDate(oldStartDateAndTime),
      'oldEndDateAndTime': Timestamp.fromDate(oldEndDateAndTime),
    };
  }

  static Map<String, dynamic> toEditServiceAndPricesFirebaseMap({
    required double totalRate,
    required double totalDiscount,
    required double totalPrice,
    required List<ScheduledService> scheduledServices,
    required DateTime newEndDate,
  }) {
    final List<Map<String, dynamic>> services = scheduledServices
        .map((s) => ScheduledServiceConverter.toFirebaseMap(scheduledService: s))
        .toList();
    return {
      'totalRate': totalRate,
      'totalDiscount': totalDiscount,
      'totalPrice': totalPrice,
      'services': services,
      'endDateAndTime': Timestamp.fromDate(newEndDate),
    };
  }
}
