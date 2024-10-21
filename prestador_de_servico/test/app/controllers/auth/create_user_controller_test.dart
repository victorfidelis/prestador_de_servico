import 'package:flutter_test/flutter_test.dart';
import 'package:prestador_de_servico/app/controllers/auth/create_user_controller.dart';
import 'package:prestador_de_servico/app/services/auth/auth_service.dart';
import 'package:prestador_de_servico/app/states/auth/create_user_state.dart';

import '../../../helpers/auth/mock_auth_repository.dart';
import '../../../helpers/constants/user_constants.dart';
import '../../../helpers/user/mock_user_repository.dart';

void main() {
  late CreateUserController createUserController;

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
      createUserController = CreateUserController(authService: authService);
    },
  );
  
  test(
    '''Ao tentar criar um usuário sem informar o email o estado deve ser
    um ErrorUserCreation com uma mensagem no campo de email''',
    () async {
      await createUserController.createUserEmailPassword(
          user: userWithoutEmail);

      expect(createUserController.state is ErrorUserCreation, isTrue);
      final state = createUserController.state as ErrorUserCreation;
      expect(state.emailMessage, isNotNull);
    },
  );
  
  test(
    '''Ao tentar criar um usuário sem informar o nome o estado deve ser
    um ErrorUserCreation com uma mensagem no campo de nome''',
    () async {
      await createUserController.createUserEmailPassword(
          user: userWithoutName);

      expect(createUserController.state is ErrorUserCreation, isTrue);
      final state = createUserController.state as ErrorUserCreation;
      expect(state.nameMessage, isNotNull);
    },
  );
  
  test(
    '''Ao tentar criar um usuário sem informar o sobrenome o estado deve ser
    um ErrorUserCreation com uma mensagem no campo de sobrenome''',
    () async {
      await createUserController.createUserEmailPassword(
          user: userWithoutSurname);

      expect(createUserController.state is ErrorUserCreation, isTrue);
      final state = createUserController.state as ErrorUserCreation;
      expect(state.surnameMessage, isNotNull);
    },
  );
  
  test(
    '''Ao tentar criar um usuário sem informar a senha o estado deve ser
    um ErrorUserCreation com uma mensagem no campo de senha''',
    () async {
      await createUserController.createUserEmailPassword(
          user: userWithoutPassword);

      expect(createUserController.state is ErrorUserCreation, isTrue);
      final state = createUserController.state as ErrorUserCreation;
      expect(state.passwordMessage, isNotNull);
    },
  );
  
  test(
    '''Ao tentar criar um usuário sem informar a confirmação de senha o estado deve ser
    um ErrorUserCreation com uma mensagem no campo de confirmação de senha''',
    () async {
      await createUserController.createUserEmailPassword(
          user: userWithoutConfirmPassword);

      expect(createUserController.state is ErrorUserCreation, isTrue);
      final state = createUserController.state as ErrorUserCreation;
      expect(state.confirmPasswordMessage, isNotNull);
    },
  );
  
  test(
    '''Ao tentar criar um usuário informando uma confirmação de senha inválida
    um ErrorUserCreation com uma mensagem no campo de confirmação de senha''',
    () async {
      await createUserController.createUserEmailPassword(
          user: userInvalidConfirmPassword);

      expect(createUserController.state is ErrorUserCreation, isTrue);
      final state = createUserController.state as ErrorUserCreation;
      expect(state.confirmPasswordMessage, isNotNull);
    },
  );

  test(
    '''Ao tentar criar um usuário sem conexão com a internet o estado do controller 
    deve ser um ErrorUserCreation com uma mensagem no campo genérico''',
    () async {
      await createUserController.createUserEmailPassword(
          user: userNoNetworkConection);

      expect(createUserController.state is ErrorUserCreation, isTrue);
      final state = createUserController.state as ErrorUserCreation;
      expect(state.genericMessage, isNotNull);
    },
  );

  test(
    '''Ao tentar criar um usuário com um email que já existe o estado do controller 
    deve ser um ErrorUserCreation com uma mensagem no campo de email''',
    () async {
      await createUserController.createUserEmailPassword(
          user: userEmailAlreadyUse);
          
      expect(createUserController.state is ErrorUserCreation, isTrue);
      final state = createUserController.state as ErrorUserCreation;
      expect(state.emailMessage, isNotNull);
    },
  );

  test(
    '''Ao tentar criar um usuário valido o estado da controller de ser um UserCreated
    com o usuário criado''',
    () async {
      await createUserController.createUserEmailPassword(
          user: userValidToCreate);

      expect(createUserController.state is UserCreated, isTrue);
      final state = createUserController.state as UserCreated;
      expect(state.user, equals(userValidToCreate));
    },
  );
}
