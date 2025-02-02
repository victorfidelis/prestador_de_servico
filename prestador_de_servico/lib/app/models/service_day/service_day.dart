// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:replace_diacritic/replace_diacritic.dart';

class ServiceDay {
  final String id;
  final String name;
  final int dayOfWeek;
  final bool isActive;
  final DateTime? syncDate;
  final bool isDeleted;

  String get nameWithoutDiacritics => replaceDiacritic(name);
  
  ServiceDay({
    required this.id,
    required this.name,
    required this.dayOfWeek,
    required this.isActive,
    this.syncDate,
    this.isDeleted = false,
  });

  ServiceDay copyWith({
    String? id,
    String? name,
    int? dayOfWeek,
    bool? isActive,
    DateTime? syncDate,
    bool? isDeleted,
  }) {
    return ServiceDay(
      id: id ?? this.id,
      name: name ?? this.name,
      dayOfWeek: dayOfWeek ?? this.dayOfWeek,
      isActive: isActive ?? this.isActive,
      syncDate: syncDate ?? this.syncDate,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }

  @override
  bool operator ==(Object other) {
    return (other is ServiceDay) &&
        other.id == id &&
        other.name == name &&
        other.dayOfWeek == dayOfWeek &&
        other.isActive == isActive;
  }
}
