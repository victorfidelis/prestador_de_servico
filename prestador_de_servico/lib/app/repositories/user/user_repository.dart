import 'package:prestador_de_servico/app/models/user/user.dart';
import 'package:prestador_de_servico/app/repositories/user/firebase_user_repository.dart';

abstract class UserRepository {
  factory UserRepository.create() {
    return FirebaseUserRepository();
  }

  Future<String> insert({required User user});
  Future<User?> getById({required String id});
  Future<User?> getByEmail({required String email});
  Future<void> deleteById({required String id});
  Future<void> update({required User user});
}