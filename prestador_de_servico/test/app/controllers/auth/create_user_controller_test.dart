import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:prestador_de_servico/app/views/auth/viewmodel/create_user_viewmodel.dart';
import 'package:prestador_de_servico/app/models/user/user.dart';
import 'package:prestador_de_servico/app/services/auth/auth_service.dart';
import 'package:prestador_de_servico/app/shared/utils/either/either.dart';
import 'package:prestador_de_servico/app/shared/utils/failure/failure.dart';
import 'package:prestador_de_servico/app/views/auth/states/create_user_state.dart';

import '../../../helpers/auth/mock_auth_repository.dart';
import '../../../helpers/user/mock_user_repository.dart';

void main() {
  late CreateUserViewModel createUserController;

  late User user1;
  late User userWithoutEmail;
  late User userWithoutName;
  late User userWithoutSurname;
  late User userWithoutPassword;
  late User userWithoutConfirmPassword;
  late User userInvalidConfirmPassword;

  setUpValues() {
    user1 = User(
      email: 'victor@gmail.com',
      name: 'Victor',
      surname: 'Fidelis Correa',
      password: '123466',
      confirmPassword: '123466',
    );
    userWithoutEmail = User(
      email: '',
      name: 'Victor',
      surname: 'Fidelis Correa',
      password: '123466',
      confirmPassword: '123466',
    );
    userWithoutName = User(
      email: 'victor@gmail.com',
      name: '',
      surname: 'Fidelis Correa',
      password: '123466',
      confirmPassword: '123466',
    );
    userWithoutSurname = User(
      email: 'victor@gmail.com',
      name: 'Victor',
      surname: '',
      password: '123466',
      confirmPassword: '123466',
    );
    userWithoutPassword = User(
      email: 'victor@gmail.com',
      name: 'Victor',
      surname: 'Fidelis Correa',
      password: '',
      confirmPassword: '123466',
    );
    userWithoutConfirmPassword = User(
      email: 'victor@gmail.com',
      name: 'Victor',
      surname: 'Fidelis Correa',
      password: '123456',
      confirmPassword: '',
    );
    userInvalidConfirmPassword = User(
      email: 'victor@gmail.com',
      name: 'Victor',
      surname: 'Fidelis Correa',
      password: '123456',
      confirmPassword: '987654',
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
      createUserController = CreateUserViewModel(authService: authService);
      setUpValues();
    },
  );

  group(
    'createUserEmailPassword',
    () {
      test(
        '''Deve definir o estado como ErrorUserCreation e denifir uma mensagem de erro no campo
        "emailMessage" quando o campo "email" estiver vazio.''',
        () async {
          await createUserController.createUserEmailPassword(user: userWithoutEmail);

          expect(createUserController.state is ErrorUserCreation, isTrue);
          final state = createUserController.state as ErrorUserCreation;
          expect(state.emailMessage, isNotNull);
        },
      );

      test(
        '''Deve definir o estado como ErrorUserCreation e definir uma mensagem de erro no campo
        "nameMessage" quando o campo "name" estiver vazio.''',
        () async {
          await createUserController.createUserEmailPassword(user: userWithoutName);

          expect(createUserController.state is ErrorUserCreation, isTrue);
          final state = createUserController.state as ErrorUserCreation;
          expect(state.nameMessage, isNotNull);
        },
      );

      test(
        '''Deve definir o estado como ErrorUserCreation e definir uma mensagem de erro no campo
        "surnameMessage" quando o campo "surname" estiver vazio.''',
        () async {
          await createUserController.createUserEmailPassword(user: userWithoutSurname);

          expect(createUserController.state is ErrorUserCreation, isTrue);
          final state = createUserController.state as ErrorUserCreation;
          expect(state.surnameMessage, isNotNull);
        },
      );

      test(
        '''Deve definir o estado como ErrorUserCreation e definir uma mensagem de erro no campo
        "passwordMessage" quando o campo "password" estiver vazio.''',
        () async {
          await createUserController.createUserEmailPassword(user: userWithoutPassword);

          expect(createUserController.state is ErrorUserCreation, isTrue);
          final state = createUserController.state as ErrorUserCreation;
          expect(state.passwordMessage, isNotNull);
        },
      );

      test(
        '''Deve definir o estado como ErrorUserCreation e definir uma mensagem de erro no campo
        "confirmPasswordMessage" quando o campo "confirmPassword" estiver vazio.''',
        () async {
          await createUserController.createUserEmailPassword(user: userWithoutConfirmPassword);

          expect(createUserController.state is ErrorUserCreation, isTrue);
          final state = createUserController.state as ErrorUserCreation;
          expect(state.confirmPasswordMessage, isNotNull);
        },
      );

      test(
        '''Deve definir o estado como ErrorUserCreation e definir uma mensagem de erro no campo
        "confirmPasswordMessage" quando o campo "confirmPassword" estiver diferente do campo
        "password".''',
        () async {
          await createUserController.createUserEmailPassword(user: userInvalidConfirmPassword);

          expect(createUserController.state is ErrorUserCreation, isTrue);
          final state = createUserController.state as ErrorUserCreation;
          expect(state.confirmPasswordMessage, isNotNull);
        },
      );

      test(
        '''Deve definir o estado como ErrorUserCreation e definir uma mensagem de erro no campo
        "genericMessage" quando não estiver acesso a internet''',
        () async {
          const failureMessage = 'Teste de falha';
          when(mockUserRepository.getByEmail(email: user1.email))
              .thenAnswer((_) async => Either.left(NetworkFailure(failureMessage)));

          await createUserController.createUserEmailPassword(user: user1);

          expect(createUserController.state is ErrorUserCreation, isTrue);
          final state = createUserController.state as ErrorUserCreation;
          expect(state.genericMessage, equals(failureMessage));
        },
      );

      test(
        '''Deve definir o estado como ErrorUserCreation e definir uma mensagem de erro no campo
        "emailMessage" quando o email já existir''',
        () async {
          const failureMessage = 'Teste de falha';
          when(mockUserRepository.getByEmail(email: user1.email)).thenAnswer((_) async => Either.right(user1));
          when(mockUserRepository.update(user: user1)).thenAnswer((_) async => Either.right(unit));
          when(mockAuthRepository.createUserEmailPassword(email: user1.email, password: user1.password))
              .thenAnswer((_) async => Either.left(EmailAlreadyInUseFailure(failureMessage)));

          await createUserController.createUserEmailPassword(user: user1);

          expect(createUserController.state is ErrorUserCreation, isTrue);
          final state = createUserController.state as ErrorUserCreation;
          expect(state.emailMessage, equals(failureMessage));
        },
      );

      test(
        '''Deve definir o estado como UserCreated quando o User for válido''',
        () async {
          const userNotFoundMessage = 'Teste usuário não encontrado';
          when(mockUserRepository.getByEmail(email: user1.email))
              .thenAnswer((_) async => Either.left(UserNotFoundFailure(userNotFoundMessage)));
          when(mockAuthRepository.createUserEmailPassword(email: user1.email, password: user1.password))
              .thenAnswer((_) async => Either.right(unit));
          when(mockUserRepository.insert(user: user1)).thenAnswer((_) async => Either.right(user1.id));
          when(mockAuthRepository.sendEmailVerificationForCurrentUser()).thenAnswer((_) async => Either.right(unit));

          await createUserController.createUserEmailPassword(user: user1);

          expect(createUserController.state is UserCreated, isTrue);
          final state = createUserController.state as UserCreated;
          expect(state.user, equals(user1));
        },
      );
    },
  );
}
