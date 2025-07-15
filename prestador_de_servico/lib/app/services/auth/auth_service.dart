import 'package:prestador_de_servico/app/models/user/user.dart';
import 'package:prestador_de_servico/app/repositories/auth/auth_repository.dart';
import 'package:prestador_de_servico/app/repositories/user/user_repository.dart';
import 'package:prestador_de_servico/app/shared/utils/either/either.dart';
import 'package:prestador_de_servico/app/shared/utils/either/either_extensions.dart';
import 'package:prestador_de_servico/app/shared/utils/failure.dart';

class AuthService {
  final AuthRepository authRepository;
  final UserRepository userRepository;

  AuthService({
    required this.authRepository,
    required this.userRepository,
  });

  Future<Either<Failure, User>> signInEmailPasswordAndVerifyEmail({
    required String email,
    required String password,
  }) async {
    final getByEmailEither = await userRepository.getByEmail(email: email);
    if (getByEmailEither.isLeft) {
      return Either.left(getByEmailEither.left);
    }

    final signInEither = await authRepository.signInEmailPassword(
        email: email, password: password);

    if (signInEither.isLeft) {
      if (signInEither.left is EmailNotVerifiedFailure) {
        final sendEmailVerificationEither = await _sendEmailVerification();
        return sendEmailVerificationEither.fold(
          (error) => Either.left(error),
          (_) => Either.left(
            EmailNotVerifiedFailure(
                'Email ainda não verificado. Faça a verificação através do link enviado ao seu email.'),
          ),
        );
      }
      return Either.left(signInEither.left);
    }

    final User user = (getByEmailEither.right as User);
    return Either.right(user);
  }

  Future<Either<Failure, Unit>> _sendEmailVerification() async {
    final sendEmailEither =
        await authRepository.sendEmailVerificationForCurrentUser();

    if (sendEmailEither.isLeft) {
      return Either.left(sendEmailEither.left);
    }

    return Either.right(unit);
  }

  Future<Either<Failure, Unit>> createUserEmailPassword({
    required User user, 
    required String password,
  }) async {
    final saveUserEither = await _saveUserData(user: user);
    if (saveUserEither.isLeft) {
      return Either.left(saveUserEither.left);
    }

    final createUserEither = await authRepository.createUserEmailPassword(
      email: user.email,
      password: password,
    );
    if (createUserEither.isLeft) {
      return Either.left(createUserEither.left);
    }

    final sendEmailEither = await _sendEmailVerification();
    if (sendEmailEither.isLeft) {
      return Either.left(sendEmailEither.left);
    }

    return Either.right(unit);
  }

  Future<Either<Failure, Unit>> _saveUserData({required User user}) async {
    final getByEmailEither = await userRepository.getByEmail(email: user.email);

    if (getByEmailEither.left is UserNotFoundFailure) {
      final createUserEither = await userRepository.insert(user: user);
      if (createUserEither.isLeft) {
        return Either.left(createUserEither.left);
      }
      return Either.right(unit);
    }

    if (getByEmailEither.isLeft) {
      return Either.left(getByEmailEither.left);
    }

    // Capturando o id para realizar o update do registro correto
    user = user.copyWith(id: getByEmailEither.right!.id);
    final updateUserEither = await userRepository.update(user: user);
    if (updateUserEither.isLeft) {
      return Either.left(updateUserEither.left);
    }
    return Either.right(unit);
  }

  Future<Either<Failure, Unit>> sendPasswordResetEmail(
      {required String email}) async {

    final passwordResetEither = await authRepository.sendPasswordResetEmail(email: email);
    if (passwordResetEither.isLeft) {
      return Either.left(passwordResetEither.left);
    }

    return Either.right(unit);
  }
}
