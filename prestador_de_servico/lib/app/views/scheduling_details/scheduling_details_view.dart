import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/models/service_scheduling/service_scheduling.dart';
import 'package:prestador_de_servico/app/models/service_status/service_status.dart';
import 'package:prestador_de_servico/app/models/service_status/service_status_extensions.dart';
import 'package:prestador_de_servico/app/services/scheduling/scheduling_service.dart';
import 'package:prestador_de_servico/app/shared/themes/custom_colors.dart';
import 'package:prestador_de_servico/app/shared/utils/colors/colors_utils.dart';
import 'package:prestador_de_servico/app/shared/widgets/back_navigation.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_app_bar_title.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_header_container.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_light_buttom.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_loading.dart';
import 'package:prestador_de_servico/app/shared/widgets/notifications/custom_notifications.dart';
import 'package:prestador_de_servico/app/shared/widgets/sliver_app_bar_delegate.dart';
import 'package:prestador_de_servico/app/views/scheduling_details/states/scheduling_detail_state.dart';
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
  late final SchedulingDetailViewModel schedulingDetailViewModel;
  final notifications = CustomNotifications();

  @override
  void initState() {
    schedulingDetailViewModel = SchedulingDetailViewModel(
      schedulingService: context.read<SchedulingService>(),
      scheduling: widget.serviceScheduling,
    );
    
    schedulingDetailViewModel.refreshServiceScheduling();
  
    super.initState();
  }

  @override
  void dispose() {
    schedulingDetailViewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) {
          return;
        }
        Navigator.pop(context, schedulingDetailViewModel.hasChange);
      },
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverPersistentHeader(
              floating: true,
              delegate: SliverAppBarDelegate(
                minHeight: 120,
                maxHeight: 120,
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
                              child: BackNavigation(
                                onTap: () => Navigator.pop(
                                  context,
                                  schedulingDetailViewModel.hasChange,
                                ),
                              ),
                            ),
                            const Expanded(
                              child: CustomAppBarTitle(
                                title: 'Agendamento',
                                fontSize: 25,
                              ),
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
              listenable: schedulingDetailViewModel,
              builder: (context, _) {
                if (schedulingDetailViewModel.state is SchedulingDetailLoading) {
                  return const SliverFillRemaining(
                    child: Center(child: CustomLoading()),
                  );
                }

                if (schedulingDetailViewModel.state is SchedulingDetailError) {
                  var error = schedulingDetailViewModel.state as SchedulingDetailError;
                  return SliverToBoxAdapter(
                    child: Center(
                      child: Text(error.message),
                    ),
                  );
                }

                Color statusColor = ColorsUtils.getColorFromStatus(
                  context,
                  schedulingDetailViewModel.scheduling.serviceStatus,
                );

                bool allowsEdit = !schedulingDetailViewModel.scheduling.serviceStatus
                    .isBlockedChangeStatus();

                return SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          schedulingDetailViewModel.scheduling.user.fullname,
                          style: TextStyle(
                            color: statusColor,
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          schedulingDetailViewModel.scheduling.serviceStatus.name,
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
                          key: ValueKey(
                              schedulingDetailViewModel.scheduling.startDateAndTime),
                          oldStartDateAndTime:
                              schedulingDetailViewModel.scheduling.oldStartDateAndTime,
                          oldEndDateAndTime:
                              schedulingDetailViewModel.scheduling.oldEndDateAndTime,
                          startDateAndTime:
                              schedulingDetailViewModel.scheduling.startDateAndTime,
                          endDateAndTime:
                              schedulingDetailViewModel.scheduling.endDateAndTime,
                          onEdit: allowsEdit ? onEditDateAndTime : null,
                          unavailable:
                              schedulingDetailViewModel.scheduling.schedulingUnavailable,
                          inConflict: schedulingDetailViewModel.scheduling.conflictScheduing,
                        ),
                        const SizedBox(height: 8),
                        Divider(color: Theme.of(context).colorScheme.shadow),
                        const SizedBox(height: 8),
                        addressWidget(),
                        const SizedBox(height: 8),
                        Divider(color: Theme.of(context).colorScheme.shadow),
                        const SizedBox(height: 8),
                        ServiceListCard(
                          key: ValueKey(schedulingDetailViewModel.scheduling.hashCode),
                          serviceScheduling: schedulingDetailViewModel.scheduling,
                          onEdit: allowsEdit ? onEditScheduledServices : null,
                        ),
                        const SizedBox(height: 8),
                        Divider(color: Theme.of(context).colorScheme.shadow),
                        const SizedBox(height: 8),
                        actions(),
                        const SizedBox(height: 50),
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

  void onEditDateAndTime() async {
    final hasChange = await Navigator.pushNamed(
      context,
      '/editDateAndTime',
      arguments: {'serviceScheduling': schedulingDetailViewModel.scheduling},
    );
    if (hasChange != null && (hasChange as bool)) {
      await schedulingDetailViewModel.onChangeScheduling();
    }
  }

  void onEditScheduledServices() async {
    final hasChange = await Navigator.pushNamed(
      context,
      '/editScheduledServices',
      arguments: {'serviceScheduling': schedulingDetailViewModel.scheduling},
    );
    if (hasChange != null && (hasChange as bool)) {
      await schedulingDetailViewModel.onChangeScheduling();
    }
  }

  void onConfirmScheduling() async {
    await notifications.showQuestionAlert(
      context: context,
      title: 'Confirmar agendamento',
      content: 'Tem certeza que deseja confirmar agendamento?',
      confirmCallback: () {
        schedulingDetailViewModel.confirmScheduling();
      },
    );
  }

  void onDenyScheduling() async {
    await notifications.showQuestionAlert(
      context: context,
      title: 'Recusar agendamento',
      content: 'Tem certeza que deseja recusar agendamento?',
      confirmCallback: () {
        schedulingDetailViewModel.denyScheduling();
      },
    );
  }

  void onRequestChangeScheduling() async {
    await notifications.showQuestionAlert(
      context: context,
      title: 'Solicitar alterações',
      content: 'Tem certeza que deseja solicitar alterações a cliente?',
      confirmCallback: () {
        schedulingDetailViewModel.requestChangeScheduling();
      },
    );
  }

  void onCancelScheduling() async {
    await notifications.showQuestionAlert(
      context: context,
      title: 'Cancelar agendamento',
      content: 'Tem certeza que deseja cancelar o agendamento?',
      confirmCallback: () {
        schedulingDetailViewModel.cancelScheduling();
      },
    );
  }

  Widget addressWidget() {
    if (schedulingDetailViewModel.scheduling.address == null) {
      return const Text('Local não informado');
    }
    return AddressCard(address: schedulingDetailViewModel.scheduling.address!);
  }

  Widget actions() {
    bool isPaid = schedulingDetailViewModel.scheduling.isPaid;
    ServiceStatus serviceStatus = schedulingDetailViewModel.scheduling.serviceStatus;

    List<Widget> buttons = [];

    if (serviceStatus.isPendingProvider()) {
      buttons.add(CustomLightButtom(
        label: 'Confirmar',
        labelColor: Theme.of(context).extension<CustomColors>()!.confirm!,
        onTap: onConfirmScheduling,
      ));
    }

    if (serviceStatus.isConfirm()) {
      buttons.add(CustomLightButtom(
        label: 'Colocar em atendimento',
        labelColor: Theme.of(context).extension<CustomColors>()!.confirm!,
        onTap: () {},
      ));
    }

    if (serviceStatus.isInAttendance()) {
      buttons.add(CustomLightButtom(
        label: 'Marcar como realizado',
        labelColor: Theme.of(context).extension<CustomColors>()!.confirm!,
        onTap: () {},
      ));
    }

    if (serviceStatus.isPendingProvider()) {
      buttons.add(CustomLightButtom(
        label: 'Solicitar alterações',
        labelColor: Theme.of(context).extension<CustomColors>()!.pending!,
        onTap: onRequestChangeScheduling,
      ));
    }

    if (!isPaid && serviceStatus.isAccept()) {
      buttons.add(CustomLightButtom(
        label: 'Receber pagamentos',
        labelColor: Theme.of(context).extension<CustomColors>()!.money!,
        onTap: () {},
      ));
    }

    if (serviceStatus.isPendingProvider()) {
      buttons.add(CustomLightButtom(
        label: 'Recusar',
        labelColor: Theme.of(context).extension<CustomColors>()!.cancel!,
        onTap: onDenyScheduling,
      ));
    }

    if (serviceStatus.allowCancel()) {
      buttons.add(CustomLightButtom(
        label: 'Cancelar',
        labelColor: Theme.of(context).extension<CustomColors>()!.cancel!,
        onTap: onCancelScheduling,
      ));
    }

    return Column(
      spacing: 8,
      children: buttons,
    );
  }
}
