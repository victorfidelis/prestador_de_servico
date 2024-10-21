
import 'package:mockito/annotations.dart';
import 'package:prestador_de_servico/app/services/network/network_service.dart';
import 'mock_network_service.mocks.dart';

@GenerateNiceMocks([MockSpec<NetworkService>()])

late MockNetworkService mockNetworkService;

void setUpNetworkService() {
  mockNetworkService = MockNetworkService();
}

