import 'package:prestador_de_servico/app/models/user/user.dart';

abstract class LoginState {}
abstract class LoginSent extends LoginState {}

class PendingLogin extends LoginState {}

class LoginWithEmailAndPasswordSent extends LoginSent {
  final String email;
  final String password;

  LoginWithEmailAndPasswordSent({
    required this.email,
    required this.password,
  });
} 

class LoginSuccess extends LoginState {
  final User user;
  LoginSuccess({required this.user});
}

class LoginError extends LoginState {
  final String? emailMessage;
  final String? passwordMessage;
  final String? genericMessage;

  LoginError({
    this.emailMessage,
    this.passwordMessage,
    this.genericMessage,
  });
} 


