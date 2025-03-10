import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/models/scheduled_service/scheduled_service.dart';
import 'package:prestador_de_servico/app/shared/utils/formatters/formatters.dart';

class ServiceItemCard extends StatelessWidget {
  final ScheduledService service;

  const ServiceItemCard({super.key, required this.service});

  @override
  Widget build(BuildContext context) {

    final formatPrice = Formatters.formatPrice(service.price);

      Color backColor;
      if (service.removed) {
        backColor = const Color(0xffEF9A9A);
      } else if (service.isAdditional) {
        backColor = const Color(0xffC8E6C9);
      } else {
        backColor = Colors.white;
      }

    return Container(
      color: backColor,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(child: Text(service.name)),
          Text(formatPrice)
        ],
      ),
    );
  }
}
