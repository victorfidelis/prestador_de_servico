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
    final formatPriceToPay = Formatters.formatPrice(serviceScheduling.totalPriceToPay);
    final textColor = getTextColor();
    final finishedSealIcon = getFinishedSealIcon();
    final othersValues = getOtherValues();
    final message = messageWidget();

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
                  style: const TextStyle(fontSize: 16),
                ),
                const Text(
                  'às',
                  style: TextStyle(fontSize: 14),
                ),
                Text(
                  endHour,
                  style: const TextStyle(fontSize: 16),
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
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              completeName,
                              style: TextStyle(
                                color: textColor,
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                serviceScheduling.serviceStatus.name,
                                style: TextStyle(
                                  color: textColor,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      finishedSealIcon,
                    ],
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
                  othersValues,
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Expanded(child: Container()),
                      Text(
                        formatPriceToPay,
                        style: const TextStyle(
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 6),
                  message,
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
            style: const TextStyle(fontSize: 16),
          ),
        ),
        Text(
          formatPrice,
          style: const TextStyle(
            fontStyle: FontStyle.italic,
            fontSize: 16,
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

  Color getTextColor() {
    Color color = Colors.black;
    if (serviceScheduling.serviceStatus.isPendingStatus()) {
      color = const Color(0xffEC942C);
    } else if (serviceScheduling.serviceStatus.isAcceptStatus()) {
      color = const Color(0xff1976D2);
    } else if (serviceScheduling.serviceStatus.isServicePerformStatus()) {
      color = const Color(0xff00891E);
    } else if (serviceScheduling.serviceStatus.isCancellationStatus()) {
      color = const Color(0xffE70000);
    }
    return color;
  }

  Widget getFinishedSealIcon() {
    Widget finishedSealIcon = Container();

    if (serviceScheduling.serviceStatus.isCancellationStatus()) {
      finishedSealIcon = ClipOval(
        child: Container(
          color: const Color(0xffE70000),
          padding: const EdgeInsets.all(2),
          child: const Icon(
            Icons.close,
            color: Colors.white,
            size: 20,
          ),
        ),
      );
    } else if (serviceScheduling.serviceStatus.isServicePerformStatus() && serviceScheduling.isPaid) {
      finishedSealIcon = ClipOval(
        child: Container(
          color: const Color(0xff00891E),
          padding: const EdgeInsets.all(2),
          child: const Icon(
            Icons.check,
            color: Colors.white,
            size: 20,
          ),
        ),
      );
    }

    return finishedSealIcon;
  }

  Widget getOtherValues() {
    final prices = serviceScheduling.services.map((s) => s.price).toList();
    final totalServicesPrice = prices.reduce((s1, s2) => s1 + s2);
    final formatServicesPrice = Formatters.formatPrice(totalServicesPrice);
    Widget subTotalWidget = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(child: Container()),
        const Expanded(child: Text('- Subtotal')),
        Text(
          formatServicesPrice,
          style: const TextStyle(fontStyle: FontStyle.italic),
        ),
      ],
    );

    Widget totalRateWidget = Container();
    if (serviceScheduling.totalRate > 0) {
      final formatRate = Formatters.formatPrice(serviceScheduling.totalRate);
      totalRateWidget = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(child: Container()),
          const Expanded(child: Text('- Taxa')),
          Text(
            formatRate,
            style: const TextStyle(fontStyle: FontStyle.italic),
          ),
        ],
      );
    }

    Widget totalDiscountWidget = Container();
    if (serviceScheduling.totalDiscount > 0) {
      final formatDiscount = Formatters.formatPrice(serviceScheduling.totalDiscount);
      totalDiscountWidget = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(child: Container()),
          const Expanded(child: Text('- Desconto')),
          Text(
            formatDiscount,
            style: const TextStyle(
              fontStyle: FontStyle.italic,
              decoration: TextDecoration.lineThrough,
            ),
          ),
        ],
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        subTotalWidget,
        totalRateWidget,
        totalDiscountWidget,
      ],
    );
  }
}
