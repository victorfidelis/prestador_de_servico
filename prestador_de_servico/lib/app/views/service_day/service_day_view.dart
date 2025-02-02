
import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/controllers/service_day/service_day_controller.dart';
import 'package:prestador_de_servico/app/models/service_day/service_day.dart';
import 'package:prestador_de_servico/app/shared/widgets/back_navigation.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_app_bar_title.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_header_container.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_loading.dart';
import 'package:prestador_de_servico/app/shared/widgets/sliver_app_bar_delegate.dart';
import 'package:prestador_de_servico/app/states/service_day/service_day_state.dart';
import 'package:prestador_de_servico/app/views/service_day/widgets/custom_service_day_card.dart';
import 'package:provider/provider.dart';

class ServiceDayView extends StatefulWidget {
  const ServiceDayView({super.key});

  @override
  State<ServiceDayView> createState() => _ServiceDayViewState();
}

class _ServiceDayViewState extends State<ServiceDayView> {

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => context.read<ServiceDayController>().load());
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
              maxHeight: 116,
              minHeight: 116,
              child: Stack(
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
                            child: CustomAppBarTitle(title: 'Dias de atendimento'),
                          ),
                          const SizedBox(width: 60),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Consumer<ServiceDayController>(
            builder: (context, serviceDayController, _) {
              if (serviceDayController.state is ServiceDayInitial) {
                return const SliverFillRemaining();
              }

              if (serviceDayController.state is ServiceDayError) {
                return SliverFillRemaining(
                  child: Center(
                    child: Text((serviceDayController.state as ServiceDayError).message),
                  ),
                );
              }

              if (serviceDayController.state is ServiceDayLoading) {
                return const SliverFillRemaining(
                  child: Center(
                    child: CustomLoading(),
                  ),
                );
              }

              final serviceDays = (serviceDayController.state as ServiceDayLoaded).serviceDays;

              serviceDays.sort((s1, s2) {
                if (s1.dayOfWeek > s2.dayOfWeek) {
                  return 1;
                }
                if (s1.dayOfWeek < s2.dayOfWeek) {
                  return -1;
                }
                return 0;
              });
              
              return SliverPadding(
                padding: const EdgeInsets.symmetric(
                  vertical: 6,
                  horizontal: 18,
                ),
                sliver: SliverList.builder(
                  itemCount: serviceDays.length,
                  itemBuilder: (context, index) {
                    return CustomServiceDayCard(
                      serviceDay: serviceDays[index],
                      changeStateOfServiceDay: _changeStateOfServiceDay,
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

  void _changeStateOfServiceDay({required ServiceDay serviceDay}) {
    context.read<ServiceDayController>().update(serviceDay: serviceDay);
  }
}