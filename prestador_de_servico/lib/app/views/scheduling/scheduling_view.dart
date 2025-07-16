import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/services/scheduling/scheduling_service.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_empty_list.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_header.dart';
import 'package:prestador_de_servico/app/views/scheduling/viewmodels/days_viewmodel.dart';
import 'package:prestador_de_servico/app/shared/viewmodels/scheduling/scheduling_viewmodel.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_loading.dart';
import 'package:prestador_de_servico/app/shared/states/scheduling/scheduling_state.dart';
import 'package:prestador_de_servico/app/views/scheduling/viewmodels/type_view.dart';
import 'package:prestador_de_servico/app/views/scheduling/widgets/custom_horizontal_calendar.dart';
import 'package:prestador_de_servico/app/views/scheduling/widgets/custom_menu_calendar_type.dart';
import 'package:prestador_de_servico/app/views/scheduling/widgets/custom_month_calendar.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_scheduling_card.dart';
import 'package:prestador_de_servico/app/views/scheduling/widgets/scheduling_day_title.dart';
import 'package:provider/provider.dart';

class SchedulingView extends StatefulWidget {
  const SchedulingView({super.key});

  @override
  State<SchedulingView> createState() => _SchedulingViewState();
}

class _SchedulingViewState extends State<SchedulingView> {
  late final DaysViewModel daysViewModel;
  late final SchedulingViewModel schedulingViewModel;

  @override
  void initState() {
    daysViewModel = DaysViewModel(schedulingService: context.read<SchedulingService>());
    schedulingViewModel = SchedulingViewModel(
      schedulingService: context.read<SchedulingService>(),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      daysViewModel.load();
      _loadToday();
    });
    super.initState();
  }

  @override
  void dispose() {
    daysViewModel.dispose();
    schedulingViewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverFloatingHeader(
              child: CustomHeader(
                title: 'Agenda',
                action: CustomMenuCalendarType(onChangeTypeView: daysViewModel.changeTypeView),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 10)),
            ListenableBuilder(
              listenable: daysViewModel,
              builder: (context, _) {
                if (daysViewModel.hasError) {
                  return SliverToBoxAdapter(
                    child: Center(
                      child: Text(daysViewModel.errorMessage!),
                    ),
                  );
                }

                if (daysViewModel.daysLoading) {
                  return SliverToBoxAdapter(
                    child: Container(
                      padding: const EdgeInsets.only(top: 28),
                      child: const Center(child: CustomLoading()),
                    ),
                  );
                }

                if (daysViewModel.schedulesPerDay.isEmpty) {
                  return const SliverToBoxAdapter(child: SizedBox());
                }

                if (daysViewModel.typeView == TypeView.main) {
                  return SliverToBoxAdapter(
                    child: CustomHorizontalCalendar(
                      schedulesPerDay: daysViewModel.schedulesPerDay,
                      initialDate: daysViewModel.selectedDay.value,
                      onChangeSelectedDay: _onChangeSelectedDay,
                    ),
                  );
                } else {
                  return SliverToBoxAdapter(
                    child: CustomMonthCalendar(
                      schedulesPerDay: daysViewModel.schedulesPerDay,
                      onChangeSelectedDay: _onChangeSelectedDay,
                    ),
                  );
                }
              },
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 6)),
            SliverToBoxAdapter(child: Divider(color: Theme.of(context).colorScheme.shadow)),
            const SliverToBoxAdapter(child: SizedBox(height: 6)),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(left: 14, right: 24),
                child: ListenableBuilder(
                  listenable: daysViewModel.selectedDay,
                  builder: (context, _) {
                    return SchedulingDayTitle(date: daysViewModel.selectedDay.value);
                  },
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 6)),
            ListenableBuilder(
              listenable: schedulingViewModel,
              builder: (context, _) {
                if (schedulingViewModel.state is SchedulingInitial) {
                  return const SliverToBoxAdapter();
                }

                if (schedulingViewModel.state is SchedulingError) {
                  return SliverToBoxAdapter(
                    child: Center(
                      child: Text((schedulingViewModel.state as SchedulingError).message),
                    ),
                  );
                }

                if (schedulingViewModel.state is SchedulingLoading) {
                  return const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.only(top: 28),
                      child: Center(child: CustomLoading()),
                    ),
                  );
                }

                final schedules = (schedulingViewModel.state as SchedulingLoaded).schedules;

                if (schedules.isEmpty) {
                  return const SliverToBoxAdapter(child: CustomEmptyList(label: 'Nenhum agendamento'));
                }

                return SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  sliver: SliverList.builder(
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
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _loadToday() {
    daysViewModel.changeToToday();
    schedulingViewModel.load(dateTime: daysViewModel.selectedDay.value);
  }

  void _onChangeSelectedDay(DateTime date) {
    schedulingViewModel.load(dateTime: date);
    daysViewModel.changeSelectedDay(date);
  }

  void _refreshView() {
    daysViewModel.load();
    schedulingViewModel.load(dateTime: daysViewModel.selectedDay.value);
  }
}
