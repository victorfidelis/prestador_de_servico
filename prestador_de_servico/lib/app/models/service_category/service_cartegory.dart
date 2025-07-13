// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:prestador_de_servico/app/models/service/service.dart';
import 'package:replace_diacritic/replace_diacritic.dart';

class ServiceCategory {
  final String id;
  final String name;
  final DateTime? syncDate;
  final bool isDeleted;
  final List<Service> services;

  String get nameWithoutDiacritics => replaceDiacritic(name);

  ServiceCategory({
    required this.id,
    required this.name,
    this.syncDate,
    this.isDeleted = false,
    this.services = const [],
  });

  ServiceCategory copyWith({
    String? id,
    String? name,
    DateTime? syncDate,
    bool? isDeleted,
    List<Service>? services,
  }) {
    return ServiceCategory(
      id: id ?? this.id,
      name: name ?? this.name,
      syncDate: syncDate ?? this.syncDate,
      isDeleted: isDeleted ?? this.isDeleted,
      services: services ?? this.services,
    );
  }

  @override
  bool operator ==(covariant ServiceCategory other) {
    return other.id == id && other.name == name;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode;
}
