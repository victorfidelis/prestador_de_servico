import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/models/service_status/service_status.dart';
import 'package:prestador_de_servico/app/models/service_status/service_status_extensions.dart';

class ColorsUtils {
  static Color getColorFromStatus(ServiceStatus serviceStatus) {
    Color color = Colors.black;
    if (serviceStatus.isPendingStatus()) {
      color = const Color(0xffEC942C);
    } else if (serviceStatus.isAcceptStatus()) {
      color = const Color(0xff1976D2);
    } else if (serviceStatus.isServicePerformStatus()) {
      color = const Color(0xff00891E);
    } else if (serviceStatus.isCancellationStatus()) {
      color = const Color(0xffE70000);
    }
    return color;
  }
}