import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/models/scheduling/scheduling.dart';
import 'package:prestador_de_servico/app/models/service_status/service_status_extensions.dart';
import 'package:prestador_de_servico/app/services/offline_image/offline_image_service.dart';
import 'package:prestador_de_servico/app/services/scheduling/scheduling_service.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_divider.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_header.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_loading.dart';
import 'package:prestador_de_servico/app/shared/widgets/notifications/custom_notifications.dart';
import 'package:prestador_de_servico/app/views/scheduling_details/viewmodels/scheduling_detail_viewmodel.dart';
import 'package:prestador_de_servico/app/views/scheduling_details/widgets/date_and_time_card.dart';
import 'package:prestador_de_servico/app/views/scheduling_details/widgets/images_card.dart';
import 'package:prestador_de_servico/app/views/scheduling_details/widgets/review_card.dart';
import 'package:prestador_de_servico/app/views/scheduling_details/widgets/review_sheet.dart';
import 'package:prestador_de_servico/app/views/scheduling_details/widgets/scheduling_actions.dart';
import 'package:prestador_de_servico/app/views/scheduling_details/widgets/scheduling_address.dart';
import 'package:prestador_de_servico/app/views/scheduling_details/widgets/scheduling_details_header.dart';
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

  @override
  void initState() {
    schedulingDetailViewModel = SchedulingDetailViewModel(
      scheduling: widget.scheduling,
      schedulingService: context.read<SchedulingService>(),
      offlineImageService: context.read<OfflineImageService>(),
    );

    schedulingDetailViewModel.notificationMessage.addListener(() {
      if (schedulingDetailViewModel.notificationMessage.value != null) {
        CustomNotifications()
            .showSnackBar(context: context, message: schedulingDetailViewModel.notificationMessage.value!);
      }
    });

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
                    if (schedulingDetailViewModel.schedulingLoading) {
                      return const SliverFillRemaining(
                        child: Center(child: CustomLoading()),
                      );
                    }

                    if (schedulingDetailViewModel.hasSchedulingError) {
                      ;
                      return SliverFillRemaining(
                        child: Center(
                          child: Text(schedulingDetailViewModel.schedulingErrorMessage!),
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
                          SchedulingDetailsHeader(
                            user: schedulingDetailViewModel.scheduling.user,
                            serviceStatus: schedulingDetailViewModel.scheduling.serviceStatus,
                          ),
                          const CustomDivider(),
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
                          const CustomDivider(),
                          SchedulingAddress(address: schedulingDetailViewModel.scheduling.address),
                          const CustomDivider(),
                          ServiceListCard(
                            key: ValueKey(schedulingDetailViewModel.scheduling.hashCode),
                            scheduling: schedulingDetailViewModel.scheduling,
                            onEdit: allowsEdit ? _onEditScheduledServices : null,
                          ),
                          const CustomDivider(),
                          schedulingDetailViewModel.scheduling.showImageCard ? const ImagesCard() : const SizedBox(),
                          schedulingDetailViewModel.scheduling.showImageCard ? const CustomDivider() : const SizedBox(),
                          schedulingDetailViewModel.scheduling.showReviewCard
                              ? ReviewCard(
                                  reviewDetails: schedulingDetailViewModel.scheduling.reviewDetails,
                                  review: schedulingDetailViewModel.scheduling.review,
                                  onAddOrEditReview: _onAddOrEditReview,
                                )
                              : const SizedBox(),
                          schedulingDetailViewModel.scheduling.showReviewCard
                              ? const CustomDivider()
                              : const SizedBox(),
                          SchedulingActions(
                            isPaid: schedulingDetailViewModel.scheduling.isPaid,
                            serviceStatus: schedulingDetailViewModel.scheduling.serviceStatus,
                            onConfirmScheduling: _onConfirmScheduling,
                            onSchedulingInService: _onSchedulingInService,
                            onPerformScheduling: _onPerformScheduling,
                            onRequestChangeScheduling: _onRequestChangeScheduling,
                            onReceivePayment: _onReceivePayment,
                            onDenyScheduling: _onDenyScheduling,
                            onCancelScheduling: _onCancelScheduling,
                          ),
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
    await CustomNotifications().showQuestionAlert(
      context: context,
      title: 'Confirmar agendamento',
      content: 'Tem certeza que deseja CONFIRMAR agendamento?',
      confirmCallback: () {
        schedulingDetailViewModel.confirmScheduling();
      },
    );
  }

  void _onDenyScheduling() async {
    await CustomNotifications().showQuestionAlert(
      context: context,
      title: 'Recusar agendamento',
      content: 'Tem certeza que deseja RECUSAR agendamento?',
      confirmCallback: () {
        schedulingDetailViewModel.denyScheduling();
      },
    );
  }

  void _onRequestChangeScheduling() async {
    await CustomNotifications().showQuestionAlert(
      context: context,
      title: 'Solicitar alterações',
      content: 'Tem certeza que deseja solicitar alterações ao cliente?',
      confirmCallback: () {
        schedulingDetailViewModel.requestChangeScheduling();
      },
    );
  }

  void _onCancelScheduling() async {
    await CustomNotifications().showQuestionAlert(
      context: context,
      title: 'Cancelar agendamento',
      content: 'Tem certeza que deseja CANCELAR o agendamento?',
      confirmCallback: () {
        schedulingDetailViewModel.cancelScheduling();
      },
    );
  }

  void _onSchedulingInService() async {
    await CustomNotifications().showQuestionAlert(
      context: context,
      title: 'Agendamento em atendimento',
      content: 'Tem certeza que deseja colocar o agendamento "Em atendimento"?',
      confirmCallback: () {
        schedulingDetailViewModel.schedulingInService();
      },
    );
  }

  void _onPerformScheduling() async {
    await CustomNotifications().showQuestionAlert(
      context: context,
      title: 'Agendamento realizado',
      content: 'Tem certeza que deseja colocar o agendamento como "Realizado"?',
      confirmCallback: () {
        schedulingDetailViewModel.performScheduling();
      },
    );
  }

  void _questionOfReview() {
    CustomNotifications().showQuestionAlert(
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
}
