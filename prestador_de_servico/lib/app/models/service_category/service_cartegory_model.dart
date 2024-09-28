import 'package:replace_diacritic/replace_diacritic.dart';

class ServiceCartegoryModel {
  final String id;
  final String name;
  String get nameWithoutDiacritics => replaceDiacritic(name);

  ServiceCartegoryModel({
    required this.id,
    required this.name,
  });

  ServiceCartegoryModel copyWith({
    String? id,
    String? name,
  }) {
    return ServiceCartegoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }


  @override
  bool operator ==(Object other) {
    return (other is ServiceCartegoryModel) &&
        other.id == id &&
        other.name == name;
  }
}
