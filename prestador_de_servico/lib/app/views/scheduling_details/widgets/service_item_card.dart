import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/models/service/service.dart';
import 'package:prestador_de_servico/app/shared/utils/formatters/formatters.dart';

class ServiceItemCard extends StatelessWidget {
  final Service service;

  const ServiceItemCard({super.key, required this.service});

  @override
  Widget build(BuildContext context) {

    final formatPrice = Formatters.formatPrice(service.price);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
      child: Row(
        children: [
          Expanded(child: Text(service.name)),
          Text(formatPrice)
        ],
      ),
    );
  }
}
