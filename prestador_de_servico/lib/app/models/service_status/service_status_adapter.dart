import 'package:prestador_de_servico/app/models/service_status/service_status.dart';

class ServiceStatusAdapter {
  static ServiceStatus fromServiceSchedulingMap({required Map map}) {
    return ServiceStatus(code: map['code'], name: map['name']);
  }
}