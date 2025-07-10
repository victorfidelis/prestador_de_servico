import 'package:prestador_de_servico/app/models/user/user.dart';
import 'package:prestador_de_servico/app/repositories/user/firebase_user_repository.dart';
import 'package:prestador_de_servico/app/shared/utils/either/either.dart';
import 'package:prestador_de_servico/app/shared/utils/failure/failure.dart';

abstract class UserRepository {
  factory UserRepository.create() {
    return FirebaseUserRepository();
  }

  Future<Either<Failure, String>> insert({required User user});
  Future<Either<Failure, User>> getById({required String id});
  Future<Either<Failure, User>> getByEmail({required String email});
  Future<Either<Failure, Unit>> deleteById({required String id});
  Future<Either<Failure, Unit>> update({required User user}); 
  Future<Either<Failure, List<User>>> getClients();
}