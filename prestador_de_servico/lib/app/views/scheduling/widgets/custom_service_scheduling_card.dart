import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/models/service_scheduling/service_scheduling.dart';
import 'package:prestador_de_servico/app/shared/formatters/formatters.dart';

class CustomServiceSchedulingCard extends StatelessWidget {
  final ServiceScheduling serviceScheduling;

  const CustomServiceSchedulingCard({
    super.key,
    required this.serviceScheduling,
  });

  @override
  Widget build(BuildContext context) {
    final startHour = Formatters.defaultFormatHoursAndMinutes(
      serviceScheduling.startDateAndTime.hour,
      serviceScheduling.startDateAndTime.minute,
    );
    final endHour = Formatters.defaultFormatHoursAndMinutes(
      serviceScheduling.endDateAndTime.hour,
      serviceScheduling.endDateAndTime.minute,
    );
    final completeName = '${serviceScheduling.user.name} ${serviceScheduling.user.surname}';

    return Container(
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
      child: IntrinsicHeight(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  startHour,
                ),
                Text(
                  endHour,
                ),
              ],
            ),
            VerticalDivider(
              color: Theme.of(context).colorScheme.shadow,
              thickness: 1,
              width: 20,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    completeName,
                    style: TextStyle(
                      color: Colors.orange,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      'Pendente prestador',
                      style: TextStyle(
                        color: Colors.orange,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
