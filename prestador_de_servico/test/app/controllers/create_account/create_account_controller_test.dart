import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:prestador_de_servico/app/controllers/create_account/create_account_controller.dart';
import 'package:prestador_de_servico/app/models/user/user_model.dart';
import 'package:prestador_de_servico/app/states/create_account/create_accout_state.dart';
import '../../services/auth/auth_service_test.mocks.dart';

void main() {

  final UserModel user = UserModel(
    uid: '1',
    email: 'test@test.com',
    name: 'Test',
    surname: 'valid',
    phone: '11912345678',
  );

  late MockAuthService mockAuthService;
  late CreateAccountController createAccountController;
  setUpAll(() {
    mockAuthService = MockAuthService();
    createAccountController = CreateAccountController(
      authService: mockAuthService,
    );
  });

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
    '''Ao tentar criar uma conta sem informar o nome um estado de erro 
    será retornando junto a uma mensagem específca''',
    () async {
      await createAccountController.createAccountWithEmailAndPassword(
        name: '',
        surname: '',
        phone: '',
        email: '',
        password: '',
        confirmPassword: '',
      );

      expect(createAccountController.state.runtimeType, ErrorInCreation);
      if (createAccountController.state is ErrorInCreation) {
        expect(
          (createAccountController.state as ErrorInCreation).nameMessage,
          equals('Necessário informar o nome'),
        );
      }
    },
  );

  test(
    '''Ao tentar criar uma conta sem informar o sobrenome um estado de erro 
    será retornando junto a uma mensagem específca''',
    () async {
      await createAccountController.createAccountWithEmailAndPassword(
        name: 'test',
        surname: '',
        phone: '',
        email: '',
        password: '',
        confirmPassword: '',
      );

      expect(createAccountController.state.runtimeType, ErrorInCreation);
      if (createAccountController.state is ErrorInCreation) {
        expect(
          (createAccountController.state as ErrorInCreation).surnameMessage,
          equals('Necessário informar o sobrenome'),
        );
      }
    },
  );

  test(
    '''Ao tentar criar uma conta sem informar o email um estado de erro 
    será retornando junto a uma mensagem específca''',
    () async {
      await createAccountController.createAccountWithEmailAndPassword(
        name: 'test',
        surname: 'teste',
        phone: '',
        email: '',
        password: '',
        confirmPassword: '',
      );

      expect(createAccountController.state.runtimeType, ErrorInCreation);
      if (createAccountController.state is ErrorInCreation) {
        expect(
          (createAccountController.state as ErrorInCreation).emailMessage,
          equals('Necessário informar o email'),
        );
      }
    },
  );

  test(
    '''Ao tentar criar uma conta sem informar a senha um estado de erro 
    será retornando junto a uma mensagem específca''',
    () async {
      await createAccountController.createAccountWithEmailAndPassword(
        name: 'test',
        surname: 'teste',
        phone: '',
        email: 'test@test.com',
        password: '',
        confirmPassword: '',
      );

      expect(createAccountController.state.runtimeType, ErrorInCreation);
      if (createAccountController.state is ErrorInCreation) {
        expect(
          (createAccountController.state as ErrorInCreation).passwordMessage,
          equals('Necessário informar a senha'),
        );
      }
    },
  );

  test(
    '''Ao tentar criar uma conta sem informar a confirmação de senha um estado de erro 
    será retornando junto a uma mensagem específca''',
    () async {
      await createAccountController.createAccountWithEmailAndPassword(
        name: 'test',
        surname: 'teste',
        phone: '',
        email: 'test@test.com',
        password: '123456',
        confirmPassword: '',
      );

      expect(createAccountController.state.runtimeType, ErrorInCreation);
      if (createAccountController.state is ErrorInCreation) {
        expect(
          (createAccountController.state as ErrorInCreation).confirmPasswordMessage,
          equals('Necessário informar a confirmação da senha'),
        );
      }
    },
  );

  test(
    '''Ao tentar criar uma conta através de um email que já existe um estado de erro 
    será retornando junto a uma mensagem específca''',
    () async {
      await createAccountController.createAccountWithEmailAndPassword(
        name: 'test',
        surname: 'test',
        phone: '11923456789',
        email: 'test@test.com',
        password: '123456',
        confirmPassword: '123465',
      );

      expect(createAccountController.state.runtimeType, ErrorInCreation);
      if (createAccountController.state is ErrorInCreation) {
        expect(
          (createAccountController.state as ErrorInCreation).emailMessage,
          equals('Email já cadastrado'),
        );
      }
    },
  );

  test(
    '''Ao tentar criar uma conta através de um email que não existe um estado de 
        sucesso será retornado''',
    () async {
      await createAccountController.createAccountWithEmailAndPassword(
        name: 'test',
        surname: 'test',
        phone: '11923456789',
        email: 'test2@test2.com',
        password: '123456',
        confirmPassword: '123465',
      );

      expect(createAccountController.state.runtimeType, AccountCreated);
    },
  );
}
