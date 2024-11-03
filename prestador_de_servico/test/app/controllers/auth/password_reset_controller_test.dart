import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:prestador_de_servico/app/controllers/auth/password_reset_controller.dart';
import 'package:prestador_de_servico/app/models/user/user.dart';
import 'package:prestador_de_servico/app/services/auth/auth_service.dart';
import 'package:prestador_de_servico/app/shared/either/either.dart';
import 'package:prestador_de_servico/app/shared/failure/failure.dart';
import 'package:prestador_de_servico/app/states/auth/password_reset_state.dart';

import '../../../helpers/auth/mock_auth_repository.dart';
import '../../../helpers/user/mock_user_repository.dart';

void main() {
  late PasswordResetController passwordResetController;

  late User user1;

  setUpValues() {
    user1 = User(
      email: 'victor@gmail.com',
      name: 'Victor',
      surname: 'Fidelis Correa',
    );
  }

  setUp(
    () {
      setUpMockAuthRepository();
      setUpMockUserRepository();
      AuthService authService = AuthService(
        authRepository: mockAuthRepository,
        userRepository: mockUserRepository,
      );
      passwordResetController = PasswordResetController(authService: authService);
      setUpValues();
    },
  );

  group(
    'sendPasswordResetEmail',
    () {
      test(
        '''Deve definir o estado como ErrorPasswordResetEmail quando não existir acesso a internet''',
        () async {
          const failureMessage = 'Teste de falha';
          when(mockAuthRepository.sendPasswordResetEmail(email: user1.email))
              .thenAnswer((_) async => Either.left(NetworkFailure(failureMessage)));

          await passwordResetController.sendPasswordResetEmail(email: user1.email);

          expect(passwordResetController.state is ErrorPasswordResetEmail, isTrue);
          final state = (passwordResetController.state as ErrorPasswordResetEmail);
          expect(state.message, equals(failureMessage));
        },
      );

      test(
        '''Deve definir o estado como PasswordResetEmailSentSuccess quando a solicitação for válida''',
        () async {
          when(mockAuthRepository.sendPasswordResetEmail(email: user1.email))
              .thenAnswer((_) async => Either.right(unit));

          await passwordResetController.sendPasswordResetEmail(email: user1.email);

          expect(passwordResetController.state is PasswordResetEmailSentSuccess, isTrue);
        },
      );
    },
  );
}
