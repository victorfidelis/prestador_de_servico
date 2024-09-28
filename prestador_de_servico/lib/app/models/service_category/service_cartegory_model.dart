import 'package:replace_diacritic/replace_diacritic.dart';

class ServiceCategoryModel {
  final String id;
  final String name;
  String get nameWithoutDiacritics => replaceDiacritic(name);

  ServiceCategoryModel({
    required this.id,
    required this.name,
  });

  ServiceCategoryModel copyWith({
    String? id,
    String? name,
  }) {
    return ServiceCategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }


  @override
  bool operator ==(Object other) {
    return (other is ServiceCategoryModel) &&
        other.id == id &&
        other.name == name;
  }
}
