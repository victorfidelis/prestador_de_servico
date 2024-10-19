
import 'package:prestador_de_servico/app/services/network/netwotk_service_impl.dart';

abstract class NetworkService {

  factory NetworkService.create() {
    return NetwotkServiceImpl();
  }

  Future<bool> isConnectedToInternet();
}

