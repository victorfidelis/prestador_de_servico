import 'package:prestador_de_servico/app/models/scheduling/scheduling.dart';

abstract class SchedulingState {}

class SchedulingInitial extends SchedulingState {}

class SchedulingLoading extends SchedulingState {}

class SchedulingError extends SchedulingState {
  final String message;
  SchedulingError(this.message);
}

class SchedulingLoaded extends SchedulingState {
  final List<Scheduling> schedules;
  final String message;

  SchedulingLoaded({required this.schedules, this.message = ''});
}

