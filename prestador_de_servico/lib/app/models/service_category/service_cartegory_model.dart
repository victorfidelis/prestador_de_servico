class ServiceCartegoryModel {
  final int id;
  final String name;

  ServiceCartegoryModel({
    required this.id,
    required this.name,
  });

  ServiceCartegoryModel copyWith({
    int? id,
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
