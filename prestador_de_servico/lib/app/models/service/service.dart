// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:replace_diacritic/replace_diacritic.dart';

class Service {
  final String id;
  final String serviceCategoryId;
  final String name;
  final double price;
  final int hours;
  final int minutes;
  final String urlImage;
  final DateTime? syncDate;
  final bool isDeleted;

  String get nameWithoutDiacritics => replaceDiacritic(name);

  Service({
    required this.id,
    required this.serviceCategoryId,
    required this.name,
    required this.price,
    required this.hours,
    required this.minutes,
    required this.urlImage,
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
        other.minutes == minutes && 
        other.urlImage == urlImage; 
  }

  Service copyWith({
    String? id,
    String? serviceCategoryId,
    String? name,
    double? price,
    int? hours,
    int? minutes,
    String? urlImage,
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
      urlImage: urlImage ?? this.urlImage,
      syncDate: syncDate ?? this.syncDate,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }
}
