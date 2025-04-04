import 'package:prestador_de_servico/app/models/service_status/service_status.dart';

extension ServiceStatusExtensions on ServiceStatus {
  bool causesConflict() =>
      ServiceStatus.pendingStatusCodes.contains(code) || ServiceStatus.acceptStatusCodes.contains(code);
  bool isPendingProvider() => ServiceStatus.pendingProviderCode == code;
  bool isPendingClient() => ServiceStatus.pendingClientCode == code;
  bool isPending() => ServiceStatus.pendingStatusCodes.contains(code);
  bool isConfirm() => ServiceStatus.confirmCode == code;
  bool isInAttendance() => ServiceStatus.inAttendanceCode == code;
  bool isAccept() => ServiceStatus.acceptStatusCodes.contains(code);
  bool isCancelled() => ServiceStatus.cancellationStatusCodes.contains(code);
  bool isServicePerform() => ServiceStatus.servicePerformCode == code;
  bool isFinalStatus() => ServiceStatus.finalStatusCodes.contains(code);
  bool isBlockedChangeStatus() => ServiceStatus.blockChangesStatusCodes.contains(code);
}
