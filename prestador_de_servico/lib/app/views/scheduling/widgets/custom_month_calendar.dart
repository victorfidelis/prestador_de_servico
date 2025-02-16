import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/models/scheduling_day/scheduling_day.dart';
import 'package:simple_calendar/widgets/calendar_widget.dart';

class CustomMonthCalendar extends StatefulWidget {
  final List<SchedulingDay> schedulesPerDay;
  final Function(DateTime) onChangeSelectedDay;

  const CustomMonthCalendar({super.key, required this.schedulesPerDay, required this.onChangeSelectedDay});

  @override
  State<CustomMonthCalendar> createState() => _CustomMonthCalendarState();
}

class _CustomMonthCalendarState extends State<CustomMonthCalendar> {
  List<SchedulingDay> schedulesPerDay = [];
  List<DateTime> daysWithServices = [];
  late DateTime selectedDay;
  late DateTime initialDate;
  late DateTime finalDate;

  @override
  void initState() {
    schedulesPerDay = widget.schedulesPerDay;
    loadSelectedDay();
    loadDaysWithServices();
    loadInitialAndFinalDate();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CalendarWidget(
      initialDate: initialDate,
      finalDate: finalDate,
      selectedDate: selectedDay,
      markedDates: daysWithServices,
      onSelectDate: widget.onChangeSelectedDay,
    );
  }

  void loadInitialAndFinalDate() {
    initialDate = schedulesPerDay[0].date;
    finalDate = schedulesPerDay[schedulesPerDay.length - 1].date;
  }

  void loadSelectedDay() {
    final int indexForSelectedDay = schedulesPerDay.indexWhere((s) => s.isSelected);
    selectedDay = schedulesPerDay[indexForSelectedDay].date;
  }

  void loadDaysWithServices() {
    final schedulesWithServices = schedulesPerDay.where((s) => s.hasService).toList();
    daysWithServices = schedulesWithServices.map((d) => d.date).toList();
  }
}
