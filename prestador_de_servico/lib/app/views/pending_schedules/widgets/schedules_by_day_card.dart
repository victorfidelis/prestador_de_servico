import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/models/schedules_by_day/schedules_by_day.dart';
import 'package:prestador_de_servico/app/shared/utils/formatters/formatters.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_service_scheduling_card.dart';

class SchedulesByDayCard extends StatefulWidget {
  final SchedulesByDay schedulesByDay;
  const SchedulesByDayCard({super.key, required this.schedulesByDay});

  @override
  State<SchedulesByDayCard> createState() => _SchedulesByDayCardState();
}

class _SchedulesByDayCardState extends State<SchedulesByDayCard> {
  late SchedulesByDay schedulesByDay;

  @override
  void initState() {
    schedulesByDay = widget.schedulesByDay;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final formatDay = Formatters.defaultFormatDate(schedulesByDay.day);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          formatDay,
          style: TextStyle(
            fontSize: 22,
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.w700,
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: serviceScheduleschedulesCard(),
        )
      ],
    );
  }

  List<CustomServiceSchedulingCard> serviceScheduleschedulesCard() {
    return schedulesByDay.serviceSchedules.map((s) => CustomServiceSchedulingCard(serviceScheduling: s)).toList();
  }
}
