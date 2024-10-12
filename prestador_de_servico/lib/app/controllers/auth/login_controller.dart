import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/services/auth/auth_service.dart';
import 'package:prestador_de_servico/app/shared/either/either_extension.dart';
import 'package:prestador_de_servico/app/states/auth/login_state.dart';

class LoginController extends ChangeNotifier {
  
  final AuthService _authService;

  LoginController({required AuthService authService}) : _authService = authService; 

  LoginState _state = PendingLogin();
  LoginState get state => _state;

  void _changeState(LoginState currentState) {
    _state = currentState;
    notifyListeners();
  }

  Future<void> loginWithEmailPasswordSent({
    required String email,
    required String password,
  }) async {
    
    _changeState(LoginWithEmailAndPasswordSent(
      email: email,
      password: password,
    ));
    
    final signInEither = await _authService.signInEmailPasswordAndVerifyEmail(
      email: email,
      password: password,
    );

    signInEither.fold(
      (error) => _changeState(LoginError(genericMessage: error.message)),
      (value) => _changeState(LoginSuccess(user: value)),
    );
  }
}
