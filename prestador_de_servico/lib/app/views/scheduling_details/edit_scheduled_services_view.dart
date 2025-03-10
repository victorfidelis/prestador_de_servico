import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/shared/utils/text_input_fomatters/money_text_input_formatter.dart';
import 'package:prestador_de_servico/app/shared/widgets/back_navigation.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_app_bar_title.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_button.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_header_container.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_text_field.dart';
import 'package:prestador_de_servico/app/shared/widgets/sliver_app_bar_delegate.dart';
import 'package:prestador_de_servico/app/views/scheduling_details/viewmodels/edit_scheduled_services_viewmodel.dart';
import 'package:prestador_de_servico/app/views/scheduling_details/viewmodels/scheduling_detail_viewmodel.dart';
import 'package:prestador_de_servico/app/views/scheduling_details/widgets/service_item_card.dart';
import 'package:provider/provider.dart';

class EditScheduledServicesView extends StatefulWidget {
  const EditScheduledServicesView({super.key});

  @override
  State<EditScheduledServicesView> createState() => _EditScheduledServicesViewState();
}

class _EditScheduledServicesViewState extends State<EditScheduledServicesView> {
  late final EditScheduledServicesViewmodel editViewModel;

  final TextEditingController rateController = TextEditingController();
  final FocusNode rateFocus = FocusNode();

  final TextEditingController discountController = TextEditingController();
  final FocusNode discountFocus = FocusNode();

  @override
  void initState() {
    final serviceScheduling = context.read<SchedulingDetailViewModel>().serviceScheduling;
    editViewModel = EditScheduledServicesViewmodel(serviceScheduling: serviceScheduling);
    rateController.text = serviceScheduling.totalRate.toString();
    discountController.text = serviceScheduling.totalDiscount.toString();
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
    return Scaffold(
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
                      ),
                      const SizedBox(height: 12),
                      CustomTextField(
                        label: 'Desconto',
                        controller: discountController,
                        focusNode: discountFocus,
                        isNumeric: true,
                        inputFormatters: [MoneyTextInputFormatter()],
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
        child: CustomButton(
          label: 'Salvar',
          onTap: () {},
        ),
      ),
    );
  }

  Widget servicesCard() {
    final services = editViewModel.serviceScheduling.services;
    List<Widget> servicesWidgets = [];
    for (int i = 0; i < services.length; i++) {
      servicesWidgets.add(ServiceItemCard(service: services[i]));
    }
    return Column(
      children: servicesWidgets,
    );
  }
}
