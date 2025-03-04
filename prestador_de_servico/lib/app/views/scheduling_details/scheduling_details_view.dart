import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/models/service_scheduling/service_scheduling.dart';
import 'package:prestador_de_servico/app/shared/utils/colors/colors_utils.dart';
import 'package:prestador_de_servico/app/shared/widgets/back_navigation.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_app_bar_title.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_header_container.dart';
import 'package:prestador_de_servico/app/shared/widgets/sliver_app_bar_delegate.dart';
import 'package:prestador_de_servico/app/views/scheduling_details/widgets/address_card.dart';
import 'package:prestador_de_servico/app/views/scheduling_details/widgets/date_and_time_card.dart';
import 'package:prestador_de_servico/app/views/scheduling_details/widgets/service_list_card.dart';

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
    Color statusColor = ColorsUtils.getColorFromStatus(context, serviceScheduling.serviceStatus);

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
                          SizedBox(
                              width: 60,
                              child: BackNavigation(
                                  onTap: () => Navigator.pop(context))),
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
          SliverFillRemaining(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    serviceScheduling.user.fullname,
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    serviceScheduling.serviceStatus.name,
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
                    startDateAndTime: serviceScheduling.startDateAndTime,
                    endDateAndTime: serviceScheduling.endDateAndTime,
                    onEdit: _onEditDateAndTime,
                  ),
                  const SizedBox(height: 8),
                  Divider(color: Theme.of(context).colorScheme.shadow),
                  const SizedBox(height: 8),
                  addressWidget(),
                  const SizedBox(height: 8),
                  Divider(color: Theme.of(context).colorScheme.shadow),
                  const SizedBox(height: 8),
                  ServiceListCard(serviceScheduling: serviceScheduling),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onEditDateAndTime() {
    Navigator.pushNamed(
      context,
      '/editDateAndTime',
      arguments: {'serviceScheduling': serviceScheduling},
    );
  }

  Widget addressWidget() {
    if (serviceScheduling.address == null) {
      return const Text('Local não informado');
    }
    return AddressCard(address: serviceScheduling.address!);
  }
}
