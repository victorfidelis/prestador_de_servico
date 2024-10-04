import 'package:prestador_de_servico/app/models/user/user.dart';

abstract class CreateUserState {}
abstract class CreateUserSent extends CreateUserState {}


class PendingCreation extends CreateUserState {}

class CreateUserWithEmailAndPasswordSent extends CreateUserSent {
  final String name;
  final String surname;
  final String phone;
  final String email;
  final String password;
  final String confirmPassword;

  CreateUserWithEmailAndPasswordSent({
    required this.name,
    required this.surname,
    required this.phone,
    required this.email,
    required this.password,
    required this.confirmPassword,
  });
} 

class ErrorCreatingUser extends CreateUserState {
  final String? nameMessage;
  final String? surnameMessage;
  final String? phoneMessage;
  final String? emailMessage;
  final String? passwordMessage;
  final String? confirmPasswordMessage;
  final String? genericMessage;

  ErrorCreatingUser({
    this.nameMessage, 
    this.surnameMessage, 
    this.phoneMessage, 
    this.emailMessage, 
    this.passwordMessage,
    this.confirmPasswordMessage,
    this.genericMessage,
  });
}

class UserCreated extends CreateUserState {
  final User user;

  UserCreated({required this.user});
}
