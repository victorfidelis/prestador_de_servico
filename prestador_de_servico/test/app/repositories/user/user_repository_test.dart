import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:prestador_de_servico/app/models/user/user.dart';
import 'package:prestador_de_servico/app/repositories/user/user_repository.dart';
import 'package:prestador_de_servico/app/shared/either/either.dart';

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
    ).thenAnswer((_) async => Either.right('1'));

    when(
      mockUserRepository.getByEmail(
        email: 'test@test.com',
      ),
    ).thenAnswer((_) async => Either.right(user1));

    when(
      mockUserRepository.deleteById(
        id: '1',
      ),
    ).thenAnswer((_) async => Either.right(unit));

    when(
      mockUserRepository.update(
        user: user1,
      ),
    ).thenAnswer((_) async => Either.right(unit));
  });
}
