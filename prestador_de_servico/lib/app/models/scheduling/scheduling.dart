import 'package:flutter/foundation.dart';
import 'package:prestador_de_servico/app/models/address/address.dart';
import 'package:prestador_de_servico/app/models/scheduled_service/scheduled_service.dart';
import 'package:prestador_de_servico/app/models/service_status/service_status.dart';
import 'package:prestador_de_servico/app/models/service_status/service_status_extensions.dart';
import 'package:prestador_de_servico/app/models/user/user.dart';
import 'package:prestador_de_servico/app/shared/utils/general.dart';

class Scheduling {
  final String id;
  final User user;
  final List<ScheduledService> services;
  final ServiceStatus serviceStatus;
  final DateTime startDateAndTime;
  final DateTime endDateAndTime;
  final DateTime? oldStartDateAndTime;
  final DateTime? oldEndDateAndTime;
  final double totalRate;
  final double totalDiscount;
  final double totalPrice;
  final double totalPaid;
  final bool schedulingUnavailable;
  final bool conflictScheduing;
  final bool isPaid;
  final DateTime creationDate;
  final Address? address;
  final int? review;
  final String? reviewDetails; 
  final List<String> images;

  double get needToPay => totalPrice + totalRate - totalDiscount - totalPaid;
  double get totalPriceCalculated => totalPrice + totalRate - totalDiscount;
  int get serviceTime => endDateAndTime.difference(startDateAndTime).inMinutes;
  List<ScheduledService> get activeServices {
    return services.where((s) => !s.removed).toList();
  }
  bool get hasReview => review != null;

  bool get hasMessage =>
      schedulingUnavailable || conflictScheduing || isPaid || (!isPaid && serviceStatus.isAccept());
      
  bool get showImageCard => serviceStatus.isInService() || serviceStatus.isServicePerform();
  bool get showReviewCard => serviceStatus.isServicePerform();

  Scheduling({
    this.id = '',
    required this.user,
    required this.services,
    required this.serviceStatus,
    required this.startDateAndTime,
    required this.endDateAndTime,
    this.oldStartDateAndTime,
    this.oldEndDateAndTime,
    required this.totalRate,
    required this.totalDiscount,
    required this.totalPrice,
    required this.totalPaid,
    this.schedulingUnavailable = false,
    this.conflictScheduing = false,
    this.isPaid = false,
    required this.creationDate,
    this.address,
    this.review,
    this.reviewDetails,
    this.images = const [],
  });

  Scheduling copyWith({
    String? id,
    User? user,
    List<ScheduledService>? services,
    ServiceStatus? serviceStatus,
    DateTime? startDateAndTime,
    DateTime? endDateAndTime,
    DateTime? oldStartDateAndTime,
    DateTime? oldEndDateAndTime,
    double? totalRate,
    double? totalDiscount,
    double? totalPrice,
    double? totalPaid,
    bool? schedulingUnavailable,
    bool? conflictScheduing,
    DateTime? creationDate,
    Address? address,
    int? review,
    String? reviewDetails,
    List<String>? images,
  }) {
    return Scheduling(
      id: id ?? this.id,
      user: user ?? this.user,
      services: services ?? this.services,
      serviceStatus: serviceStatus ?? this.serviceStatus,
      startDateAndTime: startDateAndTime ?? this.startDateAndTime,
      endDateAndTime: endDateAndTime ?? this.endDateAndTime,
      oldStartDateAndTime: oldStartDateAndTime ?? this.oldStartDateAndTime,
      oldEndDateAndTime: oldEndDateAndTime ?? this.oldEndDateAndTime,
      totalRate: totalRate ?? this.totalRate,
      totalDiscount: totalDiscount ?? this.totalDiscount,
      totalPrice: totalPrice ?? this.totalPrice,
      totalPaid: totalPaid ?? this.totalPaid,
      schedulingUnavailable: schedulingUnavailable ?? this.schedulingUnavailable,
      conflictScheduing: conflictScheduing ?? this.conflictScheduing,
      creationDate: creationDate ?? this.creationDate,
      address: address ?? this.address,
      review: review ?? this.review,
      reviewDetails: reviewDetails ?? this.reviewDetails,
      images: images ?? this.images,
    );
  }

  @override
  bool operator ==(covariant Scheduling other) {
    return id == other.id &&
        user == other.user &&
        listEquals(services, other.services) &&
        serviceStatus == other.serviceStatus &&
        startDateAndTime == other.startDateAndTime &&
        endDateAndTime == other.endDateAndTime &&
        oldStartDateAndTime == other.oldStartDateAndTime &&
        oldEndDateAndTime == other.oldEndDateAndTime &&
        totalRate == other.totalRate &&
        totalDiscount == other.totalDiscount &&
        totalPrice == other.totalPrice &&
        totalPaid == other.totalPaid &&
        schedulingUnavailable == other.schedulingUnavailable &&
        conflictScheduing == other.conflictScheduing &&
        isPaid == other.isPaid &&
        creationDate == other.creationDate &&
        address == other.address;
  }

  @override
  int get hashCode =>
      id.hashCode ^
      user.hashCode ^
      hashList(services) ^
      serviceStatus.hashCode ^
      startDateAndTime.hashCode ^
      endDateAndTime.hashCode ^
      oldStartDateAndTime.hashCode ^
      oldEndDateAndTime.hashCode ^
      totalRate.hashCode ^
      totalDiscount.hashCode ^
      totalPrice.hashCode ^
      totalPaid.hashCode ^
      schedulingUnavailable.hashCode ^
      conflictScheduing.hashCode ^
      isPaid.hashCode ^
      creationDate.hashCode ^
      address.hashCode;
}
