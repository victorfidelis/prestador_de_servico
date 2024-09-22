import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:prestador_de_servico/app/models/user/user_model.dart';
import 'package:prestador_de_servico/app/services/auth/auth_service.dart';
import 'package:prestador_de_servico/app/states/create_account/create_accout_state.dart';
import 'package:prestador_de_servico/app/states/login/login_state.dart';

@GenerateNiceMocks([MockSpec<AuthService>()])
import 'auth_service_test.mocks.dart';

void main() {
  final mockAuthService = MockAuthService();

  final UserModel user = UserModel(
    uid: '1',
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
          when(mockAuthService.createAccountWithEmailAndPassword(
            name: argThat(isEmpty, named: 'name'),
            surname: anyNamed('surname'),
            phone: anyNamed('phone'),
            email: anyNamed('email'),
            password: anyNamed('password'),
            confirmPassword: anyNamed('confirmPassword'),
          )).thenAnswer((_) async =>
              ErrorInCreation(nameMessage: 'Necessário informar o nome'));

          when(mockAuthService.createAccountWithEmailAndPassword(
            name: argThat(isNotEmpty, named: 'name'),
            surname: argThat(isEmpty, named: 'surname'),
            phone: anyNamed('phone'),
            email: anyNamed('email'),
            password: anyNamed('password'),
            confirmPassword: anyNamed('confirmPassword'),
          )).thenAnswer((_) async =>
              ErrorInCreation(surnameMessage: 'Necessário informar o sobrenome'));

          when(mockAuthService.createAccountWithEmailAndPassword(
            name: argThat(isNotEmpty, named: 'name'),
            surname: argThat(isNotEmpty, named: 'surname'),
            phone: anyNamed('phone'),
            email: argThat(isEmpty, named: 'email'),
            password: anyNamed('password'),
            confirmPassword: anyNamed('confirmPassword'),
          )).thenAnswer((_) async =>
              ErrorInCreation(emailMessage: 'Necessário informar o email'));

          when(mockAuthService.createAccountWithEmailAndPassword(
            name: argThat(isNotEmpty, named: 'name'),
            surname: argThat(isNotEmpty, named: 'surname'),
            phone: anyNamed('phone'),
            email: argThat(isNotEmpty, named: 'email'),
            password: argThat(isEmpty, named: 'password'),
            confirmPassword: anyNamed('confirmPassword'),
          )).thenAnswer((_) async =>
              ErrorInCreation(passwordMessage: 'Necessário informar a senha'));

          when(mockAuthService.createAccountWithEmailAndPassword(
            name: argThat(isNotEmpty, named: 'name'),
            surname: argThat(isNotEmpty, named: 'surname'),
            phone: anyNamed('phone'),
            email: argThat(isNotEmpty, named: 'email'),
            password: argThat(isNotEmpty, named: 'password'),
            confirmPassword: argThat(isEmpty, named: 'confirmPassword'),
          )).thenAnswer((_) async => ErrorInCreation(
              confirmPasswordMessage: 'Necessário informar a confirmação da senha'));

          when(mockAuthService.createAccountWithEmailAndPassword(
            name: argThat(isNotEmpty, named: 'name'),
            surname: argThat(isNotEmpty, named: 'surname'),
            phone: anyNamed('phone'),
            email: 'test@test.com',
            password: argThat(isNotEmpty, named: 'password'),
            confirmPassword: argThat(isNotEmpty, named: 'confirmPassword'),
          )).thenAnswer(
              (_) async => ErrorInCreation(emailMessage: 'Email já cadastrado'));

          when(mockAuthService.createAccountWithEmailAndPassword(
            name: argThat(isNotEmpty, named: 'name'),
            surname: argThat(isNotEmpty, named: 'surname'),
            phone: anyNamed('phone'),
            email: argThat(isNot('test@test.com'), named: 'email'),
            password: argThat(isNotEmpty, named: 'password'),
            confirmPassword: argThat(isNotEmpty, named: 'confirmPassword'),
          )).thenAnswer((_) async => AccountCreated(user: user));
        },
      );

      test(
        '''Ao tentar criar uma conta através de um email que já existe um estado de erro 
          será retornando junto a uma mensagem específca''',
        () async {
          CreateAccountState createAccountState =
              await mockAuthService.createAccountWithEmailAndPassword(
            name: 'test',
            surname: 'test',
            phone: '11923456789',
            email: 'test@test.com',
            password: '123456',
            confirmPassword: '123465',
          );

          expect(createAccountState.runtimeType, equals(ErrorInCreation));
          if (createAccountState is ErrorInCreation) {
            expect(createAccountState.emailMessage, 'Email já cadastrado');
          }
        },
      );

      test(
        '''Ao tentar criar uma conta através de um email que não existe um estado de 
        sucesso será retornado''',
        () async {
          CreateAccountState createAccountState =
              await mockAuthService.createAccountWithEmailAndPassword(
            name: 'test',
            surname: 'test',
            phone: '11923456789',
            email: 'test2@test2.com',
            password: '123456',
            confirmPassword: '123465',
          );
          
          expect(createAccountState.runtimeType, AccountCreated);
        },
      );
    },
  );
}
