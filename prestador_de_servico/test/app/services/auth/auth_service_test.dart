import 'package:flutter_test/flutter_test.dart';
import 'package:prestador_de_servico/app/services/auth/auth_service.dart';
import 'package:prestador_de_servico/app/shared/either/either.dart';
import 'package:prestador_de_servico/app/shared/either/either_extension.dart';
import 'package:prestador_de_servico/app/shared/failure/failure.dart';
import '../../../helpers/auth/mock_auth_repository_helper.dart';
import '../../../helpers/constants/user_constants.dart';
import '../../../helpers/user/mock_user_repository_helper.dart';

void main() {
  late AuthService authService;

  setUpAll(
    () {
      setUpMockAuthRepository();
      setUpMockUserRepository();
      authService = AuthService(
        authRepository: mockAuthRepository,
        userRepository: mockUserRepository,
      );
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
              user: userValidToCreate);
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
            email: userValidToSignIn.email,
            password: userValidToSignIn.password,
          );

          expect(signInEither.isRight, isTrue);
          expect(signInEither.right == userValidToSignIn, isTrue);
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
          final resetPasswordEmailEither =
              await authService.sendPasswordResetEmail(
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
          final resetPasswordEmailEither =
              await authService.sendPasswordResetEmail(
            email: userValidToSendResetPasswordEmail.email,
          );

          expect(resetPasswordEmailEither.isRight, isTrue);
          expect(resetPasswordEmailEither.right is Unit, isTrue);
        },
      );
    },
  );
}
