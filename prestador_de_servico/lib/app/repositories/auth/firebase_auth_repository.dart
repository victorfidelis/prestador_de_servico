import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:prestador_de_servico/app/repositories/auth/auth_repository.dart';
import 'package:prestador_de_servico/app/repositories/config/firebase_initializer.dart';
import 'package:prestador_de_servico/app/shared/utils/either/either.dart';
import 'package:prestador_de_servico/app/shared/utils/either/either_extensions.dart';
import 'package:prestador_de_servico/app/shared/utils/failure.dart';

class FirebaseAuthRepository implements AuthRepository {
  final _firebaseInitializer = FirebaseInitializer();

  @override
  Future<Either<Failure, Unit>> signInEmailPassword({
    required String email,
    required String password,
  }) async {
    final initializeEither = await _firebaseInitializer.initialize();
    if (initializeEither.isLeft) {
      return Either.left(initializeEither.left);
    }

    try {
      final fb_auth.FirebaseAuth firebaseAuth = fb_auth.FirebaseAuth.instance;
      final userCredential = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final firbaseUser = userCredential.user!;

      if (!firbaseUser.emailVerified) {
        return Either.left(EmailNotVerifiedFailure(
            'Email ainda não verificado. Faça a verificação através do link enviado ao seu email.'));
      } else {
        return Either.right(unit);
      }
    } on fb_auth.FirebaseAuthException catch (e) {
      if (e.code == 'network-request-failed') {
        return Either.left(NetworkFailure('Sem conexão com a internet'));
      } else if (e.code == 'invalid-credential') {
        return Either.left(
            InvalidCredentialFailure('Credenciais de usuário inválidas'));
      } else if (e.code == 'too-many-requests') {
        return Either.left(TooManyRequestsFailure(
            'Bloqueio temporário. Muitas tentativas incorretas'));
      } else {
        return Either.left(Failure('Firestore error: ${e.message}'));
      }
    }
  }

  @override
  Future<Either<Failure, Unit>> sendEmailVerificationForCurrentUser() async {
    final initializeEither = await _firebaseInitializer.initialize();
    if (initializeEither.isLeft) {
      return Either.left(initializeEither.left);
    }

    try {
      final fb_auth.FirebaseAuth firebaseAuth = fb_auth.FirebaseAuth.instance;
      await firebaseAuth.currentUser!.sendEmailVerification();
      return Either.right(unit);
    } on fb_auth.FirebaseAuthException catch (e) {
      if (e.code == 'network-request-failed') {
        return Either.left(NetworkFailure('Sem conexão com a internet'));
      } else {
        return Either.left(Failure('Firestore error: ${e.message}'));
      }
    }
  }

  @override
  Future<Either<Failure, Unit>> createUserEmailPassword({
    required String email,
    required String password,
  }) async {
    final initializeEither = await _firebaseInitializer.initialize();
    if (initializeEither.isLeft) {
      return Either.left(initializeEither.left);
    }

    try {
      final fb_auth.FirebaseAuth firebaseAuth = fb_auth.FirebaseAuth.instance;
      await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return Either.right(unit);
    } on fb_auth.FirebaseAuthException catch (e) {
      if (e.code == 'network-request-failed') {
        return Either.left(NetworkFailure('Sem conexão com a internet'));
      } else if (e.code == 'email-already-in-use') {
        return Either.left(EmailAlreadyInUseFailure('Email já cadastrado'));
      } else {
        return Either.left(Failure('Firestore error: ${e.message}'));
      }
    }
  }

  @override
  Future<Either<Failure, Unit>> sendPasswordResetEmail({
    required String email,
  }) async {
    final initializeEither = await _firebaseInitializer.initialize();
    if (initializeEither.isLeft) {
      return Either.left(initializeEither.left);
    }

    try {
      final fb_auth.FirebaseAuth firebaseAuth = fb_auth.FirebaseAuth.instance;
      await firebaseAuth.sendPasswordResetEmail(email: email);
      return Either.right(unit);
    } on fb_auth.FirebaseAuthException catch (e) {
      if (e.code == 'network-request-failed') {
        return Either.left(NetworkFailure('Sem conexão com a internet'));
      } else {
        return Either.left(Failure('Firestore error: ${e.message}'));
      }
    }
  }
}
