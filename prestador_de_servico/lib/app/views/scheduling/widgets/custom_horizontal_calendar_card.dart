import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/models/scheduling_day/scheduling_day.dart';
import 'package:prestador_de_servico/app/shared/utils/formatters/formatters.dart';

class CustomHorizontalCalendarCard extends StatefulWidget {
  final SchedulingDay schedulingDay;
  final Function(DateTime) onSelectedDay;

  const CustomHorizontalCalendarCard({
    super.key,
    required this.schedulingDay,
    required this.onSelectedDay,
  });

  @override
  State<CustomHorizontalCalendarCard> createState() => _CustomHorizontalCalendarCardState();
}

class _CustomHorizontalCalendarCardState extends State<CustomHorizontalCalendarCard> {

  String get formatDay => widget.schedulingDay.date.day.toString();
  String get formatWeekDay => Formatters.getWeekDayNameWithDoubleLine(widget.schedulingDay.date.weekday);

  Color get textColor {
    if (widget.schedulingDay.isSelected) {
      return Theme.of(context).colorScheme.onSecondary;
    }
    if (widget.schedulingDay.hasService) {
      return Theme.of(context).colorScheme.onPrimary;
    }
    return Theme.of(context).colorScheme.secondary;
  }

  Color get backColor {
    if (widget.schedulingDay.isSelected) {
      return Theme.of(context).colorScheme.secondary;
    }
    if (widget.schedulingDay.hasService) {
      return Theme.of(context).colorScheme.primary;
    }
    return Theme.of(context).colorScheme.onSecondary;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.schedulingDay.isSelected) return;

        widget.onSelectedDay(widget.schedulingDay.date);
      },
      child: Container(
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
      ),
    );
  }
}
