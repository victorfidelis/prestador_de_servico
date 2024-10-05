import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:prestador_de_servico/app/models/user/user.dart';
import 'package:prestador_de_servico/app/repositories/user/user_repository.dart';

@GenerateNiceMocks([MockSpec<UserRepository>()])
import 'user_repository_test.mocks.dart';

void main() {
  final MockUserRepository mockUserRepository = MockUserRepository();

  User user1 = User(
      id: '1',
      isAdmin: false,
      email: 'test@test.com',
      name: 'test',
      surname: 'teste',
      phone: '11912345678');

  setUpAll(() {
    when(
      mockUserRepository.insert(
        user: user1,
      ),
    ).thenAnswer((_) async => '1');

    when(
      mockUserRepository.getByEmail(
        email: 'test@test.com',
      ),
    ).thenAnswer((_) async => user1);

    when(
      mockUserRepository.deleteById(
        id: '1',
      ),
    ).thenAnswer((_) async {});

    when(
      mockUserRepository.update(
        user: user1,
      ),
    ).thenAnswer((_) async => true);
  });

  test(
    '''Ao tentar adicionar um usuário o retorno deve ser true''',
    () async {
      String? id = await mockUserRepository.insert(user: user1);

      expect(id, equals('1'));
    },
  );

  test(
    '''Ao tentar capturar um usuário válido pelo seu email o retorno deve ser uma instância 
    de UserModel do usuário consultado''',
    () async {
      User? user = await mockUserRepository.getByEmail(email: user1.email);

      expect(user, equals(user1));
    },
  );

  test(
    '''Ao tentar capturar um usuário válido pelo seu email retorno deve uma instância 
    de UserModel do usuário consultado''',
    () async {
      User? user = await mockUserRepository.getByEmail(email: user1.email);

      expect(user, equals(user1));
    },
  );

  test(
    '''Ao tentar deletar um usuário válido pelo seu uid a operação deve ser feita sem erros''',
    () async {
      await mockUserRepository.deleteById(id: user1.id);
    },
  );
}
