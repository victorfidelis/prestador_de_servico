
import 'package:prestador_de_servico/app/shared/network/network_helpers_http.dart';

abstract class NetworkHelpers {
  factory NetworkHelpers() {
    return NetworkHelpersHttp();
  }

  Future<bool> isImageLinkOnline(String url);
}