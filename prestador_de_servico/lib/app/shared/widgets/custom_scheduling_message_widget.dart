import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/models/scheduling/scheduling.dart';
import 'package:prestador_de_servico/app/models/service_status/service_status_extensions.dart';
import 'package:prestador_de_servico/app/shared/themes/custom_colors.dart';
import 'package:prestador_de_servico/app/shared/utils/formatters/formatters.dart';

class CustomSchedulingMessageWidget extends StatelessWidget {
  final Scheduling scheduling;
  final double fontSize;
  const CustomSchedulingMessageWidget({
    super.key,
    required this.scheduling,
    this.fontSize = 14,
  });

  @override
  Widget build(BuildContext context) {
    final customColors = Theme.of(context).extension<CustomColors>();

    if (scheduling.schedulingUnavailable) {
      return Text(
        'Horário indisponível',
        style: TextStyle(
          color: customColors!.conflict,
          fontWeight: FontWeight.w700,
          fontSize: fontSize,
        ),
      );
    } else if (scheduling.conflictScheduing) {
      return Text(
        'Horário em conflito',
        style: TextStyle(
          color: customColors!.conflict,
          fontWeight: FontWeight.w700,
          fontSize: fontSize,
        ),
      );
    } else if (scheduling.isPaid) {
      final totalPaid = Formatters.formatPrice(scheduling.totalPaid);
      return Text(
        'Serviço pago ($totalPaid)',
        style: TextStyle(
          color: customColors!.money,
          fontWeight: FontWeight.w700,
          fontSize: fontSize,
        ),
      );
    } else if (!scheduling.isPaid && scheduling.serviceStatus.isAccept()) {
      final needToPay = Formatters.formatPrice(scheduling.needToPay);
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
