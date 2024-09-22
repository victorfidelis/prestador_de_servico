import 'package:prestador_de_servico/app/models/user/user_model.dart';

abstract class CreateAccountState {}
abstract class CreateAccountSent extends CreateAccountState {}


class PendingCreation extends CreateAccountState {}

class CreateAccountWithEmailAndPasswordSent extends CreateAccountSent {
  final String name;
  final String surname;
  final String phone;
  final String email;
  final String password;
  final String confirmPassword;

  CreateAccountWithEmailAndPasswordSent({
    required this.name,
    required this.surname,
    required this.phone,
    required this.email,
    required this.password,
    required this.confirmPassword,
  });
} 

class ErrorInCreation extends CreateAccountState {
  final String? nameMessage;
  final String? surnameMessage;
  final String? phoneMessage;
  final String? emailMessage;
  final String? passwordMessage;
  final String? confirmPasswordMessage;
  final String? genericMessage;

  ErrorInCreation({
    this.nameMessage, 
    this.surnameMessage, 
    this.phoneMessage, 
    this.emailMessage, 
    this.passwordMessage,
    this.confirmPasswordMessage,
    this.genericMessage,
  });
}

class AccountCreated extends CreateAccountState {
  final UserModel user;

  AccountCreated({required this.user});
}
