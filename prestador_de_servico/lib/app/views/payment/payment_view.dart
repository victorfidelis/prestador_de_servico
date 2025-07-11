import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/services/payments/payment_service.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_header.dart';
import 'package:prestador_de_servico/app/views/payment/viewmodels/payment_viewmodel.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_loading.dart';
import 'package:prestador_de_servico/app/views/payment/states/payment_state.dart';
import 'package:prestador_de_servico/app/views/payment/widgets/custom_payment_card.dart';
import 'package:provider/provider.dart';

class PaymentView extends StatefulWidget {
  const PaymentView({super.key});

  @override
  State<PaymentView> createState() => _PaymentViewState();
}

class _PaymentViewState extends State<PaymentView> {
  late final PaymentViewModel paymentViewModel;

  @override
  void initState() {
    paymentViewModel = PaymentViewModel(paymentService: context.read<PaymentService>());
    WidgetsBinding.instance.addPostFrameCallback((_) => paymentViewModel.load());
    super.initState();
  }

  @override
  void dispose() {
    paymentViewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            const SliverFloatingHeader(child: CustomHeader(title: 'Pagamentos')),
            ListenableBuilder(
              listenable: paymentViewModel,
              builder: (context, _) {
                if (paymentViewModel.state is PaymentInitial) {
                  return const SliverFillRemaining();
                }
            
                if (paymentViewModel.state is PaymentError) {
                  return SliverFillRemaining(
                    child: Center(
                      child: Text((paymentViewModel.state as PaymentError).message),
                    ),
                  );
                }
            
                if (paymentViewModel.state is PaymentLoading) {
                  return const SliverFillRemaining(
                    child: Center(
                      child: CustomLoading(),
                    ),
                  );
                }
            
                final payments = (paymentViewModel.state as PaymentLoaded).payments;
            
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
                    itemCount: payments.length + 1,
                    itemBuilder: (context, index) {
                      if (index == payments.length) {
                        return const SizedBox(height: 80);
                      }
                      return CustomPaymentCard(
                        payment: payments[index],
                        changeStateOfPayment: paymentViewModel.update,
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
