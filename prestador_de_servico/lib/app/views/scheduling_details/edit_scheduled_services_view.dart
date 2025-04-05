import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/models/service/service.dart';
import 'package:prestador_de_servico/app/models/service_scheduling/service_scheduling.dart';
import 'package:prestador_de_servico/app/services/scheduling/scheduling_service.dart';
import 'package:prestador_de_servico/app/shared/utils/formatters/formatters.dart';
import 'package:prestador_de_servico/app/shared/utils/text_input_fomatters/money_text_input_formatter.dart';
import 'package:prestador_de_servico/app/shared/widgets/back_navigation.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_app_bar_title.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_button.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_header_container.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_loading.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_text_field.dart';
import 'package:prestador_de_servico/app/shared/widgets/notifications/custom_notifications.dart';
import 'package:prestador_de_servico/app/shared/widgets/sliver_app_bar_delegate.dart';
import 'package:prestador_de_servico/app/views/scheduling_details/states/edit_services_and_prices_state.dart';
import 'package:prestador_de_servico/app/views/scheduling_details/viewmodels/edit_scheduled_services_viewmodel.dart';
import 'package:prestador_de_servico/app/views/scheduling_details/widgets/add_service_buttom.dart';
import 'package:prestador_de_servico/app/views/scheduling_details/widgets/edit_service_item_card.dart';
import 'package:provider/provider.dart';

class EditScheduledServicesView extends StatefulWidget {
  final ServiceScheduling serviceScheduling;
  const EditScheduledServicesView({super.key, required this.serviceScheduling});

  @override
  State<EditScheduledServicesView> createState() => _EditScheduledServicesViewState();
}

class _EditScheduledServicesViewState extends State<EditScheduledServicesView> {
  late final EditScheduledServicesViewmodel editViewModel;

  final TextEditingController rateController = TextEditingController();
  final FocusNode rateFocus = FocusNode();

  final TextEditingController discountController = TextEditingController();
  final FocusNode discountFocus = FocusNode();

  final CustomNotifications notifications = CustomNotifications();

  @override
  void initState() {
    final serviceScheduling = widget.serviceScheduling;
    editViewModel = EditScheduledServicesViewmodel(
      schedulingService: context.read<SchedulingService>(),
      serviceScheduling: serviceScheduling.copyWith(
        services: List.from(serviceScheduling.services),
      ),
    );
    if (serviceScheduling.totalRate > 0) {
      rateController.text = serviceScheduling.totalRate.toString();
    }
    if (serviceScheduling.totalDiscount > 0) {
      discountController.text = serviceScheduling.totalDiscount.toString();
    }
    super.initState();
  }

  @override
  void dispose() {
    editViewModel.dispose();
    rateController.dispose();
    rateFocus.dispose();
    discountController.dispose();
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
                                child: BackNavigation(onTap: () => Navigator.pop(context))),
                            const Expanded(
                              child: CustomAppBarTitle(
                                title: 'Alteração de Serviços',
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
                          controller: rateController,
                          focusNode: rateFocus,
                          isNumeric: true,
                          inputFormatters: [MoneyTextInputFormatter()],
                          onChanged: (_) => onChangeRate(),
                        ),
                        const SizedBox(height: 12),
                        CustomTextField(
                          label: 'Desconto',
                          controller: discountController,
                          focusNode: discountFocus,
                          isNumeric: true,
                          inputFormatters: [MoneyTextInputFormatter()],
                          onChanged: (_) => onChangeDicount(),
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
                        servicesCard(),
                        const SizedBox(height: 12),
                        totalProductsCard(),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            const Expanded(child: SizedBox()),
                            AddServiceButtom(onTap: onNewService),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Divider(height: 1, color: Theme.of(context).colorScheme.shadow),
                        const SizedBox(height: 12),
                        totalCard(),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ListenableBuilder(
            listenable: editViewModel,
            builder: (context, _) {
              if (editViewModel.state is EditServicesAndPricesLoading) {
                return const CustomLoading();
              }

              if (editViewModel.state is EditServicesAndPricesError) {
                final messageError = (editViewModel.state as EditServicesAndPricesError).message;
                WidgetsBinding.instance.addPostFrameCallback(
                  (_) => notifications.showSnackBar(
                    context: context,
                    message: messageError,
                  ),
                );
              }

              if (editViewModel.state is EditServicesAndPricesUpdateSuccess) {
                WidgetsBinding.instance.addPostFrameCallback(
                  (_) => Navigator.pop(context, true),
                );
              }

              return CustomButton(
                label: 'Salvar',
                onTap: onSave,
              );
            },
          ),
        ),
      ),
    );
  }

  Widget servicesCard() {
    final services = editViewModel.serviceScheduling.services;
    List<Widget> servicesWidgets = [];
    for (int i = 0; i < services.length; i++) {
      servicesWidgets.add(
        EditServiceItemCard(
            key: ValueKey(services[i].hashCode),
            service: services[i],
            index: i,
            onLongPress: onLongPressService),
      );
      if (i < services.length - 1) {
        servicesWidgets.add(const SizedBox(height: 10));
      }
    }
    return Column(
      children: servicesWidgets,
    );
  }

  Widget totalCard() {
    return Row(
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
          Formatters.formatPrice(editViewModel.serviceScheduling.totalPriceCalculated),
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w500,
          ),
        )
      ],
    );
  }

  Widget totalProductsCard() {
    return Padding(
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
            Formatters.formatPrice(editViewModel.serviceScheduling.totalPrice),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              fontStyle: FontStyle.italic,
            ),
          )
        ],
      ),
    );
  }

  void onLongPressService(int index) {
    removeFocus();

    final service = editViewModel.serviceScheduling.services[index];
    if (service.removed) {
      onReturnService(index);
    } else {
      onRemoveService(index);
    }
  }

  void onRemoveService(int index) {
    if (editViewModel.quantityOfActiveServices() == 1) {
      notifications.showSuccessAlert(
        context: context,
        title: 'Exclusão não permitida',
        content: 'Não é permitido excluir todos os serviços do agendamento.',
      );
    } else {
      final service = editViewModel.serviceScheduling.services[index];
      notifications.showQuestionAlert(
        context: context,
        title: 'Remover serviço',
        content: 'Tem certeza que deseja remover o serviço "${service.name}"?',
        confirmCallback: () {
          editViewModel.removeService(index: index);
        },
      );
    }
  }

  void onReturnService(int index) {
    final service = editViewModel.serviceScheduling.services[index];
    notifications.showQuestionAlert(
      context: context,
      title: 'Readicionar serviço',
      content: 'Tem certeza que deseja retornar o serviço "${service.name}"?',
      confirmCallback: () {
        editViewModel.returnService(index: index);
      },
    );
  }

  void onChangeRate() {
    if (rateController.text.isEmpty) {
      editViewModel.changeRate(0);
    } else {
      editViewModel.changeRate(double.parse(rateController.text.replaceAll(',', '.')));
    }
  }

  void onChangeDicount() {
    if (discountController.text.isEmpty) {
      editViewModel.changeDicount(0);
    } else {
      editViewModel.changeDicount(double.parse(discountController.text.replaceAll(',', '.')));
    }
  }

  void onNewService() async {
    removeFocus();

    final result = await Navigator.pushNamed(
      context,
      '/service',
      arguments: {'isSelectionView': true},
    );

    if (result is Service) {
      editViewModel.addService(service: result);
    }
  }

  void onSave() {
    removeFocus();

    if (!editViewModel.validateSave()) {
      return;
    }

    confirmSave();
  }

  Future<void> confirmSave() async {
    await notifications.showQuestionAlert(
      context: context,
      title: 'Alterar serviços e preços',
      content: 'Tem certeza que deseja salvar as alterações efetuadas?',
      confirmCallback: () {
        editViewModel.save();
      },
    );
  }

  void removeFocus() {
    rateFocus.unfocus();
    discountFocus.unfocus();
  }
}
