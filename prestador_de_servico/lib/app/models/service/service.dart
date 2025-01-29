// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:replace_diacritic/replace_diacritic.dart';

class Service {
  final String id;
  final String serviceCategoryId;
  final String name;
  final double price;
  final int hours;
  final int minutes;
  final String imageUrl;
  final File? imageFile;
  final DateTime? syncDate;
  final bool isDeleted;

  String get nameWithoutDiacritics => replaceDiacritic(name);

  String get imageName => 'images/services/${id}_01.png';

  Service({
    required this.id,
    required this.serviceCategoryId,
    required this.name,
    required this.price,
    required this.hours,
    required this.minutes,
    required this.imageUrl,
    this.imageFile,
    this.syncDate,
    this.isDeleted = false,
  });

  @override
  bool operator ==(Object other) {
    return (other is Service) &&
        other.id == id &&
        other.serviceCategoryId == serviceCategoryId &&
        other.name == name &&
        other.price == price &&
        other.hours == hours && 
        other.minutes == minutes; 
  }

  Service copyWith({
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
  }) {
    return Service(
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
    );
  }
}
