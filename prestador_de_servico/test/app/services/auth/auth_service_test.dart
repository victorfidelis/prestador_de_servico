import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:prestador_de_servico/app/models/user/user.dart';
import 'package:prestador_de_servico/app/services/auth/auth_service.dart';
import 'package:prestador_de_servico/app/shared/either/either.dart';
import 'package:prestador_de_servico/app/shared/extensions/either_extensions.dart';
import 'package:prestador_de_servico/app/shared/failure/failure.dart';
import '../../../helpers/auth/mock_auth_repository.dart';
import '../../../helpers/user/mock_user_repository.dart';

void main() {
  late AuthService authService;

  late User user1;

  setUpValues() {
    user1 = User(
      email: 'victor@gmail.com',
      name: 'Victor',
      surname: 'Fidelis Correa',
      password: '123466',
      confirmPassword: '123466',
    );
  }

  setUp(
    () {
      setUpMockAuthRepository();
      setUpMockUserRepository();
      authService = AuthService(
        authRepository: mockAuthRepository,
        userRepository: mockUserRepository,
      );
      setUpValues();
    },
  );

  group(
    'createUserEmailPassword',
    () {
      test(
        '''Deve retornar um NetworkFailure quando não tiver acesso a internet''',
        () async {
          const failureMessage = 'Teste de falha';
          when(mockUserRepository.getByEmail(email: user1.email))
              .thenAnswer((_) async => Either.left(NetworkFailure(failureMessage)));

          final createUserEither = await authService.createUserEmailPassword(user: user1);

          expect(createUserEither.isLeft, isTrue);
          expect(createUserEither.left is NetworkFailure, isTrue);
          final state = (createUserEither.left as NetworkFailure);
          expect(state.message, equals(failureMessage));
        },
      );

      test(
        '''Deve retornar um EmailAlreadyInUseFailure quando o email já estiver cadastrado''',
        () async {
          const failureMessage = 'Teste de falha';
          when(mockUserRepository.getByEmail(email: user1.email)).thenAnswer((_) async => Either.right(user1));
          when(mockUserRepository.update(user: user1)).thenAnswer((_) async => Either.right(unit));
          when(mockAuthRepository.createUserEmailPassword(email: user1.email, password: user1.password))
              .thenAnswer((_) async => Either.left(EmailAlreadyInUseFailure(failureMessage)));

          final createUserEither = await authService.createUserEmailPassword(user: user1);

          expect(createUserEither.isLeft, isTrue);
          expect(createUserEither.left is EmailAlreadyInUseFailure, isTrue);
          final state = (createUserEither.left as EmailAlreadyInUseFailure);
          expect(state.message, equals(failureMessage));
        },
      );

      test(
        '''Deve retornar um Unit quando o usuário for criado com sucesso''',
        () async {
          const userNotFoundMessage = 'Teste usuário não encontrado';
          when(mockUserRepository.getByEmail(email: user1.email))
              .thenAnswer((_) async => Either.left(UserNotFoundFailure(userNotFoundMessage)));
          when(mockAuthRepository.createUserEmailPassword(email: user1.email, password: user1.password))
              .thenAnswer((_) async => Either.right(unit));
          when(mockUserRepository.insert(user: user1)).thenAnswer((_) async => Either.right(user1.id));
          when(mockAuthRepository.sendEmailVerificationForCurrentUser()).thenAnswer((_) async => Either.right(unit));

          final createUserEither = await authService.createUserEmailPassword(user: user1);

          expect(createUserEither.isRight, isTrue);
          expect(createUserEither.right is Unit, isTrue);
        },
      );
    },
  );

  group(
    'signInEmailPasswordAndVerifyEmail',
    () {
      test(
        '''Deve retornar um NetworkFailure quando não tiver acesso a internet''',
        () async {
          const failureMessage = 'Teste de falha';
          when(mockUserRepository.getByEmail(email: user1.email))
              .thenAnswer((_) async => Either.left(NetworkFailure(failureMessage)));

          final signInEither = await authService.signInEmailPasswordAndVerifyEmail(
            email: user1.email,
            password: user1.password,
          );

          expect(signInEither.isLeft, isTrue);
          expect(signInEither.left is NetworkFailure, isTrue);
          final state = (signInEither.left as NetworkFailure);
          expect(state.message, equals(failureMessage));
        },
      );

      test(
        '''Deve retornar um UserNotFoundFailure quando o email não estiver cadastrado''',
        () async {
          const failureMessage = 'Teste de falha';
          when(mockUserRepository.getByEmail(email: user1.email))
              .thenAnswer((_) async => Either.left(UserNotFoundFailure(failureMessage)));

          final signInEither = await authService.signInEmailPasswordAndVerifyEmail(
            email: user1.email,
            password: user1.password,
          );

          expect(signInEither.isLeft, isTrue);
          expect(signInEither.left is UserNotFoundFailure, isTrue);
          final state = (signInEither.left as UserNotFoundFailure);
          expect(state.message, equals(failureMessage));
        },
      );

      test(
        '''Deve retornar um InvalidCredentialFailure quando a senha estiver incorreta''',
        () async {
          const failureMessage = 'Teste de falha';
          when(mockUserRepository.getByEmail(email: user1.email)).thenAnswer((_) async => Either.right(user1));
          when(mockAuthRepository.signInEmailPassword(email: user1.email, password: user1.password))
              .thenAnswer((_) async => Either.left(InvalidCredentialFailure(failureMessage)));

          final signInEither = await authService.signInEmailPasswordAndVerifyEmail(
            email: user1.email,
            password: user1.password,
          );

          expect(signInEither.isLeft, isTrue);
          expect(signInEither.left is InvalidCredentialFailure, isTrue);
          final state = (signInEither.left as InvalidCredentialFailure);
          expect(state.message, equals(failureMessage));
        },
      );

      test(
        '''Deve retornar um TooManyRequestsFailure quando realizar um login após muitas
        tentativas incorretas''',
        () async {
          const failureMessage = 'Teste de falha';
          when(mockUserRepository.getByEmail(email: user1.email)).thenAnswer((_) async => Either.right(user1));
          when(mockAuthRepository.signInEmailPassword(email: user1.email, password: user1.password))
              .thenAnswer((_) async => Either.left(TooManyRequestsFailure(failureMessage)));

          final signInEither = await authService.signInEmailPasswordAndVerifyEmail(
            email: user1.email,
            password: user1.password,
          );

          expect(signInEither.isLeft, isTrue);
          expect(signInEither.left is TooManyRequestsFailure, isTrue);
          final state = (signInEither.left as TooManyRequestsFailure);
          expect(state.message, equals(failureMessage));
        },
      );

      test(
        '''Deve retornar um User quando o login for executado com sucesso''',
        () async {
          when(mockUserRepository.getByEmail(email: user1.email)).thenAnswer((_) async => Either.right(user1));
          when(mockAuthRepository.signInEmailPassword(email: user1.email, password: user1.password))
              .thenAnswer((_) async => Either.right(unit));

          final signInEither = await authService.signInEmailPasswordAndVerifyEmail(
            email: user1.email,
            password: user1.password,
          );

          expect(signInEither.isRight, isTrue);
          expect(signInEither.right == user1, isTrue);
        },
      );
    },
  );

  group(
    '''sendPasswordResetEmail''',
    () {
      test(
        '''Deve retornar um NetworkFailure quando não tiver acesso a internet''',
        () async {
          const failureMessage = 'Teste de falha';
          when(mockAuthRepository.sendPasswordResetEmail(email: user1.email))
              .thenAnswer((_) async => Either.left(NetworkFailure(failureMessage)));

          final resetPasswordEmailEither = await authService.sendPasswordResetEmail(email: user1.email);

          expect(resetPasswordEmailEither.isLeft, isTrue);
          expect(resetPasswordEmailEither.left is NetworkFailure, isTrue);
          final state = (resetPasswordEmailEither.left as NetworkFailure);
          expect(state.message, equals(failureMessage));
        },
      );

      test(
        '''Deve retornar um Unit quando o envio de redefinição de senha for enviado 
        com sucesso''',
        () async {
          when(mockAuthRepository.sendPasswordResetEmail(email: user1.email))
              .thenAnswer((_) async => Either.right(unit));

          final resetPasswordEmailEither =
              await authService.sendPasswordResetEmail(email: user1.email);

          expect(resetPasswordEmailEither.isRight, isTrue);
          expect(resetPasswordEmailEither.right is Unit, isTrue);
        },
      );
    },
  );
}
