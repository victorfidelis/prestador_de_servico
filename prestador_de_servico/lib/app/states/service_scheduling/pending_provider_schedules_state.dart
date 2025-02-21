
import 'package:prestador_de_servico/app/models/service_scheduling/service_scheduling.dart';

abstract class PendingProviderSchedulesState {}

class PendingProviderInitial extends PendingProviderSchedulesState {}

class PendingProviderLoading extends PendingProviderSchedulesState {}

class PendingProviderError extends PendingProviderSchedulesState {
  final String message;
  PendingProviderError(this.message);
}

class PendingProviderLoaded extends PendingProviderSchedulesState {
  final List<ServiceScheduling> serviceSchedules;
  final String message;

  PendingProviderLoaded({required this.serviceSchedules, this.message = ''});
}