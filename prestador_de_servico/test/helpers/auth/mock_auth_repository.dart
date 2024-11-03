import 'package:mockito/annotations.dart';
import 'package:prestador_de_servico/app/repositories/auth/auth_repository.dart';
import 'mock_auth_repository.mocks.dart';

@GenerateNiceMocks([MockSpec<AuthRepository>()])
late MockAuthRepository mockAuthRepository;

void setUpMockAuthRepository() {
  mockAuthRepository = MockAuthRepository();
}
