import 'package:prestador_de_servico/app/models/service_status/service_status.dart';

extension ServiceStatusExtensions on ServiceStatus {
  bool causesConflict() =>
      ServiceStatus.pendingStatusCodes.contains(code) || ServiceStatus.acceptStatusCodes.contains(code);
  bool isPendingProviderStatus() => ServiceStatus.pendingProviderStatusCodes.contains(code);
  bool isPendingClientStatus() => ServiceStatus.pendingClientStatusCodes.contains(code);
  bool isPendingStatus() => ServiceStatus.pendingStatusCodes.contains(code);
  bool isConfirmStatus() => ServiceStatus.confirmStatusCodes.contains(code);
  bool isInAttendanceStatus() => ServiceStatus.inAttendanceStatusCodes.contains(code);
  bool isAcceptStatus() => ServiceStatus.acceptStatusCodes.contains(code);
  bool isCancellationStatus() => ServiceStatus.cancellationStatusCodes.contains(code);
  bool isServicePerformStatus() => ServiceStatus.servicePerformStatusCodes.contains(code);
  bool isFinalStatus() => ServiceStatus.finalStatusCodes.contains(code);
  bool isBlockChangesStatus() => ServiceStatus.blockChangesStatusCodes.contains(code);
}
