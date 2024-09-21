import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:prestador_de_servico/app/models/user/user_model.dart';
import 'package:prestador_de_servico/app/services/auth/auth_service.dart';
import 'package:prestador_de_servico/app/states/login/login_state.dart';

@GenerateNiceMocks([MockSpec<AuthService>()])
import 'auth_service_test.mocks.dart';

void main() {
  final mockAuthService = MockAuthService();

  final UserModel validUser = UserModel(
    uid: '1',
    email: 'test@test.com',
    name: 'Test',
    surname: 'valid',
    phone: '11912345678',
  );

  final UserModel invalidUser = UserModel(
    uid: '2',
    email: 'test2@test2.com',
    name: 'Test2',
    surname: 'valid2',
    phone: '11912345678',
  );

  test(
    '''Definição de comportamentos (stubbing)''',
    () async {
      when(mockAuthService.doLoginWithEmailPassword(
        email: 'test@test.com',
        password: '123456',
      )).thenAnswer((_) async => LoginSuccess(user: validUser));
      
      when(mockAuthService.doLoginWithEmailPassword(
        email: argThat(isNot('test@test.com'), named: 'email'),
        password: anyNamed('password'),
      )).thenAnswer((_) async => LoginError(genericMessage: 'Credenciais de usuário inválidas'));
      
      when(mockAuthService.doLoginWithEmailPassword(
        email: 'test@test.com',
        password: argThat(isNot('123456'), named: 'password'),
      )).thenAnswer((_) async => LoginError(genericMessage: 'Credenciais de usuário inválidas'));
    },
  );

  test(
      '''Ao efetuar o login com uma crendencial válida o estado de sucesso deve 
    ser retornado junto ao usuário válido''', () async {
    LoginState loginState = await mockAuthService.doLoginWithEmailPassword(
      email: 'test@test.com',
      password: '123456',
    );

    expect(loginState.runtimeType, equals(LoginSuccess));
    if (loginState is LoginSuccess) {
      expect(loginState.user, equals(validUser));
    }
  }); 

  test(
      '''Ao efetuar o login com um email que não existe o estado de erro deve 
    ser retornado junto a uma mensagem específica''', () async {
    LoginState loginState = await mockAuthService.doLoginWithEmailPassword(
      email: 'test2@test2.com',
      password: '123456',
    );

    expect(loginState.runtimeType, equals(LoginError));
    if (loginState is LoginError) {
      expect(loginState.genericMessage, equals('Credenciais de usuário inválidas'));
    }
  }); 

  test(
      '''Ao efetuar o login com uma senha inválida o estado de erro deve 
    ser retornado junto a uma mensagem específica''', () async {
    LoginState loginState = await mockAuthService.doLoginWithEmailPassword(
      email: 'test@test.com',
      password: '1234565',
    );

    expect(loginState.runtimeType, equals(LoginError));
    if (loginState is LoginError) {
      expect(loginState.genericMessage, equals('Credenciais de usuário inválidas'));
    }
  }); 


}
