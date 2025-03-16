import 'dart:io';

import 'package:prestador_de_servico/app/models/service/service.dart';

class ScheduledService extends Service {
  final int scheduledServiceId;
  final bool isAdditional;
  final bool removed;

  ScheduledService({
    required this.scheduledServiceId,
    required super.id,
    required super.serviceCategoryId,
    required super.name,
    required super.price,
    required super.hours,
    required super.minutes,
    required super.imageUrl,
    super.imageFile,
    super.syncDate,
    super.isDeleted = false,
    required this.isAdditional,
    required this.removed,
  });

  @override
  ScheduledService copyWith({
    int? scheduledServiceId,
    String? id,
    String? serviceCategoryId,
    String? name,
    double? price,
    int? hours,
    int? minutes,
    String? imageUrl,
    File? imageFile,
    DateTime? syncDate,
    bool? isDeleted,
    bool? isAdditional,
    bool? removed,
  }) {
    return ScheduledService(
      scheduledServiceId: scheduledServiceId ?? this.scheduledServiceId,
      id: id ?? this.id,
      serviceCategoryId: serviceCategoryId ?? this.serviceCategoryId,
      name: name ?? this.name,
      price: price ?? this.price,
      hours: hours ?? this.hours,
      minutes: minutes ?? this.minutes,
      imageUrl: imageUrl ?? this.imageUrl,
      imageFile: imageFile ?? this.imageFile,
      syncDate: syncDate ?? this.syncDate,
      isDeleted: isDeleted ?? this.isDeleted,
      isAdditional: isAdditional ?? this.isAdditional,
      removed: removed ?? this.removed,
    );
  }

  @override
  int get hashCode =>
      scheduledServiceId.hashCode ^
      id.hashCode ^
      serviceCategoryId.hashCode ^
      name.hashCode ^
      price.hashCode ^
      hours.hashCode ^
      minutes.hashCode ^
      imageUrl.hashCode ^
      isDeleted.hashCode ^
      isAdditional.hashCode ^
      removed.hashCode;

  @override
  bool operator ==(covariant ScheduledService other) {
    return scheduledServiceId == other.scheduledServiceId &&
        id == other.id &&
        serviceCategoryId == other.serviceCategoryId &&
        name == other.name &&
        price == other.price &&
        hours == other.hours &&
        minutes == other.minutes &&
        imageUrl == other.imageUrl &&
        isDeleted == other.isDeleted &&
        isAdditional == other.isAdditional &&
        removed == other.removed;
  }
}
