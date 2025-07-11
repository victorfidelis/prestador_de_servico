import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/models/scheduling/scheduling.dart';
import 'package:prestador_de_servico/app/models/service_status/service_status.dart';
import 'package:prestador_de_servico/app/models/service_status/service_status_extensions.dart';
import 'package:prestador_de_servico/app/services/offline_image/offline_image_service.dart';
import 'package:prestador_de_servico/app/services/scheduling/scheduling_service.dart';
import 'package:prestador_de_servico/app/shared/themes/custom_colors.dart';
import 'package:prestador_de_servico/app/shared/utils/colors/colors_utils.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_header.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_light_buttom.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_loading.dart';
import 'package:prestador_de_servico/app/shared/widgets/notifications/custom_notifications.dart';
import 'package:prestador_de_servico/app/views/scheduling_details/states/scheduling_detail_state.dart';
import 'package:prestador_de_servico/app/views/scheduling_details/viewmodels/scheduling_detail_viewmodel.dart';
import 'package:prestador_de_servico/app/views/scheduling_details/widgets/address_card.dart';
import 'package:prestador_de_servico/app/views/scheduling_details/widgets/date_and_time_card.dart';
import 'package:prestador_de_servico/app/views/scheduling_details/widgets/images_card.dart';
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
      scheduling: widget.scheduling,
      schedulingService: context.read<SchedulingService>(),
      offlineImageService: context.read<OfflineImageService>(),
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
    Widget imageCard = const SizedBox();
    bool showImageCard = false;
    ServiceStatus serviceStatus = schedulingDetailViewModel.scheduling.serviceStatus;
    if (serviceStatus.isInService() || serviceStatus.isServicePerform()) {
      imageCard = const ImagesCard();
      showImageCard = true;
    }

    return ChangeNotifierProvider.value(
      value: schedulingDetailViewModel,
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, _) {
          if (didPop) {
            return;
          }
          _popNavigation();
        },
        child: Scaffold(
          body: SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverFloatingHeader(child: CustomHeader(title: 'Agendamento', overridePop: _popNavigation)),
                const SliverToBoxAdapter(child: SizedBox(height: 10)),
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
                      return SliverFillRemaining(
                        child: Center(
                          child: Text(error.message),
                        ),
                      );
                    }

                    if (schedulingDetailViewModel.scheduling.serviceStatus.isServicePerform() &&
                        schedulingDetailViewModel.scheduling.review == null) {
                      WidgetsBinding.instance.addPostFrameCallback((_) => _questionOfReview());
                    }

                    bool allowsEdit = !schedulingDetailViewModel.scheduling.serviceStatus.isBlockedChangeStatus();

                    return SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildHeader(),
                          const SizedBox(height: 8),
                          _buildDivider(),
                          const SizedBox(height: 8),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: DateAndTimeCard(
                              key: ValueKey(schedulingDetailViewModel.scheduling.startDateAndTime),
                              oldStartDateAndTime: schedulingDetailViewModel.scheduling.oldStartDateAndTime,
                              oldEndDateAndTime: schedulingDetailViewModel.scheduling.oldEndDateAndTime,
                              startDateAndTime: schedulingDetailViewModel.scheduling.startDateAndTime,
                              endDateAndTime: schedulingDetailViewModel.scheduling.endDateAndTime,
                              onEdit: allowsEdit ? _onEditDateAndTime : null,
                              unavailable: schedulingDetailViewModel.scheduling.schedulingUnavailable,
                              inConflict: schedulingDetailViewModel.scheduling.conflictScheduing,
                            ),
                          ),
                          const SizedBox(height: 8),
                          _buildDivider(),
                          const SizedBox(height: 8),
                          _addressWidget(),
                          const SizedBox(height: 8),
                          _buildDivider(),
                          const SizedBox(height: 8),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: ServiceListCard(
                              key: ValueKey(schedulingDetailViewModel.scheduling.hashCode),
                              scheduling: schedulingDetailViewModel.scheduling,
                              onEdit: allowsEdit ? _onEditScheduledServices : null,
                            ),
                          ),
                          const SizedBox(height: 8),
                          _buildDivider(),
                          const SizedBox(height: 8),
                          imageCard,
                          showImageCard ? const SizedBox(height: 8) : const SizedBox(),
                          showImageCard ? _buildDivider() : const SizedBox(),
                          const SizedBox(height: 8),
                          _reviewWidget(),
                          _actions(),
                          const SizedBox(height: 50),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _popNavigation() {
    Navigator.pop(context, schedulingDetailViewModel.hasChange);
  }

  Widget _buildHeader() {
    Color statusColor = ColorsUtils.getColorFromStatus(
      context,
      schedulingDetailViewModel.scheduling.serviceStatus,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Divider(color: Theme.of(context).colorScheme.shadow),
    );
  }

  void _onEditDateAndTime() async {
    final hasChange = await Navigator.pushNamed(
      context,
      '/editDateAndTime',
      arguments: {'scheduling': schedulingDetailViewModel.scheduling},
    );
    if (hasChange != null && (hasChange as bool)) {
      await schedulingDetailViewModel.onChangeScheduling();
    }
  }

  void _onEditScheduledServices() async {
    final hasChange = await Navigator.pushNamed(
      context,
      '/editScheduledServices',
      arguments: {'scheduling': schedulingDetailViewModel.scheduling},
    );
    if (hasChange != null && (hasChange as bool)) {
      await schedulingDetailViewModel.onChangeScheduling();
    }
  }

  void _onReceivePayment() async {
    final hasChange = await Navigator.pushNamed(
      context,
      '/paymentScheduling',
      arguments: {'scheduling': schedulingDetailViewModel.scheduling},
    );
    if (hasChange != null && (hasChange as bool)) {
      await schedulingDetailViewModel.onChangeScheduling();
    }
  }

  void _onConfirmScheduling() async {
    await notifications.showQuestionAlert(
      context: context,
      title: 'Confirmar agendamento',
      content: 'Tem certeza que deseja CONFIRMAR agendamento?',
      confirmCallback: () {
        schedulingDetailViewModel.confirmScheduling();
      },
    );
  }

  void _onDenyScheduling() async {
    await notifications.showQuestionAlert(
      context: context,
      title: 'Recusar agendamento',
      content: 'Tem certeza que deseja RECUSAR agendamento?',
      confirmCallback: () {
        schedulingDetailViewModel.denyScheduling();
      },
    );
  }

  void _onRequestChangeScheduling() async {
    await notifications.showQuestionAlert(
      context: context,
      title: 'Solicitar alterações',
      content: 'Tem certeza que deseja solicitar alterações ao cliente?',
      confirmCallback: () {
        schedulingDetailViewModel.requestChangeScheduling();
      },
    );
  }

  void _onCancelScheduling() async {
    await notifications.showQuestionAlert(
      context: context,
      title: 'Cancelar agendamento',
      content: 'Tem certeza que deseja CANCELAR o agendamento?',
      confirmCallback: () {
        schedulingDetailViewModel.cancelScheduling();
      },
    );
  }

  void _onSchedulingInService() async {
    await notifications.showQuestionAlert(
      context: context,
      title: 'Agendamento em atendimento',
      content: 'Tem certeza que deseja colocar o agendamento "Em atendimento"?',
      confirmCallback: () {
        schedulingDetailViewModel.schedulingInService();
      },
    );
  }

  void _onPerformScheduling() async {
    await notifications.showQuestionAlert(
      context: context,
      title: 'Agendamento realizado',
      content: 'Tem certeza que deseja colocar o agendamento como "Realizado"?',
      confirmCallback: () {
        schedulingDetailViewModel.performScheduling();
      },
    );
  }

  Widget _reviewWidget() {
    ServiceStatus serviceStatus = schedulingDetailViewModel.scheduling.serviceStatus;
    if (!serviceStatus.isServicePerform()) {
      return const SizedBox();
    }

    bool hasReviewDetail = false;
    if (schedulingDetailViewModel.scheduling.reviewDetails != null &&
        schedulingDetailViewModel.scheduling.reviewDetails!.trim().isNotEmpty) {
      hasReviewDetail = true;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
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
                onMark: (review) => _onAddOrEditReview(review),
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
          _buildDivider(),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  void _questionOfReview() {
    notifications.showQuestionAlert(
      context: context,
      title: 'Avalie o cliente',
      content: 'Deseja realizar a avaliação da sessão do cliente?',
      confirmCallback: () => _onAddOrEditReview(1),
    );
  }

  void _onAddOrEditReview(int review) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return ReviewSheet(
          review: review,
          reviewDetails: schedulingDetailViewModel.scheduling.reviewDetails ?? '',
          onSave: _onSaveReview,
        );
      },
    );
  }

  void _onSaveReview(int review, String reviewDetails) {
    Navigator.pop(context);
    schedulingDetailViewModel.reviewScheduling(review: review, reviewDetails: reviewDetails);
  }

  Widget _addressWidget() {
    if (schedulingDetailViewModel.scheduling.address == null) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Text('Local não informado'),
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: AddressCard(address: schedulingDetailViewModel.scheduling.address!),
    );
  }

  Widget _actions() {
    bool isPaid = schedulingDetailViewModel.scheduling.isPaid;
    ServiceStatus serviceStatus = schedulingDetailViewModel.scheduling.serviceStatus;

    List<Widget> buttons = [];

    if (serviceStatus.isPendingProvider()) {
      buttons.add(CustomLightButtom(
        label: 'Confirmar',
        labelColor: Theme.of(context).extension<CustomColors>()!.confirm!,
        onTap: _onConfirmScheduling,
      ));
    }

    if (serviceStatus.isConfirm()) {
      buttons.add(CustomLightButtom(
        label: 'Colocar em atendimento',
        labelColor: Theme.of(context).extension<CustomColors>()!.confirm!,
        onTap: _onSchedulingInService,
      ));
    }

    if (serviceStatus.isInService()) {
      buttons.add(CustomLightButtom(
        label: 'Marcar como realizado',
        labelColor: Theme.of(context).extension<CustomColors>()!.confirm!,
        onTap: _onPerformScheduling,
      ));
    }

    if (serviceStatus.isPendingProvider()) {
      buttons.add(CustomLightButtom(
        label: 'Solicitar alterações',
        labelColor: Theme.of(context).extension<CustomColors>()!.pending!,
        onTap: _onRequestChangeScheduling,
      ));
    }

    if (!isPaid && serviceStatus.isAccept()) {
      buttons.add(CustomLightButtom(
        label: 'Receber pagamentos',
        labelColor: Theme.of(context).extension<CustomColors>()!.money!,
        onTap: _onReceivePayment,
      ));
    }

    if (serviceStatus.isPendingProvider()) {
      buttons.add(CustomLightButtom(
        label: 'Recusar',
        labelColor: Theme.of(context).extension<CustomColors>()!.cancel!,
        onTap: _onDenyScheduling,
      ));
    }

    if (serviceStatus.allowCancel()) {
      buttons.add(
        CustomLightButtom(
          label: 'Cancelar',
          labelColor: Theme.of(context).extension<CustomColors>()!.cancel!,
          onTap: _onCancelScheduling,
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        spacing: 8,
        children: buttons,
      ),
    );
  }
}
