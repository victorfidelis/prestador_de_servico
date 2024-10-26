import 'package:mockito/annotations.dart';
import 'package:prestador_de_servico/app/repositories/service/services_by_category/services_by_category_repository.dart';

import 'mock_services_by_category_repository.mocks.dart';

@GenerateNiceMocks([MockSpec<ServicesByCategoryRepository>()])

late MockServicesByCategoryRepository offlineMockServicesByCategoryRepository;
void setUpMockServicesByCategoryRepository() {
  offlineMockServicesByCategoryRepository = MockServicesByCategoryRepository();
}
