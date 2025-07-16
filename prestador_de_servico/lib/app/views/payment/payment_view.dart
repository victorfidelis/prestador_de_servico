import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/services/payments/payment_service.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_header.dart';
import 'package:prestador_de_servico/app/shared/widgets/notifications/custom_notifications.dart';
import 'package:prestador_de_servico/app/views/payment/viewmodels/payment_viewmodel.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_loading.dart';
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

    paymentViewModel.notificationMessage.addListener(() {
      if (paymentViewModel.notificationMessage.value != null) {
        CustomNotifications().showSnackBar(context: context, message: paymentViewModel.notificationMessage.value!);
      }
    });

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
                if (paymentViewModel.hasError) {
                  return SliverFillRemaining(
                    child: Center(
                      child: Text(paymentViewModel.errorMessage!),
                    ),
                  );
                }

                if (paymentViewModel.paymentLoading) {
                  return const SliverFillRemaining(
                    child: Center(
                      child: CustomLoading(),
                    ),
                  );
                }

                return SliverPadding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 6,
                    horizontal: 18,
                  ),
                  sliver: SliverList.builder(
                    itemCount: paymentViewModel.payments.length + 1,
                    itemBuilder: (context, index) {
                      if (index == paymentViewModel.payments.length) {
                        return const SizedBox(height: 80);
                      }
                      return CustomPaymentCard(
                        payment: paymentViewModel.payments[index],
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
