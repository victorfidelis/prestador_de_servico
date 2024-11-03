
import 'package:mockito/annotations.dart';
import 'package:prestador_de_servico/app/repositories/service/service_category/service_category_repository.dart';

import 'mock_service_category_repository.mocks.dart';

@GenerateNiceMocks([MockSpec<ServiceCategoryRepository>()])
late MockServiceCategoryRepository onlineMockServiceCategoryRepository;
late MockServiceCategoryRepository offlineMockServiceCategoryRepository;

void setUpMockServiceCategoryRepository() {
  onlineMockServiceCategoryRepository = MockServiceCategoryRepository();
  offlineMockServiceCategoryRepository = MockServiceCategoryRepository();
}
