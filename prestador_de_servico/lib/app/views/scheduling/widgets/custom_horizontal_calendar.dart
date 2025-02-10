import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/models/scheduling_day/scheduling_day.dart';
import 'package:prestador_de_servico/app/shared/date/date_functions.dart';
import 'package:prestador_de_servico/app/views/scheduling/widgets/custom_horizontal_calendar_card.dart';

class CustomHorizontalCalendar extends StatefulWidget {
  final List<SchedulingDay> schedulesPerDay;

  const CustomHorizontalCalendar({super.key, required this.schedulesPerDay});

  @override
  State<CustomHorizontalCalendar> createState() => _CustomHorizontalCalendarState();
}

class _CustomHorizontalCalendarState extends State<CustomHorizontalCalendar> {
  late List<SchedulingDay> schedulesPerDay;
  late DateTime selectedDay;

  @override
  void initState() {
    schedulesPerDay = widget.schedulesPerDay;
    setSelectedDay();
    super.initState();
  }

  void setSelectedDay() {
    selectedDay = schedulesPerDay.firstWhere((d) => d.isSelected).date;
  }

  String get selectedMonth => DateFunctions.getMonthName(selectedDay.month);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: Text(
                  selectedMonth,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
              Text(
                selectedDay.year.toString(),
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w400,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: schedulesPerDay.length,
            itemBuilder: (context, index) {
              return CustomHorizontalCalendarCard(schedulingDay: schedulesPerDay[index]);
            },
          ),
        ),
      ],
    );
  }
}
