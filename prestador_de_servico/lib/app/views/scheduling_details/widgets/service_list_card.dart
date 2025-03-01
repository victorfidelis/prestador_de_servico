import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/models/service_scheduling/service_scheduling.dart';
import 'package:prestador_de_servico/app/shared/utils/formatters/formatters.dart';
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
            children: [
              Column(children: serviceItemCards()),
              const SizedBox(height: 12),
              otherValuesCard('Subtotal', serviceScheduling.totalPrice),
              hasDiscount ? const SizedBox(height: 12) : const SizedBox(),
              hasDiscount
                  ? otherValuesCard('Discontos', serviceScheduling.totalDiscount)
                  : const SizedBox(),
              hasRate ? const SizedBox(height: 12) : const SizedBox(),
              hasRate
                  ? otherValuesCard('Taxas', serviceScheduling.totalRate)
                  : const SizedBox(),
              const SizedBox(height: 12),
              totalCard(),
            ],
          ),
        )
      ],
    );
  }

  List<Widget> serviceItemCards() {
    return serviceScheduling.services.map((s) {
      return Padding(
        padding: const EdgeInsets.only(top: 8),
        child: ServiceItemCard(service: s),
      );
    }).toList();
  }

  Widget totalCard() {
    return Row(
      children: [
        const Expanded(
          child: Text(
            'Total',
            style: const TextStyle(
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
