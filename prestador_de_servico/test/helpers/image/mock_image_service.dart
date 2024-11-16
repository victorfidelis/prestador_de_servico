
import 'package:mockito/annotations.dart';
import 'package:prestador_de_servico/app/services/image/image_service.dart';

import 'mock_image_service.mocks.dart';

@GenerateNiceMocks([MockSpec<ImageService>()])

late MockImageService mockImageService;
void setUpMockImageService() {
  mockImageService = MockImageService();
}