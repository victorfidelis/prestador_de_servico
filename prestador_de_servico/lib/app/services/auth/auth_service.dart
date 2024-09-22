import 'package:prestador_de_servico/app/services/auth/firebase_auth_service.dart';
import 'package:prestador_de_servico/app/states/create_account/create_accout_state.dart';
import 'package:prestador_de_servico/app/states/login/login_state.dart';

abstract class AuthService {

  factory AuthService.create() {
    return FirebaseAuthService();
  }

  Future<LoginState> loginWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<CreateAccountState> createAccountWithEmailAndPassword({
    required String name,
    required String surname,
    required String phone,
    required String email,
    required String password,
    required String confirmPassword,
  });
}


