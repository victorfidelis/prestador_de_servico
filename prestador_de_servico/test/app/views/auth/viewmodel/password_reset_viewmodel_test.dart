import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prestador_de_servico/app/repositories/auth/auth_repository.dart';
import 'package:prestador_de_servico/app/repositories/user/user_repository.dart';
import 'package:prestador_de_servico/app/views/auth/viewmodel/password_reset_viewmodel.dart';
import 'package:prestador_de_servico/app/models/user/user.dart';
import 'package:prestador_de_servico/app/services/auth/auth_service.dart';
import 'package:prestador_de_servico/app/shared/utils/either/either.dart';
import 'package:prestador_de_servico/app/shared/utils/failure/failure.dart';
import 'package:prestador_de_servico/app/views/auth/states/password_reset_state.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  final mockAuthRepository = MockAuthRepository();
  final mockUserRepository = MockUserRepository();
  final authService = AuthService(
    authRepository: mockAuthRepository,
    userRepository: mockUserRepository,
  );
  final passwordResetViewModel = PasswordResetViewModel(authService: authService);

  late User user1;

  setUp(
    () {
      user1 = User(
        email: 'victor@gmail.com',
        name: 'Victor',
        surname: 'Fidelis Correa',
      );
    },
  );

  group(
    'sendPasswordResetEmail',
    () {
      test(
        '''Deve definir o estado como ErrorPasswordResetEmail quando não existir acesso a internet''',
        () async {
          const failureMessage = 'Teste de falha';
          when(() => mockAuthRepository.sendPasswordResetEmail(email: user1.email))
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
          when(() => mockAuthRepository.sendPasswordResetEmail(email: user1.email))
              .thenAnswer((_) async => Either.right(unit));

          await passwordResetViewModel.sendPasswordResetEmail(email: user1.email);

          expect(passwordResetViewModel.state is PasswordResetEmailSentSuccess, isTrue);
        },
      );
    },
  );
}
