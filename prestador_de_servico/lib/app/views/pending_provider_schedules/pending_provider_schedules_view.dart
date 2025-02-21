import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/controllers/scheduling/pending_provider_schedules_controller.dart';
import 'package:prestador_de_servico/app/shared/widgets/back_navigation.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_app_bar_title.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_header_container.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_loading.dart';
import 'package:prestador_de_servico/app/states/service_scheduling/pending_provider_schedules_state.dart';
import 'package:prestador_de_servico/app/views/scheduling/widgets/custom_service_scheduling_card.dart';
import 'package:provider/provider.dart';

class PendingProviderSchedulesView extends StatefulWidget {
  const PendingProviderSchedulesView({super.key});

  @override
  State<PendingProviderSchedulesView> createState() => _PendingProviderSchedulesViewState();
}

class _PendingProviderSchedulesViewState extends State<PendingProviderSchedulesView> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PendingProviderSchedulesController>().load();
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
                height: 120,
                child: Padding(
                  padding: const EdgeInsets.only(top: 28),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(width: 60, child: BackNavigation(onTap: () => Navigator.pop(context))),
                      const Expanded(
                        child: CustomAppBarTitle(
                          title: 'Agendamentos Pendentes',
                          fontSize: 25,
                        ),
                      ),
                      const SizedBox(width: 60)
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Consumer<PendingProviderSchedulesController>(
            builder: (context, pendingProviderController, _) {
              
              if (pendingProviderController.state is PendingProviderInitial) {
                return Container();
              }

              if (pendingProviderController.state is PendingProviderError) {
                return Center(
                  child: Text((pendingProviderController.state as PendingProviderError).message),
                );
              }

              if (pendingProviderController.state is PendingProviderLoading) {
                return Container(
                  padding: const EdgeInsets.only(top: 28),
                  child: const Center(child: CustomLoading()),
                );
              }

              final serviceSchedules = (pendingProviderController.state as PendingProviderLoaded).serviceSchedules;

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
}
