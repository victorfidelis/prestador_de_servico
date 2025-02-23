import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/views/scheduling/viewmodels/days_viewmodel.dart';
import 'package:prestador_de_servico/app/views/scheduling/viewmodels/service_scheduling_viewmodel.dart';
import 'package:prestador_de_servico/app/shared/utils/formatters/formatters.dart';
import 'package:prestador_de_servico/app/shared/widgets/back_navigation.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_app_bar_title.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_header_container.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_loading.dart';
import 'package:prestador_de_servico/app/views/scheduling/states/days_state.dart';
import 'package:prestador_de_servico/app/views/scheduling/states/service_scheduling_state.dart';
import 'package:prestador_de_servico/app/views/scheduling/widgets/custom_horizontal_calendar.dart';
import 'package:prestador_de_servico/app/views/scheduling/widgets/custom_menu_calendar_type.dart';
import 'package:prestador_de_servico/app/views/scheduling/widgets/custom_month_calendar.dart';
import 'package:prestador_de_servico/app/views/scheduling/widgets/custom_service_scheduling_card.dart';
import 'package:provider/provider.dart';

class SchedulingView extends StatefulWidget {
  const SchedulingView({super.key});

  @override
  State<SchedulingView> createState() => _SchedulingViewState();
}

class _SchedulingViewState extends State<SchedulingView> {
  ValueNotifier<DateTime> selectedDay = ValueNotifier(DateTime.now());

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DaysViewModel>().load();
      _loadToday();
    });
    super.initState();
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
                      SizedBox(width: 60, child: BackNavigation(onTap: () => Navigator.pop(context))),
                      const Expanded(
                        child: CustomAppBarTitle(title: 'Agenda'),
                      ),
                      SizedBox(
                        width: 60,
                        child: CustomMenuCalendarType(),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Consumer<DaysViewModel>(
            builder: (context, daysViewModel, _) {
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
                  onChangeSelectedDay: _onChangeSelectedDay,
                );
              } else {
                return CustomMonthCalendar(
                  schedulesPerDay: schedulesPerDay,
                  onChangeSelectedDay: _onChangeSelectedDay,
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
          Consumer<ServiceSchedulingViewModel>(
            builder: (context, serviceSchedulingViewModel, _) {
              if (serviceSchedulingViewModel.state is ServiceSchedulingInitial) {
                return Container();
              }

              if (serviceSchedulingViewModel.state is ServiceSchedulingError) {
                return Center(
                  child: Text((serviceSchedulingViewModel.state as ServiceSchedulingError).message),
                );
              }

              if (serviceSchedulingViewModel.state is ServiceSchedulingLoading) {
                return Container(
                  padding: const EdgeInsets.only(top: 28),
                  child: const Center(child: CustomLoading()),
                );
              }

              final serviceSchedules = (serviceSchedulingViewModel.state as ServiceSchedulingLoaded).serviceSchedules;

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

                      return CustomServiceSchedulingCard(
                        serviceScheduling: serviceSchedules[index],
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

  void _loadToday() {
    final actualDateTime = DateTime.now();
    selectedDay.value = DateTime(actualDateTime.year, actualDateTime.month, actualDateTime.day);
    context.read<ServiceSchedulingViewModel>().load(dateTime: selectedDay.value);
  }

  void _onChangeSelectedDay(DateTime date) {
    selectedDay.value = date;
    context.read<ServiceSchedulingViewModel>().load(dateTime: selectedDay.value);
    context.read<DaysViewModel>().changeSelectedDay(date);
  }
}
