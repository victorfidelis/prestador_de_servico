import 'package:prestador_de_servico/app/models/user/user.dart';

abstract class SignInState {}
abstract class LoadingSignIn extends SignInState {}

class PendingSignIn extends SignInState {}

class LoadingSignInEmailPassword extends LoadingSignIn {
  final String email;
  final String password;

  LoadingSignInEmailPassword({
    required this.email,
    required this.password,
  });
} 

class SignInSuccess extends SignInState {
  final User user;
  SignInSuccess({required this.user});
}

class SignInError extends SignInState {
  final String? emailMessage;
  final String? passwordMessage;
  final String? genericMessage;

  SignInError({
    this.emailMessage,
    this.passwordMessage,
    this.genericMessage,
  });
} 

class SignInValidated extends SignInState{}


