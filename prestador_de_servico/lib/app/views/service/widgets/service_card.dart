import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/models/service/service.dart';
import 'package:prestador_de_servico/app/shared/formatters/formatters.dart';

class ServiceCard extends StatelessWidget {
  final Function() onTap;
  final Service service;

  const ServiceCard({
    super.key,
    required this.onTap,
    required this.service,
  });

  @override
  Widget build(BuildContext context) {
    Image image;

    if (service.imageUrl.isNotEmpty) {
      image = Image.network(service.imageUrl, fit: BoxFit.cover);
    } else {
      image = Image.asset('assets/images/sem_imagem.jpg', fit: BoxFit.cover);
    }

    return GestureDetector(
      onTap: () {},
      child: Container(
        width: 180,
        margin: const EdgeInsets.symmetric(horizontal: 6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
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
                borderRadius: const BorderRadius.all(Radius.circular(12)),
                child: image,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.only(left: 8, right: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    service.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: Text(
                          Formatters.formatHoursAndMinutes(service.hours, service.minutes),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Text(
                        Formatters.formatPrice(service.price),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xff169A00),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
