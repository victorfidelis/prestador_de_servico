import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/controllers/scheduling/days_controller.dart';
import 'package:prestador_de_servico/app/controllers/scheduling/service_scheduling_controller.dart';
import 'package:prestador_de_servico/app/shared/formatters/formatters.dart';
import 'package:prestador_de_servico/app/shared/widgets/back_navigation.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_app_bar_title.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_header_container.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_loading.dart';
import 'package:prestador_de_servico/app/states/service_scheduling/days_state.dart';
import 'package:prestador_de_servico/app/states/service_scheduling/service_scheduling_state.dart';
import 'package:prestador_de_servico/app/views/scheduling/widgets/custom_horizontal_calendar.dart';
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
      context.read<DaysController>().load();
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
                      const SizedBox(width: 60),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Consumer<DaysController>(
            builder: (context, daysController, _) {
              if (daysController.state is DaysInitial) {
                return Container();
              }

              if (daysController.state is DaysError) {
                return Center(
                  child: Text((daysController.state as DaysError).message),
                );
              }

              if (daysController.state is DaysLoading) {
                return Container(
                  padding: const EdgeInsets.only(top: 28),
                  child: const CustomLoading(),
                );
              }

              final schedulesPerDay = (daysController.state as DaysLoaded).dates;

              return CustomHorizontalCalendar(
                schedulesPerDay: schedulesPerDay,
                onChangeSelectedDay: _onChangeSelectedDay,
              );
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
          Consumer<ServiceSchedulingController>(
            builder: (context, serviceSchedulingController, _) {
              if (serviceSchedulingController.state is ServiceSchedulingInitial) {
                return Container();
              }

              if (serviceSchedulingController.state is ServiceSchedulingError) {
                return Center(
                  child: Text((serviceSchedulingController.state as ServiceSchedulingError).message),
                );
              }

              if (serviceSchedulingController.state is ServiceSchedulingLoading) {
                return Container(
                  padding: const EdgeInsets.only(top: 28),
                  child: const Center(child: CustomLoading()),
                );
              }

              final serviceSchedules = (serviceSchedulingController.state as ServiceSchedulingLoaded).serviceSchedules;

              return Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: serviceSchedules.length,
                    itemBuilder: (context, index) {
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
    context.read<ServiceSchedulingController>().load(dateTime: selectedDay.value);
  }

  void _onChangeSelectedDay(DateTime date) {
    selectedDay.value = date;
    context.read<ServiceSchedulingController>().load(dateTime: selectedDay.value);
  }
}
