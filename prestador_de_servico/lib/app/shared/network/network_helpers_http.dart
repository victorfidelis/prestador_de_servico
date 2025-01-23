import 'package:http/http.dart' as http;
import 'package:prestador_de_servico/app/shared/network/network_helpers.dart';

class NetworkHelpersHttp implements NetworkHelpers {  
  @override
  Future<bool> isImageLinkOnline(String url) async {
    try {
      final response = await http.head(Uri.parse(url));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}