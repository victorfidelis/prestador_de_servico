import 'package:firebase_auth/firebase_auth.dart';
import 'package:prestador_de_servico/app/models/user/user_adapter.dart';
import 'package:prestador_de_servico/app/services/auth/auth_service.dart';
import 'package:prestador_de_servico/app/states/login/login_state.dart';

class FirebaseAuthService implements AuthService {

  @override
  Future<LoginState> doLoginWithEmailPassword({
    required String email,
    required String password,
  }) async {
    if (email.isEmpty) {
      return LoginError(emailMessage: 'Necessário informar o email');
    }
    if (password.isEmpty) {
      return LoginError(passwordMessage: 'Necessário informar a senha');
    }

    LoginState loginState;

    try {
      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      loginState = LoginSuccess(user: UserAdapter.fromUserCredendial(userCredential: userCredential));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-credential') {
        loginState =
            LoginError(genericMessage: 'Credenciais de usuário inválidas');
      }
      if (e.code == 'too-many-requests') {
        loginState = LoginError(
            genericMessage:
                'Bloqueio temporário. Muitas tentativas incorretas');
      } else {
        loginState = LoginError(genericMessage: 'Erro desconhecido');
      }
    }

    return loginState;
  }

}
