import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:prestador_de_servico/app/views/auth/viewmodel/sign_in_viewmodel.dart';
import 'package:prestador_de_servico/app/models/user/user.dart';
import 'package:prestador_de_servico/app/services/auth/auth_service.dart';
import 'package:prestador_de_servico/app/shared/utils/either/either.dart';
import 'package:prestador_de_servico/app/shared/utils/failure/failure.dart';
import 'package:prestador_de_servico/app/views/auth/states/sign_in_state.dart';

import '../../../../helpers/auth/mock_auth_repository.dart';
import '../../../../helpers/user/mock_user_repository.dart';

void main() {
  late SignInViewModel signInViewModel;

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

  setUpAll(
    () {
      setUpMockAuthRepository();
      setUpMockUserRepository();
      AuthService authService = AuthService(
        authRepository: mockAuthRepository,
        userRepository: mockUserRepository,
      );
      signInViewModel = SignInViewModel(authService: authService);
      setUpValues();
    },
  );

  group(
    'signInEmailPassword',
    () {
      test(
        '''Deve definir o estado como SignInError e definir uma mensagem no campo "emailMessage" 
        quando o campo "email" estiver vazio''',
        () async { 
          await signInViewModel.signInEmailPassword(
            email: '',
            password: user1.password,
          );

          expect(signInViewModel.state is SignInError, isTrue);
          final state = signInViewModel.state as SignInError;
          expect(state.emailMessage, isNotNull);
        },
      );

      test(
        '''Deve definir o estado como SignInError e definir uma mensagem no campo "passwordMessage" 
        quando o campo "password" estiver vazio''',
        () async {
          await signInViewModel.signInEmailPassword(
            email: user1.email,
            password: '',
          );

          expect(signInViewModel.state is SignInError, isTrue);
          final state = signInViewModel.state as SignInError;
          expect(state.passwordMessage, isNotNull);
        },
      );

      test(
        '''Deve definir o estado como SignInError e definir uma mensagem no campo "genericMessage" 
        quando não existir acesso a internet''',
        () async {
          const failureMessage = 'Teste de falha';
          when(mockUserRepository.getByEmail(email: user1.email))
              .thenAnswer((_) async => Either.left(NetworkFailure(failureMessage)));

          await signInViewModel.signInEmailPassword(
            email: user1.email,
            password: user1.password,
          );

          expect(signInViewModel.state is SignInError, isTrue);
          final state = signInViewModel.state as SignInError;
          expect(state.genericMessage, equals(failureMessage));
        },
      );

      test(
        '''Deve definir o estado como SignInError e definir uma mensagem no campo "genericMessage" 
        quando o campo "email" não estiver cadastrado''',
        () async {
          const failureMessage = 'Teste de falha';
          when(mockUserRepository.getByEmail(email: user1.email))
              .thenAnswer((_) async => Either.left(UserNotFoundFailure(failureMessage)));

          await signInViewModel.signInEmailPassword(
            email: user1.email,
            password: user1.password,
          );

          expect(signInViewModel.state is SignInError, isTrue);
          final state = signInViewModel.state as SignInError;
          expect(state.genericMessage, equals(failureMessage));
        },
      );

      test(
        '''Deve definir o estado como SignInError e definir uma mensagem no campo "genericMessage" 
        quando o campo "password" não estiver correto''',
        () async {
          const failureMessage = 'Teste de falha';
          when(mockUserRepository.getByEmail(email: user1.email)).thenAnswer((_) async => Either.right(user1));
          when(mockAuthRepository.signInEmailPassword(email: user1.email, password: user1.password))
              .thenAnswer((_) async => Either.left(InvalidCredentialFailure(failureMessage)));

          await signInViewModel.signInEmailPassword(
            email: user1.email,
            password: user1.password,
          );

          expect(signInViewModel.state is SignInError, isTrue);
          final state = signInViewModel.state as SignInError;
          expect(state.genericMessage, equals(failureMessage));
        },
      );

      test(
        '''Deve definir o estado como SignInError e definir uma mensagem para o campo "genericMessage"
        quando o campo "email" não estiver confirmado''',
        () async {
          const failureMessage = 'Teste de falha';
          when(mockUserRepository.getByEmail(email: user1.email)).thenAnswer((_) async => Either.right(user1));
          when(mockAuthRepository.signInEmailPassword(email: user1.email, password: user1.password))
              .thenAnswer((_) async => Either.left(EmailNotVerifiedFailure(failureMessage)));
          when(mockAuthRepository.sendEmailVerificationForCurrentUser()).thenAnswer((_) async => Either.right(unit));

          await signInViewModel.signInEmailPassword(email: user1.email, password: user1.password);

          expect(signInViewModel.state is SignInError, isTrue);
          final state = signInViewModel.state as SignInError;
          expect(state.genericMessage, isNotEmpty);
        },
      );

      test(
        '''Deve definir o estado como SignInError e definir uma mensagem para o campo "genericMessage"
        quando muitas tentativas inválidas forem executadas''',
        () async {
          const failureMessage = 'Teste de falha';
          when(mockUserRepository.getByEmail(email: user1.email)).thenAnswer((_) async => Either.right(user1));
          when(mockAuthRepository.signInEmailPassword(email: user1.email, password: user1.password))
              .thenAnswer((_) async => Either.left(TooManyRequestsFailure(failureMessage)));

          await signInViewModel.signInEmailPassword(
            email: user1.email,
            password: user1.password,
          );

          expect(signInViewModel.state is SignInError, isTrue);
          final state = signInViewModel.state as SignInError;
          expect(state.genericMessage, equals(failureMessage));
        },
      );

      test(
        '''Deve definir o estado como SignInSuccess e definir o usuário no campo "user"
        quando o "email" e "password" estiverem válidos''',
        () async {
          when(mockUserRepository.getByEmail(email: user1.email)).thenAnswer((_) async => Either.right(user1));
          when(mockAuthRepository.signInEmailPassword(email: user1.email, password: user1.password))
              .thenAnswer((_) async => Either.right(unit));

          await signInViewModel.signInEmailPassword(
            email: user1.email,
            password: user1.password,
          );

          expect(signInViewModel.state is SignInSuccess, isTrue);
          final state = signInViewModel.state as SignInSuccess;
          expect(state.user, equals(user1));
        },
      );
    },
  );
}
