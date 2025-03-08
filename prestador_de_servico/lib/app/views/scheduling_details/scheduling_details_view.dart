import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/models/service_scheduling/service_scheduling.dart';
import 'package:prestador_de_servico/app/shared/utils/colors/colors_utils.dart';
import 'package:prestador_de_servico/app/shared/widgets/back_navigation.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_app_bar_title.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_header_container.dart';
import 'package:prestador_de_servico/app/shared/widgets/sliver_app_bar_delegate.dart';
import 'package:prestador_de_servico/app/views/scheduling_details/viewmodels/scheduling_detail_viewmodel.dart';
import 'package:prestador_de_servico/app/views/scheduling_details/widgets/address_card.dart';
import 'package:prestador_de_servico/app/views/scheduling_details/widgets/date_and_time_card.dart';
import 'package:prestador_de_servico/app/views/scheduling_details/widgets/service_list_card.dart';
import 'package:provider/provider.dart';

class SchedulingDetailsView extends StatefulWidget {
  final ServiceScheduling serviceScheduling;

  const SchedulingDetailsView({super.key, required this.serviceScheduling});

  @override
  State<SchedulingDetailsView> createState() => _SchedulingDetailsViewState();
}

class _SchedulingDetailsViewState extends State<SchedulingDetailsView> {
  late ServiceScheduling serviceScheduling;

  @override
  void initState() {
    serviceScheduling = widget.serviceScheduling;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (_, __) {
        Navigator.pop(context, context.read<SchedulingDetailViewModel>().hasChange);
      },
      child: Scaffold(
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
                            SizedBox(
                                width: 60,
                                child: BackNavigation(onTap: () => Navigator.pop(context))),
                            const Expanded(
                              child: CustomAppBarTitle(
                                title: 'Agendamento',
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
            Consumer<SchedulingDetailViewModel>(
              builder: (context, schedulingDetailViewModel, _) {
                Color statusColor = ColorsUtils.getColorFromStatus(
                  context,
                  schedulingDetailViewModel.serviceScheduling.serviceStatus,
                );
      
                return SliverFillRemaining(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          schedulingDetailViewModel.serviceScheduling.user.fullname,
                          style: TextStyle(
                            color: statusColor,
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          schedulingDetailViewModel.serviceScheduling.serviceStatus.name,
                          style: TextStyle(
                            color: statusColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Divider(color: Theme.of(context).colorScheme.shadow),
                        const SizedBox(height: 8),
                        DateAndTimeCard(
                          key: ValueKey(schedulingDetailViewModel.serviceScheduling.startDateAndTime),
                          oldStartDateAndTime:
                              schedulingDetailViewModel.serviceScheduling.oldStartDateAndTime,
                          oldEndDateAndTime:
                              schedulingDetailViewModel.serviceScheduling.oldEndDateAndTime,
                          startDateAndTime:
                              schedulingDetailViewModel.serviceScheduling.startDateAndTime,
                          endDateAndTime: schedulingDetailViewModel.serviceScheduling.endDateAndTime,
                          onEdit: onEditDateAndTime,
                        ),
                        const SizedBox(height: 8),
                        Divider(color: Theme.of(context).colorScheme.shadow),
                        const SizedBox(height: 8),
                        addressWidget(),
                        const SizedBox(height: 8),
                        Divider(color: Theme.of(context).colorScheme.shadow),
                        const SizedBox(height: 8),
                        ServiceListCard(
                          serviceScheduling: schedulingDetailViewModel.serviceScheduling,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void onEditDateAndTime() {
    Navigator.pushNamed(
      context,
      '/editDateAndTime',
      arguments: {'schedulingDetailViewModel': context.read<SchedulingDetailViewModel>()},
    );
  }

  Widget addressWidget() {
    if (serviceScheduling.address == null) {
      return const Text('Local não informado');
    }
    return AddressCard(address: serviceScheduling.address!);
  }
}
