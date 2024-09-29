import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:prestador_de_servico/app/controllers/auth/login_controller.dart';
import 'package:prestador_de_servico/app/models/user/user_model.dart';
import 'package:prestador_de_servico/app/states/login/login_state.dart';
import '../../services/auth/auth_service_test.mocks.dart';

void main() {

  final mockAuthService = MockAuthService();
  final LoginController loginController = LoginController(authService: mockAuthService);

  final UserModel validUser = UserModel(
    id: '',
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
        email: argThat(isEmpty, named: 'email'),
        password: anyNamed('password'),
      )).thenAnswer((_) async => LoginError(emailMessage: 'Necessário informar o email'));
      
      when(mockAuthService.loginWithEmailAndPassword(
        email: argThat(isNotEmpty, named: 'email'),
        password: argThat(isEmpty, named: 'password'),
      )).thenAnswer((_) async => LoginError(passwordMessage: 'Necessário informar a senha'));
      
      when(mockAuthService.loginWithEmailAndPassword(
        email: argThat(isNot('test@test.com'), named: 'email'),
        password: argThat(isNotEmpty, named: 'password'),
      )).thenAnswer((_) async => LoginError(genericMessage: 'Credenciais de usuário inválidas'));
      
      when(mockAuthService.loginWithEmailAndPassword(
        email: 'test@test.com',
        password: argThat(isNot('123456'), named: 'password'),
      )).thenAnswer((_) async => LoginError(genericMessage: 'Credenciais de usuário inválidas'));
      
      when(mockAuthService.loginWithEmailAndPassword(
        email: 'test@test.com',
        password: '123456',
      )).thenAnswer((_) async => LoginSuccess(user: validUser));
    },
  );
  
  test(
    '''Ao tentar criar uma conta sem informar um email um estado de erro 
    será retornando junto a uma mensagem específca''',
    () async {
      await loginController.loginWithEmailPasswordSent(
        email: '',
        password: '',
      );

      expect(loginController.state.runtimeType, LoginError);
      if (loginController.state is LoginError) {
        expect(
          (loginController.state as LoginError).emailMessage,
          equals('Necessário informar o email'),
        );
      }
    },
  );

  test(
    '''Ao tentar criar uma conta sem informar a senha um estado de erro 
    será retornando junto a uma mensagem específca''',
    () async {
      await loginController.loginWithEmailPasswordSent(
        email: 'teste@test.com',
        password: '',
      );

      expect(loginController.state.runtimeType, LoginError);
      if (loginController.state is LoginError) {
        expect(
          (loginController.state as LoginError).passwordMessage,
          equals('Necessário informar a senha'),
        );
      }
    },
  );

  test(
      '''Ao efetuar o login com um email que não existe o estado de erro deve 
    ser retornado junto a uma mensagem específica''', () async {
    await loginController.loginWithEmailPasswordSent(
      email: 'test2@test2.com',
      password: '123456',
    );

    expect(loginController.state.runtimeType, equals(LoginError));
    if (loginController.state is LoginError) {
      expect((loginController.state as LoginError).genericMessage, equals('Credenciais de usuário inválidas'));
    }
  }); 

  test(
      '''Ao efetuar o login com uma senha inválida o estado de erro deve 
    ser retornado junto a uma mensagem específica''', () async {
    await loginController.loginWithEmailPasswordSent(
      email: 'test@test.com',
      password: 'incorreta',
    );

    expect(loginController.state.runtimeType, equals(LoginError));
    if (loginController.state is LoginError) {
      expect((loginController.state as LoginError).genericMessage, equals('Credenciais de usuário inválidas'));
    }
  }); 

  test(
      '''Ao efetuar o login com uma crendencial válida o estado de sucesso deve 
    ser retornado junto ao usuário válido''', () async {
    await loginController.loginWithEmailPasswordSent(
      email: 'test@test.com',
      password: '123456',
    );

    expect(loginController.state.runtimeType, equals(LoginSuccess));
    if (loginController.state is LoginSuccess) {
      expect((loginController.state as LoginSuccess).user, equals(validUser));
    }
  }); 

}