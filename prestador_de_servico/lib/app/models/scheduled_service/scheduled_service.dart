import 'dart:io';

import 'package:prestador_de_servico/app/models/service/service.dart';

class ScheduledService extends Service {
  final bool isAdditional;
  final bool removed;

  ScheduledService({
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
}
