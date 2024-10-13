import 'package:flutter_test/flutter_test.dart';
import 'package:prestador_de_servico/app/controllers/auth/password_reset_controller.dart';
import 'package:prestador_de_servico/app/services/auth/auth_service.dart';
import 'package:prestador_de_servico/app/states/auth/password_reset_state.dart';

import '../../../helpers/auth/mock_auth_repository_helper.dart';
import '../../../helpers/constants/constants.dart';
import '../../../helpers/user/mock_user_repository_helper.dart';

void main() {
  late PasswordResetController passwordResetController;

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
      passwordResetController =
          PasswordResetController(authService: authService);
    },
  );

  test(
    '''Ao tentar enviar um email de recuperação de senha sem conexão com a internet
    o estado da controller deve ser alterado para ErrorPasswordResetEmail''',
    () async {
      await passwordResetController.sendPasswordResetEmail(
          email: userNoNetworkConection.email);

      expect(passwordResetController.state is ErrorPasswordResetEmail, isTrue);
    },
  );

  test(
    '''Ao tentar enviar um email de recuperação de senha devidamente conectado a internet
    o estado da controller deve ser alterado para PasswordResetEmailSentSuccess''',
    () async {
      await passwordResetController.sendPasswordResetEmail(
          email: userValidToSendResetPasswordEmail.email);

      expect(passwordResetController.state is PasswordResetEmailSentSuccess, isTrue);
    },
  );
}
