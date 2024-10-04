import 'package:replace_diacritic/replace_diacritic.dart';

class ServiceCategory {
  final String id;
  final String name;
  String get nameWithoutDiacritics => replaceDiacritic(name);

  ServiceCategory({
    required this.id,
    required this.name,
  });

  ServiceCategory copyWith({
    String? id,
    String? name,
  }) {
    return ServiceCategory(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }


  @override
  bool operator ==(Object other) {
    return (other is ServiceCategory) &&
        other.id == id &&
        other.name == name;
  }
}
