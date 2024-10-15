import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:prestador_de_servico/app/repositories/auth/auth_repository.dart';
import 'package:prestador_de_servico/app/shared/either/either.dart';
import 'package:prestador_de_servico/app/shared/failure/failure.dart';
import '../constants/user_constants.dart';
import 'mock_auth_repository_helper.mocks.dart';

@GenerateNiceMocks([MockSpec<AuthRepository>()])
late MockAuthRepository mockAuthRepository;

void setUpMockAuthRepository() {
  mockAuthRepository = MockAuthRepository();

  when(mockAuthRepository.createUserEmailPassword(
    email: userNoNetworkConection.email,
    password: userNoNetworkConection.password,
  )).thenAnswer(
      (_) async => Either.left(NetworkFailure('Sem conexão com a internet')));

  when(mockAuthRepository.createUserEmailPassword(
    email: userEmailAlreadyUse.email,
    password: userEmailAlreadyUse.password,
  )).thenAnswer((_) async =>
      Either.left(EmailAlreadyInUseFailure('Email já cadastrado')));

  when(mockAuthRepository.createUserEmailPassword(
    email: userValidToCreate.email,
    password: userValidToCreate.password,
  )).thenAnswer((_) async => Either.right(unit));

  when(mockAuthRepository.signInEmailPassword(
    email: userNoNetworkConection.email,
    password: userNoNetworkConection.password,
  )).thenAnswer(
      (_) async => Either.left(NetworkFailure('Sem conexão com a internet')));

  when(mockAuthRepository.signInEmailPassword(
    email: userNotFoud.email,
    password: userNotFoud.password,
  )).thenAnswer(
      (_) async => Either.left(UserNotFoundFailure('Usuário não encontrado')));

  when(mockAuthRepository.signInEmailPassword(
    email: userInvalidCredentials.email,
    password: userInvalidCredentials.password,
  )).thenAnswer((_) async => Either.left(
      InvalidCredentialFailure('Credenciais de usuário inválidas')));

  when(mockAuthRepository.signInEmailPassword(
    email: userEmailNotVerified.email,
    password: userEmailNotVerified.password,
  )).thenAnswer((_) async => Either.left(EmailNotVerifiedFailure(
      'Email ainda não verificado. Faça a verificação através do link enviado ao seu email.')));

  when(mockAuthRepository.signInEmailPassword(
    email: userTooManyRequests.email,
    password: userTooManyRequests.password,
  )).thenAnswer((_) async => Either.left(TooManyRequestsFailure(
      'Bloqueio temporário. Muitas tentativas incorretas')));

  when(mockAuthRepository.signInEmailPassword(
    email: userValidToSignIn.email,
    password: userValidToSignIn.password,
  )).thenAnswer((_) async => Either.right(unit));

  when(mockAuthRepository.sendEmailVerificationForCurrentUser())
      .thenAnswer((_) async => Either.right(unit));

  when(mockAuthRepository.sendPasswordResetEmail(
          email: userNoNetworkConection.email))
      .thenAnswer((_) async =>
          Either.left(NetworkFailure('Sem conexão com a internet')));

  when(mockAuthRepository.sendPasswordResetEmail(
          email: userValidToSendResetPasswordEmail.email))
      .thenAnswer((_) async => Either.right(unit));
}
