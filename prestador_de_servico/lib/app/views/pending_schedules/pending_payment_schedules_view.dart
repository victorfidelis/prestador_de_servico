import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/services/scheduling/scheduling_service.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_empty_list.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_header.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_loading.dart';
import 'package:prestador_de_servico/app/views/pending_schedules/viewmodels/pending_payment_schedules_viewmodel.dart';
import 'package:prestador_de_servico/app/views/pending_schedules/widgets/schedules_by_day_card.dart';
import 'package:provider/provider.dart';

class PendingPaymentSchedulesView extends StatefulWidget {
  const PendingPaymentSchedulesView({super.key});

  @override
  State<PendingPaymentSchedulesView> createState() => _PendingPaymentSchedulesViewState();
}

class _PendingPaymentSchedulesViewState extends State<PendingPaymentSchedulesView> {
  late final PendingPaymentSchedulesViewModel pendingPaymentViewModel;

  @override
  void initState() {
    pendingPaymentViewModel = PendingPaymentSchedulesViewModel(
      schedulingService: context.read<SchedulingService>(),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      pendingPaymentViewModel.load();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            const SliverFloatingHeader(child: CustomHeader(title: 'Pagamentos Pendentes', height: 100)),
            ListenableBuilder(
              listenable: pendingPaymentViewModel,
              builder: (context, _) {
                if (pendingPaymentViewModel.hasError) {
                  return SliverFillRemaining(
                    child: Center(
                      child: Text(pendingPaymentViewModel.errorMessage!),
                    ),
                  );
                }

                if (pendingPaymentViewModel.pendingLoading) {
                  return SliverFillRemaining(
                    child: Container(
                      padding: const EdgeInsets.only(top: 28),
                      child: const Center(child: CustomLoading()),
                    ),
                  );
                }

                if (pendingPaymentViewModel.schedulesByDays.isEmpty) {
                  return const SliverFillRemaining(child: CustomEmptyList(label: 'Nenhum pagamento pendente'));
                }

                return SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                  sliver: SliverList.builder(
                    itemCount: pendingPaymentViewModel.schedulesByDays.length + 1,
                    itemBuilder: (context, index) {
                      if (index == pendingPaymentViewModel.schedulesByDays.length) {
                        return const SizedBox(height: 150);
                      }

                      return SchedulesByDayCard(
                        schedulesByDay: pendingPaymentViewModel.schedulesByDays[index],
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
