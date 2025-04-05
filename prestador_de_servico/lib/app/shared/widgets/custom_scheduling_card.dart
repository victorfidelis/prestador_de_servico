import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/models/service/service.dart';
import 'package:prestador_de_servico/app/models/service_scheduling/service_scheduling.dart';
import 'package:prestador_de_servico/app/models/service_status/service_status_extensions.dart';
import 'package:prestador_de_servico/app/shared/utils/colors/colors_utils.dart';
import 'package:prestador_de_servico/app/shared/utils/formatters/formatters.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_scheduling_message_widget.dart';

class CustomSchedulingCard extends StatefulWidget {
  final ServiceScheduling serviceScheduling;
  final Function()? refreshOriginPage;
  final bool isReadOnly;

  const CustomSchedulingCard({
    super.key,
    required this.serviceScheduling,
    this.refreshOriginPage,
    this.isReadOnly = false,
  });

  @override
  State<CustomSchedulingCard> createState() => _CustomSchedulingCardState();
}

class _CustomSchedulingCardState extends State<CustomSchedulingCard> {
  late ServiceScheduling serviceScheduling;

  @override
  void initState() {
    serviceScheduling = widget.serviceScheduling;
    super.initState();
  }

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
    final formatPriceToPay = Formatters.formatPrice(serviceScheduling.totalPriceToPay);
    Color statusColor = ColorsUtils.getColorFromStatus(context, serviceScheduling.serviceStatus);
    final finishedSealIcon = getFinishedSealIcon();
    final othersValues = getOtherValues();

    return GestureDetector(
      onTap: onTap,
      child: Container(
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
                                serviceScheduling.user.fullname,
                                style: TextStyle(
                                  color: statusColor,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(
                                  serviceScheduling.serviceStatus.name,
                                  style: TextStyle(
                                    color: statusColor,
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
                        children: serviceScheduling.activeServices
                            .map((e) => serviceItemList(e))
                            .toList(),
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
                    CustomSchedulingMessageWidget(serviceScheduling: serviceScheduling),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onTap() async {
    if (widget.isReadOnly) {
      return;
    }

    final bool hasChange = await Navigator.pushNamed(
      context,
      '/schedulingDetails',
      arguments: {'serviceScheduling': serviceScheduling},
    ) as bool;

    if (hasChange && widget.refreshOriginPage != null) {
      widget.refreshOriginPage!();
    }
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

  Widget getFinishedSealIcon() {
    Widget finishedSealIcon = Container();

    if (serviceScheduling.serviceStatus.isCancelled()) {
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
    } else if (serviceScheduling.serviceStatus.isServicePerform() && serviceScheduling.isPaid) {
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
