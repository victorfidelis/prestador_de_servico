import 'package:flutter/foundation.dart';
import 'package:prestador_de_servico/app/models/user/user.dart';
import 'package:prestador_de_servico/app/services/auth/auth_service.dart';
import 'package:prestador_de_servico/app/shared/either/either_extension.dart';
import 'package:prestador_de_servico/app/shared/failure/failure.dart';
import 'package:prestador_de_servico/app/states/auth/create_user_state.dart';

class CreateUserController extends ChangeNotifier {
  final AuthService authService;

  CreateUserState _state = WaitingUserCreation();
  CreateUserState get state => _state;
  void _changeState(currentState) {
    _state = currentState;
    notifyListeners();
  }

  CreateUserController({required this.authService});

  void init() {
    _changeState(WaitingUserCreation());
  }

  Future<void> createUserEmailPassword({required User user}) async {
    _changeState(LoadingUserCreation());

    CreateUserState createUserState = _validate(user: user);
    if (createUserState is ErrorUserCreation) {
      _changeState(createUserState);
      return;
    }

    final createUserEither =
        await authService.createUserEmailPassword(user: user);
    createUserEither.fold(
      (error) {
        if (error is EmailAlreadyInUseFailure) {
          _changeState(
              ErrorUserCreation(emailMessage: createUserEither.left!.message));
        } else {
          _changeState(ErrorUserCreation(
              genericMessage: createUserEither.left!.message));
        }
      },
      (value) => _changeState(UserCreated(user: user)),
    );
  }

  CreateUserState _validate({required User user}) {
    if (user.name.isEmpty) {
      return ErrorUserCreation(nameMessage: 'Necessário informar o nome');
    }
    if (user.surname.isEmpty) {
      return ErrorUserCreation(
          surnameMessage: 'Necessário informar o sobrenome');
    }
    if (user.email.isEmpty) {
      return ErrorUserCreation(emailMessage: 'Necessário informar o email');
    }
    if (user.password.isEmpty) {
      return ErrorUserCreation(passwordMessage: 'Necessário informar a senha');
    }
    if (user.confirmPassword.isEmpty) {
      return ErrorUserCreation(
          confirmPasswordMessage: 'Necessário informar a confirmação da senha');
    }
    if (user.password != user.confirmPassword) {
      return ErrorUserCreation(
        passwordMessage: 'Senha incompatível',
        confirmPasswordMessage: 'Senha incompatível',
      );
    }
    return UserValidated();
  }
}
