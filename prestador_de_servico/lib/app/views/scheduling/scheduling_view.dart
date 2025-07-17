import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/services/scheduling/scheduling_service.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_header.dart';
import 'package:prestador_de_servico/app/shared/widgets/scheduling_list/scheduling_list.dart';
import 'package:prestador_de_servico/app/views/scheduling/viewmodels/days_viewmodel.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_loading.dart';
import 'package:prestador_de_servico/app/views/scheduling/viewmodels/type_view.dart';
import 'package:prestador_de_servico/app/views/scheduling/widgets/custom_horizontal_calendar.dart';
import 'package:prestador_de_servico/app/views/scheduling/widgets/custom_menu_calendar_type.dart';
import 'package:prestador_de_servico/app/views/scheduling/widgets/custom_month_calendar.dart';
import 'package:prestador_de_servico/app/views/scheduling/widgets/scheduling_day_title.dart';
import 'package:provider/provider.dart';

class SchedulingView extends StatefulWidget {
  const SchedulingView({super.key});

  @override
  State<SchedulingView> createState() => _SchedulingViewState();
}

class _SchedulingViewState extends State<SchedulingView> {
  late final DaysViewModel daysViewModel;

  @override
  void initState() {
    daysViewModel = DaysViewModel(schedulingService: context.read<SchedulingService>());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      daysViewModel.load();
      daysViewModel.changeToToday();
    });
    super.initState();
  }

  @override
  void dispose() {
    daysViewModel.dispose();
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
                      onChangeSelectedDay: daysViewModel.changeSelectedDay,
                    ),
                  );
                } else {
                  return SliverToBoxAdapter(
                    child: CustomMonthCalendar(
                      schedulesPerDay: daysViewModel.schedulesPerDay,
                      onChangeSelectedDay: daysViewModel.changeSelectedDay,
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
              listenable: daysViewModel.selectedDay,
              builder: (context, _) {
                return SchedulingList(
                  date: daysViewModel.selectedDay.value,
                  onSchedulingChanged: daysViewModel.load,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
