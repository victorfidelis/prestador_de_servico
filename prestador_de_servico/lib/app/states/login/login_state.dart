import 'package:firebase_auth/firebase_auth.dart';

sealed class LoginState {}

class PendingLogin extends LoginState {}

class LoginSent extends LoginState {} 

class LoginWithEmailPasswordSent extends LoginSent {
  LoginWithEmailPasswordSent({
    required this.email,
    required this.password,
  });

  final String email;
  final String password;
} 

class LoginSuccess extends LoginState {
  LoginSuccess({required this.userCredential});

  final UserCredential userCredential;

}

class LoginError extends LoginState {
  LoginError({
    this.emailMessage,
    this.passwordMessage,
    this.genericMessage,
  });

  final String? emailMessage;
  final String? passwordMessage;
  final String? genericMessage;
} 


