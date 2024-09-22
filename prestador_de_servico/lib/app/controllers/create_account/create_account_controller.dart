import 'package:flutter/foundation.dart';
import 'package:prestador_de_servico/app/services/auth/auth_service.dart';
import 'package:prestador_de_servico/app/states/create_account/create_accout_state.dart';

class CreateAccountController extends ChangeNotifier {
  final AuthService authService;

  CreateAccountState _state = PendingCreation();
  CreateAccountState get state => _state;
  void _changeState({required CreateAccountState currentState}) {
    _state = currentState;
    notifyListeners();
  }

  CreateAccountController({required this.authService});

  Future<void> createAccountWithEmailAndPassword({
    required String name,
    required String surname,
    required String phone,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    _changeState(
        currentState: CreateAccountWithEmailAndPasswordSent(
      name: name,
      surname: surname,
      phone: phone,
      email: email,
      password: password,
      confirmPassword: confirmPassword,
    ));

    CreateAccountState createAccountState =
        await authService.createAccountWithEmailAndPassword(
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
