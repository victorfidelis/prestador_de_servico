import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/services/service_day/service_day_service.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_header.dart';
import 'package:prestador_de_servico/app/shared/widgets/notifications/custom_notifications.dart';
import 'package:prestador_de_servico/app/views/service_day/viewmodels/service_day_viewmodel.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_loading.dart';
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

    serviceDayViewModel.notificationMessage.addListener(() {
      if (serviceDayViewModel.notificationMessage.value != null) {
        CustomNotifications().showSnackBar(context: context, message: serviceDayViewModel.notificationMessage.value!);
      }
    });

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
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            const SliverFloatingHeader(child: CustomHeader(title: 'Dias de atendimento')),
            ListenableBuilder(
              listenable: serviceDayViewModel,
              builder: (context, _) {
                if (serviceDayViewModel.hasError) {
                  return SliverFillRemaining(
                    child: Center(
                      child: Text(serviceDayViewModel.errorMessage!),
                    ),
                  );
                }

                if (serviceDayViewModel.serviceDayLoading) {
                  return const SliverFillRemaining(
                    child: Center(
                      child: CustomLoading(),
                    ),
                  );
                }

                return SliverPadding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 6,
                    horizontal: 18,
                  ),
                  sliver: SliverList.builder(
                    itemCount: serviceDayViewModel.serviceDays.length + 1,
                    itemBuilder: (context, index) {
                      if (index == serviceDayViewModel.serviceDays.length) {
                        return const SizedBox(height: 80);
                      }
                      return CustomServiceDayCard(
                        serviceDay: serviceDayViewModel.serviceDays[index],
                        changeStateOfServiceDay: serviceDayViewModel.update,
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
