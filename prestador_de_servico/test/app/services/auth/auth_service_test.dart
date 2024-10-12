import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:prestador_de_servico/app/models/user/user.dart';
import 'package:prestador_de_servico/app/repositories/auth/auth_repository.dart';
import 'package:prestador_de_servico/app/repositories/user/user_repository.dart';
import 'package:prestador_de_servico/app/services/auth/auth_service.dart';
import 'package:prestador_de_servico/app/shared/either/either.dart';
import 'package:prestador_de_servico/app/shared/either/either_extension.dart';
import 'package:prestador_de_servico/app/shared/failure/failure.dart';
import 'auth_service_test.mocks.dart';

@GenerateNiceMocks([MockSpec<AuthRepository>()])
@GenerateNiceMocks([MockSpec<UserRepository>()])

void main() {
  late AuthService authService;
  final mockAuthRepository = MockAuthRepository();
  final mockUserRepository = MockUserRepository();

  final userNoNetworkConection = User(
    id: '1',
    isAdmin: true,
    email: 'userNoNetworkConection@test.com',
    name: 'userNoNetworkConection',
    surname: 'test',
    phone: '11912345678',
    password: '123456',
    confirmPassword: '123456',
  );

  final userEmailAlreadyUse = User(
    id: '2',
    isAdmin: true,
    email: 'userEmailAlreadyUse@test.com',
    name: 'userEmailAlreadyUse',
    surname: 'test',
    phone: '11912345678',
    password: '123456',
    confirmPassword: '123456',
  );

  final validUserToCreate = User(
    id: '3',
    isAdmin: true,
    email: 'validUserToCreate@test.com',
    name: 'validUserToCreate',
    surname: 'test',
    phone: '11912345678',
    password: '123456',
    confirmPassword: '123456',
  );

  setUpAll(
    () {
      authService = AuthService(
        authRepository: mockAuthRepository,
        userRepository: mockUserRepository,
      );

      when(mockAuthRepository.createUserEmailPassword(
        email: userNoNetworkConection.email,
        password: userNoNetworkConection.password,
      )).thenAnswer((_) async =>
          Either.left(NetworkFailure('Sem conexão com a interner')));

      when(mockAuthRepository.createUserEmailPassword(
        email: userEmailAlreadyUse.email,
        password: userEmailAlreadyUse.password,
      )).thenAnswer((_) async =>
          Either.left(EmailAlreadyInUseFailure('Email já cadastrado')));

      when(mockAuthRepository.createUserEmailPassword(
        email: validUserToCreate.email,
        password: validUserToCreate.password,
      )).thenAnswer((_) async => Either.right(unit));

      when(mockUserRepository.getByEmail(email: userNoNetworkConection.email))
          .thenAnswer((_) async =>
              Either.left(NetworkFailure('Sem conexão com a internet')));

      when(mockUserRepository.getByEmail(email: userEmailAlreadyUse.email))
          .thenAnswer((_) async => Either.right(userEmailAlreadyUse));

      when(mockUserRepository.getByEmail(email: validUserToCreate.email))
          .thenAnswer((_) async => Either.right(validUserToCreate));

      when(mockUserRepository.update(user: anyNamed("user")))
          .thenAnswer((_) async => Either.right(unit));

      when(mockAuthRepository.sendEmailVerificationForCurrentUser())
          .thenAnswer((_) async => Either.right(unit));
    },
  );

  group(
    'Testes referentes a criação de conta',
    () {
      test(
        '''Ao tentar criar um usuário sem conexão com a internet um 
      NetworkFailure deve ser retorndo no left do Either''',
        () async {
          final createUserEither = await authService.createUserEmailPassword(
              user: userNoNetworkConection);
          expect(createUserEither.isLeft, isTrue);
          expect(createUserEither.left is NetworkFailure, isTrue);
        },
      );

      test(
        '''Ao tentar criar um usuário com um email já cadastrado um
      EmailAlreadyInUseFailure deve ser retorndo no left do Either''',
        () async {
          final createUserEither = await authService.createUserEmailPassword(
              user: userEmailAlreadyUse);
          expect(createUserEither.isLeft, isTrue);
          expect(createUserEither.left is EmailAlreadyInUseFailure, isTrue);
        },
      );

      test(
        '''Ao tentar criar um usuário valido um right vazio deve ser retornado no Either''',
        () async {
          final createUserEither = await authService.createUserEmailPassword(
              user: validUserToCreate);
          expect(createUserEither.isRight, isTrue);
          expect(createUserEither.right is Unit, isTrue);
        },
      );
    },
  );
}
