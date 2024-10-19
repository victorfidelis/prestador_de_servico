import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:prestador_de_servico/app/services/network/network_service.dart';

class NetwotkServiceImpl implements NetworkService {
  @override
  Future<bool> isConnectedToInternet() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult.contains(ConnectivityResult.mobile) ||
        connectivityResult.contains(ConnectivityResult.wifi)) {
      return true;
    } else {
      return false;
    }
  }
}
