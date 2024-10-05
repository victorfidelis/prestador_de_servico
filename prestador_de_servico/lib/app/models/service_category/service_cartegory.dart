// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:replace_diacritic/replace_diacritic.dart';

class ServiceCategory {
  final String id;
  final String name;
  final DateTime? dateSync;
  String get nameWithoutDiacritics => replaceDiacritic(name);

  ServiceCategory({
    required this.id,
    required this.name,
    this.dateSync,
  });

  ServiceCategory copyWith({
    String? id,
    String? name,
    DateTime? dateSync,
  }) {
    return ServiceCategory(
      id: id ?? this.id,
      name: name ?? this.name,
      dateSync: dateSync ?? this.dateSync,
    );
  }


  @override
  bool operator ==(Object other) {
    return (other is ServiceCategory) &&
        other.id == id &&
        other.name == name;
  }
}
