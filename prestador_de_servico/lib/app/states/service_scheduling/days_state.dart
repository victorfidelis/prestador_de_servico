
import 'package:prestador_de_servico/app/models/scheduling_day/scheduling_day.dart';

abstract class DaysState {}

class DaysInitial extends DaysState {}

class DaysLoading extends DaysState {}

class DaysError extends DaysState {
  final String message;
  DaysError(this.message);
}

class DaysLoaded extends DaysState {
  final List<SchedulingDay> dates;
  final String message;

  DaysLoaded({required this.dates, this.message = ''});
}