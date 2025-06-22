import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/models/scheduling/scheduling.dart';
import 'package:prestador_de_servico/app/services/scheduling/scheduling_service.dart';
import 'package:prestador_de_servico/app/shared/themes/custom_colors.dart';
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
import 'package:prestador_de_servico/app/views/scheduling_details/states/payment_scheduling_state.dart';
import 'package:prestador_de_servico/app/views/scheduling_details/viewmodels/payment_scheduling_viewmodel.dart';
import 'package:provider/provider.dart';

class PaymentSchedulingView extends StatefulWidget {
  final Scheduling scheduling;
  const PaymentSchedulingView({super.key, required this.scheduling});

  @override
  State<PaymentSchedulingView> createState() => _PaymentSchedulingViewState();
}

class _PaymentSchedulingViewState extends State<PaymentSchedulingView> {
  late final PaymentSchedulingViewModel paymentViewModel;

  final notifications = CustomNotifications();

  final valueToPayController = TextEditingController();
  final valueToPayFocus = FocusNode();

  @override
  void initState() {
    paymentViewModel = PaymentSchedulingViewModel(
      schedulingService: context.read<SchedulingService>(),
      scheduling: widget.scheduling,
    );
    super.initState();
  }

  @override
  void dispose() {
    paymentViewModel.dispose();
    valueToPayController.dispose();
    valueToPayFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = Theme.of(context).colorScheme;
    final customColor = Theme.of(context).extension<CustomColors>()!;

    final totalPrice =
        Formatters.formatPrice(paymentViewModel.scheduling.totalPriceCalculated);
    final needToPay = Formatters.formatPrice(paymentViewModel.scheduling.needToPay);
    final totalPaid = Formatters.formatPrice(paymentViewModel.scheduling.totalPaid);

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
                              title: 'Pagamento de serviços',
                              fontSize: 25,
                            ),
                          ),
                          const SizedBox(width: 60)
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Valor total $totalPrice',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    '$needToPay pendente',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: customColor.pending,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '$totalPaid pago',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: customColor.money,
                    ),
                  ),
                  const SizedBox(height: 28),
                  Divider(color: themeColor.shadow),
                  const SizedBox(height: 32),
                  ListenableBuilder(
                      listenable: paymentViewModel.valueToPayError,
                      builder: (context, _) {
                        return CustomTextField(
                          label: 'Valor à pagar',
                          controller: valueToPayController,
                          focusNode: valueToPayFocus,
                          errorMessage: paymentViewModel.valueToPayError.value,
                          isNumeric: true,
                          inputFormatters: [MoneyTextInputFormatter()],
                          onChanged: onValueChanged,
                        );
                      }),
                ],
              ),
            ),
          )
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ListenableBuilder(
          listenable: paymentViewModel,
          builder: (context, _) {
            if (paymentViewModel.state is PaymentLoading) {
              return const CustomLoading();
            }

            if (paymentViewModel.state is PaymentError) {
              final messageError = (paymentViewModel.state as PaymentError).message;
              WidgetsBinding.instance.addPostFrameCallback(
                (_) => notifications.showSnackBar(
                  context: context,
                  message: messageError,
                ),
              );
            }

            if (paymentViewModel.state is PaymentSuccess) {
              WidgetsBinding.instance.addPostFrameCallback(
                (_) => Navigator.pop(context, true),
              );
            }

            return CustomButton(
              label: 'Efetuar pagamento',
              onTap: onSave,
            );
          },
        ),
      ),
    );
  }

  void onSave() async {
    if (!paymentViewModel.validate()) {
      return;
    }

    confirmSave();
  }

  void confirmSave() {
    final value = Formatters.formatPrice(paymentViewModel.valueToPay);

    notifications.showQuestionAlert(
      context: context,
      title: 'Pagamento',
      content: 'Tem certeza que deseja efetivar o recebimento do pagamento no valor de $value?',
      confirmCallback: paymentViewModel.receivePayment,
    );
  }

  void onValueChanged(String value) {
    var valueToPay = value.trim().replaceAll(',', '.');
    if (valueToPay.isEmpty) {
      valueToPay = '0';
    }
    paymentViewModel.setValueToPay(double.parse(valueToPay));
  }
}
