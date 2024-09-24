import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:prestador_de_servico/app/models/user/user_model.dart';
import 'package:prestador_de_servico/app/services/auth/auth_service.dart';
import 'package:prestador_de_servico/app/states/create_user/create_user_state.dart';
import 'package:prestador_de_servico/app/states/login/login_state.dart';

@GenerateNiceMocks([MockSpec<AuthService>()])
import 'auth_service_test.mocks.dart';

void main() {
  final mockAuthService = MockAuthService();

  final UserModel user = UserModel(
    id: '1',
    isAdmin: false,
    email: 'test@test.com',
    name: 'Test',
    surname: 'valid',
    phone: '11912345678',
  );

  test(
    '''Definição de comportamentos (stubbing)''',
    () {
      when(mockAuthService.loginWithEmailAndPassword(
        email: 'test@test.com',
        password: '123456',
      )).thenAnswer((_) async => LoginSuccess(user: user));

      when(mockAuthService.loginWithEmailAndPassword(
        email: argThat(isNot('test@test.com'), named: 'email'),
        password: anyNamed('password'),
      )).thenAnswer((_) async =>
          LoginError(genericMessage: 'Credenciais de usuário inválidas'));

      when(mockAuthService.loginWithEmailAndPassword(
        email: 'test@test.com',
        password: argThat(isNot('123456'), named: 'password'),
      )).thenAnswer((_) async =>
          LoginError(genericMessage: 'Credenciais de usuário inválidas'));
    },
  );

  group('Login', () {
    test(
        '''Ao efetuar o login com uma crendencial válida o estado de sucesso deve 
    ser retornado junto ao usuário válido''', () async {
      LoginState loginState = await mockAuthService.loginWithEmailAndPassword(
        email: 'test@test.com',
        password: '123456',
      );

      expect(loginState.runtimeType, equals(LoginSuccess));
      if (loginState is LoginSuccess) {
        expect(loginState.user, equals(user));
      }
    });

    test(
        '''Ao efetuar o login com um email que não existe o estado de erro deve 
    ser retornado junto a uma mensagem específica''', () async {
      LoginState loginState = await mockAuthService.loginWithEmailAndPassword(
        email: 'test2@test2.com',
        password: '123456',
      );

      expect(loginState.runtimeType, equals(LoginError));
      if (loginState is LoginError) {
        expect(loginState.genericMessage,
            equals('Credenciais de usuário inválidas'));
      }
    });

    test('''Ao efetuar o login com uma senha inválida o estado de erro deve 
    ser retornado junto a uma mensagem específica''', () async {
      LoginState loginState = await mockAuthService.loginWithEmailAndPassword(
        email: 'test@test.com',
        password: 'incorreta',
      );

      expect(loginState.runtimeType, equals(LoginError));
      if (loginState is LoginError) {
        expect(loginState.genericMessage,
            equals('Credenciais de usuário inválidas'));
      }
    });
  });

  group(
    'Criação de conta',
    () {
      test(
        '''Definição de comportamentos (stubbing)''',
        () {
          when(mockAuthService.createUserWithEmailAndPassword(
            name: argThat(isEmpty, named: 'name'),
            surname: anyNamed('surname'),
            phone: anyNamed('phone'),
            email: anyNamed('email'),
            password: anyNamed('password'),
            confirmPassword: anyNamed('confirmPassword'),
          )).thenAnswer((_) async =>
              ErrorCreatingUser(nameMessage: 'Necessário informar o nome'));

          when(mockAuthService.createUserWithEmailAndPassword(
            name: argThat(isNotEmpty, named: 'name'),
            surname: argThat(isEmpty, named: 'surname'),
            phone: anyNamed('phone'),
            email: anyNamed('email'),
            password: anyNamed('password'),
            confirmPassword: anyNamed('confirmPassword'),
          )).thenAnswer((_) async =>
              ErrorCreatingUser(surnameMessage: 'Necessário informar o sobrenome'));

          when(mockAuthService.createUserWithEmailAndPassword(
            name: argThat(isNotEmpty, named: 'name'),
            surname: argThat(isNotEmpty, named: 'surname'),
            phone: anyNamed('phone'),
            email: argThat(isEmpty, named: 'email'),
            password: anyNamed('password'),
            confirmPassword: anyNamed('confirmPassword'),
          )).thenAnswer((_) async =>
              ErrorCreatingUser(emailMessage: 'Necessário informar o email'));

          when(mockAuthService.createUserWithEmailAndPassword(
            name: argThat(isNotEmpty, named: 'name'),
            surname: argThat(isNotEmpty, named: 'surname'),
            phone: anyNamed('phone'),
            email: argThat(isNotEmpty, named: 'email'),
            password: argThat(isEmpty, named: 'password'),
            confirmPassword: anyNamed('confirmPassword'),
          )).thenAnswer((_) async =>
              ErrorCreatingUser(passwordMessage: 'Necessário informar a senha'));

          when(mockAuthService.createUserWithEmailAndPassword(
            name: argThat(isNotEmpty, named: 'name'),
            surname: argThat(isNotEmpty, named: 'surname'),
            phone: anyNamed('phone'),
            email: argThat(isNotEmpty, named: 'email'),
            password: argThat(isNotEmpty, named: 'password'),
            confirmPassword: argThat(isEmpty, named: 'confirmPassword'),
          )).thenAnswer((_) async => ErrorCreatingUser(
              confirmPasswordMessage: 'Necessário informar a confirmação da senha'));

          when(mockAuthService.createUserWithEmailAndPassword(
            name: argThat(isNotEmpty, named: 'name'),
            surname: argThat(isNotEmpty, named: 'surname'),
            phone: anyNamed('phone'),
            email: 'test@test.com',
            password: argThat(isNotEmpty, named: 'password'),
            confirmPassword: argThat(isNotEmpty, named: 'confirmPassword'),
          )).thenAnswer(
              (_) async => ErrorCreatingUser(emailMessage: 'Email já cadastrado'));

          when(mockAuthService.createUserWithEmailAndPassword(
            name: argThat(isNotEmpty, named: 'name'),
            surname: argThat(isNotEmpty, named: 'surname'),
            phone: anyNamed('phone'),
            email: argThat(isNot('test@test.com'), named: 'email'),
            password: argThat(isNotEmpty, named: 'password'),
            confirmPassword: argThat(isNotEmpty, named: 'confirmPassword'),
          )).thenAnswer((_) async => UserCreated(user: user));
        },
      );

      test(
        '''Ao tentar criar uma conta através de um email que já existe um estado de erro 
          será retornando junto a uma mensagem específca''',
        () async {
          CreateUserState createAccountState =
              await mockAuthService.createUserWithEmailAndPassword(
            name: 'test',
            surname: 'test',
            phone: '11923456789',
            email: 'test@test.com',
            password: '123456',
            confirmPassword: '123465',
          );

          expect(createAccountState.runtimeType, equals(ErrorCreatingUser));
          if (createAccountState is ErrorCreatingUser) {
            expect(createAccountState.emailMessage, 'Email já cadastrado');
          }
        },
      );

      test(
        '''Ao tentar criar uma conta através de um email que não existe um estado de 
        sucesso será retornado''',
        () async {
          CreateUserState createAccountState =
              await mockAuthService.createUserWithEmailAndPassword(
            name: 'test',
            surname: 'test',
            phone: '11923456789',
            email: 'test2@test2.com',
            password: '123456',
            confirmPassword: '123465',
          );
          
          expect(createAccountState.runtimeType, UserCreated);
        },
      );
    },
  );
}
