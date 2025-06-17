// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:prestador_de_servico/app/models/scheduling/scheduling.dart';

class SchedulesByDay {
  DateTime day; 
  List<Scheduling> serviceSchedules;

  SchedulesByDay({
    required this.day,
    required this.serviceSchedules,
  });

  SchedulesByDay copyWith({
    DateTime? day,
    List<Scheduling>? serviceSchedules,
  }) {
    return SchedulesByDay(
      day: day ?? this.day,
      serviceSchedules: serviceSchedules ?? this.serviceSchedules,
    );
  }
}
