
class ServiceStatus {
  int code;
  String name;

  ServiceStatus({
    required this.code,
    required this.name,
  });

  ServiceStatus copyWith({
    int? code,
    String? name,
  }) {
    return ServiceStatus(
      code: code ?? this.code,
      name: name ?? this.name,
    );
  }
}
