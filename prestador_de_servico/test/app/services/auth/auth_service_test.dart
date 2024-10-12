import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:prestador_de_servico/app/models/user/user.dart';
import 'package:prestador_de_servico/app/repositories/auth/auth_repository.dart';
import 'package:prestador_de_servico/app/repositories/user/user_repository.dart';
import 'package:prestador_de_servico/app/services/auth/auth_service.dart';
import 'package:prestador_de_servico/app/shared/either/either.dart';
import 'package:prestador_de_servico/app/shared/either/either_extension.dart';
import 'package:prestador_de_servico/app/shared/failure/failure.dart';
import 'auth_service_test.mocks.dart';

@GenerateNiceMocks([MockSpec<AuthRepository>()])
@GenerateNiceMocks([MockSpec<UserRepository>()])

void main() {
  late AuthService authService;
  final mockAuthRepository = MockAuthRepository();
  final mockUserRepository = MockUserRepository();

  final userNoNetworkConection = User(
    id: '1',
    isAdmin: true,
    email: 'userNoNetworkConection@test.com',
    name: 'userNoNetworkConection',
    surname: 'test',
    phone: '11912345678',
    password: '123456',
    confirmPassword: '123456',
  );

  final userEmailAlreadyUse = User(
    id: '2',
    isAdmin: true,
    email: 'userEmailAlreadyUse@test.com',
    name: 'userEmailAlreadyUse',
    surname: 'test',
    phone: '11912345678',
    password: '123456',
    confirmPassword: '123456',
  );

  final validUserToCreate = User(
    id: '3',
    isAdmin: true,
    email: 'validUserToCreate@test.com',
    name: 'validUserToCreate',
    surname: 'test',
    phone: '11912345678',
    password: '123456',
    confirmPassword: '123456',
  );

  final userNotFoud = User(
    id: '4',
    isAdmin: true,
    email: 'userNotFoud@test.com',
    name: 'userNotFoud',
    surname: 'test',
    phone: '11912345678',
    password: '123456',
    confirmPassword: '123456',
  );

  final userInvalidCredentials = User(
    id: '5',
    isAdmin: true,
    email: 'userInvalidCredentials@test.com',
    name: 'userInvalidCredentials',
    surname: 'test',
    phone: '11912345678',
    password: '1234567',
    confirmPassword: '1234567',
  );

  final userTooManyRequests = User(
    id: '6',
    isAdmin: true,
    email: 'userTooManyRequests@test.com',
    name: 'userTooManyRequests',
    surname: 'test',
    phone: '11912345678',
    password: '1234567',
    confirmPassword: '1234567',
  );

  final validUserToSignIn = User(
    id: '7',
    isAdmin: true,
    email: 'validUserToSignIn@test.com',
    name: 'validUserToSignIn',
    surname: 'test',
    phone: '11912345678',
    password: '1234567',
    confirmPassword: '1234567',
  );

  final validUserSendResetPasswordEmail = User(
    id: '7',
    isAdmin: true,
    email: 'validUserSendResetPasswordEmail@test.com',
    name: 'validUserSendResetPasswordEmail',
    surname: 'test',
    phone: '11912345678',
    password: '1234567',
    confirmPassword: '1234567',
  );

  setUpAll(
    () {
      authService = AuthService(
        authRepository: mockAuthRepository,
        userRepository: mockUserRepository,
      );

      when(mockAuthRepository.createUserEmailPassword(
        email: userNoNetworkConection.email,
        password: userNoNetworkConection.password,
      )).thenAnswer((_) async =>
          Either.left(NetworkFailure('Sem conexão com a internet')));

      when(mockAuthRepository.createUserEmailPassword(
        email: userEmailAlreadyUse.email,
        password: userEmailAlreadyUse.password,
      )).thenAnswer((_) async =>
          Either.left(EmailAlreadyInUseFailure('Email já cadastrado')));

      when(mockAuthRepository.createUserEmailPassword(
        email: validUserToCreate.email,
        password: validUserToCreate.password,
      )).thenAnswer((_) async => Either.right(unit));

      when(mockAuthRepository.signInEmailPassword(
        email: userNoNetworkConection.email,
        password: userNoNetworkConection.password,
      )).thenAnswer((_) async =>
          Either.left(NetworkFailure('Sem conexão com a internet')));

      when(mockAuthRepository.signInEmailPassword(
        email: userNotFoud.email,
        password: userNotFoud.password,
      )).thenAnswer((_) async =>
          Either.left(UserNotFoundFailure('Usuário não encontrado')));

      when(mockAuthRepository.signInEmailPassword(
        email: userInvalidCredentials.email,
        password: userInvalidCredentials.password,
      )).thenAnswer((_) async => Either.left(
          InvalidCredentialFailure('Credenciais de usuário inválidas')));

      when(mockAuthRepository.signInEmailPassword(
        email: userTooManyRequests.email,
        password: userTooManyRequests.password,
      )).thenAnswer((_) async => Either.left(TooManyRequestsFailure(
          'Bloqueio temporário. Muitas tentativas incorretas')));

      when(mockAuthRepository.signInEmailPassword(
        email: validUserToSignIn.email,
        password: validUserToSignIn.password,
      )).thenAnswer((_) async => Either.right(unit));

      when(mockUserRepository.getByEmail(email: userNoNetworkConection.email))
          .thenAnswer((_) async =>
              Either.left(NetworkFailure('Sem conexão com a internet')));

      when(mockUserRepository.getByEmail(email: userEmailAlreadyUse.email))
          .thenAnswer((_) async => Either.right(userEmailAlreadyUse));

      when(mockUserRepository.getByEmail(email: validUserToCreate.email))
          .thenAnswer((_) async => Either.right(validUserToCreate));

      when(mockUserRepository.getByEmail(email: userNotFoud.email)).thenAnswer(
          (_) async =>
              Either.left(UserNotFoundFailure('Usuário não encontrado')));

      when(mockUserRepository.getByEmail(email: userInvalidCredentials.email))
          .thenAnswer((_) async => Either.right(userInvalidCredentials));

      when(mockUserRepository.getByEmail(email: userTooManyRequests.email))
          .thenAnswer((_) async => Either.right(userTooManyRequests));

      when(mockUserRepository.getByEmail(email: validUserToSignIn.email))
          .thenAnswer((_) async => Either.right(validUserToSignIn));

      when(mockUserRepository.update(user: anyNamed("user")))
          .thenAnswer((_) async => Either.right(unit));

      when(mockAuthRepository.sendEmailVerificationForCurrentUser())
          .thenAnswer((_) async => Either.right(unit));

      when(mockAuthRepository.sendPasswordResetEmail(
              email: userNoNetworkConection.email))
          .thenAnswer((_) async =>
              Either.left(NetworkFailure('Sem conexão com a internet')));

      when(mockAuthRepository.sendPasswordResetEmail(
              email: validUserSendResetPasswordEmail.email))
          .thenAnswer((_) async => Either.right(unit));
    },
  );

  group(
    '''Testes referentes a criação de conta''',
    () {
      test(
        '''Ao tentar criar um usuário sem conexão com a internet um 
      NetworkFailure deve ser retornado no left do Either''',
        () async {
          final createUserEither = await authService.createUserEmailPassword(
              user: userNoNetworkConection);
          expect(createUserEither.isLeft, isTrue);
          expect(createUserEither.left is NetworkFailure, isTrue);
        },
      );

      test(
        '''Ao tentar criar um usuário com um email já cadastrado um
      EmailAlreadyInUseFailure deve ser retorndo no left do Either''',
        () async {
          final createUserEither = await authService.createUserEmailPassword(
              user: userEmailAlreadyUse);
          expect(createUserEither.isLeft, isTrue);
          expect(createUserEither.left is EmailAlreadyInUseFailure, isTrue);
        },
      );

      test(
        '''Ao tentar criar um usuário valido um right vazio deve ser retornado no Either''',
        () async {
          final createUserEither = await authService.createUserEmailPassword(
              user: validUserToCreate);
          expect(createUserEither.isRight, isTrue);
          expect(createUserEither.right is Unit, isTrue);
        },
      );
    },
  );

  group(
    '''Testes referentes ao login''',
    () {
      test(
        '''Ao tentar realizar um login sem conexão com a internet 
        um either com left do tipo NetworkFailure deve ser retornado''',
        () async {
          final signInEither =
              await authService.signInEmailPasswordAndVerifyEmail(
            email: userNoNetworkConection.email,
            password: userNoNetworkConection.password,
          );

          expect(signInEither.isLeft, isTrue);
          expect(signInEither.left is NetworkFailure, isTrue);
        },
      );

      test(
        '''Ao tentar realizar um login de um usuário não cadastrado 
        um either com left do tipo UserNotFoundFailure deve ser retornado''',
        () async {
          final signInEither =
              await authService.signInEmailPasswordAndVerifyEmail(
            email: userNotFoud.email,
            password: userNotFoud.password,
          );

          expect(signInEither.isLeft, isTrue);
          expect(signInEither.left is UserNotFoundFailure, isTrue);
        },
      );

      test(
        '''Ao tentar realizar um login com a senha incorreta um either com 
        left do tipo InvalidCredentialFailure deve ser retornado''',
        () async {
          final signInEither =
              await authService.signInEmailPasswordAndVerifyEmail(
            email: userInvalidCredentials.email,
            password: userInvalidCredentials.password,
          );

          expect(signInEither.isLeft, isTrue);
          expect(signInEither.left is InvalidCredentialFailure, isTrue);
        },
      );

      test(
        '''Ao tentar realizar um login incorreto depois de muitas tantativas 
        incorretas um either com left do tipo TooManyRequestsFailure deve ser 
        retornado''',
        () async {
          final signInEither =
              await authService.signInEmailPasswordAndVerifyEmail(
            email: userTooManyRequests.email,
            password: userTooManyRequests.password,
          );

          expect(signInEither.isLeft, isTrue);
          expect(signInEither.left is TooManyRequestsFailure, isTrue);
        },
      );

      test(
        '''Ao tentar realizar um login com um usuário valido e com 
        suas credenciais válidas um rigth vazio deve ser retornado''',
        () async {
          final signInEither =
              await authService.signInEmailPasswordAndVerifyEmail(
            email: validUserToSignIn.email,
            password: validUserToSignIn.password,
          );

          expect(signInEither.isRight, isTrue);
          expect(signInEither.right == validUserToSignIn, isTrue);
        },
      );
    },
  );

  group(
    '''Testes referentes ao envio do link de redefinição de senha''',
    () {
      test(
        '''Ao tentar enviar link para redefinição de senha sem estar conectado a
        internet um either com left do tipo NetworkFailure deve ser retornado''',
        () async {
          final resetPasswordEmailEither = await authService.sendPasswordResetEmail(
            email: userNoNetworkConection.email,
          );

          expect(resetPasswordEmailEither.isLeft, isTrue);
          expect(resetPasswordEmailEither.left is NetworkFailure, isTrue);
        },
      );
      
      test(
        '''Ao tentar enviar link para redefinição de senha sem estar conectado a
        internet um either com left do tipo NetworkFailure deve ser retornado''',
        () async {
          final resetPasswordEmailEither = await authService.sendPasswordResetEmail(
            email: validUserSendResetPasswordEmail.email,
          );

          expect(resetPasswordEmailEither.isRight, isTrue);
          expect(resetPasswordEmailEither.right is Unit, isTrue);
        },
      );
    },
  );
}
