import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:prestador_de_servico/app/views/auth/viewmodel/password_reset_viewmodel.dart';
import 'package:prestador_de_servico/app/models/user/user.dart';
import 'package:prestador_de_servico/app/services/auth/auth_service.dart';
import 'package:prestador_de_servico/app/shared/utils/either/either.dart';
import 'package:prestador_de_servico/app/shared/utils/failure/failure.dart';
import 'package:prestador_de_servico/app/views/auth/states/password_reset_state.dart';

import '../../../../helpers/auth/mock_auth_repository.dart';
import '../../../../helpers/user/mock_user_repository.dart';

void main() {
  late PasswordResetViewModel passwordResetViewModel;

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
      passwordResetViewModel = PasswordResetViewModel(authService: authService);
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

          await passwordResetViewModel.sendPasswordResetEmail(email: user1.email);

          expect(passwordResetViewModel.state is ErrorPasswordResetEmail, isTrue);
          final state = (passwordResetViewModel.state as ErrorPasswordResetEmail);
          expect(state.message, equals(failureMessage));
        },
      );

      test(
        '''Deve definir o estado como PasswordResetEmailSentSuccess quando a solicitação for válida''',
        () async {
          when(mockAuthRepository.sendPasswordResetEmail(email: user1.email))
              .thenAnswer((_) async => Either.right(unit));

          await passwordResetViewModel.sendPasswordResetEmail(email: user1.email);

          expect(passwordResetViewModel.state is PasswordResetEmailSentSuccess, isTrue);
        },
      );
    },
  );
}
