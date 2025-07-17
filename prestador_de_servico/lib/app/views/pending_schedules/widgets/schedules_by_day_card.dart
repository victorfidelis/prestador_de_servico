import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/models/schedules_by_day/schedules_by_day.dart';
import 'package:prestador_de_servico/app/shared/utils/data_converter.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_scheduling_card.dart';

class SchedulesByDayCard extends StatefulWidget {
  final SchedulesByDay schedulesByDay;
  final Function()? onSchedulingChanged;
  const SchedulesByDayCard({
    super.key,
    required this.schedulesByDay,
    this.onSchedulingChanged,
  });

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
    final formatDay = DataConverter.defaultFormatDate(schedulesByDay.day);
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
          children: schedulesCard(),
        )
      ],
    );
  }

  List<CustomSchedulingCard> schedulesCard() {
    return schedulesByDay.schedules
        .map(
          (scheduling) => CustomSchedulingCard(
            scheduling: scheduling,
            index: schedulesByDay.schedules.indexWhere((s) => s.id == scheduling.id),
            onPressed: _editScheduling,
          ),
        )
        .toList();
  }

  void _editScheduling(int index) async {
    final bool hasChange = await Navigator.pushNamed(
      context,
      '/schedulingDetails',
      arguments: {'scheduling': schedulesByDay.schedules[index]},
    ) as bool;

    if (hasChange && widget.onSchedulingChanged != null) {
      widget.onSchedulingChanged!();
    }
  }
}
