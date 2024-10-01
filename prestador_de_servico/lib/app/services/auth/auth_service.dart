import 'package:prestador_de_servico/app/services/auth/firebase_auth_service.dart';
import 'package:prestador_de_servico/app/states/auth/create_user_state.dart';
import 'package:prestador_de_servico/app/states/auth/login_state.dart';
import 'package:prestador_de_servico/app/states/auth/password_reset_state.dart';

abstract class AuthService {

  factory AuthService.create() {
    return FirebaseAuthService();
  }

  Future<LoginState> loginWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<CreateUserState> createUserWithEmailAndPassword({
    required String name,
    required String surname,
    required String phone,
    required String email,
    required String password,
    required String confirmPassword,
  });

  Future<PasswordResetState> sendPasswordResetEmail({
    required String email,
  });
}


