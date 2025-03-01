import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/shared/widgets/back_navigation.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_app_bar_title.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_header_container.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_loading.dart';
import 'package:prestador_de_servico/app/shared/widgets/sliver_app_bar_delegate.dart';
import 'package:prestador_de_servico/app/views/pending_schedules/states/pending_schedules_state.dart';
import 'package:prestador_de_servico/app/views/pending_schedules/viewmodels/pending_payment_schedules_viewmodel.dart';
import 'package:prestador_de_servico/app/views/pending_schedules/widgets/schedules_by_day_card.dart';
import 'package:provider/provider.dart';

class PendingPaymentSchedulesView extends StatefulWidget {
  const PendingPaymentSchedulesView({super.key});

  @override
  State<PendingPaymentSchedulesView> createState() => _PendingPaymentSchedulesViewState();
}

class _PendingPaymentSchedulesViewState extends State<PendingPaymentSchedulesView> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PendingPaymentSchedulesViewModel>().load();
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
                              title: 'Pagamentos Pendentes',
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
          Consumer<PendingPaymentSchedulesViewModel>(
            builder: (context, pendingPaymentViewModel, _) {
              
              if (pendingPaymentViewModel.state is PendingInitial) {
                return const SliverFillRemaining();
              }

              if (pendingPaymentViewModel.state is PendingError) {
                return SliverFillRemaining(
                  child: Center(
                    child: Text((pendingPaymentViewModel.state as PendingError).message),
                  ),
                );
              }

              if (pendingPaymentViewModel.state is PendingLoading) {
                return SliverFillRemaining(
                  child: Container(
                    padding: const EdgeInsets.only(top: 28),
                    child: const Center(child: CustomLoading()),
                  ),
                );
              }

              final schedulesByDays = (pendingPaymentViewModel.state as PendingLoaded).schedulesByDays;

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