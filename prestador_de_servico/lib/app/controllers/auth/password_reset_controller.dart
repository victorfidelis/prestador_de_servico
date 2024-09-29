import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/services/auth/auth_service.dart';
import 'package:prestador_de_servico/app/states/password_reset/password_reset_state.dart';

class PasswordResetController extends ChangeNotifier {
  final AuthService authService;

  PasswordResetState _state = WaitingUserSentEmail();
  PasswordResetState get state => _state;
  void _changeState({required PasswordResetState currentState}) {
    _state = currentState;
    notifyListeners();
  }

  PasswordResetController({required this.authService});
  
  void init() {
    _changeState(currentState: WaitingUserSentEmail());
  }

  Future<void> sendPasswordResetEmail({required String email}) async {
    _changeState(currentState: LoadingSentEmail());

    PasswordResetState passwordResetState =
        await authService.sendPasswordResetEmail(email: email);

    _changeState(currentState: passwordResetState);
  }
}
