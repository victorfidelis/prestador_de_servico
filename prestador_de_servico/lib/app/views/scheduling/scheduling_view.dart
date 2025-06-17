import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/services/scheduling/scheduling_service.dart';
import 'package:prestador_de_servico/app/views/scheduling/viewmodels/days_viewmodel.dart';
import 'package:prestador_de_servico/app/shared/viewmodels/scheduling/scheduling_viewmodel.dart';
import 'package:prestador_de_servico/app/shared/utils/formatters/formatters.dart';
import 'package:prestador_de_servico/app/shared/widgets/back_navigation.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_app_bar_title.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_header_container.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_loading.dart';
import 'package:prestador_de_servico/app/views/scheduling/states/days_state.dart';
import 'package:prestador_de_servico/app/shared/states/scheduling/scheduling_state.dart';
import 'package:prestador_de_servico/app/views/scheduling/widgets/custom_horizontal_calendar.dart';
import 'package:prestador_de_servico/app/views/scheduling/widgets/custom_menu_calendar_type.dart';
import 'package:prestador_de_servico/app/views/scheduling/widgets/custom_month_calendar.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_scheduling_card.dart';
import 'package:provider/provider.dart';

class SchedulingView extends StatefulWidget {
  const SchedulingView({super.key});

  @override
  State<SchedulingView> createState() => _SchedulingViewState();
}

class _SchedulingViewState extends State<SchedulingView> {
  late final DaysViewModel daysViewModel;
  late final SchedulingViewModel schedulingViewModel;

  ValueNotifier<DateTime> selectedDay = ValueNotifier(DateTime.now());

  @override
  void initState() {
    daysViewModel = DaysViewModel(schedulingService: context.read<SchedulingService>());
    schedulingViewModel = SchedulingViewModel(
      schedulingService: context.read<SchedulingService>(),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      daysViewModel.load(selectedDay.value);
      loadToday();
    });
    super.initState();
  }

  @override
  void dispose() {
    daysViewModel.dispose();
    schedulingViewModel.dispose();
    selectedDay.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              CustomHeaderContainer(
                height: 100,
                child: Padding(
                  padding: const EdgeInsets.only(top: 28),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                          width: 60, child: BackNavigation(onTap: () => Navigator.pop(context))),
                      const Expanded(
                        child: CustomAppBarTitle(title: 'Agenda'),
                      ),
                      SizedBox(
                        width: 60,
                        child: CustomMenuCalendarType(
                          onChangeTypeView: daysViewModel.changeTypeView,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ListenableBuilder(
            listenable: daysViewModel,
            builder: (context, _) {
              if (daysViewModel.state is DaysInitial) {
                return Container();
              }

              if (daysViewModel.state is DaysError) {
                return Center(
                  child: Text((daysViewModel.state as DaysError).message),
                );
              }

              if (daysViewModel.state is DaysLoading) {
                return Container(
                  padding: const EdgeInsets.only(top: 28),
                  child: const Center(child: CustomLoading()),
                );
              }

              final loadedState = (daysViewModel.state as DaysLoaded);
              final schedulesPerDay = loadedState.dates;

              if (loadedState.typeView == TypeView.main) {
                return CustomHorizontalCalendar(
                  schedulesPerDay: schedulesPerDay,
                  initialDate: selectedDay.value,
                  onChangeSelectedDay: onChangeSelectedDay,
                );
              } else {
                return CustomMonthCalendar(
                  schedulesPerDay: schedulesPerDay,
                  onChangeSelectedDay: onChangeSelectedDay,
                );
              }
            },
          ),
          const SizedBox(height: 6),
          Divider(color: Theme.of(context).colorScheme.shadow),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.only(left: 14, right: 24),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Agendamentos',
                    style: TextStyle(
                      fontSize: 20,
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                ListenableBuilder(
                  listenable: selectedDay,
                  builder: (context, _) {
                    return Text(
                      Formatters.defaultFormatDate(selectedDay.value),
                      style: TextStyle(
                        fontSize: 24,
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          ListenableBuilder(
            listenable: schedulingViewModel,
            builder: (context, _) {
              if (schedulingViewModel.state is SchedulingInitial) {
                return Container();
              }

              if (schedulingViewModel.state is SchedulingError) {
                return Center(
                  child: Text((schedulingViewModel.state as SchedulingError).message),
                );
              }

              if (schedulingViewModel.state is SchedulingLoading) {
                return Container(
                  padding: const EdgeInsets.only(top: 28),
                  child: const Center(child: CustomLoading()),
                );
              }

              final serviceSchedules =
                  (schedulingViewModel.state as SchedulingLoaded).schedules;

              return Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: serviceSchedules.length + 1,
                    itemBuilder: (context, index) {
                      if (index == serviceSchedules.length) {
                        return const SizedBox(height: 150);
                      }

                      return CustomSchedulingCard(
                        scheduling: serviceSchedules[index],
                        refreshOriginPage: refreshView,
                      );
                    },
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void loadToday() {
    final actualDateTime = DateTime.now();
    selectedDay.value = DateTime(actualDateTime.year, actualDateTime.month, actualDateTime.day);
    schedulingViewModel.load(dateTime: selectedDay.value);
  }

  void onChangeSelectedDay(DateTime date) {
    selectedDay.value = date;
    schedulingViewModel.load(dateTime: selectedDay.value);
    daysViewModel.changeSelectedDay(date);
  }

  void refreshView() {
    daysViewModel.load(selectedDay.value);
    schedulingViewModel.load(dateTime: selectedDay.value);
  }
}
