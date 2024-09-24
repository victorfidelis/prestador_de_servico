import 'package:prestador_de_servico/app/models/user/user_model.dart';
import 'package:prestador_de_servico/app/repositories/user/firebase_user_repository.dart';

abstract class UserRepository {
  factory UserRepository.create() {
    return FirebaseUserRepository();
  }

  Future<String?> add({required UserModel user});
  Future<UserModel?> getById({required String id});
  Future<UserModel?> getByEmail({required String email});
  Future<bool> deleteById({required String id});
  Future<bool> update({required UserModel user});
}