import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/models/service/service.dart';
import 'package:prestador_de_servico/app/models/service_scheduling/service_scheduling.dart';
import 'package:prestador_de_servico/app/models/service_status/service_status_extensions.dart';
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
    final formatPrice = Formatters.formatPrice(serviceScheduling.totalPrice);

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
                      serviceScheduling.serviceStatus.name,
                      style: TextStyle(
                        color: Colors.orange,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: serviceScheduling.services.map((e) => serviceItemList(e)).toList(),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Expanded(child: messageWidget()),
                      Text(
                        formatPrice,
                        style: const TextStyle(
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w700,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget serviceItemList(Service service) {
    final formatPrice = Formatters.formatPrice(service.price);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.circle, size: 6),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            service.name,
            style: const TextStyle(fontSize: 14),
          ),
        ),
        Text(
          formatPrice,
          style: const TextStyle(
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }

  Widget messageWidget() {
    Widget widgetReturn = Container();
    if (serviceScheduling.schedulingUnavailable) {
      widgetReturn = const Text(
        'Horário indisponível',
        style: TextStyle(
          color: Color(0xffE70000),
          fontWeight: FontWeight.w700,
        ),
      );
    } else if (serviceScheduling.conflictScheduing) {
      widgetReturn = const Text(
        'Horário em conflito',
        style: TextStyle(
          color: Color(0xffE70000),
          fontWeight: FontWeight.w700,
        ),
      );
    } else if (serviceScheduling.isPaid) {
      final totalPaid = Formatters.formatPrice(serviceScheduling.totalPaid);
      widgetReturn = Text(
        'Serviço pago ($totalPaid)',
        style: const TextStyle(
          color: Color(0xff00891E),
          fontWeight: FontWeight.w700,
        ),
      );
    } else if (!serviceScheduling.isPaid && serviceScheduling.serviceStatus.isAcceptStatus()) {
      final needToPay = Formatters.formatPrice(serviceScheduling.needToPay);
      widgetReturn = Text(
        '$needToPay pendente',
        style: const TextStyle(
          color: Color(0xffEC942C),
          fontWeight: FontWeight.w700,
        ),
      );
    }
    return widgetReturn;
  }
}
