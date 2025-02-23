import 'package:flutter/foundation.dart';
import 'package:prestador_de_servico/app/models/user/user.dart';
import 'package:prestador_de_servico/app/services/auth/auth_service.dart';
import 'package:prestador_de_servico/app/shared/utils/either/either_extensions.dart';
import 'package:prestador_de_servico/app/shared/utils/failure/failure.dart';
import 'package:prestador_de_servico/app/views/auth/states/create_user_state.dart';

class CreateUserViewModel extends ChangeNotifier {
  final AuthService authService;

  CreateUserState _state = WaitingUserCreation();
  CreateUserState get state => _state;
  void _emitState(currentState) {
    _state = currentState;
    notifyListeners();
  }

  CreateUserViewModel({required this.authService});

  void init() {
    _emitState(WaitingUserCreation());
  }

  Future<void> createUserEmailPassword({required User user}) async {
    _emitState(LoadingUserCreation());

    CreateUserState createUserState = _validate(user: user);
    if (createUserState is ErrorUserCreation) {
      _emitState(createUserState);
      return;
    }

    final createUserEither = await authService.createUserEmailPassword(user: user);
    createUserEither.fold(
      (error) {
        if (error is EmailAlreadyInUseFailure) {
          _emitState(ErrorUserCreation(emailMessage: createUserEither.left!.message));
        } else {
          _emitState(ErrorUserCreation(genericMessage: createUserEither.left!.message));
        }
      },
      (value) => _emitState(UserCreated(user: user)),
    );
  }

  CreateUserState _validate({required User user}) {
    if (user.name.isEmpty) {
      return ErrorUserCreation(nameMessage: 'Necessário informar o nome');
    }
    if (user.surname.isEmpty) {
      return ErrorUserCreation(surnameMessage: 'Necessário informar o sobrenome');
    }
    if (user.email.isEmpty) {
      return ErrorUserCreation(emailMessage: 'Necessário informar o email');
    }
    if (user.password.isEmpty) {
      return ErrorUserCreation(passwordMessage: 'Necessário informar a senha');
    }
    if (user.confirmPassword.isEmpty) {
      return ErrorUserCreation(confirmPasswordMessage: 'Necessário informar a confirmação da senha');
    }
    if (user.password != user.confirmPassword) {
      return ErrorUserCreation(
        confirmPasswordMessage: 'Senha incompatível',
      );
    }
    return UserValidated();
  }
}
