import 'package:mockito/annotations.dart';
import 'package:prestador_de_servico/app/repositories/image/image_repository.dart';

import 'mock_image_repository.mocks.dart';

@GenerateNiceMocks([MockSpec<ImageRepository>()])

late MockImageRepository mockImageRepository;
void setUpMockImageRepository() {
  mockImageRepository = MockImageRepository();
}


