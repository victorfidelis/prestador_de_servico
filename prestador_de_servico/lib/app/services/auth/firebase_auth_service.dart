import 'package:firebase_auth/firebase_auth.dart';
import 'package:prestador_de_servico/app/models/user/user_model.dart';
import 'package:prestador_de_servico/app/repositories/user/user_repository.dart';
import 'package:prestador_de_servico/app/services/auth/auth_service.dart';
import 'package:prestador_de_servico/app/states/create_user/create_user_state.dart';
import 'package:prestador_de_servico/app/states/login/login_state.dart';

class FirebaseCreateUserState {
  final String? genericMessage;
  final String? emailMessage;

  FirebaseCreateUserState({
    this.genericMessage,
    this.emailMessage,
  });
}

class FirebaseAuthService implements AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final UserRepository _userRepository = UserRepository.create();

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

      UserModel? user =
          await _userRepository.getByUid(uid: userCredential.user!.uid);

      if (user == null) {
        loginState = LoginError(genericMessage: 'Usuário não encontrado');
      } else if (!userCredential.user!.emailVerified) {
        await userCredential.user!.sendEmailVerification();
        loginState = LoginError(
            genericMessage:
                'Email ainda não verificado. Faça a verificação através do link enviado ao seu email.');
      } else {
        loginState = LoginSuccess(user: user);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-credential') {
        loginState =
            LoginError(genericMessage: 'Credenciais de usuário inválidas');
      } else if (e.code == 'too-many-requests') {
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
  Future<CreateUserState> createUserWithEmailAndPassword({
    required String name,
    required String surname,
    required String phone,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    if (name.isEmpty) {
      return ErrorCreatingUser(nameMessage: 'Necessário informar o nome');
    }
    if (surname.isEmpty) {
      return ErrorCreatingUser(
          surnameMessage: 'Necessário informar o sobrenome');
    }
    if (email.isEmpty) {
      return ErrorCreatingUser(emailMessage: 'Necessário informar o email');
    }
    if (password.isEmpty) {
      return ErrorCreatingUser(passwordMessage: 'Necessário informar a senha');
    }
    if (confirmPassword.isEmpty) {
      return ErrorCreatingUser(
          confirmPasswordMessage: 'Necessário informar a confirmação da senha');
    }
    if (password != confirmPassword) {
      return ErrorCreatingUser(
        passwordMessage: 'Senha incompatível',
        confirmPasswordMessage: 'Senha incompatível',
      );
    }

    CreateUserState createAccountState;

    try {
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      UserModel user = UserModel(
        id: '',
        uid: userCredential.user!.uid,
        email: email,
        name: name,
        surname: surname,
        phone: phone,
      );

      String? id = await _userRepository.add(user: user);
      if (id == null) {
        createAccountState = ErrorCreatingUser(
          genericMessage:
              'Ocorreu uma falha ao iserir os dados do usuário. Tente novamente.',
        );
      } else {
        createAccountState = UserCreated(user: user.copyWith(id: id));
        await userCredential.user!.sendEmailVerification();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        createAccountState =
            ErrorCreatingUser(emailMessage: 'Email já cadastrado');
      } else {
        createAccountState = ErrorCreatingUser(genericMessage: e.code);
      }
    }

    return createAccountState;
  }
}
