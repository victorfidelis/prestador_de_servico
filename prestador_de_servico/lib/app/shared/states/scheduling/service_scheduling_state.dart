import 'package:prestador_de_servico/app/models/scheduling/scheduling.dart';

abstract class ServiceSchedulingState {}

class ServiceSchedulingInitial extends ServiceSchedulingState {}

class ServiceSchedulingLoading extends ServiceSchedulingState {}

class ServiceSchedulingError extends ServiceSchedulingState {
  final String message;
  ServiceSchedulingError(this.message);
}

class ServiceSchedulingLoaded extends ServiceSchedulingState {
  final List<Scheduling> serviceSchedules;
  final String message;

  ServiceSchedulingLoaded({required this.serviceSchedules, this.message = ''});
}

