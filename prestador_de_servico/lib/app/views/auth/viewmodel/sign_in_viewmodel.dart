import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/services/auth/auth_service.dart';
import 'package:prestador_de_servico/app/shared/utils/either/either_extensions.dart';
import 'package:prestador_de_servico/app/views/auth/states/sign_in_state.dart';

class SignInViewModel extends ChangeNotifier {
  
  final AuthService _authService;

  SignInViewModel({required AuthService authService}) : _authService = authService; 

  SignInState _state = PendingSignIn();
  SignInState get state => _state;

  void _emitState(SignInState currentState) {
    _state = currentState;
    notifyListeners();
  }

  Future<void> signInEmailPassword({
    required String email,
    required String password,
  }) async {
    
    _emitState(LoadingSignInEmailPassword(
      email: email,
      password: password,
    ));

    final signInState = _validateSignInEmailPassword(email: email, password: password); 
    if (signInState is SignInError) {
      _emitState(signInState);
      return;
    } 
    
    final signInEither = await _authService.signInEmailPasswordAndVerifyEmail(
      email: email,
      password: password,
    );

    signInEither.fold(
      (error) => _emitState(SignInError(genericMessage: error.message)),
      (value) => _emitState(SignInSuccess(user: value)),
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
