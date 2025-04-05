
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
  
  static int get pendingProvider => 1;
  static int get pendingClientCode => 2;
  static int get confirmCode => 3;
  static int get inAttendanceCode => 4;
  static int get servicePerformCode => 5;
  static int get deniedCode => 6;
  static int get canceledByProviderCode => 7;
  static int get canceledByClientCode => 8;
  static int get expiredCode => 9;

  static List<int> get pendingStatusCodes => [1, 2];
  static List<int> get acceptStatusCodes => [3, 4, 5];
  static List<int> get cancellationStatusCodes => [6, 7, 8, 9];
  static List<int> get finalStatusCodes => [5, 6, 7, 8, 9];
  static List<int> get blockChangesStatusCodes => [2, 5, 6, 7, 8, 9];
}
