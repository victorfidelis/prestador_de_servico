import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/services/auth/auth_service.dart';
import 'package:prestador_de_servico/app/shared/extensions/either_extensions.dart';
import 'package:prestador_de_servico/app/states/auth/sign_in_state.dart';

class SignInController extends ChangeNotifier {
  
  final AuthService _authService;

  SignInController({required AuthService authService}) : _authService = authService; 

  SignInState _state = PendingSignIn();
  SignInState get state => _state;

  void _changeState(SignInState currentState) {
    _state = currentState;
    notifyListeners();
  }

  Future<void> signInEmailPassword({
    required String email,
    required String password,
  }) async {
    
    _changeState(LoadingSignInEmailPassword(
      email: email,
      password: password,
    ));

    final signInState = _validateSignInEmailPassword(email: email, password: password); 
    if (signInState is SignInError) {
      _changeState(signInState);
      return;
    } 
    
    final signInEither = await _authService.signInEmailPasswordAndVerifyEmail(
      email: email,
      password: password,
    );

    signInEither.fold(
      (error) => _changeState(SignInError(genericMessage: error.message)),
      (value) => _changeState(SignInSuccess(user: value)),
    );
  }

  SignInState _validateSignInEmailPassword({
    required String email,
    required String password,
  }) {
    if (email.isEmpty) {
      return SignInError(emailMessage: 'Necessário informar o email');
    } else if (password.isEmpty) {
      return SignInError(passwordMessage: 'Necessário informar a senha');
    }
    return SignInValidated();
  }  
}
