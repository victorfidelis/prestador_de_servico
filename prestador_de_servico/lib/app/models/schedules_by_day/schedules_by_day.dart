// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:prestador_de_servico/app/models/service_scheduling/service_scheduling.dart';

class SchedulesByDay {
  DateTime day; 
  List<ServiceScheduling> serviceSchedules;

  SchedulesByDay({
    required this.day,
    required this.serviceSchedules,
  });

  SchedulesByDay copyWith({
    DateTime? day,
    List<ServiceScheduling>? serviceSchedules,
  }) {
    return SchedulesByDay(
      day: day ?? this.day,
      serviceSchedules: serviceSchedules ?? this.serviceSchedules,
    );
  }
}
