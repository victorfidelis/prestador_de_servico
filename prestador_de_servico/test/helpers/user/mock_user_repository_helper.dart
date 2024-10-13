import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:prestador_de_servico/app/repositories/user/user_repository.dart';
import 'package:prestador_de_servico/app/shared/either/either.dart';
import 'package:prestador_de_servico/app/shared/failure/failure.dart';
import '../constants/constants.dart';
import 'mock_user_repository_helper.mocks.dart';

@GenerateNiceMocks([MockSpec<UserRepository>()])
late MockUserRepository mockUserRepository;

void setupMockUserRepository() {
  mockUserRepository = MockUserRepository();
  
  when(mockUserRepository.getByEmail(email: userNoNetworkConection.email))
      .thenAnswer((_) async =>
          Either.left(NetworkFailure('Sem conexão com a internet')));

  when(mockUserRepository.getByEmail(email: userEmailAlreadyUse.email))
      .thenAnswer((_) async => Either.right(userEmailAlreadyUse));

  when(mockUserRepository.getByEmail(email: validUserToCreate.email))
      .thenAnswer((_) async => Either.right(validUserToCreate));

  when(mockUserRepository.getByEmail(email: userNotFoud.email)).thenAnswer(
      (_) async => Either.left(UserNotFoundFailure('Usuário não encontrado')));

  when(mockUserRepository.getByEmail(email: userInvalidCredentials.email))
      .thenAnswer((_) async => Either.right(userInvalidCredentials));

  when(mockUserRepository.getByEmail(email: userTooManyRequests.email))
      .thenAnswer((_) async => Either.right(userTooManyRequests));

  when(mockUserRepository.getByEmail(email: validUserToSignIn.email))
      .thenAnswer((_) async => Either.right(validUserToSignIn));

  when(mockUserRepository.update(user: anyNamed("user")))
      .thenAnswer((_) async => Either.right(unit));
}
