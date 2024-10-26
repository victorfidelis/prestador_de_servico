
import 'package:mockito/annotations.dart';
import 'package:prestador_de_servico/app/repositories/service/service/service_repository.dart';

import 'mock_service_repository.mocks.dart';

@GenerateNiceMocks([MockSpec<ServiceRepository>()])

late MockServiceRepository offlineMockServiceRepository;
late MockServiceRepository onlineMockServiceRepository;
void setUpMockServiceRepository() {
  offlineMockServiceRepository = MockServiceRepository();
  onlineMockServiceRepository = MockServiceRepository();
}

