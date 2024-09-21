import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/services/auth/auth_service.dart';
import 'package:prestador_de_servico/app/states/login/login_state.dart';

class LoginController extends ChangeNotifier {
  
  final AuthService _authService;

  LoginController({required AuthService authService}) : _authService = authService; 

  LoginState _state = PendingLogin();
  LoginState get state => _state;

  void _changeState({required LoginState currentLoginState}) {
    _state = currentLoginState;
    notifyListeners();
  }

  Future<void> loginWithEmailPasswordSent({
    required String email,
    required String password,
  }) async {
    
    _changeState(currentLoginState: LoginWithEmailPasswordSent(
      email: email,
      password: password,
    ));
    
    LoginState loginState = await _authService.doLoginWithEmailPassword(
      email: email,
      password: password,
    );

    _changeState(currentLoginState: loginState);
  }
}
