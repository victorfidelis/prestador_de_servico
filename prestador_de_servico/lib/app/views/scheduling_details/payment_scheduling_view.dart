import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/models/scheduling/scheduling.dart';
import 'package:prestador_de_servico/app/services/scheduling/scheduling_service.dart';
import 'package:prestador_de_servico/app/shared/themes/custom_colors.dart';
import 'package:prestador_de_servico/app/shared/utils/data_converter.dart';
import 'package:prestador_de_servico/app/shared/utils/text_input_fomatters/money_text_input_formatter.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_button.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_header.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_loading.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_text_field.dart';
import 'package:prestador_de_servico/app/shared/widgets/notifications/custom_notifications.dart';
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

  @override
  void initState() {
    paymentViewModel = PaymentSchedulingViewModel(
      schedulingService: context.read<SchedulingService>(),
      scheduling: widget.scheduling,
    );

    paymentViewModel.notificationMessage.addListener(() {
      final message = paymentViewModel.notificationMessage.value;
      if (message != null) {
        CustomNotifications().showSnackBar(context: context, message: message);
      }
    });

    paymentViewModel.paymentSuccess.addListener(() {
      if (paymentViewModel.paymentSuccess.value) {
        WidgetsBinding.instance.addPostFrameCallback(
          (_) => Navigator.pop(context, true),
        );
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    paymentViewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = Theme.of(context).colorScheme;
    final customColor = Theme.of(context).extension<CustomColors>()!;

    final totalPrice = DataConverter.formatPrice(paymentViewModel.scheduling.totalPriceCalculated);
    final needToPay = DataConverter.formatPrice(paymentViewModel.scheduling.needToPay);
    final totalPaid = DataConverter.formatPrice(paymentViewModel.scheduling.totalPaid);

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            const SliverFloatingHeader(child: CustomHeader(title: 'Pagamento de Serviços', height: 100)),
            const SliverToBoxAdapter(child: SizedBox(height: 10)),
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
                          controller: paymentViewModel.valueToPayController,
                          errorMessage: paymentViewModel.valueToPayError.value,
                          isNumeric: true,
                          inputFormatters: [MoneyTextInputFormatter()],
                          onChanged: (_) => paymentViewModel.setValueToPay(),
                        );
                      },
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ListenableBuilder(
          listenable: paymentViewModel,
          builder: (context, _) {
            if (paymentViewModel.paymentLoading) {
              return const CustomLoading();
            }

            return CustomButton(
              label: 'Efetuar pagamento',
              onTap: _onSave,
            );
          },
        ),
      ),
    );
  }

  void _onSave() async {
    if (!paymentViewModel.validate()) {
      return;
    }

    _confirmSave();
  }

  void _confirmSave() {
    final value = DataConverter.formatPrice(paymentViewModel.valueToPay);

    CustomNotifications().showQuestionAlert(
      context: context,
      title: 'Pagamento',
      content: 'Tem certeza que deseja efetivar o recebimento do pagamento no valor de $value?',
      confirmCallback: paymentViewModel.receivePayment,
    );
  }
}
