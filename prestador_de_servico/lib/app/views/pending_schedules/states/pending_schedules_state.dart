
import 'package:prestador_de_servico/app/models/schedules_by_day/schedules_by_day.dart';

abstract class PendingSchedulesState {}

class PendingInitial extends PendingSchedulesState {}

class PendingLoading extends PendingSchedulesState {}

class PendingError extends PendingSchedulesState {
  final String message;
  PendingError(this.message);
}

class PendingLoaded extends PendingSchedulesState {
  final List<SchedulesByDay> schedulesByDays;
  final String message;

  PendingLoaded({required this.schedulesByDays, this.message = ''});
}