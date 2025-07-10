import 'package:prestador_de_servico/app/models/user/user.dart';
import 'package:prestador_de_servico/app/repositories/user/user_repository.dart';
import 'package:prestador_de_servico/app/shared/utils/either/either.dart';
import 'package:prestador_de_servico/app/shared/utils/failure/failure.dart';

class ClientService {
  final UserRepository userRepository; 

  ClientService({required this.userRepository});

  Future<Either<Failure, List<User>>> getClients() async {
    return userRepository.getClients();
  }
}