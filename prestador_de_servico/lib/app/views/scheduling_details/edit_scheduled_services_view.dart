import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/models/service/service.dart';
import 'package:prestador_de_servico/app/models/scheduling/scheduling.dart';
import 'package:prestador_de_servico/app/services/scheduling/scheduling_service.dart';
import 'package:prestador_de_servico/app/shared/utils/data_converter.dart';
import 'package:prestador_de_servico/app/shared/utils/text_input_fomatters/money_text_input_formatter.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_button.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_header.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_loading.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_text_field.dart';
import 'package:prestador_de_servico/app/shared/widgets/notifications/custom_notifications.dart';
import 'package:prestador_de_servico/app/views/scheduling_details/viewmodels/edit_scheduled_services_viewmodel.dart';
import 'package:prestador_de_servico/app/views/scheduling_details/widgets/add_service_buttom.dart';
import 'package:prestador_de_servico/app/views/scheduling_details/widgets/edit_service_item_card.dart';
import 'package:provider/provider.dart';

class EditScheduledServicesView extends StatefulWidget {
  final Scheduling scheduling;
  const EditScheduledServicesView({super.key, required this.scheduling});

  @override
  State<EditScheduledServicesView> createState() => _EditScheduledServicesViewState();
}

class _EditScheduledServicesViewState extends State<EditScheduledServicesView> {
  late final EditScheduledServicesViewmodel editViewModel;

  final FocusNode rateFocus = FocusNode();
  final FocusNode discountFocus = FocusNode();

  @override
  void initState() {
    editViewModel = EditScheduledServicesViewmodel(
      schedulingService: context.read<SchedulingService>(),
      scheduling: widget.scheduling.copyWith(
        services: List.from(widget.scheduling.services),
      ),
    );

    editViewModel.notificationMessage.addListener(() {
      final message = editViewModel.notificationMessage.value;
      if (message != null) {
        CustomNotifications().showSnackBar(context: context, message: message);
      }
    });

    editViewModel.editSuccessful.addListener(() {
      if (editViewModel.editSuccessful.value) {
        WidgetsBinding.instance.addPostFrameCallback(
          (_) => Navigator.pop(context, true),
        );
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    editViewModel.dispose();
    rateFocus.dispose();
    discountFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, hasChange) {
        if (didPop) {
          return;
        }
        Navigator.pop(context, hasChange as bool?);
      },
      child: Scaffold(
        body: SafeArea(
          child: CustomScrollView(
            slivers: [
              const SliverFloatingHeader(child: CustomHeader(title: 'Alteração de Serviços', height: 100)),
              ListenableBuilder(
                listenable: editViewModel,
                builder: (context, _) {
                  return SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    sliver: SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomTextField(
                            label: 'Taxa',
                            controller: editViewModel.rateController,
                            focusNode: rateFocus,
                            isNumeric: true,
                            inputFormatters: [MoneyTextInputFormatter()],
                            onChanged: (_) => editViewModel.changeRate(),
                          ),
                          const SizedBox(height: 12),
                          CustomTextField(
                            label: 'Desconto',
                            controller: editViewModel.discountController,
                            focusNode: discountFocus,
                            isNumeric: true,
                            inputFormatters: [MoneyTextInputFormatter()],
                            onChanged: (_) => editViewModel.changeDicount(),
                            errorMessage: editViewModel.discountError,
                          ),
                          const SizedBox(height: 20),
                          Divider(height: 1, color: Theme.of(context).colorScheme.shadow),
                          const SizedBox(height: 18),
                          const Text(
                            'Serviços',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 12),
                          _servicesCard(),
                          const SizedBox(height: 12),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            child: Row(
                              children: [
                                const Expanded(
                                  child: Text(
                                    'Total de produtos',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                Text(
                                  DataConverter.formatPrice(editViewModel.scheduling.totalPrice),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    fontStyle: FontStyle.italic,
                                  ),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              const Expanded(child: SizedBox()),
                              AddServiceButtom(onTap: _onNewService),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Divider(height: 1, color: Theme.of(context).colorScheme.shadow),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Total: ',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                DataConverter.formatPrice(editViewModel.scheduling.totalPriceCalculated),
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w500,
                                ),
                              )
                            ],
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
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ListenableBuilder(
            listenable: editViewModel,
            builder: (context, _) {
              if (editViewModel.editLoading) {
                return const CustomLoading();
              }

              return CustomButton(
                label: 'Salvar',
                onTap: _onSave,
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _servicesCard() {
    final services = editViewModel.scheduling.services;
    List<Widget> servicesWidgets = [];
    for (int i = 0; i < services.length; i++) {
      servicesWidgets.add(
        EditServiceItemCard(
            key: ValueKey(services[i].hashCode), service: services[i], index: i, onLongPress: _onLongPressService),
      );
      if (i < services.length - 1) {
        servicesWidgets.add(const SizedBox(height: 10));
      }
    }
    return Column(
      children: servicesWidgets,
    );
  }

  void _onLongPressService(int index) {
    _removeFocus();

    final service = editViewModel.scheduling.services[index];
    if (service.removed) {
      _onReturnService(index);
    } else {
      _onRemoveService(index);
    }
  }

  void _onReturnService(int index) {
    final service = editViewModel.scheduling.services[index];
    CustomNotifications().showQuestionAlert(
      context: context,
      title: 'Readicionar serviço',
      content: 'Tem certeza que deseja retornar o serviço "${service.name}"?',
      confirmCallback: () {
        editViewModel.returnService(index: index);
      },
    );
  }

  void _onRemoveService(int index) {
    if (editViewModel.quantityOfActiveServices == 1) {
      CustomNotifications().showSuccessAlert(
        context: context,
        title: 'Exclusão não permitida',
        content: 'Não é permitido excluir todos os serviços do agendamento.',
      );
    } else {
      final service = editViewModel.scheduling.services[index];
      CustomNotifications().showQuestionAlert(
        context: context,
        title: 'Remover serviço',
        content: 'Tem certeza que deseja remover o serviço "${service.name}"?',
        confirmCallback: () {
          editViewModel.removeService(index: index);
        },
      );
    }
  }

  void _onNewService() async {
    _removeFocus();

    final result = await Navigator.pushNamed(
      context,
      '/service',
      arguments: {'isSelectionView': true},
    );

    if (result is Service) {
      editViewModel.addService(service: result);
    }
  }

  void _onSave() {
    _removeFocus();

    if (!editViewModel.validateSave()) {
      return;
    }

    _confirmSave();
  }

  Future<void> _confirmSave() async {
    await CustomNotifications().showQuestionAlert(
      context: context,
      title: 'Alterar serviços e preços',
      content: 'Tem certeza que deseja salvar as alterações efetuadas?',
      confirmCallback: () {
        editViewModel.save();
      },
    );
  }

  void _removeFocus() {
    rateFocus.unfocus();
    discountFocus.unfocus();
  }
}
