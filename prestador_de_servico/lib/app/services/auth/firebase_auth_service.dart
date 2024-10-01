import 'package:firebase_auth/firebase_auth.dart';
import 'package:prestador_de_servico/app/models/user/user_model.dart';
import 'package:prestador_de_servico/app/repositories/user/user_repository.dart';
import 'package:prestador_de_servico/app/services/auth/auth_service.dart';
import 'package:prestador_de_servico/app/states/auth/create_user_state.dart';
import 'package:prestador_de_servico/app/states/auth/login_state.dart';
import 'package:prestador_de_servico/app/states/auth/password_reset_state.dart';


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
          await _userRepository.getByEmail(email: email);

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
    
    UserModel user = UserModel(
      id: '',
      isAdmin: false,
      email: email,
      name: name,
      surname: surname,
      phone: phone,
    );

    UserModel? userGet = await _userRepository.getByEmail(email: email); 

    if (userGet == null) {
      String? id = await _userRepository.add(user: user);
      if (id == null) {
        return ErrorCreatingUser(
          genericMessage:
              'Ocorreu uma falha ao iserir os dados do usuário. Tente novamente.',
        );
      } 
      user = user.copyWith(id: id);
    } else  {
      user = user.copyWith(id: userGet.id);
    }

    CreateUserState createAccountState;
    UserCredential? userCredential;

    try {
      userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      createAccountState = UserCreated(user: user);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        createAccountState =
            ErrorCreatingUser(emailMessage: 'Email já cadastrado');
      } else {
        createAccountState = ErrorCreatingUser(genericMessage: e.code);
      } 
    } 

    if (createAccountState is UserCreated) {
      if (userGet != null)  {
        await _userRepository.update(user: user);
      } 
      await userCredential!.user!.sendEmailVerification();
    }

    return createAccountState;
  }
  
  @override
  Future<PasswordResetState> sendPasswordResetEmail({required String email}) async {

    if (email.isEmpty) {
      return ErrorSentEmail(emailMessage: 'Necessário informar o email');
    }

    await _firebaseAuth.sendPasswordResetEmail(email: email);

    return ResetEmailSent();
  } 
}
