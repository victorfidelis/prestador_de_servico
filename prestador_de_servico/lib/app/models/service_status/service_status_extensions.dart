import 'package:prestador_de_servico/app/models/service_status/service_status.dart';

extension ServiceStatusExtensions on ServiceStatus {
  static final List<int> _pendingStatusCodes = [1, 2];
  static final List<int> _acceptStatusCodes = [3, 4, 5];
  static final List<int> _cancellationStatusCodes = [6, 7, 8, 9];
  static final List<int> _servicePerformStatusCodes = [5];

  bool causesConflict() => _pendingStatusCodes.contains(code) || _acceptStatusCodes.contains(code);
  bool isAcceptStatus() => _acceptStatusCodes.contains(code);
  bool isPendingStatus() => _pendingStatusCodes.contains(code);
  bool isCancellationStatus() => _cancellationStatusCodes.contains(code);
  bool isServicePerformStatus() => _servicePerformStatusCodes.contains(code);
}

