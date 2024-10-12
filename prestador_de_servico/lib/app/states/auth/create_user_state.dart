import 'package:prestador_de_servico/app/models/user/user.dart';

abstract class CreateUserState {}

class WaitingUserCreation extends CreateUserState {}

class LoadingUserCreation extends CreateUserState {} 

class ErrorUserCreation extends CreateUserState {
  final String? nameMessage;
  final String? surnameMessage;
  final String? phoneMessage;
  final String? emailMessage;
  final String? passwordMessage;
  final String? confirmPasswordMessage;
  final String? genericMessage;

  ErrorUserCreation({
    this.nameMessage, 
    this.surnameMessage, 
    this.phoneMessage, 
    this.emailMessage, 
    this.passwordMessage,
    this.confirmPasswordMessage,
    this.genericMessage,
  });
}

class UserValidated extends CreateUserState{}

class UserCreated extends CreateUserState {
  final User user;

  UserCreated({required this.user});
}
