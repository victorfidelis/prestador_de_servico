import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/models/service_scheduling/service_scheduling.dart';
import 'package:prestador_de_servico/app/models/service_status/service_status_extensions.dart';
import 'package:prestador_de_servico/app/shared/themes/custom_colors.dart';
import 'package:prestador_de_servico/app/shared/utils/formatters/formatters.dart';

class CustomSchedulingMessageWidget extends StatelessWidget {
  final ServiceScheduling serviceScheduling;
  final double fontSize;
  const CustomSchedulingMessageWidget({
    super.key,
    required this.serviceScheduling,
    this.fontSize = 14,
  });

  @override
  Widget build(BuildContext context) {
    final customColors = Theme.of(context).extension<CustomColors>();

    if (serviceScheduling.schedulingUnavailable) {
      return Text(
        'Horário indisponível',
        style: TextStyle(
          color: customColors!.conflict,
          fontWeight: FontWeight.w700,
          fontSize: fontSize,
        ),
      );
    } else if (serviceScheduling.conflictScheduing) {
      return Text(
        'Horário em conflito',
        style: TextStyle(
          color: customColors!.conflict,
          fontWeight: FontWeight.w700,
          fontSize: fontSize,
        ),
      );
    } else if (serviceScheduling.isPaid) {
      final totalPaid = Formatters.formatPrice(serviceScheduling.totalPaid);
      return Text(
        'Serviço pago ($totalPaid)',
        style: TextStyle(
          color: customColors!.money,
          fontWeight: FontWeight.w700,
          fontSize: fontSize,
        ),
      );
    } else if (!serviceScheduling.isPaid && serviceScheduling.serviceStatus.isAccept()) {
      final needToPay = Formatters.formatPrice(serviceScheduling.needToPay);
      return Text(
        '$needToPay pendente',
        style: TextStyle(
          color: customColors!.pending,
          fontWeight: FontWeight.w700,
          fontSize: fontSize,
        ),
      );
    } else {
      return const SizedBox();
    }
  }
}
