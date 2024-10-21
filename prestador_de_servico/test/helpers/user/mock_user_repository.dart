import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:prestador_de_servico/app/repositories/user/user_repository.dart';
import 'package:prestador_de_servico/app/shared/either/either.dart';
import 'package:prestador_de_servico/app/shared/failure/failure.dart';
import '../constants/user_constants.dart';
import 'mock_user_repository.mocks.dart';

@GenerateNiceMocks([MockSpec<UserRepository>()])
late MockUserRepository mockUserRepository;

void setUpMockUserRepository() {
  mockUserRepository = MockUserRepository();
  
  when(mockUserRepository.getByEmail(email: userNoNetworkConection.email))
      .thenAnswer((_) async =>
          Either.left(NetworkFailure('Sem conexão com a internet')));

  when(mockUserRepository.getByEmail(email: userEmailAlreadyUse.email))
      .thenAnswer((_) async => Either.right(userEmailAlreadyUse));

  when(mockUserRepository.getByEmail(email: userValidToCreate.email))
      .thenAnswer((_) async => Either.right(userValidToCreate));

  when(mockUserRepository.getByEmail(email: userNotFoud.email)).thenAnswer(
      (_) async => Either.left(UserNotFoundFailure('Usuário não encontrado')));

  when(mockUserRepository.getByEmail(email: userInvalidCredentials.email))
      .thenAnswer((_) async => Either.right(userInvalidCredentials));

  when(mockUserRepository.getByEmail(email: userEmailNotVerified.email))
      .thenAnswer((_) async => Either.right(userEmailNotVerified));

  when(mockUserRepository.getByEmail(email: userTooManyRequests.email))
      .thenAnswer((_) async => Either.right(userTooManyRequests));

  when(mockUserRepository.getByEmail(email: userValidToSignIn.email))
      .thenAnswer((_) async => Either.right(userValidToSignIn));

  when(mockUserRepository.update(user: anyNamed("user")))
      .thenAnswer((_) async => Either.right(unit));
}
