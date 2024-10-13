import 'package:flutter_test/flutter_test.dart';
import 'package:prestador_de_servico/app/controllers/auth/sign_in_controller.dart';
import 'package:prestador_de_servico/app/services/auth/auth_service.dart';
import 'package:prestador_de_servico/app/states/auth/sign_in_state.dart';

import '../../../helpers/auth/mock_auth_repository_helper.dart';
import '../../../helpers/constants/constants.dart';
import '../../../helpers/user/mock_user_repository_helper.dart';

void main() {
  late SignInController signInController;

  setUpAll(
    () {
      // As configurações abaixo criam os comportamentos mockados para diferentes
      // situações relacionadas a autenticação e cadastro de usuário, além de instânciar
      // os mocks públicos mockAuthRepository e mockUserRepository
      setUpMockAuthRepository();
      setUpMockUserRepository();
      AuthService authService = AuthService(
        authRepository: mockAuthRepository,
        userRepository: mockUserRepository,
      );
      signInController = SignInController(authService: authService);
    },
  );

  test(
    '''Ao tentar logar sem informar o email o estado do controller deve ser 
    alterado para SignInError e conter uma mensagem no campo de email''',
    () async {
      await signInController.signInEmailPassword(
        email: userWithoutEmail.email,
        password: userWithoutEmail.password,
      );

      expect(signInController.state is SignInError, isTrue);
      final state = signInController.state as SignInError;
      expect(state.emailMessage, isNotNull);
    },
  );

  test(
    '''Ao tentar logar sem informar a senha o estado do controller deve ser 
    alterado para SignInError e conter uma mensagem no campo de senha''',
    () async {
      await signInController.signInEmailPassword(
        email: userWithoutPassword.email,
        password: userWithoutPassword.password,
      );

      expect(signInController.state is SignInError, isTrue);
      final state = signInController.state as SignInError;
      expect(state.passwordMessage, isNotNull);
    },
  );

  test(
    '''Ao tentar logar sem estar conectado a internet o estado do controller deve ser
    alterado para SignInError e conter uma mensagem no campo genérico''',
    () async {
      await signInController.signInEmailPassword(
        email: userNoNetworkConection.email,
        password: userNoNetworkConection.password,
      );

      expect(signInController.state is SignInError, isTrue);
      final state = signInController.state as SignInError;
      expect(state.genericMessage, isNotNull);
    },
  );

  test(
    '''Ao tentar logar com um email não cadatrado o estado do controller deve ser
    alterado para SignInError e conter uma mensagem no campo genérico''',
    () async {
      await signInController.signInEmailPassword(
        email: userNotFoud.email,
        password: userNotFoud.password,
      );

      expect(signInController.state is SignInError, isTrue);
      final state = signInController.state as SignInError;
      expect(state.genericMessage, isNotNull);
    },
  );

  test(
    '''Ao tentar logar com uma senha incorreta o estado do controller deve ser
    alterado para SignInError e conter uma mensagem no campo genérico''',
    () async {
      await signInController.signInEmailPassword(
        email: userInvalidCredentials.email,
        password: userInvalidCredentials.password,
      );

      expect(signInController.state is SignInError, isTrue);
      final state = signInController.state as SignInError;
      expect(state.genericMessage, isNotNull);
    },
  );

  test(
    '''Ao tentar logar em uma conta que não possui email validado o estado do 
    controller deve ser alterado para SignInError e conter uma mensagem 
    no campo genérico''',
    () async {
      await signInController.signInEmailPassword(
        email: userEmailNotVerified.email,
        password: userEmailNotVerified.password,
      );

      expect(signInController.state is SignInError, isTrue);
      final state = signInController.state as SignInError;
      expect(state.genericMessage, isNotNull);
    },
  );

  test(
    '''Ao tentar logar em uma conta após muitas tentativa inválidas o estado do 
    controller deve ser alterado para SignInError e conter uma mensagem 
    no campo genérico''',
    () async {
      await signInController.signInEmailPassword(
        email: userTooManyRequests.email,
        password: userTooManyRequests.password,
      );

      expect(signInController.state is SignInError, isTrue);
      final state = signInController.state as SignInError;
      expect(state.genericMessage, isNotNull);
    },
  );

  test(
    '''Ao tentar logar em uma conta válida com a credenciais válidas o estado do 
    controller deve ser alterado para SignInSuccess com o respectivo usuário logado''',
    () async {
      await signInController.signInEmailPassword(
        email: userValidToSignIn.email,
        password: userValidToSignIn.password,
      );

      expect(signInController.state is SignInSuccess, isTrue);
      final state = signInController.state as SignInSuccess;
      expect(state.user, equals(userValidToSignIn));
    },
  );
}
