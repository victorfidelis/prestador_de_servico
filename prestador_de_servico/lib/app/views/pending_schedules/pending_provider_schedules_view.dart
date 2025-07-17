import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/services/scheduling/scheduling_service.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_empty_list.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_header.dart';
import 'package:prestador_de_servico/app/views/pending_schedules/viewmodels/pending_provider_schedules_viewmodel.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_loading.dart';
import 'package:prestador_de_servico/app/views/pending_schedules/widgets/schedules_by_day_card.dart';
import 'package:provider/provider.dart';

class PendingProviderSchedulesView extends StatefulWidget {
  const PendingProviderSchedulesView({super.key});

  @override
  State<PendingProviderSchedulesView> createState() => _PendingProviderSchedulesViewState();
}

class _PendingProviderSchedulesViewState extends State<PendingProviderSchedulesView> {
  late final PendingProviderSchedulesViewModel pendingProviderViewModel;

  @override
  void initState() {
    pendingProviderViewModel = PendingProviderSchedulesViewModel(
      schedulingService: context.read<SchedulingService>(),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      pendingProviderViewModel.load();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            const SliverFloatingHeader(child: CustomHeader(title: 'Agendamentos Pendentes', height: 100)),
            const SliverToBoxAdapter(child: SizedBox(height: 10)),
            ListenableBuilder(
              listenable: pendingProviderViewModel,
              builder: (context, _) {
                if (pendingProviderViewModel.hasError) {
                  return SliverFillRemaining(
                    child: Center(
                      child: Text(pendingProviderViewModel.errorMessage!),
                    ),
                  );
                }

                if (pendingProviderViewModel.pendingLoading) {
                  return const SliverFillRemaining(
                    child: Padding(
                      padding: EdgeInsets.only(top: 28),
                      child: Center(child: CustomLoading()),
                    ),
                  );
                }

                if (pendingProviderViewModel.schedulesByDays.isEmpty) {
                  return const SliverFillRemaining(child: CustomEmptyList(label: 'Nenhum agendamento pendente'));
                }

                return SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                  sliver: SliverList.builder(
                    itemCount: pendingProviderViewModel.schedulesByDays.length + 1,
                    itemBuilder: (context, index) {
                      if (index == pendingProviderViewModel.schedulesByDays.length) {
                        return const SizedBox(height: 150);
                      }

                      return SchedulesByDayCard(
                        schedulesByDay: pendingProviderViewModel.schedulesByDays[index],
                        onSchedulingChanged: () => pendingProviderViewModel.load(),
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
}
