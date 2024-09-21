import 'package:prestador_de_servico/app/services/auth/firebase_auth_service.dart';
import 'package:prestador_de_servico/app/states/login/login_state.dart';

abstract class AuthService {

  factory AuthService.create() {
    return FirebaseAuthService();
  }

  Future<LoginState> doLoginWithEmailPassword({
    required String email,
    required String password,
  });
}


