import 'package:firebase_auth/firebase_auth.dart';
import 'package:prestador_de_servico/app/models/user/user_adapter.dart';
import 'package:prestador_de_servico/app/services/auth/auth_service.dart';
import 'package:prestador_de_servico/app/states/create_account/create_accout_state.dart';
import 'package:prestador_de_servico/app/states/login/login_state.dart';

class FirebaseAuthService implements AuthService {

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Future<LoginState> loginWithEmailAndPassword({
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
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      loginState = LoginSuccess(
          user: UserAdapter.fromUserCredendial(userCredential: userCredential));
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
        loginState = LoginError(genericMessage: e.code);
      }
    }

    return loginState;
  }

  @override
  Future<CreateAccountState> createAccountWithEmailAndPassword({
    required String name,
    required String surname,
    required String phone,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {

    if (name.isEmpty) {
      return ErrorInCreation(nameMessage: 'Necessário informar o nome');
    }
    if (surname.isEmpty) {
      return ErrorInCreation(surnameMessage: 'Necessário informar o sobrenome');
    }
    if (email.isEmpty) {
      return ErrorInCreation(emailMessage: 'Necessário informar o email');
    }
    if (password.isEmpty) {
      return ErrorInCreation(passwordMessage: 'Necessário informar a senha');
    }
    if (confirmPassword.isEmpty) {
      return ErrorInCreation(
          confirmPasswordMessage: 'Necessário informar a confirmação da senha');
    }
    if (password != confirmPassword) {
      return ErrorInCreation(
        passwordMessage: 'Senhas incompatíveis',
        confirmPasswordMessage: 'Senhas incompatíveis',
      );
    }

    CreateAccountState createAccountState;

    try {

      final UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      createAccountState = AccountCreated(
          user: UserAdapter.fromUserCredendial(userCredential: userCredential));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-credential') {
        createAccountState =
            ErrorInCreation(genericMessage: 'Credenciais de usuário inválidas');
      } else {
        createAccountState = ErrorInCreation(genericMessage: e.code);
      }
    }

    return createAccountState;
  }
}
