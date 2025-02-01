import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/controllers/payment/payment_controller.dart';
import 'package:prestador_de_servico/app/models/payment/payment.dart';
import 'package:prestador_de_servico/app/shared/widgets/back_navigation.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_app_bar_title.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_header_container.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_loading.dart';
import 'package:prestador_de_servico/app/shared/widgets/sliver_app_bar_delegate.dart';
import 'package:prestador_de_servico/app/states/payment/payment_state.dart';
import 'package:prestador_de_servico/app/views/payment/widgets/custom_payment_card.dart';
import 'package:provider/provider.dart';

class PaymentView extends StatefulWidget {
  const PaymentView({super.key});

  @override
  State<PaymentView> createState() => _PaymentViewState();
}

class _PaymentViewState extends State<PaymentView> {

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => context.read<PaymentController>().load());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(
            floating: true,
            delegate: SliverAppBarDelegate(
              maxHeight: 116,
              minHeight: 116,
              child: Stack(
                children: [
                  CustomHeaderContainer(
                    height: 100,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 28),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(width: 60, child: BackNavigation(onTap: () => Navigator.pop(context))),
                          const Expanded(
                            child: CustomAppBarTitle(title: 'Pagamentos'),
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
          Consumer<PaymentController>(
            builder: (context, paymentController, _) {
              if (paymentController.state is PaymentInitial) {
                return const SliverFillRemaining();
              }

              if (paymentController.state is PaymentError) {
                return SliverFillRemaining(
                  child: Center(
                    child: Text((paymentController.state as PaymentError).message),
                  ),
                );
              }

              if (paymentController.state is PaymentLoading) {
                return const SliverFillRemaining(
                  child: Center(
                    child: CustomLoading(),
                  ),
                );
              }

              final payments = (paymentController.state as PaymentLoaded).payments;

              payments.sort((p1, p2) {
                if (p1.paymentType.index > p2.paymentType.index) {
                  return 1;
                }
                if (p1.paymentType.index < p2.paymentType.index) {
                  return -1;
                }
                return 0;
              });

              return SliverPadding(
                padding: const EdgeInsets.symmetric(
                  vertical: 6,
                  horizontal: 18,
                ),
                sliver: SliverList.builder(
                  itemCount: payments.length,
                  itemBuilder: (context, index) {
                    return CustomPaymentCard(
                      payment: payments[index],
                      changeStateOfPayment: _changeStateOfPayment,
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _changeStateOfPayment({required Payment payment}) {
    context.read<PaymentController>().update(payment: payment);
  }
}
