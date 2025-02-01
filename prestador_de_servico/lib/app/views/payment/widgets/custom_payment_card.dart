import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/models/payment/payment.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_switch.dart';

class CustomPaymentCard extends StatefulWidget {
  final Payment payment;
  final Function({required Payment payment}) changeStateOfPayment;

  const CustomPaymentCard({
    super.key,
    required this.payment,
    required this.changeStateOfPayment,
  });

  @override
  State<CustomPaymentCard> createState() => _CustomPaymentCardState();
}

class _CustomPaymentCardState extends State<CustomPaymentCard> {

  late Payment payment;

  @override
  void initState() {
    payment = widget.payment;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 80,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).colorScheme.shadow,
                offset: const Offset(0, 4),
                blurStyle: BlurStyle.normal,
                blurRadius: 4,
              )
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Image.network(payment.urlIcon),
                const SizedBox(width: 20),
                Expanded(
                  child: Text(
                    payment.name,
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
                CustomSwitch(
                  initialValue: payment.isActive,
                  onChanged: onChanged,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 18),
      ],
    );
  }

  void onChanged() {
    payment = payment.copyWith(isActive: !payment.isActive);
    widget.changeStateOfPayment(payment: payment);
  }
}
