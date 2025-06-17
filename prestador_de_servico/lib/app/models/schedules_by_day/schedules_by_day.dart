// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:prestador_de_servico/app/models/scheduling/scheduling.dart';

class SchedulesByDay {
  DateTime day; 
  List<Scheduling> schedules;

  SchedulesByDay({
    required this.day,
    required this.schedules,
  });

  SchedulesByDay copyWith({
    DateTime? day,
    List<Scheduling>? schedules,
  }) {
    return SchedulesByDay(
      day: day ?? this.day,
      schedules: schedules ?? this.schedules,
    );
  }
}
