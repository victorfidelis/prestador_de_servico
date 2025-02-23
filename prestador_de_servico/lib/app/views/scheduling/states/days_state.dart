// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:prestador_de_servico/app/models/scheduling_day/scheduling_day.dart';

enum TypeView {
  main,
  mount,
}

abstract class DaysState {}

class DaysInitial extends DaysState {}

class DaysLoading extends DaysState {}

class DaysError extends DaysState {
  final String message;
  DaysError(this.message);
}

class DaysLoaded extends DaysState {
  final List<SchedulingDay> dates;
  final TypeView typeView;
  final String message;

  DaysLoaded({required this.dates, this.typeView = TypeView.main, this.message = ''});

  DaysLoaded copyWith({
    List<SchedulingDay>? dates,
    TypeView? typeView,
    String? message,
  }) {
    return DaysLoaded(
      dates: dates ?? this.dates,
      typeView: typeView ?? this.typeView,
      message: message ?? this.message,
    );
  }
}
