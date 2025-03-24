
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
  
  static List<int> get pendingStatusCodes => [1, 2];
  static List<int> get acceptStatusCodes => [3, 4, 5];
  static List<int> get cancellationStatusCodes => [6, 7, 8, 9];
  static List<int> get servicePerformStatusCodes => [5];
  static List<int> get finalStatusCodes => [5, 6, 7, 8, 9];
  static List<int> get blockChangesStatusCodes => [2, 5, 6, 7, 8, 9];
}
