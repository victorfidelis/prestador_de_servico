

import 'package:mockito/annotations.dart';
import 'package:prestador_de_servico/app/repositories/service_scheduling/service_scheduling_repository.dart';

import 'mock_service_scheduling_repository.mocks.dart';

@GenerateNiceMocks([MockSpec<ServiceSchedulingRepository>()])

late MockServiceSchedulingRepository onlineMockServiceSchedulingRepository;
void setUpMockServiceSchedulingRepository() {
  onlineMockServiceSchedulingRepository = MockServiceSchedulingRepository();
}
