import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/models/scheduling/scheduling.dart';
import 'package:prestador_de_servico/app/models/service_status/service_status.dart';
import 'package:prestador_de_servico/app/models/service_status/service_status_extensions.dart';
import 'package:prestador_de_servico/app/services/scheduling/scheduling_service.dart';
import 'package:prestador_de_servico/app/shared/themes/custom_colors.dart';
import 'package:prestador_de_servico/app/shared/utils/colors/colors_utils.dart';
import 'package:prestador_de_servico/app/shared/viewmodels/scheduling/scheduling_viewmodel.dart';
import 'package:prestador_de_servico/app/shared/widgets/back_navigation.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_app_bar_title.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_header_container.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_light_buttom.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_link.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_loading.dart';
import 'package:prestador_de_servico/app/shared/widgets/notifications/custom_notifications.dart';
import 'package:prestador_de_servico/app/shared/widgets/sliver_app_bar_delegate.dart';
import 'package:prestador_de_servico/app/views/scheduling_details/states/scheduling_detail_state.dart';
import 'package:prestador_de_servico/app/views/scheduling_details/viewmodels/scheduling_detail_viewmodel.dart';
import 'package:prestador_de_servico/app/views/scheduling_details/widgets/address_card.dart';
import 'package:prestador_de_servico/app/views/scheduling_details/widgets/date_and_time_card.dart';
import 'package:prestador_de_servico/app/views/scheduling_details/widgets/review_sheet.dart';
import 'package:prestador_de_servico/app/views/scheduling_details/widgets/review_stars.dart';
import 'package:prestador_de_servico/app/views/scheduling_details/widgets/service_list_card.dart';
import 'package:provider/provider.dart';

class SchedulingDetailsView extends StatefulWidget {
  final Scheduling scheduling;

  const SchedulingDetailsView({super.key, required this.scheduling});

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
      scheduling: widget.scheduling,
    );

    schedulingDetailViewModel.refreshScheduling();

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

                if (schedulingDetailViewModel.scheduling.serviceStatus.isServicePerform() &&
                    schedulingDetailViewModel.scheduling.review == null) {
                  WidgetsBinding.instance.addPostFrameCallback((_) => questionOfReview());
                }

                Color statusColor = ColorsUtils.getColorFromStatus(
                  context,
                  schedulingDetailViewModel.scheduling.serviceStatus,
                );

                bool allowsEdit =
                    !schedulingDetailViewModel.scheduling.serviceStatus.isBlockedChangeStatus();

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
                          key: ValueKey(schedulingDetailViewModel.scheduling.startDateAndTime),
                          oldStartDateAndTime:
                              schedulingDetailViewModel.scheduling.oldStartDateAndTime,
                          oldEndDateAndTime: schedulingDetailViewModel.scheduling.oldEndDateAndTime,
                          startDateAndTime: schedulingDetailViewModel.scheduling.startDateAndTime,
                          endDateAndTime: schedulingDetailViewModel.scheduling.endDateAndTime,
                          onEdit: allowsEdit ? onEditDateAndTime : null,
                          unavailable: schedulingDetailViewModel.scheduling.schedulingUnavailable,
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
                          scheduling: schedulingDetailViewModel.scheduling,
                          onEdit: allowsEdit ? onEditScheduledServices : null,
                        ),
                        const SizedBox(height: 8),
                        Divider(color: Theme.of(context).colorScheme.shadow),
                        const SizedBox(height: 8),
                        imagesWidget(),
                        const SizedBox(height: 8),
                        Divider(color: Theme.of(context).colorScheme.shadow),
                        const SizedBox(height: 8),
                        reviewWidget(),
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
      arguments: {'scheduling': schedulingDetailViewModel.scheduling},
    );
    if (hasChange != null && (hasChange as bool)) {
      await schedulingDetailViewModel.onChangeScheduling();
    }
  }

  void onEditScheduledServices() async {
    final hasChange = await Navigator.pushNamed(
      context,
      '/editScheduledServices',
      arguments: {'scheduling': schedulingDetailViewModel.scheduling},
    );
    if (hasChange != null && (hasChange as bool)) {
      await schedulingDetailViewModel.onChangeScheduling();
    }
  }

  void onReceivePayment() async {
    final hasChange = await Navigator.pushNamed(
      context,
      '/paymentScheduling',
      arguments: {'scheduling': schedulingDetailViewModel.scheduling},
    );
    if (hasChange != null && (hasChange as bool)) {
      await schedulingDetailViewModel.onChangeScheduling();
    }
  }

  void onConfirmScheduling() async {
    await notifications.showQuestionAlert(
      context: context,
      title: 'Confirmar agendamento',
      content: 'Tem certeza que deseja CONFIRMAR agendamento?',
      confirmCallback: () {
        schedulingDetailViewModel.confirmScheduling();
      },
    );
  }

  void onDenyScheduling() async {
    await notifications.showQuestionAlert(
      context: context,
      title: 'Recusar agendamento',
      content: 'Tem certeza que deseja RECUSAR agendamento?',
      confirmCallback: () {
        schedulingDetailViewModel.denyScheduling();
      },
    );
  }

  void onRequestChangeScheduling() async {
    await notifications.showQuestionAlert(
      context: context,
      title: 'Solicitar alterações',
      content: 'Tem certeza que deseja solicitar alterações ao cliente?',
      confirmCallback: () {
        schedulingDetailViewModel.requestChangeScheduling();
      },
    );
  }

  void onCancelScheduling() async {
    await notifications.showQuestionAlert(
      context: context,
      title: 'Cancelar agendamento',
      content: 'Tem certeza que deseja CANCELAR o agendamento?',
      confirmCallback: () {
        schedulingDetailViewModel.cancelScheduling();
      },
    );
  }

  void onSchedulingInService() async {
    await notifications.showQuestionAlert(
      context: context,
      title: 'Agendamento em atendimento',
      content: 'Tem certeza que deseja colocar o agendamento "Em atendimento"?',
      confirmCallback: () {
        schedulingDetailViewModel.schedulingInService();
      },
    );
  }

  void onPerformScheduling() async {
    await notifications.showQuestionAlert(
      context: context,
      title: 'Agendamento realizado',
      content: 'Tem certeza que deseja colocar o agendamento como "Realizado"?',
      confirmCallback: () {
        schedulingDetailViewModel.performScheduling();
      },
    );
  }

  Widget imagesWidget() {
    ServiceStatus serviceStatus = schedulingDetailViewModel.scheduling.serviceStatus;
    if (!serviceStatus.isInService() && !serviceStatus.isServicePerform()) {
      return const SizedBox();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(
              child: Text(
                'Imagens',
                style: TextStyle(fontSize: 16),
              ),
            ),
            CustomLink(label: 'Abrir', onTap: onAddOrEditImages)
          ],
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Nenhuma imagem cadastrada',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.shadow,
              ),
            ),
          ],
        ),
      ],
    );
  }

  void onAddOrEditImages() async {
    Navigator.pushNamed(context, '/serviceImages', arguments: {'scheduling': schedulingDetailViewModel.scheduling});
  }

  Widget reviewWidget() {
    ServiceStatus serviceStatus = schedulingDetailViewModel.scheduling.serviceStatus;
    if (!serviceStatus.isServicePerform()) {
      return const SizedBox();
    }

    bool hasReviewDetail = false;
    if (schedulingDetailViewModel.scheduling.reviewDetails != null &&
        schedulingDetailViewModel.scheduling.reviewDetails!.trim().isNotEmpty) {
      hasReviewDetail = true;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Avaliação do cliente',
          style: TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ReviewStars(
              review: schedulingDetailViewModel.scheduling.review ?? 0,
              onMark: (review) => onAddOrEditReview(review),
              allowSetState: false,
            ),
          ],
        ),
        const SizedBox(height: 16),
        hasReviewDetail
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        schedulingDetailViewModel.scheduling.reviewDetails ?? '',
                      ),
                    ),
                  ],
                ),
              )
            : const SizedBox(),
        hasReviewDetail ? const SizedBox(height: 8) : const SizedBox(),
        Divider(color: Theme.of(context).colorScheme.shadow),
        const SizedBox(height: 8),
      ],
    );
  }

  void questionOfReview() {
    notifications.showQuestionAlert(
      context: context,
      title: 'Avalie o cliente',
      content: 'Deseja realizar a avaliação da sessão do cliente?',
      confirmCallback: () => onAddOrEditReview(1),
    );
  }

  void onAddOrEditReview(int review) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return ReviewSheet(
          review: review,
          reviewDetails: schedulingDetailViewModel.scheduling.reviewDetails ?? '',
          onSave: onSaveReview,
        );
      },
    );
  }

  void onSaveReview(int review, String reviewDetails) {
    Navigator.pop(context);
    schedulingDetailViewModel.reviewScheduling(review: review, reviewDetails: reviewDetails);
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
        onTap: onSchedulingInService,
      ));
    }

    if (serviceStatus.isInService()) {
      buttons.add(CustomLightButtom(
        label: 'Marcar como realizado',
        labelColor: Theme.of(context).extension<CustomColors>()!.confirm!,
        onTap: onPerformScheduling,
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
        onTap: onReceivePayment,
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
      buttons.add(
        CustomLightButtom(
          label: 'Cancelar',
          labelColor: Theme.of(context).extension<CustomColors>()!.cancel!,
          onTap: onCancelScheduling,
        ),
      );
    }

    return Column(
      spacing: 8,
      children: buttons,
    );
  }
}
