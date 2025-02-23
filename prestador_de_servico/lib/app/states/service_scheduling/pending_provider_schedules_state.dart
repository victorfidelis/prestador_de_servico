
import 'package:prestador_de_servico/app/models/schedules_by_day/schedules_by_day.dart';

abstract class PendingProviderSchedulesState {}

class PendingProviderInitial extends PendingProviderSchedulesState {}

class PendingProviderLoading extends PendingProviderSchedulesState {}

class PendingProviderError extends PendingProviderSchedulesState {
  final String message;
  PendingProviderError(this.message);
}

class PendingProviderLoaded extends PendingProviderSchedulesState {
  final List<SchedulesByDay> schedulesByDays;
  final String message;

  PendingProviderLoaded({required this.schedulesByDays, this.message = ''});
}