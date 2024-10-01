import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/services/auth/auth_service.dart';
import 'package:prestador_de_servico/app/states/auth/login_state.dart';

class LoginController extends ChangeNotifier {
  
  final AuthService _authService;

  LoginController({required AuthService authService}) : _authService = authService; 

  LoginState _state = PendingLogin();
  LoginState get state => _state;

  void _changeState({required LoginState currentState}) {
    _state = currentState;
    notifyListeners();
  }

  Future<void> loginWithEmailPasswordSent({
    required String email,
    required String password,
  }) async {
    
    _changeState(currentState: LoginWithEmailAndPasswordSent(
      email: email,
      password: password,
    ));
    
    LoginState loginState = await _authService.loginWithEmailAndPassword(
      email: email,
      password: password,
    );

    _changeState(currentState: loginState);
  }
}
