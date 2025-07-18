import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/models/service_status/service_status.dart';
import 'package:prestador_de_servico/app/models/service_status/service_status_extensions.dart';
import 'package:prestador_de_servico/app/shared/themes/custom_colors.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_light_buttom.dart';

class SchedulingActions extends StatelessWidget {
  final bool isPaid;
  final ServiceStatus serviceStatus;

  final Function() onConfirmScheduling;
  final Function() onSchedulingInService;
  final Function() onPerformScheduling;
  final Function() onRequestChangeScheduling;
  final Function() onReceivePayment;
  final Function() onDenyScheduling;
  final Function() onCancelScheduling;

  const SchedulingActions({
    super.key,
    required this.isPaid,
    required this.serviceStatus,
    required this.onConfirmScheduling,
    required this.onSchedulingInService,
    required this.onPerformScheduling,
    required this.onRequestChangeScheduling,
    required this.onReceivePayment,
    required this.onDenyScheduling,
    required this.onCancelScheduling,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> buttons = [];

    if (serviceStatus.isPendingProvider()) {
      buttons.add(CustomLightButtom(
        label: 'Confirmar',
        labelColor: Theme.of(context).extension<CustomColors>()!.confirm!,
        onTap: onConfirmScheduling,
      ));
    }

    if (serviceStatus.isConfirm()) {
      buttons.add(CustomLightButtom(
        label: 'Colocar em atendimento',
        labelColor: Theme.of(context).extension<CustomColors>()!.confirm!,
        onTap: onSchedulingInService,
      ));
    }

    if (serviceStatus.isInService()) {
      buttons.add(CustomLightButtom(
        label: 'Marcar como realizado',
        labelColor: Theme.of(context).extension<CustomColors>()!.confirm!,
        onTap: onPerformScheduling,
      ));
    }

    if (serviceStatus.isPendingProvider()) {
      buttons.add(CustomLightButtom(
        label: 'Solicitar alterações',
        labelColor: Theme.of(context).extension<CustomColors>()!.pending!,
        onTap: onRequestChangeScheduling,
      ));
    }

    if (!isPaid && serviceStatus.isAccept()) {
      buttons.add(CustomLightButtom(
        label: 'Receber pagamentos',
        labelColor: Theme.of(context).extension<CustomColors>()!.money!,
        onTap: onReceivePayment,
      ));
    }

    if (serviceStatus.isPendingProvider()) {
      buttons.add(CustomLightButtom(
        label: 'Recusar',
        labelColor: Theme.of(context).extension<CustomColors>()!.cancel!,
        onTap: onDenyScheduling,
      ));
    }

    if (serviceStatus.allowCancel()) {
      buttons.add(
        CustomLightButtom(
          label: 'Cancelar',
          labelColor: Theme.of(context).extension<CustomColors>()!.cancel!,
          onTap: onCancelScheduling,
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(left: 20, top: 8, right: 20),
      child: Column(
        spacing: 8,
        children: buttons,
      ),
    );
  }
}
