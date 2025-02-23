import 'package:prestador_de_servico/app/models/service_status/service_status.dart';

extension ServiceStatusExtensions on ServiceStatus {
  bool causesConflict() =>
      ServiceStatus.pendingStatusCodes.contains(code) || ServiceStatus.acceptStatusCodes.contains(code);
  bool isAcceptStatus() => ServiceStatus.acceptStatusCodes.contains(code);
  bool isPendingStatus() => ServiceStatus.pendingStatusCodes.contains(code);
  bool isCancellationStatus() => ServiceStatus.cancellationStatusCodes.contains(code);
  bool isServicePerformStatus() => ServiceStatus.servicePerformStatusCodes.contains(code);
}
