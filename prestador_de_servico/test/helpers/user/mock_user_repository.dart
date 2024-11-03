import 'package:mockito/annotations.dart';
import 'package:prestador_de_servico/app/repositories/user/user_repository.dart';
import 'mock_user_repository.mocks.dart';

@GenerateNiceMocks([MockSpec<UserRepository>()])
late MockUserRepository mockUserRepository;

void setUpMockUserRepository() {
  mockUserRepository = MockUserRepository();
}
