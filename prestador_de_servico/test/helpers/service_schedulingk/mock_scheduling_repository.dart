

import 'package:mockito/annotations.dart';
import 'package:prestador_de_servico/app/repositories/scheduling/scheduling_repository.dart';

import 'mock_scheduling_repository.mocks.dart';


@GenerateNiceMocks([MockSpec<SchedulingRepository>()])

late MockSchedulingRepository onlineMockSchedulingRepository;
void setUpMockServiceSchedulingRepository() {
  onlineMockSchedulingRepository = MockSchedulingRepository();
}
