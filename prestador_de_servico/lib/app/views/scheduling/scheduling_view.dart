import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/controllers/scheduling/days_controller.dart';
import 'package:prestador_de_servico/app/shared/widgets/back_navigation.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_app_bar_title.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_header_container.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_loading.dart';
import 'package:prestador_de_servico/app/states/service_scheduling/days_state.dart';
import 'package:prestador_de_servico/app/views/scheduling/widgets/custom_horizontal_calendar.dart';
import 'package:provider/provider.dart';

class SchedulingView extends StatefulWidget {
  const SchedulingView({super.key});

  @override
  State<SchedulingView> createState() => _SchedulingViewState();
}

class _SchedulingViewState extends State<SchedulingView> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DaysController>().load();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.min,
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
                return const Center(
                  child: CustomLoading(),
                );
              }

              final schedulesPerDay = (daysController.state as DaysLoaded).dates;

              return CustomHorizontalCalendar(
                schedulesPerDay: schedulesPerDay,
              );
            },
          ),
        ],
      ),
    );
  }
}
