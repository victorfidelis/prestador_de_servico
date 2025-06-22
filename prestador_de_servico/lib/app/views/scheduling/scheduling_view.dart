import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/services/scheduling/scheduling_service.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_empty_list.dart';
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
  late final DaysViewModel _daysViewModel;
  late final SchedulingViewModel _schedulingViewModel;

  final ValueNotifier<DateTime> _selectedDay = ValueNotifier(DateTime.now());

  @override
  void initState() {
    _daysViewModel = DaysViewModel(schedulingService: context.read<SchedulingService>());
    _schedulingViewModel = SchedulingViewModel(
      schedulingService: context.read<SchedulingService>(),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _daysViewModel.load(_selectedDay.value);
      _loadToday();
    });
    super.initState();
  }

  @override
  void dispose() {
    _daysViewModel.dispose();
    _schedulingViewModel.dispose();
    _selectedDay.dispose();
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
                          onChangeTypeView: _daysViewModel.changeTypeView,
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
            listenable: _daysViewModel,
            builder: (context, _) {
              if (_daysViewModel.state is DaysInitial) {
                return Container();
              }

              if (_daysViewModel.state is DaysError) {
                return Center(
                  child: Text((_daysViewModel.state as DaysError).message),
                );
              }

              if (_daysViewModel.state is DaysLoading) {
                return Container(
                  padding: const EdgeInsets.only(top: 28),
                  child: const Center(child: CustomLoading()),
                );
              }

              final loadedState = (_daysViewModel.state as DaysLoaded);
              final schedulesPerDay = loadedState.dates;

              if (loadedState.typeView == TypeView.main) {
                return CustomHorizontalCalendar(
                  schedulesPerDay: schedulesPerDay,
                  initialDate: _selectedDay.value,
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
                  listenable: _selectedDay,
                  builder: (context, _) {
                    return Text(
                      Formatters.defaultFormatDate(_selectedDay.value),
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
            listenable: _schedulingViewModel,
            builder: (context, _) {
              if (_schedulingViewModel.state is SchedulingInitial) {
                return Container();
              }

              if (_schedulingViewModel.state is SchedulingError) {
                return Center(
                  child: Text((_schedulingViewModel.state as SchedulingError).message),
                );
              }

              if (_schedulingViewModel.state is SchedulingLoading) {
                return Container(
                  padding: const EdgeInsets.only(top: 28),
                  child: const Center(child: CustomLoading()),
                );
              }

              final schedules =
                  (_schedulingViewModel.state as SchedulingLoaded).schedules;

              if (schedules.isEmpty) {
                return const CustomEmptyList(label: 'Nenhum agendamento');
              }

              return Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: schedules.length + 1,
                    itemBuilder: (context, index) {
                      if (index == schedules.length) {
                        return const SizedBox(height: 150);
                      }

                      return CustomSchedulingCard(
                        scheduling: schedules[index],
                        refreshOriginPage: _refreshView,
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
    _selectedDay.value = DateTime(actualDateTime.year, actualDateTime.month, actualDateTime.day);
    _schedulingViewModel.load(dateTime: _selectedDay.value);
  }

  void _onChangeSelectedDay(DateTime date) {
    _selectedDay.value = date;
    _schedulingViewModel.load(dateTime: _selectedDay.value);
    _daysViewModel.changeSelectedDay(date);
  }

  void _refreshView() {
    _daysViewModel.load(_selectedDay.value);
    _schedulingViewModel.load(dateTime: _selectedDay.value);
  }
}
