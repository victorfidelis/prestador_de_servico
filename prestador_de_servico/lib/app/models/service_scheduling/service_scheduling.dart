
import 'package:prestador_de_servico/app/models/service/service.dart';
import 'package:prestador_de_servico/app/models/service_status/service_status.dart';
import 'package:prestador_de_servico/app/models/user/user.dart';

class ServiceScheduling {
  String id; 
  User user;
  List<Service> services;
  ServiceStatus serviceStatus; 
  DateTime startDateAndTime;
  DateTime endDateAndTime;
  double totalDiscount;
  double totalPrice;
  double totalPaid;
  bool schedulingUnavailable;
  bool conflictScheduing;

  bool get isPaid => (totalPrice - totalDiscount - totalPaid) <= 0;
  double get needToPay => totalPrice - totalDiscount - totalPaid;

  ServiceScheduling({
    this.id = '',
    required this.user,
    required this.services,
    required this.serviceStatus,
    required this.startDateAndTime,
    required this.endDateAndTime,
    required this.totalDiscount,
    required this.totalPrice,
    required this.totalPaid,
    this.schedulingUnavailable = false,
    this.conflictScheduing = false,
  });

  ServiceScheduling copyWith({
    String? id,
    User? user,
    List<Service>? services,
    ServiceStatus? serviceStatus,
    DateTime? startDateAndTime,
    DateTime? endDateAndTime,
    double? totalDiscount,
    double? totalPrice,
    double? totalPaid,
    bool? schedulingUnavailable,
    bool? conflictScheduing,
  }) {
    return ServiceScheduling(
      id: id ?? this.id,
      user: user ?? this.user,
      services: services ?? this.services,
      serviceStatus: serviceStatus ?? this.serviceStatus,
      startDateAndTime: startDateAndTime ?? this.startDateAndTime,
      endDateAndTime: endDateAndTime ?? this.endDateAndTime,
      totalDiscount: totalDiscount ?? this.totalDiscount,
      totalPrice: totalPrice ?? this.totalPrice,
      totalPaid: totalPaid ?? this.totalPaid,
      schedulingUnavailable: schedulingUnavailable ?? this.schedulingUnavailable,
      conflictScheduing: conflictScheduing ?? this.conflictScheduing,
    );
  }
}
