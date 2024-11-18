
import 'package:mockito/annotations.dart';
import 'package:prestador_de_servico/app/services/offline_image/offline_image_service.dart';

import 'mock_offline_image_service.mocks.dart';


@GenerateNiceMocks([MockSpec<OfflineImageService>()])

late MockOfflineImageService mockOfflineImageService;
void setUpMockOfflineImageService() {
  mockOfflineImageService = MockOfflineImageService();
}