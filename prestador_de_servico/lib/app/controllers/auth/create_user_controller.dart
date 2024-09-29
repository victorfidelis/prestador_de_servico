import 'package:flutter/foundation.dart';
import 'package:prestador_de_servico/app/services/auth/auth_service.dart';
import 'package:prestador_de_servico/app/states/create_user/create_user_state.dart';

class CreateUserController extends ChangeNotifier {
  final AuthService authService;

  CreateUserState _state = PendingCreation();
  CreateUserState get state => _state;
  void _changeState({required CreateUserState currentState}) {
    _state = currentState;
    notifyListeners();
  }

  CreateUserController({required this.authService});

  void init() {
    _changeState(currentState: PendingCreation());
  }

  Future<void> createAccountWithEmailAndPassword({
    required String name,
    required String surname,
    required String phone,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    _changeState(
        currentState: CreateUserWithEmailAndPasswordSent(
      name: name,
      surname: surname,
      phone: phone,
      email: email,
      password: password,
      confirmPassword: confirmPassword,
    ));

    CreateUserState createAccountState =
        await authService.createUserWithEmailAndPassword(
      name: name,
      surname: surname,
      phone: phone,
      email: email,
      password: password,
      confirmPassword: confirmPassword,
    );

    _changeState(currentState: createAccountState);
  }
}
