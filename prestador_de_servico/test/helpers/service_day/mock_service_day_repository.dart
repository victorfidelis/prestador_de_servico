

import 'package:mockito/annotations.dart';
import 'package:prestador_de_servico/app/repositories/service_day/service_day_repository.dart';

import 'mock_service_day_repository.mocks.dart';


@GenerateNiceMocks([MockSpec<ServiceDayRepository>()])

late MockServiceDayRepository offlineMockServiceDayRepository;
late MockServiceDayRepository onlineMockServiceDayRepository;
void setUpMockServiceDayRepository() {
  offlineMockServiceDayRepository = MockServiceDayRepository();
  onlineMockServiceDayRepository = MockServiceDayRepository();
}

