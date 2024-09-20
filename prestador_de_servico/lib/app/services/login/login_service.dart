import 'package:firebase_auth/firebase_auth.dart';
import 'package:prestador_de_servico/app/states/login/login_state.dart';

class LoginService {

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
      final UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      loginState = LoginSuccess(userCredential: userCredential);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-credential') {
        loginState = LoginError(genericMessage: 'Credenciais de usuário inválidas');
      } else {
        loginState = LoginError(genericMessage: 'Erro desconhecido');
      }
    } 

    return loginState;
  }
}


