import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/models/scheduled_service/scheduled_service.dart';
import 'package:prestador_de_servico/app/models/service_scheduling/service_scheduling.dart';
import 'package:prestador_de_servico/app/shared/utils/formatters/formatters.dart';
import 'package:prestador_de_servico/app/views/scheduling_details/widgets/edit_button.dart';
import 'package:prestador_de_servico/app/views/scheduling_details/widgets/service_item_card.dart';

class ServiceListCard extends StatefulWidget {
  final ServiceScheduling serviceScheduling;

  const ServiceListCard({super.key, required this.serviceScheduling});

  @override
  State<ServiceListCard> createState() => _ServiceListCardState();
}

class _ServiceListCardState extends State<ServiceListCard> {
  late ServiceScheduling serviceScheduling;

  @override
  void initState() {
    serviceScheduling = widget.serviceScheduling;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool hasDiscount = serviceScheduling.totalDiscount > 0;
    bool hasRate = serviceScheduling.totalRate > 0;

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
              otherValuesCard('Subtotal', serviceScheduling.totalPrice),
              hasDiscount ? const SizedBox(height: 8) : const SizedBox(),
              hasDiscount
                  ? otherValuesCard('Discontos', serviceScheduling.totalDiscount)
                  : const SizedBox(),
              hasRate ? const SizedBox(height: 8) : const SizedBox(),
              hasRate ? otherValuesCard('Taxas', serviceScheduling.totalRate) : const SizedBox(),
              const SizedBox(height: 8),
              totalCard(),
              const SizedBox(height: 8),
              EditButton(onTap: () {}),
            ],
          ),
        )
      ],
    );
  }

  Widget servicesCard() {
    List<Widget> services = [];
    final quantityServices = serviceScheduling.services.length;
    for (int i = 0; i < quantityServices; i++) {
      final isLastService = (i == quantityServices - 1);
      services.add(
        Column(
          children: [
            ServiceItemCard(service: serviceScheduling.services[i]),
            isLastService ? const SizedBox() : const Divider(height: 1),
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
          Formatters.formatPrice(serviceScheduling.totalPriceToPay),
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
          Formatters.formatPrice(value),
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
