import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/models/scheduling/scheduling.dart';
import 'package:prestador_de_servico/app/shared/utils/data_converter.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_scheduling_message_widget.dart';
import 'package:prestador_de_servico/app/views/scheduling_details/widgets/edit_button.dart';
import 'package:prestador_de_servico/app/views/scheduling_details/widgets/service_item_card.dart';

class ServiceListCard extends StatefulWidget {
  final Scheduling scheduling;
  final Function()? onEdit;

  const ServiceListCard({
    super.key,
    required this.scheduling,
    required this.onEdit,
  });

  @override
  State<ServiceListCard> createState() => _ServiceListCardState();
}

class _ServiceListCardState extends State<ServiceListCard> {
  late Scheduling scheduling;
  late bool hasEditButtom;

  @override
  void initState() {
    scheduling = widget.scheduling;
    hasEditButtom = widget.onEdit != null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool hasDiscount = scheduling.totalDiscount > 0;
    bool hasRate = scheduling.totalRate > 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Serviços',
          style: TextStyle(fontSize: 16),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const SizedBox(height: 6),
              servicesCard(),
              const SizedBox(height: 12),
              otherValuesCard('Subtotal', scheduling.totalPrice),
              hasRate ? const SizedBox(height: 8) : const SizedBox(),
              hasRate ? otherValuesCard('Taxas', scheduling.totalRate) : const SizedBox(),
              hasDiscount ? const SizedBox(height: 8) : const SizedBox(),
              hasDiscount
                  ? otherValuesCard('Descontos', scheduling.totalDiscount)
                  : const SizedBox(),
              const SizedBox(height: 8),
              totalCard(),
              scheduling.hasMessage || hasEditButtom
                  ? const SizedBox(height: 8)
                  : const SizedBox(),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: CustomSchedulingMessageWidget(
                      scheduling: scheduling,
                      fontSize: 16,
                    ),
                  ),
                  hasEditButtom ? EditButton(onTap: widget.onEdit!) : const SizedBox(),
                ],
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget servicesCard() {
    List<Widget> services = [];
    final quantityServices = scheduling.services.length;
    for (int i = 0; i < quantityServices; i++) {
      final isLastService = (i == quantityServices - 1);
      services.add(
        Column(
          children: [
            ServiceItemCard(service: scheduling.services[i]),
            isLastService
                ? const SizedBox()
                : Divider(height: 1, color: Theme.of(context).colorScheme.shadow),
          ],
        ),
      );
    }

    return Container(
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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Column(
          children: services,
        ),
      ),
    );
  }

  Widget totalCard() {
    return Row(
      children: [
        const Expanded(
          child: Text(
            'Total',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Text(
          DataConverter.formatPrice(scheduling.totalPriceCalculated),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            fontStyle: FontStyle.italic,
          ),
        )
      ],
    );
  }

  Widget otherValuesCard(String label, double value) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Text(
          DataConverter.formatPrice(value),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            fontStyle: FontStyle.italic,
          ),
        )
      ],
    );
  }
}
