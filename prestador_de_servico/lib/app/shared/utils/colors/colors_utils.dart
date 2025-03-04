import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/models/service_status/service_status.dart';
import 'package:prestador_de_servico/app/models/service_status/service_status_extensions.dart';
import 'package:prestador_de_servico/app/shared/themes/custom_colors.dart';

class ColorsUtils {
  static Color getColorFromStatus(BuildContext context, ServiceStatus serviceStatus) {
    final customColors = Theme.of(context).extension<CustomColors>();
    Color color = Colors.black;
    if (serviceStatus.isPendingStatus()) {
      color = customColors?.pending ?? const Color(0xffEC942C);
    } else if (serviceStatus.isAcceptStatus()) {
      color = customColors?.confirm ?? const Color(0xff1976D2);
    } else if (serviceStatus.isServicePerformStatus()) {
      color = customColors?.money ?? const Color(0xff00891E);
    } else if (serviceStatus.isCancellationStatus()) {
      color = customColors?.cancel ?? const Color(0xffE70000);
    }
    return color;
  }
}