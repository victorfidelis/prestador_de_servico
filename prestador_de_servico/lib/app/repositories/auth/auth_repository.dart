import 'package:prestador_de_servico/app/repositories/auth/firebase_auth_repository.dart';
import 'package:prestador_de_servico/app/shared/utils/either/either.dart';
import 'package:prestador_de_servico/app/shared/utils/failure.dart';

abstract class AuthRepository {

  factory AuthRepository.create() {
    return FirebaseAuthRepository();
  }

  Future<Either<Failure, Unit>> signInEmailPassword({
    required String email,
    required String password,
  });

  Future<Either<Failure, Unit>> sendEmailVerificationForCurrentUser();

  Future<Either<Failure, Unit>> createUserEmailPassword({
    required String email,
    required String password,
  });

  Future<Either<Failure, Unit>> sendPasswordResetEmail({
    required String email,
  });
}
