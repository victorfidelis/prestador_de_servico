import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/models/scheduling_day/scheduling_day.dart';
import 'package:prestador_de_servico/app/models/scheduling_day/scheduling_day_list.dart';
import 'package:prestador_de_servico/app/shared/formatters/formatters.dart';
import 'package:prestador_de_servico/app/views/scheduling/widgets/custom_horizontal_calendar_card.dart';

class CustomHorizontalCalendar extends StatefulWidget {
  final List<SchedulingDay> schedulesPerDay;
  final Function(DateTime) onChangeSelectedDay;

  const CustomHorizontalCalendar({
    super.key,
    required this.schedulesPerDay,
    required this.onChangeSelectedDay,
  });

  @override
  State<CustomHorizontalCalendar> createState() => _CustomHorizontalCalendarState();
}

class _CustomHorizontalCalendarState extends State<CustomHorizontalCalendar> {
  final ScrollController _scrollController = ScrollController();
  late SchedulingDayList schedulingDayList;
  final ValueNotifier<String> selectedMonth = ValueNotifier('');
  final ValueNotifier<String> selectedYear = ValueNotifier('');
  final double cardWidth = 88;

  @override
  void initState() {
    schedulingDayList = SchedulingDayList(value: widget.schedulesPerDay);
    selectedMonth.value = Formatters.getMonthName(schedulingDayList.value[0].date.month);
    selectedYear.value = schedulingDayList.value[0].date.year.toString();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) => _positionScroll(DateTime.now()));
    super.initState();
  }

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
                child: ListenableBuilder(
                    listenable: selectedMonth,
                    builder: (context, _) {
                      return Text(
                        selectedMonth.value,
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      );
                    }),
              ),
              ListenableBuilder(
                  listenable: selectedYear,
                  builder: (context, _) {
                    return Text(
                      selectedYear.value,
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w400,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    );
                  }),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 120,
          child: ListenableBuilder(
            listenable: schedulingDayList,
            builder: (context, _) {
              return ListView.builder(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                itemCount: schedulingDayList.value.length,
                itemBuilder: (context, index) {
                  return CustomHorizontalCalendarCard(
                    key: ValueKey(schedulingDayList.value[index].hashCode.toString()),
                    schedulingDay: schedulingDayList.value[index],
                    onSelectedDay: _onChangeSelectedDay,
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  void _onScroll() {
    final int index = (_scrollController.offset / cardWidth).floor();
    selectedMonth.value = Formatters.getMonthName(schedulingDayList.value[index].date.month);
    selectedYear.value = schedulingDayList.value[index].date.year.toString();
  } 

  void _onChangeSelectedDay(DateTime date) {
    schedulingDayList.changeSelectedDay(date);
    widget.onChangeSelectedDay(date);
  }

  void _positionScroll(DateTime date) {
    final minDate = schedulingDayList.value[0].date;
    // final maxDate = schedulingDayList.value[schedulingDayList.value.length - 1].date; 

    final int numberOfDaysUntilDate = date.difference(minDate).inDays;

    final double pixelsToScroll = numberOfDaysUntilDate * cardWidth;

    _scrollController.jumpTo(pixelsToScroll);
  }
}
