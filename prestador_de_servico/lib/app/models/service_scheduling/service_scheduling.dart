
import 'package:prestador_de_servico/app/models/service/service.dart';
import 'package:prestador_de_servico/app/models/service_status/service_status.dart';
import 'package:prestador_de_servico/app/models/user/user.dart';

class ServiceScheduling {
  int id; 
  User user;
  List<Service> services;
  ServiceStatus serviceStatus; 
  DateTime startDateAndTime;
  DateTime endDateAndTime;
  double totalDiscount;
  double totalPrice;
  double totalPaid;

  ServiceScheduling({
    this.id = 0,
    required this.user,
    required this.services,
    required this.serviceStatus,
    required this.startDateAndTime,
    required this.endDateAndTime,
    required this.totalDiscount,
    required this.totalPrice,
    required this.totalPaid,
  });

  ServiceScheduling copyWith({
    int? id,
    User? user,
    List<Service>? services,
    ServiceStatus? serviceStatus,
    DateTime? startDateAndTime,
    DateTime? endDateAndTime,
    double? totalDiscount,
    double? totalPrice,
    double? totalPaid,
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
    );
  }
}
