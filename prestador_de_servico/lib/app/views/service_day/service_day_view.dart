import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/services/service_day/service_day_service.dart';
import 'package:prestador_de_servico/app/views/service_day/viewmodels/service_day_viewmodel.dart';
import 'package:prestador_de_servico/app/shared/widgets/back_navigation.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_app_bar_title.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_header_container.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_loading.dart';
import 'package:prestador_de_servico/app/shared/widgets/sliver_app_bar_delegate.dart';
import 'package:prestador_de_servico/app/views/service_day/states/service_day_state.dart';
import 'package:prestador_de_servico/app/views/service_day/widgets/custom_service_day_card.dart';
import 'package:provider/provider.dart';

class ServiceDayView extends StatefulWidget {
  const ServiceDayView({super.key});

  @override
  State<ServiceDayView> createState() => _ServiceDayViewState();
}

class _ServiceDayViewState extends State<ServiceDayView> {
  late final ServiceDayViewModel serviceDayViewModel;

  @override
  void initState() {
    serviceDayViewModel = ServiceDayViewModel(
      serviceDayService: context.read<ServiceDayService>(),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) => serviceDayViewModel.load());
    super.initState();
  }

  @override
  void dispose() {
    serviceDayViewModel.dispose();
    super.dispose();
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
                          SizedBox(
                              width: 60,
                              child: BackNavigation(onTap: () => Navigator.pop(context))),
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
          ListenableBuilder(
            listenable: serviceDayViewModel,
            builder: (context, _) {
              if (serviceDayViewModel.state is ServiceDayInitial) {
                return const SliverFillRemaining();
              }

              if (serviceDayViewModel.state is ServiceDayError) {
                return SliverFillRemaining(
                  child: Center(
                    child: Text((serviceDayViewModel.state as ServiceDayError).message),
                  ),
                );
              }

              if (serviceDayViewModel.state is ServiceDayLoading) {
                return const SliverFillRemaining(
                  child: Center(
                    child: CustomLoading(),
                  ),
                );
              }

              final serviceDays = (serviceDayViewModel.state as ServiceDayLoaded).serviceDays;

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
                  itemCount: serviceDays.length + 1,
                  itemBuilder: (context, index) {
                    if (index == serviceDays.length) {
                      return const SizedBox(height: 80);
                    }
                    return CustomServiceDayCard(
                      serviceDay: serviceDays[index],
                      changeStateOfServiceDay: serviceDayViewModel.update,
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
