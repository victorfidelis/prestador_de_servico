import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/services/login/login_service.dart';
import 'package:prestador_de_servico/app/states/login/login_state.dart';

class LoginController extends ChangeNotifier {
  
  LoginState _state = PendingLogin();
  LoginState get state => _state;

  LoginService _loginService = LoginService();

  void _changeState({required LoginState currentLoginState}) {
    _state = currentLoginState;
    notifyListeners();
  }

  Future<void> loginSent() async {
    // use case

    _changeState(currentLoginState: LoginSent());
    await Future.delayed(const Duration(seconds: 5));
    _changeState(
        currentLoginState: LoginError(
            emailMessage: 'Email não encontrado',
            passwordMessage: 'Senha incorreta'));
  }

  Future<void> loginWithEmailPasswordSent({
    required String email,
    required String password,
  }) async {
    _changeState(currentLoginState: LoginSent());

    LoginState loginState = await _loginService.doLoginWithEmailPassword(
      email: email,
      password: password,
    );

    _changeState(currentLoginState: loginState);
  }
}
