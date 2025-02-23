import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/views/pending_schedules/viewmodels/pending_provider_schedules_viewmodel.dart';
import 'package:prestador_de_servico/app/shared/widgets/back_navigation.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_app_bar_title.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_header_container.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_loading.dart';
import 'package:prestador_de_servico/app/shared/widgets/sliver_app_bar_delegate.dart';
import 'package:prestador_de_servico/app/views/pending_schedules/states/pending_schedules_state.dart';
import 'package:prestador_de_servico/app/views/pending_schedules/widgets/schedules_by_day_card.dart';
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
      context.read<PendingProviderSchedulesViewModel>().load();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(
            floating: true,
            delegate: SliverAppBarDelegate(
              minHeight: 144,
              maxHeight: 144,
              child: Stack(
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
            ),
          ),
          Consumer<PendingProviderSchedulesViewModel>(
            builder: (context, pendingProviderViewModel, _) {
              
              if (pendingProviderViewModel.state is PendingInitial) {
                return const SliverFillRemaining();
              }

              if (pendingProviderViewModel.state is PendingError) {
                return SliverFillRemaining(
                  child: Center(
                    child: Text((pendingProviderViewModel.state as PendingError).message),
                  ),
                );
              }

              if (pendingProviderViewModel.state is PendingLoading) {
                return SliverFillRemaining(
                  child: Container(
                    padding: const EdgeInsets.only(top: 28),
                    child: const Center(child: CustomLoading()),
                  ),
                );
              }

              final schedulesByDays = (pendingProviderViewModel.state as PendingLoaded).schedulesByDays;

              return SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                sliver: SliverList.builder(
                  itemCount: schedulesByDays.length + 1,
                  itemBuilder: (context, index) {
                    if (index == schedulesByDays.length) {
                      return const SizedBox(height: 150);
                    }
                              
                    return SchedulesByDayCard(
                      schedulesByDay: schedulesByDays[index],
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
