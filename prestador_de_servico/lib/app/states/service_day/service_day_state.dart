import 'package:prestador_de_servico/app/models/service_day/service_day.dart';

abstract class ServiceDayState {}

class ServiceDayInitial extends ServiceDayState {}

class ServiceDayLoading extends ServiceDayState {}

class ServiceDayError extends ServiceDayState {
  final String message;
  ServiceDayError(this.message);
}

class ServiceDayLoaded extends ServiceDayState {
  final List<ServiceDay> serviceDays;
  final String message;

  ServiceDayLoaded({required this.serviceDays, this.message = ''});
}
