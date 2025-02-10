import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/models/scheduling_day/scheduling_day.dart';
import 'package:prestador_de_servico/app/shared/date/date_functions.dart';

class CustomHorizontalCalendarCard extends StatefulWidget {
  final SchedulingDay schedulingDay;

  const CustomHorizontalCalendarCard({super.key, required this.schedulingDay});

  @override
  State<CustomHorizontalCalendarCard> createState() => _CustomHorizontalCalendarCardState();
}

class _CustomHorizontalCalendarCardState extends State<CustomHorizontalCalendarCard> {
  late SchedulingDay schedulingDay;  

  String get formatDay => widget.schedulingDay.date.day.toString();
  String get formatWeekDay => DateFunctions.getWeekDayNameWithDoubleLine(widget.schedulingDay.date.weekday);

  Color get textColor {
    if (schedulingDay.isSelected) {
      return Theme.of(context).colorScheme.onSecondary;
    }
    if (schedulingDay.hasService) {
      return Theme.of(context).colorScheme.onPrimary;
    }
    return Theme.of(context).colorScheme.secondary;
  }
  
  Color get backColor {
    if (schedulingDay.isSelected) {
      return Theme.of(context).colorScheme.secondary;
    }
    if (schedulingDay.hasService) {
      return Theme.of(context).colorScheme.primary;
    }
    return Theme.of(context).colorScheme.onSecondary;
  }

  @override
  void initState() {
    schedulingDay = widget.schedulingDay;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 4, top: 0, right: 4, bottom: 10),
      width: 80,
      decoration: BoxDecoration(
        color: backColor,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow,
            offset: const Offset(0, 4),
            blurStyle: BlurStyle.normal,
            blurRadius: 4,
          )
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 8),
          Expanded(
            child: Center(
              child: Text(
                formatDay,
                style: TextStyle(
                  fontSize: 40,
                  color: textColor,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 48,
            child: Center(
              child: Text(
                formatWeekDay,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: textColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
